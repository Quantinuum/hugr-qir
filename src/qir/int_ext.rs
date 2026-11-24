//! LLVM lowering for integer powers.

use anyhow::{Result, anyhow, bail, ensure};
use hugr::{
    HugrView, Node,
    extension::simple_op::MakeOpDef,
    ops::ExtensionOp,
    std_extensions::arithmetic::int_ops::{EXTENSION_ID, IntOpDef},
};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitOpArgs, func::EmitFuncContext},
};

use crate::inkwell::{IntPredicate, builder::Builder, values::IntValue};

/// Emit loop-free binary exponentiation with unsigned exponents and wrapping
/// multiplication. An exponent of zero returns one for every base.
pub(crate) struct IntPowCodegenExtension;

impl CodegenExtension for IntPowCodegenExtension {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: CodegenExtsBuilder<'a, H>,
    ) -> CodegenExtsBuilder<'a, H>
    where
        Self: 'a,
    {
        builder.extension_op(EXTENSION_ID, IntOpDef::ipow.opdef_id(), emit_int_pow)
    }
}

fn emit_int_pow<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    let [base, exponent] = args.inputs.as_slice() else {
        bail!("Integer power requires two operands");
    };
    let base =
        IntValue::try_from(*base).map_err(|_| anyhow!("Integer power base must be an integer"))?;
    let exponent = IntValue::try_from(*exponent)
        .map_err(|_| anyhow!("Integer power exponent must be an integer"))?;
    let ty = base.get_type();
    ensure!(
        ty == exponent.get_type(),
        "Integer power operands must have matching widths"
    );
    ensure!(
        ty.get_bit_width() <= 64,
        "Integer powers support widths up to 64 bits"
    );

    let builder = context.builder();
    let result = match exponent.get_zero_extended_constant() {
        Some(exponent) => build_constant_int_pow(builder, base, exponent)?,
        None => build_runtime_int_pow(builder, base, exponent)?,
    };
    args.outputs.finish(builder, [result.into()])
}

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
    use std::num::NonZeroU32;
    use std::rc::Rc;

    use hugr::extension::simple_op::MakeRegisteredOp;
    use hugr::llvm::emit::{EmitDebugInfo, EmitHugr, Namer};
    use hugr::llvm::utils::fat::FatExt;
    use rstest::rstest;

    use crate::{
        CompileArgs,
        inkwell::{OptimizationLevel, context::Context},
        llvm_unroll::ensure_no_loops,
        target::CompileTarget,
        test::{LLVM_TEST_LOCK, single_op_hugr},
    };

    use super::{IntOpDef, build_constant_int_pow};

    #[rstest]
    #[case::zero_exponent(64, 0, 0, 1)]
    #[case::one_exponent(64, u64::MAX, 1, u64::MAX)]
    #[case::square_wraps(64, u64::MAX, 2, 1)]
    #[case::multiple_set_bits(64, 3, 13, 3_u64.pow(13))]
    #[case::max_exponent_odd_base(64, 3, u64::MAX, 0xaaaa_aaaa_aaaa_aaab)]
    #[case::max_exponent_even_base(64, 2, u64::MAX, 0)]
    #[case::one_bit(1, 0, 0, 1)]
    #[case::eight_bits(8, 3, 13, 3_u64.pow(13) & 0xff)]
    #[case::thirty_two_bits(32, u32::MAX.into(), 2, 1)]
    fn constant_integer_power_wraps(
        #[case] width: u32,
        #[case] base: u64,
        #[case] exponent: u64,
        #[case] expected: u64,
    ) {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        CompileTarget::Native.initialise();
        let context = Context::create();
        let module = context.create_module("constant_integer_power");
        let builder = context.create_builder();
        let abi_type = context.i64_type();
        let int_type = context
            .custom_width_int_type(NonZeroU32::new(width).unwrap())
            .unwrap();
        let function =
            module.add_function("power", abi_type.fn_type(&[abi_type.into()], false), None);
        builder.position_at_end(context.append_basic_block(function, "entry"));
        let runtime_base = builder
            .build_int_truncate_or_bit_cast(
                function.get_nth_param(0).unwrap().into_int_value(),
                int_type,
                "base",
            )
            .unwrap();
        let result = build_constant_int_pow(&builder, runtime_base, exponent).unwrap();
        let result = builder
            .build_int_z_extend_or_bit_cast(result, abi_type, "result")
            .unwrap();
        builder.build_return(Some(&result)).unwrap();
        module.verify().unwrap();

        let engine = module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();
        let power = unsafe {
            engine
                .get_function::<unsafe extern "C" fn(u64) -> u64>("power")
                .unwrap()
        };
        assert_eq!(unsafe { power.call(base) }, expected);
    }

    #[test]
    fn runtime_integer_power_is_loop_free_and_wraps() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        CompileTarget::Native.initialise();
        let op = IntOpDef::ipow.with_log_width(6).to_extension_op().unwrap();
        let hugr = single_op_hugr(op.into());
        let context = Context::create();
        let emit = EmitHugr::new(
            &context,
            context.create_module("integer_power"),
            Rc::new(Namer::new("", false)),
            Rc::new(CompileArgs::default().codegen_extensions()),
        );
        let (module, _) = emit
            .emit_module(hugr.fat_root().unwrap(), EmitDebugInfo::Exclude)
            .unwrap()
            .finish();
        module.verify().unwrap();
        ensure_no_loops(&module, 1).unwrap();

        let engine = module
            .create_jit_execution_engine(OptimizationLevel::None)
            .unwrap();
        let power = unsafe {
            engine
                .get_function::<unsafe extern "C" fn(u64, u64) -> u64>("main")
                .unwrap()
        };
        for base in [0_u64, 1, 2, 3, u64::MAX - 1, u64::MAX] {
            for exponent in [0, 1, 2, 13, 64, 1000, u32::MAX] {
                assert_eq!(
                    unsafe { power.call(base, exponent.into()) },
                    base.wrapping_pow(exponent)
                );
            }
        }
        assert_eq!(unsafe { power.call(2, 1_u64 << 63) }, 0);
        assert_eq!(unsafe { power.call(3, (1_u64 << 63) + 1) }, 3);
    }
}
