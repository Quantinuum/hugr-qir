//! LLVM lowering for integer arithmetic operations.

use anyhow::{Result, ensure};
use hugr::{HugrView, Node, ops::ExtensionOp, std_extensions::arithmetic::int_ops};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitOpArgs, func::EmitFuncContext},
};

use crate::inkwell::{
    IntPredicate,
    attributes::{Attribute, AttributeLoc},
    builder::Builder,
    module::Module,
    types::IntType,
    values::{BasicValue, BasicValueEnum, CallSiteValue, FunctionValue, IntValue, Operand},
};

/// Defer integer powers until optimization exposes constant exponents.
///
/// Constant exponents become specialized multiplication chains during loop
/// unrolling. Remaining runtime exponents become loop-free binary exponentiation.
/// Exponents are unsigned, multiplication wraps at the integer width, and every
/// base raised to zero returns one, including `0**0`.
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
    validate_operand_types(base, exponent)?;
    let helper = declare_int_pow(context.get_current_module(), base.get_type())?;
    let result = context
        .builder()
        .build_call(helper, &[base.into(), exponent.into()], "ipow")?
        .try_as_basic_value()
        .unwrap_basic();
    args.outputs.finish(context.builder(), [result])
}

const IPOW_ATTRIBUTE: &str = "hugr-qir.ipow";

fn validate_operand_types(base: IntValue<'_>, exponent: IntValue<'_>) -> Result<()> {
    ensure!(
        base.get_type() == exponent.get_type(),
        "Integer power operands must have matching widths (base: {}, exponent: {})",
        base.get_type().get_bit_width(),
        exponent.get_type().get_bit_width()
    );
    ensure!(
        base.get_type().get_bit_width() <= 64,
        "Integer powers support widths up to 64 bits"
    );
    Ok(())
}

fn declare_int_pow<'c>(module: &Module<'c>, ty: IntType<'c>) -> Result<FunctionValue<'c>> {
    let name = format!("__hugr_qir_ipow_i{}", ty.get_bit_width());
    let signature = ty.fn_type(&[ty.into(), ty.into()], false);
    if let Some(helper) = module.get_function(&name) {
        ensure!(
            helper.get_type() == signature
                && helper.count_basic_blocks() == 0
                && is_int_pow_helper(helper),
            "Conflicting declaration for reserved integer-power helper {name}"
        );
        return Ok(helper);
    }
    let helper = module.add_function(&name, signature, None);
    let context = module.get_context();
    helper.add_attribute(
        AttributeLoc::Function,
        context.create_string_attribute(IPOW_ATTRIBUTE, ""),
    );
    // The placeholder represents total, side-effect-free wrapping arithmetic.
    // A zero-valued memory attribute encodes memory(none).
    for name in ["nounwind", "willreturn", "nosync", "speculatable", "memory"] {
        let kind = Attribute::get_named_enum_kind_id(name);
        ensure!(kind != 0, "LLVM does not support the {name} attribute");
        helper.add_attribute(
            AttributeLoc::Function,
            context.create_enum_attribute(kind, 0),
        );
    }
    Ok(helper)
}

/// Specialize deferred powers whose exponents have become integer constants.
/// Repeat to handle powers that themselves supply another power's exponent.
pub(crate) fn lower_constant_int_powers(module: &Module<'_>) -> Result<usize> {
    let mut total = 0;
    loop {
        let lowered = lower_int_powers(module, true)?;
        total += lowered;
        if lowered == 0 {
            return Ok(total);
        }
    }
}

