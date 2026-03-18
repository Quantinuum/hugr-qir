use std::collections::HashMap;
use std::rc::Rc;

use crate::inkwell::passes::PassBuilderOptions;
use crate::inkwell::values::CallSiteValue;
use crate::inkwell::values::PointerValue;
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
use inkwell::basic_block::BasicBlock;
use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::{Linkage, Module};
use inkwell::types::BasicTypeEnum;
use inkwell::values::{
    AsValueRef, BasicValue, BasicValueEnum, FunctionValue, InstructionValue, Operand, PhiValue,
    ValueKind,
};
use qir::{QirCodegenExtension, QirPreludeCodegen};
use rotation::RotationCodegenExtension;
use target::CompileTarget;
pub mod cli;
pub mod qir;
pub mod target;

use crate::cli::CliOptimizationLevel;
use crate::qir::random_ext::RandomCodegenExtension;
use crate::qir::utils_ext::UtilsCodegenExtension;
use crate::qir::wasm_ext::WasmCodegen;

use itertools::Itertools;

#[cfg(feature = "py")]
mod py;

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

    fn simplify_cfg(&self, module: &Module) -> Result<()> {
        self.target.initialise();

        let ctm = self.target.machine(self.opt_level.into());

        module.set_triple(&ctm.get_triple());
        module.set_data_layout(&ctm.get_target_data().get_data_layout());

        let opt_str = String::from("simplifycfg");
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

        Ok(module)
    }

    pub fn compile<'c>(&self, hugr: &mut Hugr, context: &'c Context) -> Result<Module<'c>> {
        self.hugr_to_hugr(hugr)?;
        let module = self.hugr_to_llvm(hugr, context)?;

        self.optimize_module_llvm(&module)?;
        replace_select_phi_on_qubit(&module);
        self.simplify_cfg(&module)?;
        let ok = module.verify();
        assert!(ok.is_ok(), "Failed to verify module");

        Ok(module)
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

pub fn replace_select_phi_on_qubit(module: &Module) -> bool {
    let context = module.get_context();
    let builder = context.create_builder();
    let first_func = module.get_first_function().unwrap();
    let mut changed = false;
    for block in first_func.get_basic_blocks() {
        let mut inst_opt = block.get_first_instruction();
        let mut phi_candidates: Vec<PhiValue> = Vec::new();

        while let Some(inst) = inst_opt {
            use inkwell::values::InstructionOpcode;
            if inst.get_opcode() != InstructionOpcode::Phi {
                break;
            }
            // Turn the inst into PhiValue (safe since we checked opcode)
            let phi = unsafe { PhiValue::new(inst.as_value_ref()) };
            if let BasicTypeEnum::PointerType(ptr_ty) = phi.as_basic_value().get_type() {
                if ptr_ty
                    .get_element_type()
                    .into_struct_type()
                    .get_name()
                    .unwrap()
                    .eq(c"Qubit")
                {
                    phi_candidates.push(phi);
                }
            }
            inst_opt = inst.get_next_instruction();
        }
        if phi_candidates.is_empty() {
            continue;
        }

        // 2) Find predecessors of `block`
        let preds = predecessors(first_func, block);
        println!("phi block {:?}", block.get_name());
        println!(
            "phi preds {:?}",
            preds.iter().map(|b| b.get_name()).collect::<Vec<_>>()
        );
        if preds.is_empty() {
            continue;
        }

        // 3) For each predecessor, duplicate tail and redirect edge
        for pred in preds {
            // New block that will hold the duplicated tail
            let clone_block = pred
                .get_context()
                .insert_basic_block_after(pred, &format!("{}_dup", name_of_block(block)));
            // Ensure it's attached to the function (inkwell exposes append_existing_basic_block)
            //first_func.append_existing_basic_block(clone_block);

            // Seed the value map: PHI -> incoming value for this predecessor
            let mut vmap: HashMap<String, BasicValueEnum> = HashMap::new();
            for phi in &phi_candidates {
                if let Some((val, _)) = incoming_for_predecessor(*phi, pred) {
                    let key = phi
                        .as_instruction()
                        .get_name()
                        .unwrap()
                        .to_string_lossy()
                        .to_string();
                    vmap.insert(key, val);
                } else {
                    // This predecessor doesn’t contribute to this PHI; skip this pred
                    continue;
                }
            }

            // Rebuild non‑PHI instructions from bb into clone_block
            if !rebuild_tail_into(&builder, block, clone_block, &mut vmap) {
                print!("skipping");
                // if unsupported opcode appears, skip this pred
                continue;
            }

            // Redirect edge pred -> bb to pred -> clone_block
            redirect_edge(&builder, pred, block, clone_block);

            changed = true;
        }
    }
    changed
}

