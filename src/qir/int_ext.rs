//! QIR-specific LLVM lowering for integer operations.

use anyhow::{Result, anyhow, ensure};
use hugr::extension::simple_op::MakeOpDef;
use hugr::llvm::custom::CodegenExtension;
use hugr::llvm::emit::{EmitOpArgs, func::EmitFuncContext};
use hugr::llvm::inkwell::IntPredicate;
use hugr::ops::ExtensionOp;
use hugr::std_extensions::arithmetic::int_ops::{self, IntOpDef};
use hugr::{HugrView, Node};

/// Overrides integer operations whose default LLVM lowering is unsuitable for QIR.
pub struct QirIntCodegenExtension;

impl CodegenExtension for QirIntCodegenExtension {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: hugr::llvm::CodegenExtsBuilder<'a, H>,
    ) -> hugr::llvm::CodegenExtsBuilder<'a, H>
    where
        Self: 'a,
    {
        builder.extension_op(int_ops::EXTENSION_ID, IntOpDef::ipow.opdef_id(), emit_ipow)
    }
}

/// Emit integer exponentiation as a canonical, single-exit countdown loop.
///
/// The default hugr-llvm lowering uses allocas and a switch with separate exits
/// for exponents zero and one. LLVM's scalar-evolution analysis cannot always
/// recover a trip count for that shape after an enclosing loop is unrolled.
fn emit_ipow<'c, H: HugrView<Node = Node>>(
    ctx: &mut EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    let [base, exponent] = args.inputs.as_slice() else {
        return Err(anyhow!(
            "ipow lowering expected 2 inputs, got {}",
            args.inputs.len()
        ));
    };
    ensure!(
        base.is_int_value() && exponent.is_int_value(),
        "ipow lowering expected integer inputs"
    );
    ensure!(
        base.get_type() == exponent.get_type(),
        "ipow lowering expected inputs of the same type"
    );

    let base = base.into_int_value();
    let exponent = exponent.into_int_value();
    let int_type = base.get_type();
    let one = int_type.const_int(1, false);
    let zero = int_type.const_zero();

    // Integer arithmetic wraps at the declared bit width. `2**exponent` is
    // therefore a shift for in-range exponents and zero otherwise. Guard the
    // shift because LLVM makes shifts by the bit width or greater poison.
    if base.get_zero_extended_constant() == Some(2) {
        let width = int_type.const_int(int_type.get_bit_width().into(), false);
        let exponent_out_of_range = ctx.builder().build_int_compare(
            IntPredicate::UGE,
            exponent,
            width,
            "ipow.exponent_out_of_range",
        )?;
        let safe_exponent = ctx.builder().build_select(
            exponent_out_of_range,
            zero,
            exponent,
            "ipow.safe_exponent",
        )?;
        let shifted = ctx.builder().build_left_shift(
            one,
            safe_exponent.into_int_value(),
            "ipow.power_of_two",
        )?;
        let result = ctx.builder().build_select(
            exponent_out_of_range,
            zero,
            shifted,
            "ipow.power_of_two.result",
        )?;
        return args.outputs.finish(ctx.builder(), [result]);
    }

    let entry = ctx
        .builder()
        .get_insert_block()
        .ok_or_else(|| anyhow!("ipow lowering requires an insertion block"))?;
    let function = ctx.func();
    let header = ctx.iw_context().append_basic_block(function, "ipow.header");
    let body = ctx.iw_context().append_basic_block(function, "ipow.body");
    let exit = ctx.iw_context().append_basic_block(function, "ipow.exit");

    ctx.builder().build_unconditional_branch(header)?;

    ctx.builder().position_at_end(header);
    let accumulator = ctx.builder().build_phi(int_type, "ipow.accumulator")?;
    let remaining = ctx.builder().build_phi(int_type, "ipow.remaining")?;
    accumulator.add_incoming(&[(&one, entry)]);
    remaining.add_incoming(&[(&exponent, entry)]);
    let finished = ctx.builder().build_int_compare(
        IntPredicate::EQ,
        remaining.as_basic_value().into_int_value(),
        zero,
        "ipow.finished",
    )?;
    ctx.builder()
        .build_conditional_branch(finished, exit, body)?;

    ctx.builder().position_at_end(body);
    let next_accumulator = ctx.builder().build_int_mul(
        accumulator.as_basic_value().into_int_value(),
        base,
        "ipow.next_accumulator",
    )?;
    let next_remaining = ctx.builder().build_int_sub(
        remaining.as_basic_value().into_int_value(),
        one,
        "ipow.next_remaining",
    )?;
    ctx.builder().build_unconditional_branch(header)?;
    accumulator.add_incoming(&[(&next_accumulator, body)]);
    remaining.add_incoming(&[(&next_remaining, body)]);

    ctx.builder().position_at_end(exit);
    args.outputs
        .finish(ctx.builder(), [accumulator.as_basic_value()])
}