/// Expand every remaining power and remove its compiler-only declaration.
pub(crate) fn lower_remaining_int_powers(module: &Module<'_>) -> Result<usize> {
    let lowered = lower_int_powers(module, false)?;
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

fn is_int_pow_helper(function: FunctionValue<'_>) -> bool {
    function
        .get_string_attribute(AttributeLoc::Function, IPOW_ATTRIBUTE)
        .is_some()
}

fn lower_int_powers(module: &Module<'_>, constants_only: bool) -> Result<usize> {
    if !module.get_functions().any(is_int_pow_helper) {
        return Ok(0);
    }
    let calls = module
        .get_functions()
        .flat_map(|function| function.get_basic_blocks())
        .flat_map(|block| block.get_instructions())
        .filter(|inst| {
            CallSiteValue::try_from(*inst)
                .ok()
                .and_then(|call| call.get_called_fn_value())
                .is_some_and(is_int_pow_helper)
        })
        .collect::<Vec<_>>();
    let builder = module.get_context().create_builder();
    let mut lowered = 0;
    for call in calls {
        let operand = |index| match call.get_operand(index) {
            Some(Operand::Value(BasicValueEnum::IntValue(value))) => Ok(value),
            _ => anyhow::bail!("Integer-power helper requires two integer operands"),
        };
        let base = operand(0)?;
        let exponent = operand(1)?;
        if constants_only && exponent.get_zero_extended_constant().is_none() {
            continue;
        }
        builder.position_before(&call);
        let result = build_int_pow(&builder, base, exponent)?;
        IntValue::try_from(call)
            .map_err(|_| anyhow::anyhow!("Integer-power helper must return an integer"))?
            .replace_all_uses_with(result);
        call.erase_from_basic_block();
        lowered += 1;
    }
    Ok(lowered)
}

fn build_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    exponent: IntValue<'c>,
) -> Result<IntValue<'c>> {
    validate_operand_types(base, exponent)?;
    let ty = base.get_type();
    if let Some(mut exponent) = exponent.get_zero_extended_constant() {
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
        return Ok(result.unwrap_or_else(|| ty.const_int(1, false)));
    }

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
        target::CompileTarget,
    };

    #[test]
    fn specializes_constant_exponents_without_unrolling() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
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
        crate::llvm_unroll::ensure_no_loops(&module, 1).unwrap();
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
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
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
    fn specializes_power_bounds_after_unrolling_outer_loop() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = context
            .create_module_from_ir(
                crate::inkwell::memory_buffer::MemoryBuffer::create_from_memory_range_copy(
                    c"
                    declare i64 @__hugr_qir_ipow_i64(i64, i64) \"hugr-qir.ipow\"=\"\"
                    declare void @effect(i64)
                    define void @main() {
                    entry:
                        br label %outer
                    outer:
                        %i = phi i64 [0, %entry], [%next_i, %outer_latch]
                        %bound = call i64 @__hugr_qir_ipow_i64(i64 2, i64 %i)
                        br label %inner
                    inner:
                        %j = phi i64 [0, %outer], [%next_j, %body]
                        %done = icmp eq i64 %j, %bound
                        br i1 %done, label %outer_latch, label %body
                    body:
                        call void @effect(i64 %j)
                        %next_j = add i64 %j, 1
                        br label %inner
                    outer_latch:
                        %next_i = add nuw nsw i64 %i, 1
                        %outer_done = icmp eq i64 %next_i, 3
                        br i1 %outer_done, label %exit, label %outer
                    exit:
                        ret void
                    }
                "
                    .to_bytes_with_nul(),
                    "power_bounds",
                ),
            )
            .unwrap();
        module.verify().unwrap();
        CompileTarget::Native.initialise();
        let target = CompileTarget::Native.machine(OptimizationLevel::Default);

        crate::llvm_unroll::unroll_static_loops(&module, &target, 8).unwrap();

        crate::llvm_unroll::ensure_no_loops(&module, 8).unwrap();
        assert!(module.get_function("__hugr_qir_ipow_i64").is_none());
        let calls = module
            .get_function("main")
            .unwrap()
            .get_basic_blocks()
            .iter()
            .flat_map(|block| block.get_instructions())
            .filter(|inst| CallSiteValue::try_from(*inst).is_ok())
            .count();
        assert_eq!(calls, 7);
        module.verify().unwrap();
    }

    #[test]
    fn runtime_power_bounds_still_require_static_loop_counts() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        CompileTarget::Native.initialise();
        let target = CompileTarget::Native.machine(OptimizationLevel::Default);
        for base in [1, 3] {
            let ir = format!(
                r#"
                declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
                declare void @effect(i64)
                define void @main(i64 %exponent) {{
                entry:
                    %bound = call i64 @__hugr_qir_ipow_i64(i64 {base}, i64 %exponent)
                    br label %loop
                loop:
                    %i = phi i64 [0, %entry], [%next, %body]
                    %done = icmp eq i64 %i, %bound
                    br i1 %done, label %exit, label %body
                body:
                    call void @effect(i64 %i)
                    %next = add i64 %i, 1
                    br label %loop
                exit:
                    ret void
                }}
            "#
            );
            let ir = std::ffi::CString::new(ir).unwrap();
            let module = context
                .create_module_from_ir(
                    crate::inkwell::memory_buffer::MemoryBuffer::create_from_memory_range_copy(
                        ir.as_bytes_with_nul(),
                        "runtime_bound",
                    ),
                )
                .unwrap();

            crate::llvm_unroll::unroll_static_loops(&module, &target, 8).unwrap();

            // One to any exponent is always one, so that loop can still unroll.
            assert_eq!(
                crate::llvm_unroll::ensure_no_loops(&module, 8).is_ok(),
                base == 1
            );
            assert!(module.get_function("__hugr_qir_ipow_i64").is_none());
            module.verify().unwrap();
        }
    }

    #[test]
    fn rejects_mismatched_operand_widths_before_modifying_ir() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
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
            crate::llvm_unroll::ensure_no_loops(&module, 1).unwrap();
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