/// Extract BasicBlock operand i from instruction (works for Br/Switch operands).
fn operand_as_bb(inst: InstructionValue, idx: u32) -> Option<BasicBlock> {
    // In Inkwell 0.8, operands that are blocks are exposed as BasicBlock directly via the operand API.
    // We try both typed accessors that are commonly available.
    inst.get_operand(idx)?.block()
}

fn predecessors<'ctx>(func: FunctionValue<'ctx>, to: BasicBlock<'ctx>) -> Vec<BasicBlock<'ctx>> {
    use inkwell::values::InstructionOpcode as Op;
    let mut preds = Vec::new();

    for b in func.get_basic_blocks() {
        if let Some(term) = b.get_terminator() {
            match term.get_opcode() {
                Op::Br => {
                    // Unconditional: operand 0 = target BB
                    if !term.is_conditional() {
                        if operand_as_bb(term, 0) == Some(to) {
                            preds.push(b);
                        }
                    } else {
                        // Conditional: operand 1 = then BB, operand 2 = else BB
                        if operand_as_bb(term, 1) == Some(to) || operand_as_bb(term, 2) == Some(to)
                        {
                            preds.push(b);
                        }
                    }
                }
                _ => { /* We lowered switches and don't use indirectbr so no need to handle those cases*/
                }
            }
        }
    }
    preds
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
            .create_string_attribute("qir_profiles", "custom"),
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
            "expected main function: \"{}\" not found in HUGR",
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

/// First non‑PHI in a block
fn first_non_phi(bb: BasicBlock) -> Option<InstructionValue> {
    let mut it = bb.get_first_instruction();
    while let Some(i) = it {
        if i.get_opcode() != inkwell::values::InstructionOpcode::Phi {
            return Some(i);
        }
        it = i.get_next_instruction();
    }
    None
}

fn name_of_block(bb: BasicBlock<'_>) -> String {
    bb.get_name().to_string_lossy().to_string()
}

fn incoming_for_predecessor<'ctx>(
    phi: PhiValue<'ctx>,
    pred: BasicBlock<'ctx>,
) -> Option<(BasicValueEnum<'ctx>, BasicBlock<'ctx>)> {
    for (val, inc_bb) in phi.get_incomings() {
        if inc_bb == pred {
            return Some((val, inc_bb));
        }
    }
    None
}

/// The result of rebuilding a *non-terminator* instruction.
pub enum RebuildOutcome<'ctx> {
    /// The instruction was rebuilt and produced a BasicValue (SSA value).
    Value(BasicValueEnum<'ctx>),
    /// The instruction was rebuilt but produces no value (e.g., `store`, `call void`).
    Void,
}

/// Rebuild all non‑PHI instructions from `from_bb` into `into_bb`.
fn rebuild_tail_into<'ctx>(
    builder: &Builder<'ctx>,
    from_bb: BasicBlock<'ctx>,
    into_bb: BasicBlock<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> bool {
    builder.position_at_end(into_bb);
    let mut it = first_non_phi(from_bb);
    while let Some(inst) = it {
        if inst.is_terminator() {
            if !rebuild_terminator(builder, inst, vmap) {
                return false;
            }
            break;
        }
        match rebuild_inst(builder, inst, vmap) {
            Ok(RebuildOutcome::Value(bv)) => {
                // only value-producing instructions enter vmap
                vmap.insert(inst.get_name().unwrap().to_string_lossy().to_string(), bv);
            }
            Ok(RebuildOutcome::Void) => {
                // built successfully, but nothing to map → keep going
            }
            Err(()) => {
                // unsupported/failed to rebuild → bail on this path
                return false;
            }
        }
        it = inst.get_next_instruction();
    }
    true
}

/// Remap a BasicValue through vmap using the original instruction’s name as key.
fn remap<'ctx>(
    vmap: &HashMap<String, BasicValueEnum<'ctx>>,
    v: BasicValueEnum<'ctx>,
) -> BasicValueEnum<'ctx> {
    if let Some(orig) = v
        .as_instruction_value()
        .map(|iv| iv.get_name().unwrap().to_string_lossy().to_string())
    {
        if let Some(mapped) = vmap.get(&orig) {
            return *mapped;
        }
    }
    v
}

