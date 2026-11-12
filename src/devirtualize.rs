//! Resolve indirect callees using conservative dataflow analysis.
//!
//! Function identities are propagated through tuples, sums, fixed-size arrays,
//! control flow, and direct function calls. A singleton target becomes a direct
//! call. A proven finite array or conditional choice becomes conditional direct
//! dispatch, preserving the original lookup and its checks. Unknown targets and
//! selections whose control value is not available in the call's region remain
//! indirect. No function-pointer identity test is introduced at runtime.
//!
//! Exposing direct calls before LLVM lowering allows HUGR inlining to eliminate
//! helper-local array storage before it can escape through a function return.

use std::error::Error;
use std::fmt::{self, Display, Formatter};

use hugr::extension::SignatureError;
use hugr::hugr::hugrmut::HugrMut;
use hugr::{HugrView, IncomingPort, Node, Wire};

mod analysis;
mod rewrite;
use hugr_core::hugr::internal::HugrMutInternals;
use itertools::Itertools;
use tket::passes::{ComposablePass, PassScope, WithScope};

/// Errors reported while converting a statically-known indirect call.
#[derive(Debug)]
#[non_exhaustive]
pub enum DevirtualizeDirectCallsError {
    /// The loaded function's type arguments cannot instantiate its signature.
    InvalidSignature(SignatureError),
    /// A malformed indirect call is missing a required value argument.
    MissingArgument {
        /// The malformed indirect call.
        call: Node,
        /// The zero-based function argument index.
        index: usize,
    },
    /// The static source of a loaded function has no function output port.
    MissingStaticOutput {
        /// The malformed function definition or declaration.
        function: Node,
    },
}

impl Display for DevirtualizeDirectCallsError {
    fn fmt(&self, formatter: &mut Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidSignature(error) => Display::fmt(error, formatter),
            Self::MissingArgument { call, index } => write!(
                formatter,
                "statically-known indirect call {call} is missing argument {index}"
            ),
            Self::MissingStaticOutput { function } => {
                write!(formatter, "loaded function {function} has no static output")
            }
        }
    }
}

impl Error for DevirtualizeDirectCallsError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            Self::InvalidSignature(error) => Some(error),
            Self::MissingArgument { .. } | Self::MissingStaticOutput { .. } => None,
        }
    }
}

impl From<SignatureError> for DevirtualizeDirectCallsError {
    fn from(error: SignatureError) -> Self {
        Self::InvalidSignature(error)
    }
}

/// Converts proven indirect callees into direct calls or finite conditional dispatch.
///
/// Each call is analyzed independently of the operation immediately producing its
/// function value. The returned count includes both direct-call replacements and
/// finite-dispatch replacements. Existing value dependencies and order edges are
/// preserved; unresolved callees are left unchanged.
#[derive(Clone, Debug, Default)]
pub struct DevirtualizeDirectCallsPass {
    scope: PassScope,
}

impl<H> ComposablePass<H> for DevirtualizeDirectCallsPass
where
    H: HugrMut<Node = Node> + HugrMutInternals<Node = Node>,
{
    type Error = DevirtualizeDirectCallsError;
    type Result = usize;

    fn run(&self, hugr: &mut H) -> Result<Self::Result, Self::Error> {
        let Some(root) = self.scope.root(hugr) else {
            return Ok(0);
        };
        let calls = hugr
            .descendants(root)
            .filter(|&node| hugr.get_optype(node).is_call_indirect())
            .collect_vec();
        if calls.is_empty() {
            return Ok(0);
        }
        let facts = analysis::analyze(hugr, root, &self.scope);
        let mut rewritten = 0;

        for call_node in calls {
            let Some((load_node, load_port)) =
                hugr.single_linked_output(call_node, IncomingPort::from(0))
            else {
                continue;
            };
            let Some(callees) = facts.values.get(&Wire::new(load_node, load_port)) else {
                continue;
            };
            if rewrite::rewrite(hugr, call_node, &facts, callees)? {
                if hugr.get_optype(load_node).is_load_function()
                    && hugr.linked_inputs(load_node, 0).next().is_none()
                {
                    hugr.remove_node(load_node);
                }
                rewritten += 1;
            }
        }

        Ok(rewritten)
    }
}

