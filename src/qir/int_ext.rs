//! LLVM lowering for integer powers.

use anyhow::{Result, anyhow, bail, ensure};
use hugr::{
    HugrView, Node,
    extension::simple_op::MakeOpDef,
    ops::ExtensionOp,
    std_extensions::arithmetic::int_ops::{EXTENSION_ID, IntOpDef},
    types::TypeArg,
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
    let [TypeArg::BoundedNat(log_width)] = args.node.args() else {
        bail!("Integer power requires one integer width argument");
    };
    ensure!(
        *log_width <= 6,
        "Integer powers support widths up to 64 bits"
    );
    let logical_width = 1_u32 << log_width;
    let ty = base.get_type();
    ensure!(
        ty == exponent.get_type(),
        "Integer power operands must have matching widths"
    );
    ensure!(
        logical_width <= ty.get_bit_width(),
        "Integer power operands are narrower than the HUGR integer type"
    );

    let builder = context.builder();
    let result = build_int_pow(builder, base, exponent, logical_width)?;
    // HUGR's sub-byte integers use i8 storage in LLVM.
    let result = if logical_width < ty.get_bit_width() {
        let mask = u64::MAX >> (64 - logical_width);
        builder.build_and(result, ty.const_int(mask, false), "ipow.mask")?
    } else {
        result
    };
    args.outputs.finish(builder, [result.into()])
}

fn build_int_pow<'c>(
    builder: &Builder<'c>,
    base: IntValue<'c>,
    exponent: IntValue<'c>,
    logical_width: u32,
) -> Result<IntValue<'c>> {
    let ty = base.get_type();
    let mut result = ty.const_int(1, false);
    let mut power = base;
    for bit in 0..logical_width {
        let masked = builder.build_and(exponent, ty.const_int(1_u64 << bit, false), "ipow.bit")?;
        let set =
            builder.build_int_compare(IntPredicate::NE, masked, ty.const_zero(), "ipow.set")?;
        let product = builder.build_int_mul(result, power, "ipow.product")?;
        result = builder
            .build_select(set, product, result, "ipow.accumulator")?
            .into_int_value();
        if bit + 1 < logical_width {
            power = builder.build_int_mul(power, power, "ipow.square")?;
        }
    }
    Ok(result)
}

#[cfg(test)]
mod tests {
    use std::rc::Rc;

    use hugr::extension::simple_op::MakeRegisteredOp;
    use hugr::llvm::emit::{EmitDebugInfo, EmitHugr, Namer};
    use hugr::llvm::utils::fat::FatExt;

    use crate::{
        CompileArgs,
        inkwell::{OptimizationLevel, context::Context},
        llvm_unroll::ensure_no_loops,
        target::CompileTarget,
        test::{LLVM_TEST_LOCK, single_op_hugr},
    };

    use super::IntOpDef;

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
