//! LLVM rewrites for integer division operations not accepted by the downstream compiler.

use anyhow::{Result, anyhow};

use crate::inkwell::IntPredicate;
use crate::inkwell::module::Module;
use crate::inkwell::values::IntValue;
use crate::inkwell::values::{
    BasicValue, BasicValueEnum, InstructionOpcode, InstructionValue, Operand,
};

/// Validates that all integer division operations have constant divisors and
/// lowers operations unsupported by the lower compiler stack.
///
/// Unsigned remainders are replaced using
/// `x % divisor = x - (x / divisor) * divisor`.
///
/// Signed division and remainder are lowered by dividing unsigned magnitudes
/// and restoring the LLVM result sign. The minimum signed value is handled
/// separately because its magnitude is not representable as a positive signed
/// integer in the lower compiler stack. `INT_MIN / -1` deliberately returns the
/// wrapped `INT_MIN` value.
///
/// The lower compiler stack for H-Series accepts `udiv` only when its divisor is
/// constant. A non-constant divisor is rejected here with a targeted error.
pub fn lower_integer_division(module: &Module) -> Result<usize> {
    let divisions = module
        .get_functions()
        .flat_map(|function| function.get_basic_blocks())
        .flat_map(|block| block.get_instructions())
        .filter(|inst| {
            matches!(
                inst.get_opcode(),
                InstructionOpcode::UDiv
                    | InstructionOpcode::URem
                    | InstructionOpcode::SDiv
                    | InstructionOpcode::SRem
            )
        })
        .collect::<Vec<_>>();

    // Validate before mutating the module so a failure cannot leave it partially lowered.
    for &division in &divisions {
        let divisor = int_operand(division, 1)?;
        let Some(divisor_bits) = divisor.get_zero_extended_constant() else {
            return Err(anyhow!(
                "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
            ));
        };
        if divisor_bits == 0 {
            return Err(anyhow!("Detected division by zero."));
        }
    }

    let builder = module.get_context().create_builder();
    let mut lowered = 0;

    for division in divisions {
        builder.position_before(&division);
        let replacement = match division.get_opcode() {
            InstructionOpcode::UDiv => continue,
            InstructionOpcode::URem => {
                let dividend = int_operand(division, 0)?;
                let divisor = int_operand(division, 1)?;
                let quotient =
                    builder.build_int_unsigned_div(dividend, divisor, "urem.quotient")?;
                let product = builder.build_int_mul(quotient, divisor, "urem.product")?;
                builder.build_int_sub(dividend, product, "urem.lowered")?
            }
            InstructionOpcode::SDiv | InstructionOpcode::SRem => {
                lower_signed_division(&builder, division)?
            }
            _ => unreachable!(),
        };
        let replacement_inst = replacement
            .as_instruction_value()
            .ok_or_else(|| anyhow!("lowered integer division did not produce an instruction"))?;
        division.replace_all_uses_with(&replacement_inst);
        division.erase_from_basic_block();
        lowered += 1;
    }

    module
        .verify()
        .map_err(|err| anyhow!("Invalid LLVM after lowering integer division: {err}"))?;
    Ok(lowered)
}

