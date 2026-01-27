use hugr::{HugrView, Node};
use hugr_llvm::{CodegenExtension, CodegenExtsBuilder};

use tket_qsystem::extension::classical_compute::wasm;

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
        use hugr_core::types::Type;
        builder
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::CONTEXT_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(session.iw_context().struct_type(&[], false).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::FUNC_TYPE_NAME.to_owned(),
                ),
                // TODO we want the function type, not an int
                |session, _hugr_type| Ok(session.iw_context().i64_type().into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::MODULE_TYPE_NAME.to_owned(),
                ),
                |session, hugr_type| {
                    let wasm::WasmType::Func { inputs, outputs }  = wasm::WasmType::try_from(hugr_type.clone())? else {
                        anyhow::bail!("doesn't make sense")
                    };
                    // validate inputs outputs.
                    // session.llvm_func_type(&hugr_core::types::Signature::new(
                    //     hugr_core::types::TypeRow::try_from(inputs.clone())?,
                    //     outputs.clone(),
                    // )).map_err(|e| e.into())
                }
           )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::RESULT_TYPE_NAME.to_owned(),
                ),
                |session, hugr_type| session.llvm_type(&Type::new_extension(hugr_type.clone())),
            )
            // .simple_extension_op::<T>(move |context, args, _| self.emit_op(context, args))
            .custom_const({
                move |ctx, _mod: &wasm::ConstWasmModule| {
                    Ok(ctx.iw_context().const_struct(&[], false).into())
                }
            })
    }
}
