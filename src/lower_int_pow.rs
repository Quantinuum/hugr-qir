//! LLVM rewrites that replace deferred integer-power placeholders with arithmetic.
//!
//! [`crate::qir::int_ext`] emits integer powers as calls to placeholder
//! declarations. Constant exponents become specialized multiplication chains;
//! remaining runtime exponents become loop-free binary exponentiation.

use anyhow::{Result, anyhow, bail, ensure};

use crate::inkwell::{
    IntPredicate,
    builder::Builder,
    module::Module,
    values::{
        AnyValueEnum, BasicValue, BasicValueEnum, CallSiteValue, InstructionValue, IntValue,
        Operand,
    },
};
use crate::qir::int_ext::{is_int_pow_helper, validate_operand_types};

/// Which placeholder calls a lowering pass should replace.
#[derive(Clone, Copy, PartialEq, Eq)]
enum Exponents {
    /// Only calls whose exponent is an integer constant.
    Constant,
    /// Every call, including those with runtime exponents.
    All,
}

/// Specialize deferred powers whose exponents have become integer constants.
/// Repeat to handle powers that themselves supply another power's exponent.
pub(crate) fn lower_constant_int_powers(module: &Module<'_>) -> Result<usize> {
    let mut total = 0;
    loop {
        let lowered = lower_int_powers(module, Exponents::Constant)?;
        total += lowered;
        if lowered == 0 {
            return Ok(total);
        }
    }
}

/// Expand every remaining power and remove its compiler-only declaration.
pub(crate) fn lower_remaining_int_powers(module: &Module<'_>) -> Result<usize> {
    let lowered = lower_int_powers(module, Exponents::All)?;
    let helpers = module
        .get_functions()
        .filter(|function| is_int_pow_helper(*function))
        .collect::<Vec<_>>();
    for helper in helpers {
        ensure!(
            helper
                .as_global_value()
                .as_pointer_value()
                .get_first_use()
                .is_none(),
            "Unresolved reference to integer-power helper {:?}",
            helper.get_name()
        );
        // SAFETY: The declaration has no remaining uses.
        unsafe { helper.delete() };
    }
    Ok(lowered)
}

fn lower_int_powers(module: &Module<'_>, exponents: Exponents) -> Result<usize> {
    let builder = module.get_context().create_builder();
    let mut lowered = 0;
    for call in int_pow_calls(module) {
        let base = int_operand(call, 0)?;
        let exponent = int_operand(call, 1)?;
        if exponents == Exponents::Constant && exponent.get_zero_extended_constant().is_none() {
            continue;
        }
        builder.position_before(&call);
        let result = build_int_pow(&builder, base, exponent)?;
        IntValue::try_from(call)
            .map_err(|_| anyhow!("Integer-power helper must return an integer"))?
            .replace_all_uses_with(result);
        call.erase_from_basic_block();
        lowered += 1;
    }
    Ok(lowered)
}

/// Collect calls to integer-power placeholders by walking each placeholder's uses.
fn int_pow_calls<'c>(module: &Module<'c>) -> Vec<InstructionValue<'c>> {
    let mut calls = Vec::new();
    for helper in module.get_functions().filter(|f| is_int_pow_helper(*f)) {
        let first_use = helper.as_global_value().as_pointer_value().get_first_use();
        let mut helper_calls = std::iter::successors(first_use, |u| u.get_next_use())
            .filter_map(|u| match u.get_user() {
                AnyValueEnum::IntValue(value) => value.as_instruction_value(),
                _ => None,
            })
            .filter(|inst| {
                CallSiteValue::try_from(*inst)
                    .ok()
                    .and_then(|call| call.get_called_fn_value())
                    == Some(helper)
            })
            .collect::<Vec<_>>();
        // LLVM prepends new uses, so reverse to visit calls in creation order.
        helper_calls.reverse();
        calls.extend(helper_calls);
    }
    calls
}

fn int_operand<'c>(call: InstructionValue<'c>, index: u32) -> Result<IntValue<'c>> {
    match call.get_operand(index) {
        Some(Operand::Value(BasicValueEnum::IntValue(value))) => Ok(value),
        _ => bail!("Integer-power helper requires two integer operands"),
    }
}

