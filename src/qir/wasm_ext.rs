use hugr::types::{Signature, Type};
use hugr::{
    HugrView, Node,
    extension::simple_op::MakeExtensionOp as _,
    ops::ExtensionOp,
    types::{CustomType, TypeRow},
};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitFuncContext, EmitOpArgs},
    types::TypingSession,
};
use std::collections::BTreeMap;
use std::fs;

use anyhow::{Result, bail};
use hugr_core::extension::prelude::option_type;
use inkwell::attributes::AttributeLoc;
use inkwell::types::FunctionType;
use inkwell::values::BasicValue;
use inkwell::{
    types::{BasicTypeEnum, StructType},
    values::{CallableValue, FunctionValue},
};
use tket_qsystem::extension::classical_compute::wasm;
use tket_qsystem::extension::wasm::WasmType;
use wasmparser::{Export, ExternalKind, Payload};

pub struct WasmCodegen {
    funcs: BTreeMap<u64, String>,
}

impl WasmCodegen {
    pub fn new(wasm_file: &Option<String>) -> Self {
        let mut funcs = BTreeMap::new();
        if let Some(wasm_file) = wasm_file {
            funcs = wasm_funcs_from_wasm_file(wasm_file).unwrap()
        }
        WasmCodegen { funcs }
    }
}

pub fn wasm_funcs_from_wasm_file(wasm_file_path: &String) -> Result<BTreeMap<u64, String>> {
    let bytes = fs::read(wasm_file_path)?;
    let mut funcs: BTreeMap<u64, String> = BTreeMap::new();
    for payload in wasmparser::Parser::new(0).parse_all(&bytes) {
        if let Payload::ExportSection(exports) = payload? {
            for e in exports {
                let Export {
                    name,
                    kind: ExternalKind::Func,
                    index,
                } = e?
                else {
                    continue;
                };
                let None = funcs.insert(index.into(), name.to_string()) else {
                    bail!("Duplicate export found in wasm module: {name}");
                };
            }
        }
    }
    Ok(funcs)
}

impl CodegenExtension for WasmCodegen {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: CodegenExtsBuilder<'a, H>,
    ) -> CodegenExtsBuilder<'a, H> {
        builder
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::CONTEXT_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(empty_struct_type(session.iw_context()).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::FUNC_TYPE_NAME.to_owned(),
                ),
                |session, hugr_type| {
                    let wasm::WasmType::Func { inputs, outputs } =
                        wasm::WasmType::try_from(hugr_type.clone())?
                    else {
                        anyhow::bail!("doesn't make sense")
                    };
                    let inputs: TypeRow = inputs.try_into()?;
                    let outputs: TypeRow = outputs.try_into()?;
                    // TODO verify outputs has 0 or 1 element
                    let func_type = session.llvm_func_type(&Signature::new(inputs, outputs))?;
                    // TODO func_type has only allowed types in signature
                    Ok(func_type.ptr_type(Default::default()).into())
                },
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::MODULE_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(empty_struct_type(session.iw_context()).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::RESULT_TYPE_NAME.to_owned(),
                ),
                |session, hugr_type| result_type(session, hugr_type),
            )
            .simple_extension_op(move |context, args, _: wasm::WasmOpDef| {
                emit_wasm_op(&self.funcs, context, args)
            })
            .custom_const({
                move |ctx, _mod: &wasm::ConstWasmModule| {
                    Ok(ctx.iw_context().const_struct(&[], false).into())
                }
            })
    }
}

fn empty_struct_type(context: &inkwell::context::Context) -> StructType<'_> {
    context.struct_type(&[], false)
}

fn result_type<'c>(
    session: TypingSession<'c, '_>,
    hugr_type: &CustomType,
) -> Result<BasicTypeEnum<'c>> {
    let wasm::WasmType::Result { outputs } = hugr_type.clone().try_into()? else {
        anyhow::bail!("Expected WasmType::Result");
    };

    if outputs.is_empty() {
        return Ok(empty_struct_type(session.iw_context()).into());
    }

    if outputs.len() > 1 {
        bail!("Result type has more than one output value")
    }
    session.llvm_type(&outputs[0].clone().try_into().unwrap())
}

fn insert_func<'c, H: HugrView<Node = Node>>(
    ctx: &EmitFuncContext<'c, '_, H>,
    name: &str,
    func_type: FunctionType<'c>,
) -> Result<FunctionValue<'c>> {
    let func = ctx.get_extern_func(name, func_type)?;
    // TODO set attributes
    Ok(func)
}