fn rebuild_terminator<'ctx>(
    builder: &Builder<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> bool {
    use inkwell::values::InstructionOpcode as Op;
    match inst.get_opcode() {
        Op::Br => {
            if inst.is_conditional() {
                let cond = remap(vmap, inst_operand_value(inst, 0).unwrap()).into_int_value();

                let tbb = operand_as_bb(inst, 1).unwrap();
                let fbb = operand_as_bb(inst, 2).unwrap();
                builder.build_conditional_branch(cond, fbb, tbb).is_ok()
            } else {
                let bb = operand_as_bb(inst, 0).unwrap();
                builder.build_unconditional_branch(bb).is_ok()
            }
        }
        Op::Return => {
            let val = inst
                .get_operand(0)
                .and_then(|o| operand_as_value(o))
                .map(|v| remap(vmap, v));

            use inkwell::values::BasicValue; // bring the trait into scope
            builder
                .build_return(
                    val.as_ref().map(|v| v as &dyn BasicValue), // coerce &BasicValueEnum -> &dyn BasicValue
                )
                .is_ok()
        }
        // TODO: handle Switch if your IR uses it (map default and cases)
        _ => false,
    }
}

fn redirect_edge<'ctx>(
    builder: &Builder<'ctx>,
    from: BasicBlock<'ctx>,
    old_to: BasicBlock<'ctx>,
    new_to: BasicBlock<'ctx>,
) {
    if let Some(term) = from.get_terminator() {
        use inkwell::values::InstructionOpcode as Op;
        builder.position_at_end(from);
        match term.get_opcode() {
            Op::Br => {
                if term.is_conditional() {
                    let cond = inst_operand_value(term, 0).unwrap().into_int_value();
                    let then_bb = operand_as_bb(term, 1).unwrap();
                    let else_bb = operand_as_bb(term, 2).unwrap();
                    let new_then = if then_bb == old_to { new_to } else { then_bb };
                    let new_else = if else_bb == old_to { new_to } else { else_bb };
                    builder
                        .build_conditional_branch(cond, new_else, new_then)
                        .ok();
                    println!("erasing conditional");
                    term.erase_from_basic_block();
                } else {
                    builder.build_unconditional_branch(new_to).ok();
                    println!("erasing unconditional");
                    term.erase_from_basic_block();
                }
            }
            _ => { /* extend for switch if needed */ }
        }
    }
}

