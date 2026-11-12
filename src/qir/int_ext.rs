//! LLVM lowering for integer arithmetic operations.

use anyhow::Result;
use hugr::{HugrView, Node, ops::ExtensionOp, std_extensions::arithmetic::int_ops};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitOpArgs, func::EmitFuncContext},
};

use crate::inkwell::{
    IntPredicate,
    builder::Builder,
    values::{BasicValue, IntValue},
};

/// Lower integer powers to counted loops that LLVM can fully unroll.
///
/// The default `hugr-llvm` lowering initializes the accumulator to the base,
/// stores the accumulator and exponent in stack slots, and uses a switch to
/// handle exponents zero and one separately. This lowering instead initializes
/// the accumulator to one and uses SSA phis with a single exit at exponent zero.
/// This exposes a simple countdown to LLVM's loop analysis, allowing static
/// powers to fold after enclosing loops are unrolled and their exponents become
/// constant. It also avoids relying on promotion of the stack slots to SSA.
///
/// The tradeoff is an extra multiplication for positive exponents before
/// optimization: this loop performs `exponent` multiplications rather than
/// `exponent - 1`. Both algorithms take linear time in the exponent; neither
/// uses exponentiation by squaring. LLVM can fold the initial multiplication
/// by one when unrolling, but unrolling large powers can still increase compile
/// time and intermediate code size. Dynamic or oversized loops that survive
/// optimization are rejected by the QIR compiler's loop checks.
///
/// Integer semantics match the default lowering: the exponent is unsigned,
/// multiplication wraps at the integer width, and any base to exponent zero
/// returns one, including `0**0`.
pub struct IntOpOverrideCodegenExtension;

impl CodegenExtension for IntOpOverrideCodegenExtension {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: CodegenExtsBuilder<'a, H>,
    ) -> CodegenExtsBuilder<'a, H>
    where
        Self: 'a,
    {
        builder.extension_op(int_ops::EXTENSION_ID, "ipow".into(), emit_int_pow)
    }
}

fn emit_int_pow<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    let base = args.inputs[0].into_int_value();
    let exponent = args.inputs[1].into_int_value();
    let result = build_int_pow(context.builder(), base, exponent)?;
    args.outputs
        .finish(context.builder(), [result.as_basic_value_enum()])
}

fn build_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    exponent: IntValue<'c>,
) -> Result<IntValue<'c>> {
    let ty = base.get_type();
    let one = ty.const_int(1, false);
    let zero = ty.const_zero();
    let entry = builder.get_insert_block().unwrap();
    let function = entry.get_parent().unwrap();
    let context = entry.get_context();
    let header = context.append_basic_block(function, "ipow.header");
    let body = context.append_basic_block(function, "ipow.body");
    let done = context.append_basic_block(function, "ipow.done");
    builder.build_unconditional_branch(header)?;

    builder.position_at_end(header);
    let remaining = builder.build_phi(ty, "ipow.remaining")?;
    let accumulator = builder.build_phi(ty, "ipow.accumulator")?;
    remaining.add_incoming(&[(&exponent, entry)]);
    accumulator.add_incoming(&[(&one, entry)]);
    let acc = accumulator.as_basic_value().into_int_value();
    let exp = remaining.as_basic_value().into_int_value();
    let finished = builder.build_int_compare(IntPredicate::EQ, exp, zero, "ipow.finished")?;
    builder.build_conditional_branch(finished, done, body)?;

    builder.position_at_end(body);
    // Integer multiplication wraps, and the exponent is interpreted as unsigned.
    let product = builder.build_int_mul(acc, base, "ipow.product")?;
    let next = builder.build_int_sub(exp, one, "ipow.next")?;
    builder.build_unconditional_branch(header)?;
    remaining.add_incoming(&[(&next, body)]);
    accumulator.add_incoming(&[(&product, body)]);

    builder.position_at_end(done);
    Ok(acc)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        inkwell::{OptimizationLevel, context::Context},
        target::CompileTarget,
    };

    #[test]
    fn integer_powers_match_wrapping_arithmetic() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        CompileTarget::Native.initialise();
        for width in [1, 2, 4, 8, 16, 32, 64] {
            let context = Context::create();
            let module = context.create_module("integer_power");
            let builder = context.create_builder();
            let i64_type = context.i64_type();
            let ty = context
                .custom_width_int_type(std::num::NonZeroU32::new(width).unwrap())
                .unwrap();
            let function = module.add_function(
                "power",
                i64_type.fn_type(&[i64_type.into(), i64_type.into()], false),
                None,
            );
            builder.position_at_end(context.append_basic_block(function, "entry"));
            let base = builder
                .build_int_truncate_or_bit_cast(
                    function.get_nth_param(0).unwrap().into_int_value(),
                    ty,
                    "base",
                )
                .unwrap();
            let exponent = builder
                .build_int_truncate_or_bit_cast(
                    function.get_nth_param(1).unwrap().into_int_value(),
                    ty,
                    "exponent",
                )
                .unwrap();
            let result = build_int_pow(&builder, base, exponent).unwrap();
            let result = builder
                .build_int_z_extend_or_bit_cast(result, i64_type, "result")
                .unwrap();
            builder.build_return(Some(&result)).unwrap();
            module.verify().unwrap();
            let engine = module
                .create_jit_execution_engine(OptimizationLevel::None)
                .unwrap();
            let power = unsafe {
                engine
                    .get_function::<unsafe extern "C" fn(u64, u64) -> u64>("power")
                    .unwrap()
            };
            let mask = u64::MAX >> (64 - width);
            for base in [0u64, 1, 2, 3, u64::MAX - 1, u64::MAX] {
                for exponent in [0u64, 1, 2, 3, 7, 8, 63, 64, 65] {
                    let expected = base.wrapping_pow((exponent & mask) as u32) & mask;
                    assert_eq!(
                        unsafe { power.call(base, exponent) },
                        expected,
                        "width={width}, base={base}, exponent={exponent}"
                    );
                }
            }
        }
    }
}
