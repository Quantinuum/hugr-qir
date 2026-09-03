use anyhow::{Result, anyhow, bail};
use hugr::{
    HugrView, Node,
    extension::{prelude::ConstString, simple_op::MakeExtensionOp as _},
    ops::ExtensionOp,
};
use hugr_llvm::{
    emit::{EmitFuncContext, EmitOpArgs, emit_value},
    inkwell::{types::BasicType as _, values::BasicValueEnum},
    sum::LLVMSumValue,
    types::HugrSumType,
};
use std::num::NonZeroU32;
use tket_qsystem::extension::result::{ResultArgs, ResultOp, ResultOpDef, SimpleArgs};

use super::array_codegen::load_array_elements;

const MAX_ARR_BOOL_SIZE: u64 = 63;

fn emit_tag<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    tag: impl Into<String>,
) -> Result<BasicValueEnum<'c>> {
    emit_value(context, &ConstString::new(tag.into()).into())
}

fn array_length(result_op: &ResultOp) -> Result<u64> {
    let ResultArgs::Array(_, length) = &result_op.args else {
        bail!("array result operation has non-array arguments")
    };
    Ok(*length)
}

fn array_int_width(result_op: &ResultOp) -> Result<u8> {
    let ResultArgs::Array(SimpleArgs::Int(width), _) = &result_op.args else {
        bail!("integer array result operation has invalid arguments")
    };
    Ok(*width)
}

fn bool_value_to_i1<'c>(
    context: &mut EmitFuncContext<'c, '_, impl HugrView<Node = Node>>,
    value: BasicValueEnum<'c>,
    bool_type: &hugr_llvm::sum::LLVMSumType<'c>,
) -> Result<hugr_llvm::inkwell::values::IntValue<'c>> {
    let tag = LLVMSumValue::try_new(value, bool_type.clone())
        .map_err(|_| anyhow!("expected a boolean array element"))?
        .build_get_tag(context.builder())?;
    Ok(context
        .builder()
        .build_int_truncate(tag, context.iw_context().bool_type(), "")?)
}