pub fn rebuild_inst<'ctx>(
    builder: &Builder<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> Result<RebuildOutcome<'ctx>, ()> {
    use inkwell::values::InstructionOpcode as Op;

    let name = inst.get_name().unwrap_or(c"").to_string_lossy();

    match inst.get_opcode() {
        // ---------------- Pointer / aggregate ops ----------------
        Op::GetElementPtr => unsafe {
            let base = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let num_ops = inst.get_num_operands();
            let mut indices = Vec::new();
            for i in 1..num_ops {
                let idx = inst_operand_value(inst, i).ok_or(())?;
                indices.push(remap(vmap, idx).into_int_value());
            }
            let built = builder
                .build_gep(base.into_pointer_value(), &indices, &name)
                .ok()
                .ok_or(())?;
            Ok(RebuildOutcome::Value(built.as_basic_value_enum()))
        },

        // ---------------- Casts (no `build_bitcast` fallback) ----------------
        Op::BitCast => {
            // We implement bitcast via specialized casts. See comments in our previous message.
            let src_val = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let dst_any = inst.get_type(); // LLVM 14: typed pointers still exist

            match dst_any.try_into() {
                Ok(BasicTypeEnum::PointerType(dst_ptr_ty)) => {
                    let src_ptr = match src_val {
                        BasicValueEnum::PointerValue(p) => p,
                        _ => return Err(()),
                    };
                    let cast = builder
                        .build_pointer_cast(src_ptr, dst_ptr_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::IntType(dst_int_ty)) => {
                    let src_int = match src_val {
                        BasicValueEnum::IntValue(i) => i,
                        _ => return Err(()),
                    };
                    if src_int.get_type().get_bit_width() != dst_int_ty.get_bit_width() {
                        return Err(());
                    }
                    let cast = builder
                        .build_int_cast(src_int, dst_int_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::FloatType(dst_fp_ty)) => {
                    let src_fp = match src_val {
                        BasicValueEnum::FloatValue(f) => f,
                        _ => return Err(()),
                    };
                    if src_fp.get_type() != dst_fp_ty {
                        return Err(());
                    }
                    let cast = builder
                        .build_float_cast(src_fp, dst_fp_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                _ => Err(()),
            }
        }

        // ---------------- Memory ops ----------------
        Op::Load => {
            let addr = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_pointer_value();
            //let ty   = inst.get_type();
            let load = builder.build_load(addr, &name).ok().ok_or(())?;
            Ok(RebuildOutcome::Value(load))
        }

        Op::Store => {
            let val = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let addr = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_pointer_value();
            builder.build_store(addr, val).ok().ok_or(())?;
            Ok(RebuildOutcome::Void)
        }

        // ---------------- Comparisons / select ----------------
        Op::ICmp => {
            let pred = inst.get_icmp_predicate().ok_or(())?;
            let lhs = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let rhs = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_int_value();
            let cmp = builder
                .build_int_compare(pred, lhs, rhs, &name)
                .ok()
                .ok_or(())?;
            Ok(RebuildOutcome::Value(cmp.as_basic_value_enum()))
        }

        Op::Select => {
            let cond = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let tval = remap(vmap, inst_operand_value(inst, 1).ok_or(())?);
            let fval = remap(vmap, inst_operand_value(inst, 2).ok_or(())?);
            let sel = builder
                .build_select(cond, tval, fval, &name)
                .ok()
                .ok_or(())?;
            Ok(RebuildOutcome::Value(sel))
        }

        // ---------------- Integer arithmetic ----------------
        Op::Add
        | Op::Sub
        | Op::Mul
        | Op::UDiv
        | Op::SDiv
        | Op::URem
        | Op::SRem
        | Op::And
        | Op::Or
        | Op::Xor => {
            let lhs = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let rhs = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_int_value();
            let res = match inst.get_opcode() {
                Op::Add => builder.build_int_add(lhs, rhs, &name),
                Op::Sub => builder.build_int_sub(lhs, rhs, &name),
                Op::Mul => builder.build_int_mul(lhs, rhs, &name),
                Op::UDiv => builder.build_int_unsigned_div(lhs, rhs, &name),
                Op::SDiv => builder.build_int_signed_div(lhs, rhs, &name),
                Op::URem => builder.build_int_unsigned_rem(lhs, rhs, &name),
                Op::SRem => builder.build_int_signed_rem(lhs, rhs, &name),
                Op::And => builder.build_and(lhs, rhs, &name),
                Op::Or => builder.build_or(lhs, rhs, &name),
                Op::Xor => builder.build_xor(lhs, rhs, &name),
                _ => unreachable!(),
            }
            .ok()
            .ok_or(())?;
            Ok(RebuildOutcome::Value(res.as_basic_value_enum()))
        }

        // ---------------- Calls (LLVM 14: use build_direct_call) ----------------
        Op::Call => {
            let cs = CallSiteValue::try_from(inst)?;
            let callee = cs.get_called_fn_value().ok_or(())?;

            // Collect value operands as args (calls don't have block operands).
            let mut args = Vec::new();
            for i in 0..cs.count_arguments() {
                if let Some(v) = inst_operand_value(inst, i) {
                    args.push(remap(vmap, v).into());
                }
            }

            // NOTE: In Inkwell, build_call is available only for LLVM>=15 and aliases build_direct_call.
            // On LLVM 14, use build_direct_call.
            let callsite = builder.build_call(callee, &args, &name).ok().ok_or(())?; // [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/classllvm_1_1ValueMapper.html)

            // If return type is void → Void; else produce the resulting SSA value
            let value = callsite.try_as_basic_value();
            match value {
                ValueKind::Basic(bv) => Ok(RebuildOutcome::Value(bv)),
                ValueKind::Instruction(_) => Ok(RebuildOutcome::Void),
            }
        }

        // Add more opcodes as needed (sext/zext/trunc, ptrtoint/inttoptr, FP ops, vectors, etc.)
        _ => Err(()),
    }
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
            "expected main function: \"{}\" not found in HUGR",
            entry_func_name
        ));
    }
    fn_value.unwrap().set_linkage(Linkage::External);
    Ok(())
}

#[inline]
fn operand_as_value(op: Operand) -> Option<BasicValueEnum> {
    match op {
        Operand::Value(bv) => Some(bv),
        Operand::Block(_) => None,
    }
}

// Convenience wrappers around InstructionValue::get_operand(i)
#[inline]
fn inst_operand_value(inst: InstructionValue, i: u32) -> Option<BasicValueEnum> {
    inst.get_operand(i).and_then(operand_as_value)
}

#[cfg(test)]
pub(crate) mod test;