fn lower_signed_division<'ctx>(
    builder: &crate::inkwell::builder::Builder<'ctx>,
    division: InstructionValue<'ctx>,
) -> Result<IntValue<'ctx>> {
    let dividend = int_operand(division, 0)?;
    let divisor = int_operand(division, 1)?;
    let int_type = dividend.get_type();
    let bit_width = int_type.get_bit_width();
    if bit_width == 0 || bit_width > 64 {
        return Err(anyhow!(
            "Signed division lowering supports integer widths from 1 to 64 bits, found i{bit_width}."
        ));
    }

    let divisor_bits = divisor
        .get_zero_extended_constant()
        .ok_or_else(|| anyhow!("signed division divisor is not a constant integer"))?;
    let mask = if bit_width == 64 {
        u64::MAX
    } else {
        (1_u64 << bit_width) - 1
    };
    let sign_bit = 1_u64 << (bit_width - 1);
    let divisor_negative = divisor_bits & sign_bit != 0;
    let divisor_magnitude = if divisor_negative {
        0_u64.wrapping_sub(divisor_bits) & mask
    } else {
        divisor_bits
    };

    let zero = int_type.const_zero();
    let min_value = int_type.const_int(sign_bit, false);
    let is_min = builder.build_int_compare(IntPredicate::EQ, dividend, min_value, "sdiv.is_min")?;

    // A divisor of INT_MIN cannot be represented as a positive value in the
    // lower stack. It also does not require division: only INT_MIN / INT_MIN is
    // one, and every other quotient is zero; the corresponding remainders are
    // zero and the dividend respectively.
    if divisor_magnitude == sign_bit {
        return match division.get_opcode() {
            InstructionOpcode::SDiv => Ok(builder
                .build_select(is_min, int_type.const_int(1, false), zero, "sdiv.lowered")?
                .into_int_value()),
            InstructionOpcode::SRem => Ok(builder
                .build_select(is_min, zero, dividend, "srem.lowered")?
                .into_int_value()),
            _ => unreachable!(),
        };
    }

    let dividend_negative =
        builder.build_int_compare(IntPredicate::SLT, dividend, zero, "sdiv.is_negative")?;
    let negated_dividend = builder.build_int_sub(zero, dividend, "sdiv.negated")?;
    let magnitude = builder
        .build_select(
            dividend_negative,
            negated_dividend,
            dividend,
            "sdiv.magnitude",
        )?
        .into_int_value();
    // Do not feed the unrepresentable magnitude of INT_MIN to the lower stack's
    // register form of udiv. Its result is supplied by the constant special case
    // below instead.
    let safe_magnitude = builder
        .build_select(is_min, zero, magnitude, "sdiv.safe_magnitude")?
        .into_int_value();
    let magnitude_divisor = int_type.const_int(divisor_magnitude, false);
    let unsigned_quotient =
        builder.build_int_unsigned_div(safe_magnitude, magnitude_divisor, "sdiv.quotient")?;

    match division.get_opcode() {
        InstructionOpcode::SDiv => {
            let negated_quotient =
                builder.build_int_sub(zero, unsigned_quotient, "sdiv.negated_quotient")?;
            let normal_result = if divisor_negative {
                builder.build_select(
                    dividend_negative,
                    unsigned_quotient,
                    negated_quotient,
                    "sdiv.signed",
                )?
            } else {
                builder.build_select(
                    dividend_negative,
                    negated_quotient,
                    unsigned_quotient,
                    "sdiv.signed",
                )?
            }
            .into_int_value();

            let min_quotient_magnitude = sign_bit / divisor_magnitude;
            let min_result_bits = if divisor_negative {
                min_quotient_magnitude
            } else {
                0_u64.wrapping_sub(min_quotient_magnitude) & mask
            };
            Ok(builder
                .build_select(
                    is_min,
                    int_type.const_int(min_result_bits, false),
                    normal_result,
                    "sdiv.lowered",
                )?
                .into_int_value())
        }
        InstructionOpcode::SRem => {
            let product =
                builder.build_int_mul(unsigned_quotient, magnitude_divisor, "srem.product")?;
            let unsigned_remainder =
                builder.build_int_sub(safe_magnitude, product, "srem.magnitude")?;
            let negated_remainder =
                builder.build_int_sub(zero, unsigned_remainder, "srem.negated")?;
            let normal_result = builder
                .build_select(
                    dividend_negative,
                    negated_remainder,
                    unsigned_remainder,
                    "srem.signed",
                )?
                .into_int_value();

            let min_remainder_magnitude = sign_bit % divisor_magnitude;
            let min_result_bits = 0_u64.wrapping_sub(min_remainder_magnitude) & mask;
            Ok(builder
                .build_select(
                    is_min,
                    int_type.const_int(min_result_bits, false),
                    normal_result,
                    "srem.lowered",
                )?
                .into_int_value())
        }
        _ => unreachable!(),
    }
}

fn int_operand(inst: InstructionValue, index: u32) -> Result<IntValue> {
    let Some(Operand::Value(BasicValueEnum::IntValue(value))) = inst.get_operand(index) else {
        return Err(anyhow!(
            "integer division operand {index} is not an integer value"
        ));
    };
    Ok(value)
}

#[cfg(test)]
mod tests {
    use crate::inkwell::context::Context;

    use super::*;