use super::QirCodegenExtension;
impl QirCodegenExtension {
    pub fn emit_result_op<'c, H: HugrView<Node = Node>>(
        &self,
        context: &mut EmitFuncContext<'c, '_, H>,
        args: EmitOpArgs<'c, '_, ExtensionOp, H>,
        op: ResultOpDef,
    ) -> Result<()> {
        let result_op = ResultOp::from_extension_op(&args.node())?;
        let tag_str = &result_op.tag;
        if tag_str.is_empty() {
            bail!("Empty result tag received")
        }

        let ptr_ty = context
            .iw_context()
            .ptr_type(Default::default())
            .as_basic_type_enum();
        match op {
            ResultOpDef::Bool => {
                let tag_ptr = emit_tag(context, tag_str)?;
                let [val] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_bool expects one input"))?;
                let bool_type = context.llvm_sum_type(HugrSumType::new_unary(2))?;
                let val = LLVMSumValue::try_new(val, bool_type)
                    .map_err(|_| anyhow!("bool_type expects a value"))?
                    .build_get_tag(context.builder())?;
                let i1_ty = context.iw_context().bool_type();
                let trunc_val = context.builder().build_int_truncate(val, i1_ty, "")?;
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[i1_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__bool_record_output", print_fn_ty)?;
                context.builder().build_call(
                    print_fn,
                    &[trunc_val.into(), tag_ptr.into()],
                    "print_bool",
                )?;
                args.outputs.finish(context.builder(), [])
            }
            ResultOpDef::Int | ResultOpDef::UInt => {
                let tag_ptr = emit_tag(context, tag_str)?;
                let [mut val] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_int expects one input"))?;
                let i64_ty = context.iw_context().i64_type();
                if val.get_type() != i64_ty.into() {
                    val = if op == ResultOpDef::Int {
                        context
                            .builder()
                            .build_int_s_extend(val.into_int_value(), i64_ty, "")
                    } else {
                        context
                            .builder()
                            .build_int_z_extend(val.into_int_value(), i64_ty, "")
                    }?
                    .into();
                }
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[i64_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__int_record_output", print_fn_ty)?;
                context.builder().build_call(
                    print_fn,
                    &[val.into(), tag_ptr.into()],
                    "print_bool",
                )?;
                args.outputs.finish(context.builder(), [])
            }
            ResultOpDef::F64 => {
                let tag_ptr = emit_tag(context, tag_str)?;
                let [val] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_f64 expects one input"))?;
                let f64_ty = context.iw_context().f64_type();
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[f64_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__double_record_output", print_fn_ty)?;
                context.builder().build_call(
                    print_fn,
                    &[val.into(), tag_ptr.into()],
                    "print_bool",
                )?;
                args.outputs.finish(context.builder(), [])
            }
            ResultOpDef::ArrBool => {
                let length = array_length(&result_op)?;
                if length > MAX_ARR_BOOL_SIZE {
                    bail!(
                        "ArrBool result only supports arrays up to size {MAX_ARR_BOOL_SIZE}; larger bool arrays should be split up"
                    )
                }
                let [array] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_arr_bool expects one input"))?;
                let bool_type = context.llvm_sum_type(HugrSumType::new_unary(2))?;
                let elements = load_array_elements(context, array, bool_type.value_type(), length)?;
                let i64_ty = context.iw_context().i64_type();
                let mut packed = i64_ty.const_zero();
                for element in elements {
                    let bit = bool_value_to_i1(context, element, &bool_type)?;
                    let bit = context.builder().build_int_z_extend(bit, i64_ty, "")?;
                    packed = context.builder().build_left_shift(
                        packed,
                        i64_ty.const_int(1, false),
                        "",
                    )?;
                    packed = context.builder().build_or(packed, bit, "")?;
                }
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[i64_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__int_record_output", print_fn_ty)?;
                let tag_ptr = emit_tag(context, tag_str)?;
                context.builder().build_call(
                    print_fn,
                    &[packed.into(), tag_ptr.into()],
                    "print_arr_bool",
                )?;
                args.outputs.finish(context.builder(), [])
            }
            ResultOpDef::ArrInt | ResultOpDef::ArrUInt => {
                let length = array_length(&result_op)?;
                let width = array_int_width(&result_op)?;
                let bit_width = 1u32 << width;
                let elem_ty = context
                    .iw_context()
                    .custom_width_int_type(NonZeroU32::new(bit_width).unwrap())
                    .map_err(|err| anyhow!(err))?
                    .as_basic_type_enum();
                let [array] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_arr_int and result_arr_uint expect one input"))?;
                let elements = load_array_elements(context, array, elem_ty, length)?;
                let i64_ty = context.iw_context().i64_type();
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[i64_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__int_record_output", print_fn_ty)?;
                for (index, element) in elements.into_iter().enumerate() {
                    let mut value = element.into_int_value();
                    if value.get_type() != i64_ty {
                        value = if op == ResultOpDef::ArrInt {
                            context.builder().build_int_s_extend(value, i64_ty, "")
                        } else {
                            context.builder().build_int_z_extend(value, i64_ty, "")
                        }?;
                    }
                    let tag_ptr = emit_tag(context, format!("{tag_str}:{index}"))?;
                    context.builder().build_call(
                        print_fn,
                        &[value.into(), tag_ptr.into()],
                        "print_arr_int",
                    )?;
                }
                args.outputs.finish(context.builder(), [])
            }
            ResultOpDef::ArrF64 => {
                let length = array_length(&result_op)?;
                let f64_ty = context.iw_context().f64_type();
                let [array] = args
                    .inputs
                    .try_into()
                    .map_err(|_| anyhow!("result_arr_f64 expects one input"))?;
                let elements =
                    load_array_elements(context, array, f64_ty.as_basic_type_enum(), length)?;
                let print_fn_ty = context
                    .iw_context()
                    .void_type()
                    .fn_type(&[f64_ty.into(), ptr_ty.into()], false);
                let print_fn =
                    context.get_extern_func("__quantum__rt__double_record_output", print_fn_ty)?;
                for (index, element) in elements.into_iter().enumerate() {
                    let tag_ptr = emit_tag(context, format!("{tag_str}:{index}"))?;
                    context.builder().build_call(
                        print_fn,
                        &[element.into(), tag_ptr.into()],
                        "print_arr_f64",
                    )?;
                }
                args.outputs.finish(context.builder(), [])
            }
            _ => bail!("Unknown op: {op:?}"),
        }
    }
}

#[cfg(test)]
mod test {
    use hugr::ops::OpType;
    use hugr_llvm::{
        check_emission,
        test::{TestContext, llvm_ctx},
    };
    use rstest::rstest;

    use tket_qsystem::extension::result::ResultOpDef;

    use crate::qir::{QirCodegenExtension, QirPreludeCodegen};
    use crate::target::CompileTarget;
    use crate::test::single_op_hugr;

    #[rstest::fixture]
    fn ctx(mut llvm_ctx: TestContext) -> TestContext {
        llvm_ctx.add_extensions(|builder| {
            builder
                .add_extension(QirCodegenExtension {
                    target: CompileTarget::Native,
                })
                .add_prelude_extensions(QirPreludeCodegen)
                .add_default_int_extensions()
                .add_float_extensions()
                .add_default_array_extensions()
        });
        llvm_ctx
    }

    #[rstest]
    #[case(ResultOpDef::F64.instantiate(&["foo_f64".into()]).unwrap())]
    #[case(ResultOpDef::UInt.instantiate(&["foo_uint".into(), 3.into()]).unwrap())]
    #[case(ResultOpDef::Int.instantiate(&["foo_int".into(), 4.into()]).unwrap())]
    #[case(ResultOpDef::Bool.instantiate(&["bool_int".into()]).unwrap())]
    #[case(ResultOpDef::ArrBool.instantiate(&["foo_arr_bool".into(), 3.into()]).unwrap())]
    #[case(ResultOpDef::ArrInt.instantiate(&["foo_arr_int".into(), 3.into(), 4.into()]).unwrap())]
    #[case(ResultOpDef::ArrUInt.instantiate(&["foo_arr_uint".into(), 3.into(), 4.into()]).unwrap())]
    #[case(ResultOpDef::ArrF64.instantiate(&["foo_arr_f64".into(), 3.into()]).unwrap())]
    fn emit(ctx: TestContext, #[case] op: impl Into<OpType>) {
        let op = op.into();
        let mut insta = insta::Settings::clone_current();
        insta.set_snapshot_suffix(format!("{}_{}", insta.snapshot_suffix().unwrap_or(""), op));
        insta.bind(|| {
            let mut hugr = single_op_hugr(op);
            check_emission!(hugr, ctx);
        })
    }

    #[rstest]
    #[should_panic(
        expected = "ArrBool result only supports arrays up to size 63; larger bool arrays should be split up"
    )]
    fn rejects_arr_bool_larger_than_63(ctx: TestContext) {
        let op = ResultOpDef::ArrBool
            .instantiate(&["too_large".into(), 64.into()])
            .unwrap();
        let mut hugr = single_op_hugr(op.into());
        check_emission!(hugr, ctx);
    }
}
