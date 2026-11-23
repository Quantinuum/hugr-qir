//! LLVM codegen overrides for integer arithmetic operations.
//!
//! Integer powers are emitted as calls to a compiler-only placeholder declaration.
//! The crate-private `lower_int_pow` pass replaces those calls with arithmetic once LLVM has
//! had the chance to make exponents constant.

use anyhow::{Result, ensure};
use hugr::{HugrView, Node, ops::ExtensionOp, std_extensions::arithmetic::int_ops};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitOpArgs, func::EmitFuncContext},
};

use crate::inkwell::{
    attributes::{Attribute, AttributeLoc},
    module::Module,
    types::IntType,
    values::{FunctionValue, IntValue},
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

/// Function attribute that marks the placeholder integer-power declarations.
const IPOW_ATTRIBUTE: &str = "hugr-qir.ipow";

pub(crate) fn validate_operand_types(base: IntValue<'_>, exponent: IntValue<'_>) -> Result<()> {
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

pub(crate) fn declare_int_pow<'c>(
    module: &Module<'c>,
    ty: IntType<'c>,
) -> Result<FunctionValue<'c>> {
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

/// Whether `function` is a placeholder declared by [`declare_int_pow`].
pub(crate) fn is_int_pow_helper(function: FunctionValue<'_>) -> bool {
    function
        .get_string_attribute(AttributeLoc::Function, IPOW_ATTRIBUTE)
        .is_some()
}
