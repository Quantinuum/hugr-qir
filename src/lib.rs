use std::rc::Rc;

use crate::inkwell::passes::PassBuilderOptions;
use crate::inkwell::values::{CallSiteValue, FunctionValue, PointerValue};
use anyhow::anyhow;
use anyhow::{Result, bail};
use clap_verbosity_flag::log::Level;
use hugr::HugrView;
use hugr::algorithms::{ComposablePass, RemoveDeadFuncsPass, inline_acyclic};
use hugr::llvm::custom::CodegenExtsMap;
use hugr::llvm::emit::{EmitHugr, Namer};
use hugr::llvm::utils::fat::FatExt;
use hugr::llvm::{CodegenExtsBuilder, inkwell};
use hugr::{Hugr, Node};
use hugr_llvm::inkwell::attributes::AttributeLoc;
use inkwell::context::Context;
use inkwell::module::{Linkage, Module};
use inkwell::values::UnnamedAddress;
use qir::{QirCodegenExtension, QirPreludeCodegen};
use rotation::RotationCodegenExtension;
use target::CompileTarget;
pub mod cli;
pub mod lower_ssa_vars;
pub mod qir;
pub mod target;

use crate::cli::CliOptimizationLevel;
use crate::lower_ssa_vars::{
    lower_float_selects_and_phis, lower_qubit_selects_and_phis, normalize_block_names,
};
use crate::qir::random_ext::RandomCodegenExtension;
use crate::qir::utils_ext::UtilsCodegenExtension;
use crate::qir::wasm_ext::WasmCodegen;
use itertools::Itertools;

#[cfg(feature = "py")]
mod py;

const GENERATOR_SECTION: &str = ",qir_generator";
const GENERATOR_NAME_KEY: &str = "gen_name";
const GENERATOR_VERSION_KEY: &str = "gen_version";
const VERSION_TEST_OVERRIDE_ENV_VAR: &str = "HUGR_QIR_VERSION_TEST_OVERRIDE";
const VERSION_TEST_OVERRIDE_VALUE: &str = "X.Y.Z";

// TODO this was copy pasted, ideally it would live in tket2-hseries
pub mod rotation;

#[non_exhaustive]
pub struct CompileArgs {
    pub debug: u8,

    /// None means no output
    pub verbosity: Option<Level>,
    pub validate: bool,
    pub qsystem_pass: bool,
    pub target: CompileTarget,
    pub opt_level: CliOptimizationLevel,
    pub wasm_file: Option<String>,
}

impl Default for CompileArgs {
    fn default() -> Self {
        Self {
            debug: 0,
            verbosity: None,
            validate: false,
            qsystem_pass: true,
            target: CompileTarget::QuantinuumHardware,
            opt_level: CliOptimizationLevel::Aggressive,
            wasm_file: None,
        }
    }
}

impl CompileArgs {
    pub fn codegen_extensions(&self) -> CodegenExtsMap<'static, Hugr> {
        let pcg = QirPreludeCodegen;
        let wasm_cg = WasmCodegen::new(&self.wasm_file);