impl WithScope for DevirtualizeDirectCallsPass {
    fn with_scope(mut self, scope: impl Into<PassScope>) -> Self {
        self.scope = scope.into();
        self
    }
}

#[cfg(test)]
mod tests {
    use hugr::builder::{Dataflow, DataflowSubContainer, HugrBuilder, ModuleBuilder};
    use hugr::extension::prelude::usize_t;
    use hugr::ops::CallIndirect;
    use hugr::types::Signature;

    use super::*;

    #[test]
    fn rewrites_immediately_loaded_function_and_is_idempotent() {
        let signature = Signature::new_endo([usize_t()]);
        let mut module = ModuleBuilder::new();
        let identity = {
            let builder = module
                .define_function("identity", signature.clone())
                .unwrap();
            let [value] = builder.input_wires_arr();
            builder.finish_with_outputs([value]).unwrap()
        };

        let mut main = module.define_function("main", signature.clone()).unwrap();
        let [value] = main.input_wires_arr();
        let function = main.load_func(identity.handle(), &[]).unwrap();
        let result = main
            .add_dataflow_op(CallIndirect { signature }, [function, value])
            .unwrap()
            .out_wire(0);
        main.finish_with_outputs([result]).unwrap();
        let mut hugr = module.finish_hugr().unwrap();

        assert_eq!(
            hugr.nodes()
                .filter(|&node| hugr.get_optype(node).is_call_indirect())
                .count(),
            1
        );
        assert_eq!(
            DevirtualizeDirectCallsPass::default()
                .run(&mut hugr)
                .unwrap(),
            1
        );
        assert_eq!(
            hugr.nodes()
                .filter(|&node| hugr.get_optype(node).is_call_indirect())
                .count(),
            0
        );
        assert_eq!(
            hugr.nodes()
                .filter(|&node| hugr.get_optype(node).is_call())
                .count(),
            1
        );
        assert_eq!(
            DevirtualizeDirectCallsPass::default()
                .run(&mut hugr)
                .unwrap(),
            0
        );
        hugr.validate().unwrap();
    }

    #[test]
    fn follows_tuple_values() {
        use hugr::extension::prelude::UnpackTuple;
        use hugr::types::Type;
        let signature = Signature::new_endo([usize_t()]);
        let mut module = ModuleBuilder::new();
        let identity = {
            let b = module
                .define_function("identity", signature.clone())
                .unwrap();
            let [v] = b.input_wires_arr();
            b.finish_with_outputs([v]).unwrap()
        };
        let mut main = module.define_function("main", signature.clone()).unwrap();
        let [v] = main.input_wires_arr();
        let f = main.load_func(identity.handle(), &[]).unwrap();
        let tuple = main.make_tuple([f, v]).unwrap();
        let [f, v] = main
            .add_dataflow_op(
                UnpackTuple::new(vec![Type::new_function(signature.clone()), usize_t()].into()),
                [tuple],
            )
            .unwrap()
            .outputs_arr();
        let result = main
            .add_dataflow_op(CallIndirect { signature }, [f, v])
            .unwrap()
            .out_wire(0);
        main.finish_with_outputs([result]).unwrap();
        let mut h = module.finish_hugr().unwrap();
        assert_eq!(
            DevirtualizeDirectCallsPass::default().run(&mut h).unwrap(),
            1
        );
        h.validate().unwrap();
    }

    #[test]
    fn leaves_unknown_function_arguments_indirect() {
        use hugr::ops::handle::NodeHandle;
        use hugr::types::Type;
        use tket::passes::composable::Preserve;
        let signature = Signature::new_endo([usize_t()]);
        let mut module = ModuleBuilder::new();
        let mut main = module
            .define_function(
                "main",
                Signature::new(
                    [Type::new_function(signature.clone()), usize_t()],
                    [usize_t()],
                ),
            )
            .unwrap();
        let [f, v] = main.input_wires_arr();
        let result = main
            .add_dataflow_op(CallIndirect { signature }, [f, v])
            .unwrap()
            .out_wire(0);
        let main = main.finish_with_outputs([result]).unwrap();
        let mut h = module.finish_hugr().unwrap();
        h.set_entrypoint(main.handle().node());
        assert_eq!(
            DevirtualizeDirectCallsPass::default()
                .with_scope(PassScope::Global(Preserve::Entrypoint))
                .run(&mut h)
                .unwrap(),
            0
        );
        assert_eq!(
            h.nodes()
                .filter(|n| h.get_optype(*n).is_call_indirect())
                .count(),
            1
        );
        h.validate().unwrap();
    }

