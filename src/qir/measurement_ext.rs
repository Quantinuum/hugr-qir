use anyhow::{Result, bail, ensure};
use hugr::{
    HugrView, Node,
    ops::{ExtensionOp, Value},
    types::CustomType,
};
use hugr_llvm::{
    emit::{EmitFuncContext, EmitOpArgs, emit_value},
    inkwell::types::BasicTypeEnum,
    types::TypingSession,
};
use tket::extension::measurement::{MEASUREMENT_EXTENSION_ID, MEASUREMENT_TYPE_ID, MeasurementOp};

use super::QirCodegenExtension;

impl QirCodegenExtension {
    /// We represent a hugr `tket.measurement.Measurement` as an i1.
    pub fn convert_measurement_type<'c>(
        &self,
        session: TypingSession<'c, '_>,
        custom_type: &CustomType,
    ) -> Result<BasicTypeEnum<'c>> {
        ensure!(
            custom_type.extension() == &MEASUREMENT_EXTENSION_ID
                && custom_type.name() == MEASUREMENT_TYPE_ID.as_str()
                && custom_type.args().is_empty(),
            "expected type tket.measurement.Measurement"
        );
        Ok(session.iw_context().bool_type().into())
    }

    pub fn emit_measurement_op<'c, H: HugrView<Node = Node>>(
        &self,
        context: &mut EmitFuncContext<'c, '_, H>,
        args: EmitOpArgs<'c, '_, ExtensionOp, H>,
        op: MeasurementOp,
    ) -> Result<()> {
        match op {
            MeasurementOp::Read => {
                let true_val = emit_value(context, &Value::true_val())?;
                let false_val = emit_value(context, &Value::false_val())?;

                let bool_r = context.builder().build_select(
                    args.inputs[0].into_int_value(),
                    true_val,
                    false_val,
                    "",
                )?;
                args.outputs.finish(context.builder(), [bool_r])
            }
            _ => bail!("Unknown op: {op:?}"),
        }
    }
}