        CodegenExtsBuilder::default()
            .add_prelude_extensions(pcg.clone())
            .add_default_int_extensions()
            .add_float_extensions()
            .add_conversion_extensions()
            .add_logic_extensions()
            .add_extension(RotationCodegenExtension::new(QirPreludeCodegen))
            .add_extension(QirCodegenExtension {
                target: self.target,
            })
            .add_extension(RandomCodegenExtension)
            .add_extension(UtilsCodegenExtension)
            .add_extension(wasm_cg)
            .finish()
    }

    pub fn module_name(&self) -> impl AsRef<str> {
        // TODO get this from args
        "hugr-qir"
    }

    /// TODO: Change to "hugr: &mut impl HugrMut" once QSeriesPass works on &mut impl HugrMut
    pub fn hugr_to_hugr(&self, hugr: &mut Hugr) -> Result<()> {
        if self.validate {
            hugr.validate()?;
        }
        if self.qsystem_pass {
            let pass = tket_qsystem::QSystemPass::default();
            pass.run(hugr)?;
            if self.validate {
                hugr.validate()?;
            }
        }
        self.inline_calls(hugr)?;
        self.remove_dead_functions(hugr)?;
        Ok(())
    }

    pub fn inline_calls(&self, hugr: &mut Hugr) -> Result<()> {
        inline_acyclic(hugr, |_, _| {
            true // <- always inline, no matter what
        })?;
        if self.validate {
            hugr.validate()?;
        }
        Ok(())
    }
    pub fn remove_dead_functions(&self, hugr: &mut Hugr) -> Result<()> {
        let entry_point_node = find_hugr_entry_point(hugr)?;
        let dead_func_pass =
            RemoveDeadFuncsPass::default().with_module_entry_points([entry_point_node]);
        dead_func_pass.run(hugr)?;
        if self.validate {
            hugr.validate()?;
        }
        Ok(())
    }

    /// Optimize the module using LLVM passes
    fn optimize_module_llvm(&self, module: &Module) -> Result<()> {
        self.target.initialise();

        let ctm = self.target.machine(self.opt_level.into());

        module.set_triple(&ctm.get_triple());
        module.set_data_layout(&ctm.get_target_data().get_data_layout());

        let mut opt_str = String::from(match self.opt_level {
            CliOptimizationLevel::None => "default<O0>",
            CliOptimizationLevel::Less => "default<O1>",
            CliOptimizationLevel::Default => "default<O2>",
            CliOptimizationLevel::Aggressive => "default<O3>",
        });
        opt_str.push_str(",lowerswitch");
        let _ = module.run_passes(opt_str.as_str(), &ctm, PassBuilderOptions::create());
        Ok(())
    }

    pub fn hugr_to_llvm<'c>(&self, hugr: &Hugr, context: &'c Context) -> Result<Module<'c>> {
        let extensions = self.codegen_extensions().into();
        let namer = Rc::new(Namer::new("__hugr__.", true));
        let module = context.create_module(self.module_name().as_ref());
        let emit = EmitHugr::new(context, module, namer.clone(), extensions);
        let module = emit.emit_module(hugr.fat_root().unwrap())?.finish();

        // This is a workaround to an issue in hugr-llvm: https://github.com/Quantinuum/hugr/issues/2615
        // Can be removed when that issue is resolved
        set_explicit_entrypoint_linkage(&namer, hugr, &module)?;

        // We optimize before `replace_int_opaque_pointer`ing, because that will fail if there are indirect function  calls, which must be removed in the end qir anyway.
        self.optimize_module_llvm(&module)?;
        let qubit_count: u64 = replace_int_opque_pointer(&module, "__quantum__rt__qubit_allocate")?;
        let result_count: u64 = replace_int_opque_pointer(&module, "__QIR__CONV_Qubit_TO_Result")?;

        add_module_metadata(&namer, hugr, &module, qubit_count, result_count)?;
        add_qir_runtime_contracts(&namer, hugr, &module)?;

        Ok(module)
    }

    pub fn compile<'c>(&self, hugr: &mut Hugr, context: &'c Context) -> Result<Module<'c>> {
        self.hugr_to_hugr(hugr)?;
        let module = self.hugr_to_llvm(hugr, context)?;

        self.optimize_module_llvm(&module)?;
        lower_qubit_selects_and_phis(&module)?;
        lower_float_selects_and_phis(&module)?;
        normalize_block_names(&module);
        add_generator_metadata(&module, GENERATOR_NAME_KEY, env!("CARGO_PKG_NAME"));
        add_generator_metadata(&module, GENERATOR_VERSION_KEY, &generator_version());
        Ok(module)
    }
}

/// Allow overriding the version to a static string for snapshot test purposes
/// The default case is to use the package version
fn generator_version() -> String {
    match std::env::var(VERSION_TEST_OVERRIDE_ENV_VAR).as_deref() {
        Ok("true") => VERSION_TEST_OVERRIDE_VALUE.to_string(),
        _ => env!("CARGO_PKG_VERSION").to_string(),
    }
}

pub fn find_entry_point_name(hugr: &impl HugrView<Node = Node>) -> Result<(Node, String)> {
    const HUGR_MAIN: &str = "main";

    let (name, entry_point_node) = if hugr.entrypoint_optype().is_module() {
        // backwards compatibility with old Guppy versions: assume entrypoint is "main"
        // function in module.

        let node = hugr
            .children(hugr.module_root())
            .filter(|&n| {
                hugr.get_optype(n)
                    .as_func_defn()
                    .is_some_and(|f| f.func_name() == HUGR_MAIN)
            })
            .exactly_one()
            .map_err(|_| {
                anyhow!("Module entrypoint must have a single function named {HUGR_MAIN} as child")
            })?;

        (HUGR_MAIN, node)
    } else {
        let name = {
            hugr.entrypoint_optype()
                .as_func_defn()
                .ok_or_else(|| anyhow!("Entry point node is not a function definition"))?
                .func_name()
        };

        (name.as_ref(), hugr.entrypoint())
    };
    Ok((entry_point_node, name.to_string()))
}

