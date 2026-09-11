//! LLVM rewrites for integer division operations not accepted by the downstream compiler.

use crate::compilation_error::CompilationError;
use anyhow::{Result, anyhow};

use crate::inkwell::IntPredicate;
use crate::inkwell::module::Module;
use crate::inkwell::values::IntValue;
use crate::inkwell::values::{BasicValueEnum, InstructionOpcode, InstructionValue, Operand};

/// Reject literal-zero divisors before optimization can fold them to poison.
/// Nonconstant operands must be allowed here: optimization can make them static.
pub fn validate_no_zero_divisors(module: &Module) -> Result<()> {
    for division in integer_divisions(module) {
        if int_operand(division, 1)?.get_zero_extended_constant() == Some(0) {
            return Err(CompilationError::new("Detected division by zero.").into());
        }
    }
    Ok(())
}

fn integer_divisions<'ctx>(module: &Module<'ctx>) -> Vec<InstructionValue<'ctx>> {
    module
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
        .collect()
}

/// Check final divisor operands after optimization has exposed static values.
pub fn validate_integer_division(module: &Module) -> Result<()> {
    validate_no_zero_divisors(module)?;
    for division in integer_divisions(module) {
        if int_operand(division, 1)?
            .get_zero_extended_constant()
            .is_none()
        {
            return Err(CompilationError::new(
                "A division or modulo operation required a divisor whose value could not be determined at compile time, this is unsupported."
            ).into());
        }
    }
    Ok(())
}

