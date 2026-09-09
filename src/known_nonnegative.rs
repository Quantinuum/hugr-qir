//! Removes redundant signed-to-unsigned checks on values whose producers have
//! an unsigned runtime contract.
//!
//! Guppy currently types the integer results of the qsystem shot and random
//! operations as signed integers. Converting those results to `nat` therefore
//! emits [`IntOpDef::is_to_u`], whose LLVM lowering checks for a negative value
//! and panics. When the result is subsequently consumed in a signed context,
//! Guppy also emits [`IntOpDef::iu_to_s`], adding an upper-bound check. The
//! runtime operations actually return unsigned values, so these checks are both
//! unnecessary and, for random `u32` values with the high bit set, incorrect.
//!
//! HUGR integer types do not encode signedness. This pass consequently rewrites
//! only conversion paths whose provenance is one of the exact qsystem operations
//! with an unsigned result contract. All other signed-to-unsigned conversions
//! are left untouched.

use std::convert::Infallible;

use hugr::extension::simple_op::MakeExtensionOp;
use hugr::hugr::hugrmut::HugrMut;
use hugr::std_extensions::arithmetic::int_ops::{ConcreteIntOp, IntOpDef};
use hugr::{HugrView, IncomingPort, Node, OutgoingPort};
use hugr_core::hugr::internal::HugrMutInternals;
use itertools::Itertools;
use tket::passes::{ComposablePass, PassScope, WithScope};
use tket_qsystem::extension::{random::RandomOp, utils::UtilsOp};

/// Removes redundant signedness checks fed by qsystem operations that are known
/// to return unsigned values.
///
/// The pass recognizes both a direct conversion and the Guppy-generated RNG
/// pattern containing a signed width extension:
///
/// ```text
/// GetCurrentShot ------------------------------> is_to_u
/// RandomInt/RandomIntBounded -> iwiden_s<5, 6> -> is_to_u
/// ```
///
/// Every `iwiden_s` directly fed by one of these producers is changed to
/// `iwiden_u`, since the producer's value is unsigned independently of how
/// Guppy subsequently uses it. The now-redundant conversion is then bypassed.
#[derive(Clone, Debug, Default)]
pub struct RemoveKnownNonNegativeChecksPass {
    scope: PassScope,
}

impl<H> ComposablePass<H> for RemoveKnownNonNegativeChecksPass
where
    H: HugrMut<Node = Node> + HugrMutInternals<Node = Node>,
{
    type Error = Infallible;
    type Result = usize;

    fn run(&self, hugr: &mut H) -> Result<Self::Result, Self::Error> {
        let Some(root) = self.scope.root(hugr) else {
            return Ok(0);
        };
        let signed_widens = hugr
            .descendants(root)
            .filter_map(|node| {
                let op = concrete_int_op(hugr, node)?;
                (op.def == IntOpDef::iwiden_s && op.log_widths.len() == 2)
                    .then_some((node, op.log_widths))
            })
            .collect_vec();
        let mut rewritten = 0;

        for (widen, log_widths) in signed_widens {
            let Some((source_node, source_port)) =
                hugr.single_linked_output(widen, IncomingPort::from(0))
            else {
                continue;
            };
            if !is_known_unsigned_output(hugr, source_node, source_port) {
                continue;
            }
            hugr.replace_op(
                widen,
                IntOpDef::iwiden_u.with_two_log_widths(log_widths[0], log_widths[1]),
            );
            rewritten += 1;
        }

        let conversions = hugr
            .descendants(root)
            .filter(|&node| is_int_op(hugr, node, IntOpDef::is_to_u))
            .collect_vec();

        for conversion in conversions {
            let Some((input_node, input_port)) =
                hugr.single_linked_output(conversion, IncomingPort::from(0))
            else {
                continue;
            };

            if is_known_unsigned_value(hugr, input_node, input_port) {
                replace_conversion_output(hugr, conversion, input_node, input_port);
                rewritten += 1;
            }
        }

        Ok(rewritten)
    }
}