pub fn find_hugr_entry_point(hugr: &impl HugrView<Node = Node>) -> Result<Node> {
    let (entry_point_node, _) = find_entry_point_name(hugr)?;
    Ok(entry_point_node)
}

pub fn replace_int_opque_pointer(module: &Module, funcname: &str) -> Result<u64> {
    let first_func = module.get_first_function().unwrap();

    let mut pointer_counter: u64 = 0;

    debug_assert_eq!(
        1,
        module
            .get_functions()
            .filter(|f| f.get_first_basic_block().is_some())
            .count()
    );

    for block in first_func.get_basic_blocks() {
        for ins in block.get_instructions() {
            let Ok(call) = CallSiteValue::try_from(ins) else {
                continue;
            };
            let Some(func) = call.get_called_fn_value() else {
                bail!("Indirect call {:?}", call);
            };
            let global = func.as_global_value();

            if global.get_name().to_bytes() == funcname.as_bytes() {
                let ptr = PointerValue::try_from(ins).unwrap();

                let ptr_width = ptr
                    .get_type()
                    .size_of()
                    .get_zero_extended_constant()
                    .unwrap_or(64);

                let ptr_int_type = module.get_context().custom_width_int_type(ptr_width as u32);

                let r = ptr_int_type
                    .const_int(pointer_counter, false)
                    .const_to_pointer(ptr.get_type());

                pointer_counter += 1;

                ptr.replace_all_uses_with(r);

                ins.erase_from_basic_block();
            }
        }
    }

    Ok(pointer_counter)
}

pub fn add_module_metadata(
    namer: &Namer,
    hugr: &impl HugrView<Node = Node>,
    module: &Module,
    qubit_count: u64,
    results_count: u64,
) -> Result<()> {
    let attributes = [
        module
            .get_context()
            .create_string_attribute("entry_point", ""),
        module
            .get_context()
            .create_string_attribute("output_labeling_schema", ""),
        module
            .get_context()
            .create_string_attribute("qir_profiles", "adaptive_profile"),
        module
            .get_context()
            .create_string_attribute("required_num_qubits", &qubit_count.to_string()),
        module
            .get_context()
            .create_string_attribute("required_num_results", &results_count.to_string()),
    ];
    let entrypoint_name = find_entry_point_name(hugr)?;
    let entry_func_name = namer.name_func(entrypoint_name.1, entrypoint_name.0);
    let fn_value = module.get_function(&entry_func_name);
    if Option::is_none(&fn_value) {
        return Err(anyhow!(
            "entrypoint function \"{}\" not found in generated LLVM module",
            entry_func_name
        ));
    }
    for attribute in attributes {
        fn_value
            .unwrap()
            .add_attribute(AttributeLoc::Function, attribute);
    }

    let int_type = module.get_context().i32_type();
    let bool_type = module.get_context().bool_type();

    // !0 = !{i32 1, !"qir_major_version", i32 1}
    let val_0_0 = int_type.const_int(1, false);
    let val_0_1 = module.get_context().metadata_string("qir_major_version");
    let val_0_2 = int_type.const_int(1, false);

    // !1 = !{i32 7, !"qir_minor_version", i32 0}
    let val_1_0 = int_type.const_int(7, false);
    let val_1_1 = module.get_context().metadata_string("qir_minor_version");
    let val_1_2 = int_type.const_int(0, false);

    // !2 = !{i32 1, !"dynamic_qubit_management", i1 false}
    let val_2_0 = int_type.const_int(1, false);
    let val_2_1 = module
        .get_context()
        .metadata_string("dynamic_qubit_management");
    let val_2_2 = bool_type.const_int(0, false);

    // !3 = !{i32 1, !"dynamic_result_management", i1 false}
    let val_3_0 = int_type.const_int(1, false);
    let val_3_1 = module
        .get_context()
        .metadata_string("dynamic_result_management");
    let val_3_2 = bool_type.const_int(0, false);

    let md_node_0 =
        module
            .get_context()
            .metadata_node(&[val_0_0.into(), val_0_1.into(), val_0_2.into()]);
    let md_node_1 =
        module
            .get_context()
            .metadata_node(&[val_1_0.into(), val_1_1.into(), val_1_2.into()]);
    let md_node_2 =
        module
            .get_context()
            .metadata_node(&[val_2_0.into(), val_2_1.into(), val_2_2.into()]);
    let md_node_3 =
        module
            .get_context()
            .metadata_node(&[val_3_0.into(), val_3_1.into(), val_3_2.into()]);

    module
        .add_global_metadata("llvm.module.flags", &md_node_0)
        .unwrap();
    module
        .add_global_metadata("llvm.module.flags", &md_node_1)
        .unwrap();
    module
        .add_global_metadata("llvm.module.flags", &md_node_2)
        .unwrap();
    module
        .add_global_metadata("llvm.module.flags", &md_node_3)
        .unwrap();

    Ok(())
}

