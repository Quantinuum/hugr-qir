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
        builder
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::CONTEXT_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(session.iw_context().i64_type().into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::FUNC_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(session.iw_context().i64_type().into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::MODULE_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(session.iw_context().struct_type(&[], false).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::RESULT_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(session.iw_context().i64_type().into()),
            )
            // .simple_extension_op::<T>(move |context, args, _| self.emit_op(context, args))
            .custom_const({
                move |ctx, _mod: &wasm::ConstWasmModule| {
                    Ok(ctx.iw_context().const_struct(&[], false).into())
                }
            })
    }
}
 