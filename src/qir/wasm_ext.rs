use hugr::types::{Signature, Type};
use hugr::{
    extension::simple_op::MakeExtensionOp as _,
    ops::ExtensionOp,
    types::{CustomType, TypeRow},
    HugrView, Node,
};
use hugr_llvm::{
    emit::{EmitFuncContext, EmitOpArgs},
    types::TypingSession,
    CodegenExtension, CodegenExtsBuilder,
};

use anyhow::{bail, ensure, Result};
use inkwell::types::FunctionType;
use inkwell::{
    types::{BasicTypeEnum, StructType},
    values::{CallableValue, FunctionValue, PointerValue},
};
use tket_qsystem::extension::classical_compute::{wasm, ComputeOp};

pub struct WasmCodegen {}

impl WasmCodegen {
    pub fn new() -> Self {
        WasmCodegen {}
    }
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
                emit_wasm_op(context, args)
            })
            .custom_const({
                move |ctx, _mod: &wasm::ConstWasmModule| {
                    Ok(ctx.iw_context().const_struct(&[], false).into())
                }
            })
    }
}

fn empty_struct_type<'c>(context: &'c inkwell::context::Context) -> StructType<'c> {
    context.struct_type(&[], false).into()
}

fn result_type<'c>(
    session: TypingSession<'c, '_>,
    hugr_type: &CustomType,
) -> Result<BasicTypeEnum<'c>> {
    let wasm::WasmType::Result { outputs } = hugr_type.clone().try_into()? else {
        anyhow::bail!("Expected WasmType::Result");
    };

    if outputs.len() == 0 {
        return Ok(empty_struct_type(session.iw_context()).into());
    }

    if outputs.len() > 1 {
        bail!("Result type has more than one output value")
    }

    session.llvm_type(&Type::new_extension(hugr_type.clone()))
}

fn insert_func<'c, H: HugrView<Node = Node>>(
    ctx: &EmitFuncContext<'c, '_, H>,
    name: &str,
    func_type: FunctionType<'c>,
    _wasm_id: u64,
) -> Result<FunctionValue<'c>> {
    let func = ctx.get_extern_func(name, func_type)?;
    // TODO set attributes
    Ok(func)
}

fn emit_wasm_op<'c, H: HugrView<Node = Node>>(
    // wasm_module
    ctx: &EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    match wasm::WasmOp::from_extension_op(&args.node())?.into() {
        wasm::WasmOp::GetContext => {
            let r = ctx.iw_context().struct_type(&[], false).get_undef().into();
            let builder = ctx.builder();
            args.outputs.finish(builder, [r])
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
            let name = format!("wasm_func_{id}");
            let inputs: TypeRow = inputs.try_into()?;
            let outputs: TypeRow = outputs.try_into()?;
            let llvm_func_ty = ctx.llvm_func_type(&Signature::new(inputs, outputs))?;
            let func = insert_func(ctx, &name, llvm_func_ty, id)?;
            let builder = ctx.builder();
            args.outputs
                .finish(builder, [func.as_global_value().as_pointer_value().into()])
        }
        wasm::WasmOp::LookupByName { name, .. } => {
            // TODO convert to id and reuse LookupById
            todo!()
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
            let r = if outputs.len() == 0 {
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
            if outputs.len() == 0 {
                args.outputs.finish(builder, [ctx_out])
            } else {
                args.outputs.finish(builder, [ctx_out, *r])
            }
        }
        op => bail!("Unknown op: {op:?}"),
    }
}
