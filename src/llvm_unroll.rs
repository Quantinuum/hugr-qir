//! QIR-specific control of LLVM's full-loop unroller.

use std::sync::Once;

use crate::control_flow::CycleFreeControlFlowGraph;
use crate::inkwell::{llvm_sys::support::LLVMParseCommandLineOptions, module::Module};
use anyhow::Result;

/// Remove LLVM's profitability ceiling for the dedicated QIR unroll pass.
///
/// The pass-local `full-unroll-max` setting remains the hard trip-count limit.
/// This process-wide LLVM option only prevents code-size heuristics from
/// rejecting a loop whose statically-known trip count is within that limit.
pub(crate) fn configure_forced_unrolling() {
    static CONFIGURE: Once = Once::new();
    CONFIGURE.call_once(|| unsafe {
        let program = c"hugr-qir";
        let threshold = c"-unroll-threshold=4294967295";
        let argv = [program.as_ptr(), threshold.as_ptr()];
        LLVMParseCommandLineOptions(2, argv.as_ptr(), std::ptr::null());
    });
}

/// Reject any reachable cyclic control flow that survived LLVM unrolling.
pub(crate) fn ensure_no_loops<'ctx>(
    module: &Module<'ctx>,
    max_loop_unroll: usize,
) -> Result<Vec<CycleFreeControlFlowGraph<'ctx>>> {
    module
        .get_functions()
        .filter(|function| function.get_first_basic_block().is_some())
        .map(|function| CycleFreeControlFlowGraph::new(function, max_loop_unroll))
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inkwell::context::Context;

    #[test]
    fn rejects_natural_loop_without_array_storage() {
        let context = Context::create();
        let module = context.create_module("loop_unroll_metadata");
        let builder = context.create_builder();
        let function = module.add_function("main", context.void_type().fn_type(&[], false), None);
        let entry = context.append_basic_block(function, "entry");
        let header = context.append_basic_block(function, "header");
        let latch = context.append_basic_block(function, "latch");
        let exit = context.append_basic_block(function, "exit");

        builder.position_at_end(entry);
        builder.build_unconditional_branch(header).unwrap();
        builder.position_at_end(header);
        builder
            .build_conditional_branch(context.bool_type().const_all_ones(), latch, exit)
            .unwrap();
        builder.position_at_end(latch);
        builder.build_unconditional_branch(header).unwrap();
        builder.position_at_end(exit);
        builder.build_return(None).unwrap();

        assert!(ensure_no_loops(&module, 800).is_err());
        module.verify().unwrap();
    }

    #[test]
    fn accepts_acyclic_control_flow() {
        let context = Context::create();
        let module = context.create_module("no_array_loop");
        let builder = context.create_builder();
        let function = module.add_function("main", context.void_type().fn_type(&[], false), None);
        let entry = context.append_basic_block(function, "entry");
        let exit = context.append_basic_block(function, "exit");

        builder.position_at_end(entry);
        builder.build_unconditional_branch(exit).unwrap();
        builder.position_at_end(exit);
        builder.build_return(None).unwrap();

        ensure_no_loops(&module, 800).unwrap();
    }
}