impl WithScope for RemoveKnownNonNegativeChecksPass {
    fn with_scope(mut self, scope: impl Into<PassScope>) -> Self {
        self.scope = scope.into();
        self
    }
}

fn concrete_int_op<H: HugrView<Node = Node>>(hugr: &H, node: Node) -> Option<ConcreteIntOp> {
    ConcreteIntOp::from_optype(hugr.get_optype(node))
}

fn is_int_op<H: HugrView<Node = Node>>(hugr: &H, node: Node, expected: IntOpDef) -> bool {
    concrete_int_op(hugr, node).is_some_and(|op| op.def == expected)
}

fn is_known_unsigned_output<H: HugrView<Node = Node>>(
    hugr: &H,
    node: Node,
    port: OutgoingPort,
) -> bool {
    if port != OutgoingPort::from(0) {
        return false;
    }
    let op = hugr.get_optype(node);
    matches!(
        RandomOp::from_optype(op),
        Some(RandomOp::RandomInt | RandomOp::RandomIntBounded)
    ) || matches!(UtilsOp::from_optype(op), Some(UtilsOp::GetCurrentShot))
}

fn is_known_unsigned_value<H: HugrView<Node = Node>>(
    hugr: &H,
    mut node: Node,
    mut port: OutgoingPort,
) -> bool {
    loop {
        if is_known_unsigned_output(hugr, node, port) {
            return true;
        }
        if port != OutgoingPort::from(0) || !is_int_op(hugr, node, IntOpDef::iwiden_u) {
            return false;
        }
        let Some((source_node, source_port)) =
            hugr.single_linked_output(node, IncomingPort::from(0))
        else {
            return false;
        };
        node = source_node;
        port = source_port;
    }
}

fn replace_conversion_output<H>(
    hugr: &mut H,
    conversion: Node,
    replacement_node: Node,
    replacement_port: OutgoingPort,
) where
    H: HugrMut<Node = Node>,
{
    let consumers = hugr
        .linked_inputs(conversion, OutgoingPort::from(0))
        .collect_vec();
    for (consumer, consumer_port) in consumers {
        // Guppy commonly follows `is_to_u` with `iu_to_s` when a `nat` is
        // consumed by an operation that currently expects `int`. Bypass the
        // complete round-trip; otherwise the second operation emits its own
        // upper-bound check.
        if consumer_port == IncomingPort::from(0) && is_int_op(hugr, consumer, IntOpDef::iu_to_s) {
            let signed_consumers = hugr
                .linked_inputs(consumer, OutgoingPort::from(0))
                .collect_vec();
            for (signed_consumer, signed_consumer_port) in signed_consumers {
                hugr.disconnect_edge(
                    consumer,
                    OutgoingPort::from(0),
                    signed_consumer,
                    signed_consumer_port,
                );
                hugr.connect(
                    replacement_node,
                    replacement_port,
                    signed_consumer,
                    signed_consumer_port,
                );
            }
            hugr.remove_node(consumer);
            continue;
        }
        hugr.disconnect_edge(conversion, OutgoingPort::from(0), consumer, consumer_port);
        hugr.connect(replacement_node, replacement_port, consumer, consumer_port);
    }
    hugr.remove_node(conversion);
}

#[cfg(test)]
mod tests {
    use hugr::builder::{Dataflow, DataflowHugr, FunctionBuilder};
    use hugr::extension::simple_op::MakeRegisteredOp;
    use hugr::ops::DataflowOpTrait;
    use hugr::std_extensions::arithmetic::int_types::int_type;
    use hugr::types::Signature;
    use tket_qsystem::extension::{random::RandomOpBuilder, utils::UtilsOpBuilder};

    use super::*;

    fn count_int_op(hugr: &impl HugrView<Node = Node>, expected: IntOpDef) -> usize {
        hugr.nodes()
            .filter(|&node| is_int_op(hugr, node, expected))
            .count()
    }