    fn signed_division_module(context: &Context, divisor_bits: u64, remainder: bool) -> Module<'_> {
        let module = context.create_module("signed_division");
        let int_type = context.i64_type();
        let function = module.add_function(
            "operation",
            int_type.fn_type(&[int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_first_param().unwrap().into_int_value();
        let divisor = int_type.const_int(divisor_bits, false);
        let result = if remainder {
            builder
                .build_int_signed_rem(dividend, divisor, "result")
                .unwrap()
        } else {
            builder
                .build_int_signed_div(dividend, divisor, "result")
                .unwrap()
        };
        builder.build_return(Some(&result)).unwrap();
        module
    }

    #[test]
    fn lowers_urem_with_constant_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("constant_urem");
        let int_type = context.i64_type();
        let function = module.add_function(
            "remainder",
            int_type.fn_type(&[int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_first_param().unwrap().into_int_value();
        let remainder = builder
            .build_int_unsigned_rem(dividend, int_type.const_int(3, false), "remainder")
            .unwrap();
        builder.build_return(Some(&remainder)).unwrap();

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" urem "));
        assert!(ir.contains(" udiv i64 %0, 3"));
        assert!(ir.contains(" mul i64"));
        assert!(ir.contains(" sub i64"));
    }

    #[test]
    fn rejects_urem_with_dynamic_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("dynamic_urem");
        let int_type = context.i64_type();
        let function = module.add_function(
            "remainder",
            int_type.fn_type(&[int_type.into(), int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_nth_param(0).unwrap().into_int_value();
        let divisor = function.get_nth_param(1).unwrap().into_int_value();
        let remainder = builder
            .build_int_unsigned_rem(dividend, divisor, "remainder")
            .unwrap();
        builder.build_return(Some(&remainder)).unwrap();

        let error = lower_integer_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
        );
    }

    #[test]
    fn rejects_udiv_with_dynamic_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("dynamic_udiv");
        let int_type = context.i64_type();
        let function = module.add_function(
            "division",
            int_type.fn_type(&[int_type.into(), int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_nth_param(0).unwrap().into_int_value();
        let divisor = function.get_nth_param(1).unwrap().into_int_value();
        let quotient = builder
            .build_int_unsigned_div(dividend, divisor, "quotient")
            .unwrap();
        builder.build_return(Some(&quotient)).unwrap();

        let error = lower_integer_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
        );
    }

    #[test]
    fn lowers_sdiv_with_positive_constant_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, 3, false);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" sdiv "));
        assert!(ir.contains(" udiv i64 %sdiv.safe_magnitude, 3"));
        assert!(ir.contains("icmp eq i64 %0, -9223372036854775808"));
    }

    #[test]
    fn lowers_sdiv_with_negative_constant_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, (-3_i64) as u64, false);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" sdiv "));
        assert!(ir.contains(" udiv i64 %sdiv.safe_magnitude, 3"));
    }

    #[test]
    fn wraps_int_min_divided_by_negative_one() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, (-1_i64) as u64, false);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" sdiv "));
        assert!(ir.contains("select i1 %sdiv.is_min, i64 -9223372036854775808, i64 %sdiv.signed"));
    }

    #[test]
    fn lowers_srem_and_restores_the_dividend_sign() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, (-3_i64) as u64, true);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" srem "));
        assert!(!ir.contains(" urem "));
        assert!(ir.contains(" udiv i64 %sdiv.safe_magnitude, 3"));
        assert!(ir.contains("select i1 %sdiv.is_negative"));
    }

    #[test]
    fn handles_int_min_divisor_without_udiv() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, i64::MIN as u64, false);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" sdiv "));
        assert!(!ir.contains(" udiv "));
        assert!(ir.contains("select i1 %sdiv.is_min, i64 1, i64 0"));
    }

    #[test]
    fn handles_srem_with_int_min_divisor_without_udiv() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, i64::MIN as u64, true);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" srem "));
        assert!(!ir.contains(" udiv "));
        assert!(ir.contains("select i1 %sdiv.is_min, i64 0, i64 %0"));
    }

    #[test]
    fn rejects_sdiv_with_dynamic_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("dynamic_sdiv");
        let int_type = context.i64_type();
        let function = module.add_function(
            "division",
            int_type.fn_type(&[int_type.into(), int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_nth_param(0).unwrap().into_int_value();
        let divisor = function.get_nth_param(1).unwrap().into_int_value();
        let quotient = builder
            .build_int_signed_div(dividend, divisor, "quotient")
            .unwrap();
        builder.build_return(Some(&quotient)).unwrap();

        let error = lower_integer_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
        );
    }

    #[test]
    fn rejects_srem_with_dynamic_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context.create_module("dynamic_srem");
        let int_type = context.i64_type();
        let function = module.add_function(
            "remainder",
            int_type.fn_type(&[int_type.into(), int_type.into()], false),
            None,
        );
        let block = context.append_basic_block(function, "entry");
        let builder = context.create_builder();
        builder.position_at_end(block);
        let dividend = function.get_nth_param(0).unwrap().into_int_value();
        let divisor = function.get_nth_param(1).unwrap().into_int_value();
        let remainder = builder
            .build_int_signed_rem(dividend, divisor, "remainder")
            .unwrap();
        builder.build_return(Some(&remainder)).unwrap();

        let error = lower_integer_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
        );
    }

    #[test]
    fn rejects_zero_divisor() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, 0, false);

        let error = lower_integer_division(&module).unwrap_err().to_string();
        assert_eq!(error, "Detected division by zero.");
    }
}
