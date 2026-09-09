//! LLVM rewrites for integer operations not accepted by the downstream compiler.

use anyhow::{Result, anyhow};

use crate::inkwell::module::Module;
use crate::inkwell::values::{
    BasicValue, BasicValueEnum, InstructionOpcode, InstructionValue, Operand,
};

/// Validates that all unsigned division operations have constant divisors and
/// replaces unsigned remainders using
/// `x % divisor = x - (x / divisor) * divisor`.
///
/// The lower compiler stack for H-Series does not accept LLVM `urem`, but does accept `udiv`
/// when its divisor is constant. A non-constant divisor is rejected here with a
/// targeted error.
pub fn lower_unsigned_division(module: &Module) -> Result<usize> {
    let divisions = module
        .get_functions()
        .flat_map(|function| function.get_basic_blocks())
        .flat_map(|block| block.get_instructions())
        .filter(|inst| {
            matches!(
                inst.get_opcode(),
                InstructionOpcode::UDiv | InstructionOpcode::URem
            )
        })
        .collect::<Vec<_>>();

    // Validate before mutating the module so a failure cannot leave it partially lowered.
    for &division in &divisions {
        let divisor = int_operand(division, 1)?;
        if !divisor.is_const() {
            return Err(anyhow!(
                "A division or modulo operation required a non-constant divisor, which is unsupported on hardware."
            ));
        }
    }

    let builder = module.get_context().create_builder();
    let mut lowered = 0;

    for remainder in divisions
        .into_iter()
        .filter(|inst| inst.get_opcode() == InstructionOpcode::URem)
    {
        let dividend = int_operand(remainder, 0)?;
        let divisor = int_operand(remainder, 1)?;

        builder.position_before(&remainder);
        let quotient = builder.build_int_unsigned_div(dividend, divisor, "urem.quotient")?;
        let product = builder.build_int_mul(quotient, divisor, "urem.product")?;
        let replacement = builder.build_int_sub(dividend, product, "urem.lowered")?;
        let replacement_inst = replacement
            .as_instruction_value()
            .ok_or_else(|| anyhow!("lowered urem did not produce an instruction"))?;
        remainder.replace_all_uses_with(&replacement_inst);
        remainder.erase_from_basic_block();
        lowered += 1;
    }

    module
        .verify()
        .map_err(|err| anyhow!("Invalid LLVM after lowering unsigned remainder: {err}"))?;
    Ok(lowered)
}

fn int_operand(inst: InstructionValue, index: u32) -> Result<crate::inkwell::values::IntValue> {
    let Some(Operand::Value(BasicValueEnum::IntValue(value))) = inst.get_operand(index) else {
        return Err(anyhow!(
            "unsigned division operand {index} is not an integer value"
        ));
    };
    Ok(value)
}

#[cfg(test)]
mod tests {
    use crate::inkwell::context::Context;

    use super::*;

    #[test]
    fn lowers_urem_with_constant_divisor() {
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

        assert_eq!(lower_unsigned_division(&module).unwrap(), 1);
        let ir = module.to_string();
        assert!(!ir.contains(" urem "));
        assert!(ir.contains(" udiv i64 %0, 3"));
        assert!(ir.contains(" mul i64"));
        assert!(ir.contains(" sub i64"));
    }

    #[test]
    fn rejects_urem_with_dynamic_divisor() {
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

        let error = lower_unsigned_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a non-constant divisor, which is unsupported on hardware."
        );
    }

    #[test]
    fn rejects_udiv_with_dynamic_divisor() {
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

        let error = lower_unsigned_division(&module).unwrap_err().to_string();
        assert_eq!(
            error,
            "A division or modulo operation required a non-constant divisor, which is unsupported on hardware."
        );
    }
}