fn add_generator_metadata(module: &Module, key: &str, value: &str) {
    let context = module.get_context();
    let value_type = context
        .i8_type()
        .array_type(u32::try_from(value.len()).expect("generator metadata length must fit in u32"));
    let global = module.add_global(value_type, None, key);
    global.set_initializer(&context.const_string(value.as_bytes(), false));
    global.set_linkage(Linkage::Private);
    global.set_constant(true);
    global.set_unnamed_address(UnnamedAddress::Global);
    global.set_section(Some(GENERATOR_SECTION));
}

fn add_qir_runtime_contracts(
    namer: &Namer,
    hugr: &impl HugrView<Node = Node>,
    module: &Module,
) -> Result<()> {
    let (entrypoint_node, entrypoint_name) = find_entry_point_name(hugr)?;
    let entry_func_name = namer.name_func(entrypoint_name, entrypoint_node);
    let entry_func = module.get_function(&entry_func_name).ok_or_else(|| {
        anyhow!(
            "entrypoint function \"{}\" not found in generated LLVM module",
            entry_func_name
        )
    })?;
    add_qir_initialize_call(module, entry_func)
}

fn add_qir_initialize_call(module: &Module, entry_func: FunctionValue) -> Result<()> {
    if function_calls(entry_func, "__quantum__rt__initialize")? {
        return Ok(());
    }

    let context = module.get_context();
    let i8_ptr_ty = context.i8_type().ptr_type(Default::default());
    let init_ty = context.void_type().fn_type(&[i8_ptr_ty.into()], false);
    let init_func = module
        .get_function("__quantum__rt__initialize")
        .unwrap_or_else(|| module.add_function("__quantum__rt__initialize", init_ty, None));

    let entry_block = entry_func
        .get_first_basic_block()
        .ok_or_else(|| anyhow!("QIR entry point has no entry block"))?;
    let builder = context.create_builder();
    if let Some(first_inst) = entry_block.get_first_instruction() {
        builder.position_before(&first_inst);
    } else {
        builder.position_at_end(entry_block);
    }
    builder.build_call(init_func, &[i8_ptr_ty.const_null().into()], "")?;
    Ok(())
}

fn function_calls(func: FunctionValue, callee_name: &str) -> Result<bool> {
    for block in func.get_basic_blocks() {
        let mut inst_opt = block.get_first_instruction();
        while let Some(inst) = inst_opt {
            inst_opt = inst.get_next_instruction();
            let Ok(call) = CallSiteValue::try_from(inst) else {
                continue;
            };
            let Some(callee) = call.get_called_fn_value() else {
                bail!("Indirect call {:?}", call);
            };
            if callee.as_global_value().get_name().to_bytes() == callee_name.as_bytes() {
                return Ok(true);
            }
        }
    }
    Ok(false)
}

pub fn set_explicit_entrypoint_linkage(
    namer: &Namer,
    hugr: &impl HugrView<Node = Node>,
    module: &Module,
) -> Result<()> {
    let entrypoint_name = find_entry_point_name(hugr)?;
    let entry_func_name = namer.name_func(entrypoint_name.1, entrypoint_name.0);
    let fn_value = module.get_function(&entry_func_name);
    if Option::is_none(&fn_value) {
        return Err(anyhow!(
            "entrypoint function \"{}\" not found in generated LLVM module",
            entry_func_name
        ));
    }
    fn_value.unwrap().set_linkage(Linkage::External);
    Ok(())
}

#[cfg(test)]
pub(crate) mod test;
