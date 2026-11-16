//! QIR-specific control of LLVM's full-loop unroller.

use std::sync::Once;

use crate::compilation_error::CompilationError;
use crate::control_flow::CycleFreeControlFlowGraph;
use crate::inkwell::{
    llvm_sys::support::LLVMParseCommandLineOptions, module::Module, passes::PassBuilderOptions,
    targets::TargetMachine,
};
use crate::qir::int_ext::{lower_constant_int_powers, lower_remaining_int_powers};
use anyhow::{Result, anyhow};

const MAX_LOOP_UNROLL_ROUNDS: usize = 16;

/// Unroll static loops until none remain or cleanup stops changing the IR.
/// Returns an error if cleanup exhausts its round limit. Remaining loops after
/// convergence must be checked with `ensure_no_loops`.
pub(crate) fn unroll_static_loops(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
) -> Result<()> {
    unroll_static_loops_with_round_limit(module, target, max_loop_unroll, MAX_LOOP_UNROLL_ROUNDS)?;
    if lower_remaining_int_powers(module)? > 0 {
        // Expansion can reveal constant bounds even for a runtime exponent,
        // for example when the base is one. Clean up before rejecting loops.
        unroll_static_loops_with_round_limit(
            module,
            target,
            max_loop_unroll,
            MAX_LOOP_UNROLL_ROUNDS,
        )?;
    }
    Ok(())
}

fn unroll_static_loops_with_round_limit(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
    max_rounds: usize,
) -> Result<()> {
    configure_forced_unrolling();
    let loop_cleanup = format!(
        "function(loop-unroll<O3;no-runtime;no-partial;full-unroll-max={max_loop_unroll}>,sroa<modify-cfg>,instcombine<max-iterations=2>,simplifycfg)"
    );
    // Unrolling an outer loop can make an inner loop's trip count constant.
    // Repeat cleanup until all loops disappear or the pipeline stops changing
    // the IR, with a bound for modules that keep changing without converging.
    let mut previous_ir = None;
    lower_constant_int_powers(module)?;
    for _ in 0..max_rounds {
        module
            .run_passes(&loop_cleanup, target, PassBuilderOptions::create())
            .map_err(|e| anyhow!("Failed to fully unroll static loops: {e}"))?;
        if lower_constant_int_powers(module)? > 0 {
            // Remove branches made constant by specialization before resource
            // IDs are assigned, even when there are no loops left to unroll.
            module
                .run_passes(
                    "function(instcombine<max-iterations=2>,simplifycfg)",
                    target,
                    PassBuilderOptions::create(),
                )
                .map_err(|e| anyhow!("Failed to simplify specialized integer powers: {e}"))?;
        }
        if ensure_no_loops(module, max_loop_unroll).is_ok() {
            return Ok(());
        }
        let current_ir = module.print_to_string();
        if previous_ir.as_ref() == Some(&current_ir) {
            return Ok(());
        }
        previous_ir = Some(current_ir);
    }
    Err(CompilationError::new(format!(
        "Loop unrolling exhausted its limit of {max_rounds} cleanup rounds with loops still remaining. \
         This compiler cleanup limit is separate from the per-loop iteration limit of {max_loop_unroll}."
    ))
    .into())
}

/// Remove LLVM's profitability ceiling for the dedicated QIR unroll pass.
///
/// The pass-local `full-unroll-max` setting remains the hard trip-count limit.
/// This process-wide LLVM option only prevents code-size heuristics from
/// rejecting a loop whose statically-known trip count is within that limit.
fn configure_forced_unrolling() {
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
    use crate::inkwell::{context::Context, memory_buffer::MemoryBuffer};
    use crate::target::CompileTarget;

    fn nested_loop_module(context: &Context) -> Module<'_> {
        let ir = c"
            declare void @effect(i64)

            define void @main() {
            entry:
                %bounds = alloca [3 x i64]
                store [3 x i64] [i64 1, i64 2, i64 4], ptr %bounds
                br label %outer
            outer:
                %i = phi i64 [0, %entry], [%next_i, %outer_latch]
                %bound_ptr = getelementptr [3 x i64], ptr %bounds, i64 0, i64 %i
                %bound = load i64, ptr %bound_ptr
                br label %inner
            inner:
                %j = phi i64 [0, %outer], [%next_j, %inner_body]
                %inner_done = icmp eq i64 %j, %bound
                br i1 %inner_done, label %outer_latch, label %inner_body
            inner_body:
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
        ";
        let module = context
            .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                ir.to_bytes_with_nul(),
                "nested_loops",
            ))
            .unwrap();
        module.verify().unwrap();
        module
    }

    #[test]
    fn unrolls_nested_loops_over_multiple_rounds() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = nested_loop_module(&context);
        CompileTarget::Native.initialise();
        let target = CompileTarget::Native.machine(crate::inkwell::OptimizationLevel::Default);

        // One round exposes constant inner bounds but leaves loops to unroll.
        unroll_static_loops_with_round_limit(&module, &target, 800, 1).unwrap_err();
        assert!(ensure_no_loops(&module, 800).is_err());
        unroll_static_loops(&module, &target, 800).unwrap();

        ensure_no_loops(&module, 800).unwrap();
        module.verify().unwrap();
        let calls = module
            .get_function("main")
            .unwrap()
            .get_basic_blocks()
            .iter()
            .flat_map(|block| block.get_instructions())
            .filter(|inst| inst.get_opcode() == crate::inkwell::values::InstructionOpcode::Call)
            .count();
        assert_eq!(calls, 7);
    }

    #[test]
    fn reports_round_limit_separately_from_trip_count_limit() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = nested_loop_module(&context);
        CompileTarget::Native.initialise();
        let target = CompileTarget::Native.machine(crate::inkwell::OptimizationLevel::Default);

        let error = unroll_static_loops_with_round_limit(&module, &target, 800, 1).unwrap_err();

        assert!(error.downcast_ref::<CompilationError>().is_some());
        assert!(error.to_string().contains("limit of 1 cleanup rounds"));
        module.verify().unwrap();
    }

    #[test]
    fn converges_with_oversized_loop_and_preserves_trip_count_diagnostic() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = nested_loop_module(&context);
        CompileTarget::Native.initialise();
        let target = CompileTarget::Native.machine(crate::inkwell::OptimizationLevel::Default);

        unroll_static_loops(&module, &target, 1).unwrap();
        let error = ensure_no_loops(&module, 1).err().unwrap();
        assert!(error.to_string().contains("iteration count"));
        assert!(error.to_string().contains("limit of 1"));
        module.verify().unwrap();
    }

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