/// Validates that all integer division operations have constant divisors and
/// lowers operations unsupported by the lower compiler stack.
///
/// Unsigned remainders are replaced using
/// `x % divisor = x - (x / divisor) * divisor`.
///
/// Signed division and remainder are lowered by dividing unsigned magnitudes
/// and restoring the LLVM result sign. The minimum signed value is handled
/// separately because its magnitude is not representable as a positive signed
/// integer in the lower compiler stack. Signed division overflow (`INT_MIN / -1`)
/// follows LLVM's undefined behavior: no result or runtime check is guaranteed.
///
/// The lower compiler stack for H-Series accepts `udiv` only when its divisor is
/// constant. A non-constant divisor is rejected here with a targeted error.
pub fn lower_integer_division(module: &Module) -> Result<usize> {
    // Validate before mutating the module so a failure cannot leave it partially lowered.
    validate_integer_division(module)?;
    let divisions = integer_divisions(module);

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
        // Fast paths can return an argument or constant, not just an instruction.
        IntValue::try_from(division)
            .map_err(|_| anyhow!("integer division did not produce an integer value"))?
            .replace_all_uses_with(replacement);
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
    if divisor_magnitude == 1 {
        match division.get_opcode() {
            InstructionOpcode::SDiv if !divisor_negative => return Ok(dividend),
            InstructionOpcode::SRem => return Ok(zero),
            _ => {}
        }
    }
    if division.get_opcode() == InstructionOpcode::SDiv && divisor_bits == mask {
        // Division by -1 is negation for every defined input. INT_MIN / -1 is
        // undefined in LLVM, so no special result needs to be preserved. This
        // subtraction may wrap, but earlier optimizations can already have
        // exploited the undefined case; wrapping is not a program guarantee.
        return Ok(builder.build_int_sub(zero, dividend, "sdiv.lowered")?);
    }
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
    use crate::inkwell::memory_buffer::MemoryBuffer;

    use super::*;

    /// Execute the actual lowered IR, with a runtime dividend and constant divisor.
    /// These tests check LLVM semantics, not the downstream hardware compiler.
    fn check_jit_results(
        opcode: &str,
        dividends: &[u64],
        divisors: &[u64],
        expected: impl Fn(u64, u64) -> Option<u64>,
    ) {
        use std::fmt::Write;

        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let mut ir = String::new();
        for (index, divisor) in divisors.iter().enumerate() {
            writeln!(
                ir,
                "define i64 @operation{index}(i64 %x) {{\n\
                 entry: %result = {opcode} i64 %x, {divisor}\n\
                 ret i64 %result\n}}"
            )
            .unwrap();
        }
        let module = context
            .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                format!("{ir}\0").as_bytes(),
                "jit_integer_division",
            ))
            .unwrap();
        module.verify().unwrap();
        // Run our pass directly, without an optimizer that could hide its bugs.
        assert_eq!(lower_integer_division(&module).unwrap(), divisors.len());
        assert!(!module.to_string().contains(&format!(" {opcode} ")));
        let engine = module
            .create_jit_execution_engine(crate::inkwell::OptimizationLevel::None)
            .unwrap();
        for (index, &divisor) in divisors.iter().enumerate() {
            // SAFETY: Each generated function has the C ABI signature i64(i64).
            // u64 carries its input/output bit patterns for signed operations too.
            // The engine and context remain alive throughout every call.
            let function = unsafe {
                engine
                    .get_function::<unsafe extern "C" fn(u64) -> u64>(&format!("operation{index}"))
                    .unwrap()
            };
            for &dividend in dividends {
                let Some(expected) = expected(dividend, divisor) else {
                    // Never execute LLVM's undefined zero-divisor or signed
                    // overflow cases (INT_MIN with divisor -1, for div and rem).
                    continue;
                };
                // SAFETY: Signature and lifetime are established above; this
                // input is a defined case according to the independent oracle.
                let actual = unsafe { function.call(dividend) };
                assert_eq!(
                    actual, expected,
                    "{opcode}: dividend bits {dividend:#018x}, divisor bits {divisor:#018x}"
                );
            }
        }
    }

    fn check_signed_jit_results(opcode: &str, expected: fn(i64, i64) -> Option<i64>) {
        let dividends = [
            i64::MIN,
            i64::MIN + 1,
            i64::MIN + 2,
            -(1_i64 << 32),
            -17,
            -8,
            -7,
            -6,
            -3,
            -2,
            -1,
            0,
            1,
            2,
            3,
            6,
            7,
            8,
            17,
            1_i64 << 32,
            i64::MAX - 1,
            i64::MAX,
        ]
        .map(|value| value as u64);
        let divisors = [
            i64::MIN,
            i64::MIN + 1,
            -(1_i64 << 62),
            -(1_i64 << 32),
            -7,
            -3,
            -2,
            -1,
            1,
            2,
            3,
            7,
            1_i64 << 32,
            i64::MAX,
        ]
        .map(|value| value as u64);
        check_jit_results(opcode, &dividends, &divisors, |left, right| {
            expected(left as i64, right as i64).map(|value| value as u64)
        });
    }

    #[test]
    fn jit_sdiv_matches_signed_arithmetic() {
        check_signed_jit_results("sdiv", i64::checked_div);
    }

    #[test]
    fn jit_srem_matches_signed_arithmetic() {
        check_signed_jit_results("srem", i64::checked_rem);
    }

    #[test]
    fn jit_urem_matches_unsigned_arithmetic() {
        let dividends = [
            0,
            1,
            2,
            3,
            6,
            7,
            8,
            (1_u64 << 32) - 1,
            1_u64 << 32,
            (1_u64 << 63) - 1,
            1_u64 << 63,
            (1_u64 << 63) + 1,
            u64::MAX - 1,
            u64::MAX,
        ];
        let divisors = [
            1,
            2,
            3,
            7,
            (1_u64 << 32) - 1,
            1_u64 << 32,
            (1_u64 << 63) - 1,
            1_u64 << 63,
            u64::MAX,
        ];
        check_jit_results("urem", &dividends, &divisors, u64::checked_rem);
    }

    #[test]
    fn early_validation_rejects_zero_but_allows_dynamic_divisors() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        for opcode in ["udiv", "urem", "sdiv", "srem"] {
            for divisor in ["0", "%y"] {
                let ir = format!(
                    "define i64 @f(i64 %x, i64 %y) {{ entry: %r = {opcode} i64 %x, {divisor}\n ret i64 %r }}"
                );
                let module = context
                    .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                        format!("{ir}\0").as_bytes(),
                        "test",
                    ))
                    .unwrap();
                let result = validate_no_zero_divisors(&module);
                if divisor == "0" {
                    assert_eq!(
                        result.unwrap_err().to_string(),
                        "Detected division by zero."
                    );
                } else {
                    result.unwrap();
                }
            }
        }
    }

    #[test]
    fn panic_diagnostic_distinguishes_conditional_execution() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        for conditional in [false, true] {
            let branch = if conditional {
                "br i1 %condition, label %panic, label %done\npanic:"
            } else {
                ""
            };
            let ir = format!(
                r#"
                @message = constant [24 x i8] c"Attempted division by 0\00"
                declare i32 @printf(ptr, ...)
                declare void @abort()
                define void @f(i1 %condition) {{
                entry:
                    {branch}
                    %r = call i32 (ptr, ...) @printf(ptr null, i32 2, ptr @message)
                    call void @abort()
                    unreachable
                done:
                    ret void
                }}
            "#
            );
            let module = context
                .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                    format!("{ir}\0").as_bytes(),
                    "test",
                ))
                .unwrap();
            let error = crate::validate_panic::validate_no_panic(&module)
                .unwrap_err()
                .to_string();
            if conditional {
                assert_eq!(
                    error,
                    "Program may panic: Attempted division by 0. Runtime panics are unsupported on H-Series."
                );
            } else {
                assert_eq!(error, "Program always panics: Attempted division by 0");
            }
        }
    }

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
    fn unit_signed_divisors_need_no_instructions() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        for (divisor, remainder) in [(1, false), (1, true), (u64::MAX, true)] {
            let module = signed_division_module(&context, divisor, remainder);
            assert_eq!(lower_integer_division(&module).unwrap(), 1);
            let function = module.get_function("operation").unwrap();
            let block = function.get_first_basic_block().unwrap();
            assert_eq!(block.get_instructions().count(), 1);
            let ret = block.get_first_instruction().unwrap();
            assert_eq!(ret.get_opcode(), InstructionOpcode::Return);
            let result = int_operand(ret, 0).unwrap();
            if remainder {
                assert_eq!(result.get_zero_extended_constant(), Some(0));
            } else {
                assert_eq!(result, function.get_first_param().unwrap().into_int_value());
            }
        }
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
    fn lowers_division_by_negative_one_to_negation() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = signed_division_module(&context, (-1_i64) as u64, false);

        assert_eq!(lower_integer_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" sdiv "));
        assert!(!ir.contains(" udiv "));
        assert!(ir.contains("sub i64 0, %0"));
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