fn build_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    exponent: IntValue<'c>,
) -> Result<IntValue<'c>> {
    validate_operand_types(base, exponent)?;
    match exponent.get_zero_extended_constant() {
        Some(exponent) => build_constant_int_pow(builder, base, exponent),
        None => build_runtime_int_pow(builder, base, exponent),
    }
}

/// Square-and-multiply chain specialized to a known exponent.
fn build_constant_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    mut exponent: u64,
) -> Result<IntValue<'c>> {
    let mut power = base;
    let mut result = None;
    while exponent != 0 {
        if exponent & 1 != 0 {
            result = Some(match result {
                None => power,
                Some(acc) => builder.build_int_mul(acc, power, "ipow.product")?,
            });
        }
        exponent >>= 1;
        if exponent != 0 {
            power = builder.build_int_mul(power, power, "ipow.square")?;
        }
    }
    Ok(result.unwrap_or_else(|| base.get_type().const_int(1, false)))
}

/// Loop-free square-and-multiply over every bit of a runtime exponent.
fn build_runtime_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    exponent: IntValue<'c>,
) -> Result<IntValue<'c>> {
    let ty = base.get_type();
    let mut result = ty.const_int(1, false);
    let mut power = base;
    for bit in 0..ty.get_bit_width() {
        let masked = builder.build_and(exponent, ty.const_int(1_u64 << bit, false), "ipow.bit")?;
        let set =
            builder.build_int_compare(IntPredicate::NE, masked, ty.const_zero(), "ipow.set")?;
        let product = builder.build_int_mul(result, power, "ipow.product")?;
        result = builder
            .build_select(set, product, result, "ipow.accumulator")?
            .into_int_value();
        if bit + 1 < ty.get_bit_width() {
            power = builder.build_int_mul(power, power, "ipow.square")?;
        }
    }
    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        inkwell::{OptimizationLevel, context::Context},
        llvm_unroll::ensure_no_loops,
        qir::int_ext::declare_int_pow,
        target::CompileTarget,
        test::LLVM_TEST_LOCK,
    };

    #[test]
    fn specializes_constant_exponents_without_unrolling() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("constant_exponents");
        let builder = context.create_builder();
        let ty = context.i64_type();
        let helper = declare_int_pow(&module, ty).unwrap();
        let exponents = [0, 1, 2, 3, 13, 1000, 1_u64 << 63, u64::MAX];
        for (index, exponent) in exponents.into_iter().enumerate() {
            let function = module.add_function(
                &format!("power{index}"),
                ty.fn_type(&[ty.into()], false),
                None,
            );
            builder.position_at_end(context.append_basic_block(function, "entry"));
            let result = builder
                .build_call(
                    helper,
                    &[
                        function.get_nth_param(0).unwrap().into(),
                        ty.const_int(exponent, false).into(),
                    ],
                    "deferred",
                )
                .unwrap()
                .try_as_basic_value()
                .unwrap_basic();
            builder.build_return(Some(&result)).unwrap();
        }

        assert_eq!(lower_constant_int_powers(&module).unwrap(), exponents.len());
        assert_eq!(lower_constant_int_powers(&module).unwrap(), 0);
        assert_eq!(lower_remaining_int_powers(&module).unwrap(), 0);
        ensure_no_loops(&module, 1).unwrap();
        module.verify().unwrap();
        CompileTarget::Native.initialise();
        let engine = module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();
        for (index, exponent) in exponents.into_iter().enumerate() {
            let power = unsafe {
                engine
                    .get_function::<unsafe extern "C" fn(u64) -> u64>(&format!("power{index}"))
                    .unwrap()
            };
            for base in [0_u64, 1, 2, 3, u64::MAX - 1, u64::MAX] {
                let expected = if let Ok(exponent) = u32::try_from(exponent) {
                    base.wrapping_pow(exponent)
                } else if base & 1 == 0 {
                    0
                } else if exponent == 1_u64 << 63 {
                    1
                } else {
                    // For odd bases, a^(2^64 - 1) is the inverse of a modulo 2^64.
                    // Check the inverse directly rather than calculating it here.
                    let result = unsafe { power.call(base) };
                    assert_eq!(result.wrapping_mul(base), 1);
                    continue;
                };
                assert_eq!(unsafe { power.call(base) }, expected);
            }
        }
    }

    #[test]
    fn folds_nested_constant_powers() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("nested_powers");
        let builder = context.create_builder();
        let ty = context.i64_type();
        let helper = declare_int_pow(&module, ty).unwrap();
        let function = module.add_function("power", ty.fn_type(&[], false), None);
        builder.position_at_end(context.append_basic_block(function, "entry"));
        let inner = builder
            .build_call(
                helper,
                &[ty.const_int(2, false).into(), ty.const_int(3, false).into()],
                "inner",
            )
            .unwrap()
            .try_as_basic_value()
            .unwrap_basic();
        let outer = builder
            .build_call(
                helper,
                &[ty.const_int(3, false).into(), inner.into()],
                "outer",
            )
            .unwrap()
            .try_as_basic_value()
            .unwrap_basic();
        let ret = builder.build_return(Some(&outer)).unwrap();

        assert_eq!(lower_constant_int_powers(&module).unwrap(), 2);
        let Some(Operand::Value(BasicValueEnum::IntValue(result))) = ret.get_operand(0) else {
            panic!("expected an integer return value");
        };
        assert_eq!(result.get_zero_extended_constant(), Some(6561));
        module.verify().unwrap();
    }

    #[test]
    fn rejects_mismatched_operand_widths_before_modifying_ir() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("mismatched_integer_power");
        let builder = context.create_builder();
        let function = module.add_function("power", context.void_type().fn_type(&[], false), None);
        let entry = context.append_basic_block(function, "entry");
        builder.position_at_end(entry);

        let error = build_int_pow(
            &builder,
            context.i64_type().const_int(2, false),
            context.i32_type().const_int(3, false),
        )
        .unwrap_err();

        assert_eq!(
            error.to_string(),
            "Integer power operands must have matching widths (base: 64, exponent: 32)"
        );
        assert_eq!(function.count_basic_blocks(), 1);
        assert_eq!(entry.get_instructions().count(), 0);
        builder.build_return(None).unwrap();
        module.verify().unwrap();
    }

    #[test]
    fn integer_powers_match_wrapping_arithmetic() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
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
            let helper = declare_int_pow(&module, ty).unwrap();
            let result = builder
                .build_call(helper, &[base.into(), exponent.into()], "deferred")
                .unwrap()
                .try_as_basic_value()
                .unwrap_basic()
                .into_int_value();
            let result = builder
                .build_int_z_extend_or_bit_cast(result, i64_type, "result")
                .unwrap();
            builder.build_return(Some(&result)).unwrap();
            module.verify().unwrap();
            assert_eq!(lower_constant_int_powers(&module).unwrap(), 0);
            assert_eq!(lower_remaining_int_powers(&module).unwrap(), 1);
            assert_eq!(lower_remaining_int_powers(&module).unwrap(), 0);
            ensure_no_loops(&module, 1).unwrap();
            assert_eq!(module.get_functions().count(), 1);
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
                for exponent in [0u64, 1, 2, 3, 7, 8, 63, 64, 65, 1000, u32::MAX as u64] {
                    let expected = base.wrapping_pow((exponent & mask) as u32) & mask;
                    assert_eq!(
                        unsafe { power.call(base, exponent) },
                        expected,
                        "width={width}, base={base}, exponent={exponent}"
                    );
                }
                // For odd bases, raising to 2^63 is one modulo 2^64;
                // for even bases it is zero. This exercises the unsigned high bit.
                for exponent in [1_u64 << 63, (1_u64 << 63) + 1] {
                    let expected = if width < 64 {
                        base.wrapping_pow((exponent & mask) as u32) & mask
                    } else if base & 1 == 0 {
                        0
                    } else if exponent & 1 == 0 {
                        1
                    } else {
                        base
                    };
                    assert_eq!(unsafe { power.call(base, exponent) }, expected);
                }
            }
        }
    }
}