    #[test]
    fn removes_direct_shot_check_and_is_idempotent() {
        let mut builder = FunctionBuilder::new(
            "shot_to_nat",
            Signature::new(vec![], vec![int_type(6), int_type(6)]),
        )
        .unwrap();
        let shot = builder.add_get_current_shot().unwrap();
        let converted = builder
            .add_dataflow_op(IntOpDef::is_to_u.with_log_width(6), [shot])
            .unwrap()
            .out_wire(0);
        let round_trip = builder
            .add_dataflow_op(IntOpDef::iu_to_s.with_log_width(6), [converted])
            .unwrap()
            .out_wire(0);
        let mut hugr = builder
            .finish_hugr_with_outputs([shot, round_trip])
            .unwrap();

        let pass = RemoveKnownNonNegativeChecksPass::default();
        assert_eq!(pass.run(&mut hugr).unwrap(), 1);
        assert_eq!(pass.run(&mut hugr).unwrap(), 0);
        assert_eq!(count_int_op(&hugr, IntOpDef::is_to_u), 0);
        assert_eq!(count_int_op(&hugr, IntOpDef::iu_to_s), 0);
        hugr.validate().unwrap();
    }

    #[test]
    fn treats_all_rng_widening_paths_as_unsigned() {
        let random_op = RandomOp::RandomInt.to_extension_op().unwrap();
        let context_type = random_op.signature().input()[0].clone();
        let mut builder = FunctionBuilder::new(
            "random_to_nat",
            Signature::new(
                vec![context_type.clone()],
                vec![int_type(6), int_type(6), context_type],
            ),
        )
        .unwrap();
        let [context] = builder.input_wires_arr();
        let [random, context] = builder.add_random_int(context).unwrap();
        let signed_widen = builder
            .add_dataflow_op(IntOpDef::iwiden_s.with_two_log_widths(5, 6), [random])
            .unwrap()
            .out_wire(0);
        let converted = builder
            .add_dataflow_op(IntOpDef::is_to_u.with_log_width(6), [signed_widen])
            .unwrap()
            .out_wire(0);
        let round_trip = builder
            .add_dataflow_op(IntOpDef::iu_to_s.with_log_width(6), [converted])
            .unwrap()
            .out_wire(0);
        let mut hugr = builder
            .finish_hugr_with_outputs([signed_widen, round_trip, context])
            .unwrap();

        assert_eq!(
            RemoveKnownNonNegativeChecksPass::default()
                .run(&mut hugr)
                .unwrap(),
            2
        );
        assert_eq!(count_int_op(&hugr, IntOpDef::is_to_u), 0);
        assert_eq!(count_int_op(&hugr, IntOpDef::iu_to_s), 0);
        assert_eq!(count_int_op(&hugr, IntOpDef::iwiden_s), 0);
        assert_eq!(count_int_op(&hugr, IntOpDef::iwiden_u), 1);
        hugr.validate().unwrap();
    }

    #[test]
    fn preserves_check_for_arbitrary_integer() {
        let mut builder =
            FunctionBuilder::new("checked_to_nat", Signature::new_endo(vec![int_type(6)])).unwrap();
        let [value] = builder.input_wires_arr();
        let converted = builder
            .add_dataflow_op(IntOpDef::is_to_u.with_log_width(6), [value])
            .unwrap()
            .out_wire(0);
        let round_trip = builder
            .add_dataflow_op(IntOpDef::iu_to_s.with_log_width(6), [converted])
            .unwrap()
            .out_wire(0);
        let mut hugr = builder.finish_hugr_with_outputs([round_trip]).unwrap();

        assert_eq!(
            RemoveKnownNonNegativeChecksPass::default()
                .run(&mut hugr)
                .unwrap(),
            0
        );
        assert_eq!(count_int_op(&hugr, IntOpDef::is_to_u), 1);
        assert_eq!(count_int_op(&hugr, IntOpDef::iu_to_s), 1);
        hugr.validate().unwrap();
    }
}