    #[test]
    fn propagates_callees_through_private_function_parameters() {
        use hugr::ops::handle::NodeHandle;
        use hugr::types::Type;
        use tket::passes::composable::Preserve;
        let signature = Signature::new_endo([usize_t()]);
        let mut module = ModuleBuilder::new();
        let identity = {
            let b = module
                .define_function("identity", signature.clone())
                .unwrap();
            let [v] = b.input_wires_arr();
            b.finish_with_outputs([v]).unwrap()
        };
        let wrapper = {
            let mut b = module
                .define_function(
                    "wrapper",
                    Signature::new(
                        [Type::new_function(signature.clone()), usize_t()],
                        [usize_t()],
                    ),
                )
                .unwrap();
            let [f, v] = b.input_wires_arr();
            let out = b
                .add_dataflow_op(
                    CallIndirect {
                        signature: signature.clone(),
                    },
                    [f, v],
                )
                .unwrap()
                .out_wire(0);
            b.finish_with_outputs([out]).unwrap()
        };
        let mut main = module.define_function("main", signature).unwrap();
        let [v] = main.input_wires_arr();
        let f = main.load_func(identity.handle(), &[]).unwrap();
        let out = main
            .call(wrapper.handle(), &[], [f, v])
            .unwrap()
            .out_wire(0);
        let main = main.finish_with_outputs([out]).unwrap();
        let mut h = module.finish_hugr().unwrap();
        h.set_entrypoint(main.handle().node());
        assert_eq!(
            DevirtualizeDirectCallsPass::default()
                .with_scope(PassScope::Global(Preserve::Entrypoint))
                .run(&mut h)
                .unwrap(),
            1
        );
        h.validate().unwrap();
    }

    #[test]
    fn lowers_a_runtime_conditional_between_known_functions() {
        use hugr::builder::SubContainer;
        use hugr::extension::prelude::{ConstUsize, bool_t};
        use hugr::ops::handle::NodeHandle;
        use hugr::types::{Type, TypeRow};
        let signature = Signature::new_endo([usize_t()]);
        let fn_ty = Type::new_function(signature.clone());
        let mut module = ModuleBuilder::new();
        let identity = {
            let b = module
                .define_function("identity", signature.clone())
                .unwrap();
            let [v] = b.input_wires_arr();
            b.finish_with_outputs([v]).unwrap()
        };
        let one = {
            let mut b = module.define_function("one", signature.clone()).unwrap();
            let one = b.add_load_value(ConstUsize::new(1));
            b.finish_with_outputs([one]).unwrap()
        };
        let mut main = module
            .define_function("main", Signature::new([bool_t(), usize_t()], [usize_t()]))
            .unwrap();
        let [choose, value] = main.input_wires_arr();
        let mut conditional = main
            .conditional_builder((vec![TypeRow::default(); 2], choose), [], [fn_ty].into())
            .unwrap();
        for (i, target) in [identity.handle(), one.handle()].into_iter().enumerate() {
            let mut case = conditional.case_builder(i).unwrap();
            let f = case.load_func(target, &[]).unwrap();
            case.finish_with_outputs([f]).unwrap();
        }
        let f = conditional.finish_sub_container().unwrap().out_wire(0);
        let result = main
            .add_dataflow_op(CallIndirect { signature }, [f, value])
            .unwrap()
            .out_wire(0);
        let main = main.finish_with_outputs([result]).unwrap();
        let mut h = module.finish_hugr().unwrap();
        h.set_entrypoint(main.handle().node());
        assert_eq!(
            DevirtualizeDirectCallsPass::default().run(&mut h).unwrap(),
            1
        );
        assert_eq!(
            h.nodes()
                .filter(|n| h.get_optype(*n).is_call_indirect())
                .count(),
            0
        );
        assert_eq!(h.nodes().filter(|n| h.get_optype(*n).is_call()).count(), 2);
        h.validate().unwrap();
    }
}
