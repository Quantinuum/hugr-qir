//! Devirtualization of statically-known indirect function calls.
//!
//! Some HUGR producers represent an ordinary, statically-known function call as
//! a [`LoadFunction`](hugr::ops::LoadFunction) immediately consumed by a
//! [`CallIndirect`](hugr::ops::CallIndirect). Although this representation is
//! semantically valid, it hides the callee from passes that operate on direct
//! [`Call`] nodes. In particular, it can prevent function inlining and leave
//! indirect calls in the generated LLVM IR.
//!
//! [`DevirtualizeDirectCallsPass`] recognizes this local pattern and replaces
//! the indirect call with an equivalent direct call connected to the loaded
//! function's static edge. Function values that flow through parameters,
//! conditionals, data structures, or any other operation are left unchanged
//! because their target is not proven by this pattern.
//!
//! Exposing these calls before inlining is important for QIR generation. It
//! allows fixed-size array and collection operations to be simplified in HUGR
//! and LLVM, and prevents caller-local array storage from escaping through a
//! helper function. Calls that still require dynamic dispatch remain indirect
//! and are rejected later because the targeted QIR profile cannot represent
//! them.

use std::error::Error;
use std::fmt::{self, Display, Formatter};

use hugr::extension::SignatureError;
use hugr::hugr::hugrmut::HugrMut;
use hugr::ops::Call;
use hugr::{HugrView, IncomingPort, Node};
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

/// Converts indirect calls with an immediately-known target into direct calls.
///
/// The pass only rewrites this pattern:
///
/// ```text
/// FuncDefn/FuncDecl --static--> LoadFunction --value--> CallIndirect
/// ```
///
/// The replacement [`Call`] keeps the original value arguments, outputs, and
/// order edge, and connects its static function port directly to the function
/// definition or declaration. An unused `LoadFunction` node is removed.
///
/// This transformation is semantics-preserving and idempotent. It does not try
/// to infer targets for arbitrary first-class function values. The returned
/// count is the number of calls rewritten.
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
        let mut rewritten = 0;

        for call_node in calls {
            let Some((load_node, _)) = hugr.single_linked_output(call_node, IncomingPort::from(0))
            else {
                continue;
            };
            let Some(load) = hugr.get_optype(load_node).as_load_function().cloned() else {
                continue;
            };
            let Some(function_node) = hugr.static_source(load_node) else {
                continue;
            };

            let call = Call::try_new(load.func_sig, load.type_args)?;
            let argument_count = call.instantiation.input_count();
            let argument_sources = (0..argument_count)
                .map(|index| {
                    hugr.single_linked_output(call_node, IncomingPort::from(index + 1))
                        .ok_or(DevirtualizeDirectCallsError::MissingArgument {
                            call: call_node,
                            index,
                        })
                })
                .collect::<Result<Vec<_>, _>>()?;

            // CallIndirect has the function value before its value arguments;
            // Call has only the value arguments plus a static function port.
            for index in 0..=argument_count {
                hugr.disconnect(call_node, IncomingPort::from(index));
            }
            let function_port = call.called_function_port();
            hugr.replace_op(call_node, call);
            for (index, (source_node, source_port)) in argument_sources.into_iter().enumerate() {
                hugr.connect(source_node, source_port, call_node, index);
            }
            let function_output = hugr.get_optype(function_node).static_output_port().ok_or(
                DevirtualizeDirectCallsError::MissingStaticOutput {
                    function: function_node,
                },
            )?;
            hugr.connect(function_node, function_output, call_node, function_port);

            if hugr.linked_inputs(load_node, 0).next().is_none() {
                hugr.remove_node(load_node);
            }
            rewritten += 1;
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
}
