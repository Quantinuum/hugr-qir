//! LLVM codegen for the `tket.qsystem.utils` extension.
use tket::hugr;

use anyhow::Result;
use hugr::llvm::custom::CodegenExtension;
use hugr::llvm::emit::EmitOpArgs;
use hugr::llvm::emit::func::EmitFuncContext;
use hugr::llvm::inkwell::attributes::{Attribute, AttributeLoc};
use tket::hugr::ops::ExtensionOp;
use tket::hugr::{HugrView, Node};
use tket_qsystem::extension::utils::UtilsOp;

/// Codegen extension for `tket_qsystem` `utils` extension.
pub struct UtilsCodegenExtension;

impl CodegenExtension for UtilsCodegenExtension {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: tket::hugr::llvm::CodegenExtsBuilder<'a, H>,
    ) -> tket::hugr::llvm::CodegenExtsBuilder<'a, H>
    where
        Self: 'a,
    {
        builder.simple_extension_op(|context, args, op| emit_utils_op(context, args, op))
    }
}

/// Lower the `tket_qsystem` `utils` extension.
fn emit_utils_op<H: HugrView<Node = Node>>(
    ctx: &EmitFuncContext<'_, '_, H>,
    args: EmitOpArgs<'_, '_, ExtensionOp, H>,
    op: UtilsOp,
) -> Result<()> {
    match op {
        UtilsOp::GetCurrentShot => {
            let fn_get_cur_shot = ctx.get_extern_func(
                // fun get_current_shot() -> uint
                "___get_current_shot",
                ctx.typing_session()
                    .iw_context()
                    .i64_type()
                    .fn_type(&[], false),
            )?;
            let kind_id = Attribute::get_named_enum_kind_id("noundef");
            debug_assert_ne!(kind_id, 0, "LLVM does not recognize the noundef attribute");
            fn_get_cur_shot.add_attribute(
                AttributeLoc::Return,
                ctx.typing_session()
                    .iw_context()
                    .create_enum_attribute(kind_id, 0),
            );
            let result = ctx
                .builder()
                .build_call(fn_get_cur_shot, &[], "shot")?
                .try_as_basic_value()
                .unwrap_basic();
            args.outputs.finish(ctx.builder(), [result])
        }
        _ => anyhow::bail!("Unknown op: {op:?}"),
    }
}

#[cfg(test)]
mod test {
    use hugr::extension::simple_op::MakeRegisteredOp;
    use hugr::llvm::check_emission;
    use hugr::llvm::test::TestContext;
    use hugr::llvm::test::llvm_ctx;
    use hugr::llvm::test::single_op_hugr;
    use rstest::rstest;
    use tket_qsystem::extension::utils::UtilsOp;

    use super::*;

    #[rstest]
    #[case::get_current_shot(1, UtilsOp::GetCurrentShot)]
    fn emit_utils_codegen(
        #[case] _i: i32,
        #[with(_i)] mut llvm_ctx: TestContext,
        #[case] op: UtilsOp,
    ) {
        llvm_ctx.add_extensions(|ceb| {
            ceb.add_extension(UtilsCodegenExtension)
                .add_default_int_extensions()
        });
        let ext_op = op.to_extension_op().unwrap().into();
        let mut hugr = single_op_hugr(ext_op);
        check_emission!(hugr, llvm_ctx);
    }
}