fn emit_wasm_op<'c, H: HugrView<Node = Node>>(
    wasm_module: &BTreeMap<u64, String>,
    ctx: &EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    match wasm::WasmOp::from_extension_op(&args.node())? {
        wasm::WasmOp::GetContext => {
            let r = ctx.iw_context().struct_type(&[], false).get_undef().into();
            let builder = ctx.builder();
            let result_t =
                ctx.llvm_sum_type(option_type(Type::new_extension(WasmType::Context.into())))?;
            // Although the result is an option type, we always return true
            // in this lowering: failure is already handled.
            let pair = result_t.build_tag(builder, 1, vec![r])?;
            args.outputs
                .finish(ctx.builder(), [pair.as_basic_value_enum()])
        }
        wasm::WasmOp::DisposeContext => {
            let builder = ctx.builder();
            args.outputs.finish(builder, [])
        }
        wasm::WasmOp::LookupById {
            id,
            inputs,
            outputs,
        } => {
            let Some(name) = wasm_module.get(&id) else {
                bail!("Unknown wasm module id: {id}")
            };
            let inputs: TypeRow = inputs.try_into()?;
            let outputs: TypeRow = outputs.try_into()?;
            let llvm_func_ty = ctx.llvm_func_type(&Signature::new(inputs, outputs))?;
            let func = insert_func(ctx, name, llvm_func_ty)?;
            let llvm_context = ctx.get_current_module().get_context();
            let attribute = llvm_context.create_string_attribute("wasm", "");
            func.add_attribute(AttributeLoc::Function, attribute);
            let builder = ctx.builder();
            args.outputs
                .finish(builder, [func.as_global_value().as_pointer_value().into()])
        }
        wasm::WasmOp::LookupByName {
            name,
            inputs,
            outputs,
        } => {
            let inputs: TypeRow = inputs.try_into()?;
            let outputs: TypeRow = outputs.try_into()?;
            let llvm_func_ty = ctx.llvm_func_type(&Signature::new(inputs, outputs))?;
            let func = insert_func(ctx, &name, llvm_func_ty)?;
            let builder = ctx.builder();
            let llvm_context = ctx.get_current_module().get_context();
            let attribute = llvm_context.create_string_attribute("wasm", "");
            func.add_attribute(AttributeLoc::Function, attribute);
            args.outputs
                .finish(builder, [func.as_global_value().as_pointer_value().into()])
        }
        wasm::WasmOp::Call { outputs, .. } => {
            let func: CallableValue<'c> = args.inputs[1].into_pointer_value().try_into().unwrap();
            let call_args = args.inputs[2..]
                .iter()
                .copied()
                .map(|x| x.into())
                .collect::<Vec<_>>();
            let builder = ctx.builder();
            let r = builder.build_call(func, &call_args, "")?;

            // if no outputs, return a placeholder empty struct.
            // if one output, return that output directly.
            let r = if outputs.is_empty() {
                empty_struct_type(ctx.iw_context()).get_undef().into()
            } else {
                r.try_as_basic_value().left().unwrap()
            };
            args.outputs.finish(builder, [r])
        }
        wasm::WasmOp::ReadResult { outputs } => {
            let [r] = args.inputs.as_slice() else {
                bail!("expected 1 input")
            };
            let builder = ctx.builder();
            let ctx_out = empty_struct_type(ctx.iw_context()).get_undef().into();
            if outputs.is_empty() {
                args.outputs.finish(builder, [ctx_out])
            } else {
                args.outputs.finish(builder, [ctx_out, *r])
            }
        }
        op => bail!("Unknown op: {op:?}"),
    }
}

// TODO add test cases using simple_op_hugr
#[cfg(test)]
mod test {
    use super::*;
    use crate::WasmCodegen;
    use crate::qir::utils_ext::UtilsCodegenExtension;
    use hugr::llvm::check_emission;
    use hugr::llvm::test::{TestContext, llvm_ctx, single_op_hugr};
    use rstest::Context;
    use tket::circuit::TypeRow;
    use tket::hugr::std_extensions::arithmetic::int_types::INT_TYPES;
    use tket::hugr::type_row;
    use tket_qsystem::extension::wasm::WasmOp;

    #[rstest::rstest]
    #[case::get_context(WasmOp::GetContext)]
    #[case::dispose_context(WasmOp::DisposeContext)]
    #[case::lookup_by_id(WasmOp::LookupById {
        id: 42,
        inputs: type_row![].into(),
        outputs: type_row![].into(),
        })]
    #[case::lookup_by_name(WasmOp::LookupByName {
        name: "example_function".into(),
        inputs: type_row![].into(),
        outputs: type_row![].into(),
        })]
    #[case::call_args(WasmOp::Call {
        inputs: TypeRow::from(vec![
            INT_TYPES[5].clone(),
        ]),
        outputs: TypeRow::from(vec![]),
        })]
    #[case::call_ret_int(WasmOp::Call {
        inputs: type_row![],
        outputs: TypeRow::from(INT_TYPES[5].clone()),
        })]
    #[case::read_result_int(WasmOp::ReadResult {
        outputs: TypeRow::from(INT_TYPES[5].clone()),
        })]
    fn wasm_codegen(#[context] ctx: Context, mut llvm_ctx: TestContext, #[case] op: WasmOp) {
        let _g = {
            let desc = ctx.description.unwrap();
            let mut settings = insta::Settings::clone_current();
            let suffix = settings
                .snapshot_suffix()
                .map_or_else(|| desc.to_string(), |s| format!("{s}_{desc}"));
            settings.set_snapshot_suffix(suffix);
            settings
        }
        .bind_to_scope();

        llvm_ctx.add_extensions(move |cge| {
            cge.add_extension(UtilsCodegenExtension)
                .add_default_prelude_extensions()
                .add_default_int_extensions()
                .add_extension(WasmCodegen {
                    funcs: BTreeMap::from([(42, "wasm_func_42".into())]),
                })
        });
        let hugr = single_op_hugr(op.into());
        check_emission!(hugr, llvm_ctx);
    }
}
