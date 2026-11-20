//! Integer-power specialization and QIR-specific control of LLVM's full-loop unroller.

use std::sync::Once;

use anyhow::{Result, anyhow};

use crate::compilation_error::CompilationError;
use crate::control_flow::CycleFreeControlFlowGraph;
use crate::inkwell::{
    llvm_sys::support::LLVMParseCommandLineOptions, module::Module, passes::PassBuilderOptions,
    targets::TargetMachine,
};
use crate::lower_int_pow::{lower_constant_int_powers, lower_remaining_int_powers};

/// Maximum number of specialization and unrolling rounds per cleanup phase.
const MAX_CLEANUP_ROUNDS: usize = 16;

/// Specialize integer powers and unroll loops until cleanup converges.
///
/// Expand remaining runtime powers and simplify their results before resource
/// assignment. Returns an error if either cleanup phase exhausts its round limit.
/// Callers must reject any surviving loops with `ensure_no_loops`.
pub(crate) fn lower_powers_and_unroll_loops(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
) -> Result<()> {
    lower_powers_and_unroll_with_round_limit(module, target, max_loop_unroll, MAX_CLEANUP_ROUNDS)
}

fn lower_powers_and_unroll_with_round_limit(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
    max_rounds: usize,
) -> Result<()> {
    specialize_and_unroll(
        module,
        target,
        max_loop_unroll,
        max_rounds,
        "before expanding runtime integer powers",
    )?;
    if lower_remaining_int_powers(module)? > 0 {
        // Expansion can reveal constant bounds even for a runtime exponent,
        // for example when the base is one. Clean up before rejecting loops.
        specialize_and_unroll(
            module,
            target,
            max_loop_unroll,
            max_rounds,
            "after expanding runtime integer powers",
        )?;
    }
    Ok(())
}

fn specialize_and_unroll(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
    max_rounds: usize,
    phase: &str,
) -> Result<()> {
    // Unrolling an outer loop can make an inner loop's trip count constant.
    // Repeat cleanup until all loops disappear or the pipeline stops changing
    // the IR, with a bound for modules that keep changing without converging.
    let mut previous_ir = None;
    lower_constant_int_powers(module)?;
    for _ in 0..max_rounds {
        unroll_static_loops_once(module, target, max_loop_unroll)?;
        while lower_constant_int_powers(module)? > 0 {
            // Remove branches made constant by specialization before resource
            // IDs are assigned, even when there are no loops left to unroll.
            module
                .run_passes(
                    "function(instcombine<max-iterations=2>,early-cse,simplifycfg)",
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
        "LLVM specialization and loop cleanup exhausted its limit of {max_rounds} cleanup rounds {phase} with loops still remaining. \
         This compiler cleanup limit is separate from the per-loop iteration limit of {max_loop_unroll}."
    ))
    .into())
}

/// Run one forced-unrolling round and simplify the resulting IR.
fn unroll_static_loops_once(
    module: &Module<'_>,
    target: &TargetMachine,
    max_loop_unroll: usize,
) -> Result<()> {
    configure_forced_unrolling();
    let loop_cleanup = format!(
        "function(loop-unroll<O3;no-runtime;no-partial;full-unroll-max={max_loop_unroll}>,sroa<modify-cfg>,instcombine<max-iterations=2>,early-cse,simplifycfg)"
    );
    module
        .run_passes(&loop_cleanup, target, PassBuilderOptions::create())
        .map_err(|e| anyhow!("Failed to fully unroll static loops: {e}"))
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
    use crate::inkwell::context::Context;
    use crate::test::{LLVM_TEST_LOCK, count_calls, load_module_from_ir, native_target_machine};

    const NESTED_LOOPS_IR: &str = "
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

    fn main_calls(module: &Module<'_>) -> usize {
        count_calls(module.get_function("main").unwrap())
    }

    #[test]
    fn one_round_unrolls_static_loop_and_preserves_calls() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let ir = "
            declare void @effect(i64)
            define void @main() {
            entry:
                br label %loop
            loop:
                %i = phi i64 [0, %entry], [%next, %loop]
                call void @effect(i64 %i)
                %next = add nuw nsw i64 %i, 1
                %done = icmp eq i64 %next, 3
                br i1 %done, label %exit, label %loop
            exit:
                ret void
            }
        ";
        let module = load_module_from_ir(&context, "one_round", ir).unwrap();
        let target = native_target_machine();

        unroll_static_loops_once(&module, &target, 3).unwrap();

        ensure_no_loops(&module, 3).unwrap();
        assert_eq!(main_calls(&module), 3);
        module.verify().unwrap();
    }

    #[test]
    fn unrolls_nested_loops_over_multiple_rounds() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_ir(&context, "nested_loops", NESTED_LOOPS_IR).unwrap();
        let target = native_target_machine();

        // One round exposes constant inner bounds but leaves loops to unroll.
        lower_powers_and_unroll_with_round_limit(&module, &target, 800, 1).unwrap_err();
        assert!(ensure_no_loops(&module, 800).is_err());
        lower_powers_and_unroll_loops(&module, &target, 800).unwrap();

        ensure_no_loops(&module, 800).unwrap();
        module.verify().unwrap();
        assert_eq!(main_calls(&module), 7);
    }

    #[test]
    fn reports_round_limit_separately_from_trip_count_limit() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_ir(&context, "nested_loops", NESTED_LOOPS_IR).unwrap();
        let target = native_target_machine();

        let error = lower_powers_and_unroll_with_round_limit(&module, &target, 800, 1).unwrap_err();

        assert!(error.downcast_ref::<CompilationError>().is_some());
        let message = error.to_string();
        assert!(message.contains("limit of 1 cleanup rounds"));
        assert!(message.contains("before expanding runtime integer powers"));
        module.verify().unwrap();
    }

    #[test]
    fn converges_with_oversized_loop_and_preserves_trip_count_diagnostic() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_ir(&context, "nested_loops", NESTED_LOOPS_IR).unwrap();
        let target = native_target_machine();

        lower_powers_and_unroll_loops(&module, &target, 1).unwrap();
        let error = ensure_no_loops(&module, 1).err().unwrap();
        assert!(error.to_string().contains("iteration count"));
        assert!(error.to_string().contains("limit of 1"));
        module.verify().unwrap();
    }

    #[test]
    fn specializes_power_bounds_after_unrolling_outer_loop() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let ir = r#"
            declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
            declare void @effect(i64)
            define void @main() {
            entry:
                br label %outer
            outer:
                %i = phi i64 [0, %entry], [%next_i, %outer_latch]
                %bound = call i64 @__hugr_qir_ipow_i64(i64 2, i64 %i)
                br label %inner
            inner:
                %j = phi i64 [0, %outer], [%next_j, %body]
                %done = icmp eq i64 %j, %bound
                br i1 %done, label %outer_latch, label %body
            body:
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
        "#;
        let module = load_module_from_ir(&context, "power_bounds", ir).unwrap();
        let target = native_target_machine();

        lower_powers_and_unroll_loops(&module, &target, 8).unwrap();

        ensure_no_loops(&module, 8).unwrap();
        assert!(module.get_function("__hugr_qir_ipow_i64").is_none());
        assert_eq!(main_calls(&module), 7);
        module.verify().unwrap();
    }

    #[test]
    fn simplifies_branches_after_exponent_becomes_constant() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let ir = r#"
            declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
            declare void @unreachable_effect()
            define void @main() {
            entry:
                %exponent = add i64 1, 1
                %power = call i64 @__hugr_qir_ipow_i64(i64 2, i64 %exponent)
                %wrong = icmp ne i64 %power, 4
                br i1 %wrong, label %bad, label %exit
            bad:
                call void @unreachable_effect()
                br label %exit
            exit:
                ret void
            }
        "#;
        let module = load_module_from_ir(&context, "constant_power_branch", ir).unwrap();
        let target = native_target_machine();

        lower_powers_and_unroll_loops(&module, &target, 1).unwrap();

        let function = module.get_function("main").unwrap();
        assert_eq!(function.count_basic_blocks(), 1);
        assert_eq!(
            function
                .get_first_basic_block()
                .unwrap()
                .get_instructions()
                .count(),
            1
        );
        module.verify().unwrap();
    }

    #[test]
    fn specialized_power_identities_remove_dead_resource_allocations() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let target = native_target_machine();
        for exponent in ["2", "%exponent"] {
            let ir = format!(
                r#"
                declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
                declare ptr @__quantum__rt__qubit_allocate()
                declare ptr @__QIR__CONV_Qubit_TO_Result(ptr)
                define void @main(i64 %x) {{
                entry:
                    %exponent = add i64 1, 1
                    %square = mul i64 %x, %x
                    %power = call i64 @__hugr_qir_ipow_i64(i64 %x, i64 {exponent})
                    %wrong = icmp ne i64 %square, %power
                    br i1 %wrong, label %bad, label %exit
                bad:
                    %q = call ptr @__quantum__rt__qubit_allocate()
                    %r = call ptr @__QIR__CONV_Qubit_TO_Result(ptr %q)
                    br label %exit
                exit:
                    ret void
                }}
                "#
            );
            let module = load_module_from_ir(&context, "power_identity", &ir).unwrap();

            lower_powers_and_unroll_loops(&module, &target, 1).unwrap();

            for resource in [
                "__quantum__rt__qubit_allocate",
                "__QIR__CONV_Qubit_TO_Result",
            ] {
                assert_eq!(
                    crate::replace_int_opque_pointer(&module, resource).unwrap(),
                    0
                );
            }
            module.verify().unwrap();
        }
    }

    #[test]
    fn specializes_chained_powers_before_runtime_expansion() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let target = native_target_machine();
        let ir = r#"
            declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
            define i64 @main(i64 %x) {
            entry:
                %exponent = add i64 1, 1
                %first = call i64 @__hugr_qir_ipow_i64(i64 2, i64 %exponent)
                %next = add i64 %first, 1
                %second = call i64 @__hugr_qir_ipow_i64(i64 2, i64 %next)
                %last = add i64 %second, 1
                %third = call i64 @__hugr_qir_ipow_i64(i64 %x, i64 %last)
                ret i64 %third
            }
        "#;
        let module = load_module_from_ir(&context, "chained_powers", ir).unwrap();

        specialize_and_unroll(&module, &target, 1, 1, "test").unwrap();

        assert_eq!(main_calls(&module), 0);
        module.verify().unwrap();
    }

    #[test]
    fn runtime_power_bounds_still_require_static_loop_counts() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let target = native_target_machine();
        for base in [1, 3] {
            let ir = format!(
                r#"
                declare i64 @__hugr_qir_ipow_i64(i64, i64) "hugr-qir.ipow"=""
                declare void @effect(i64)
                define void @main(i64 %exponent) {{
                entry:
                    %bound = call i64 @__hugr_qir_ipow_i64(i64 {base}, i64 %exponent)
                    br label %loop
                loop:
                    %i = phi i64 [0, %entry], [%next, %body]
                    %done = icmp eq i64 %i, %bound
                    br i1 %done, label %exit, label %body
                body:
                    call void @effect(i64 %i)
                    %next = add i64 %i, 1
                    br label %loop
                exit:
                    ret void
                }}
            "#
            );
            let module = load_module_from_ir(&context, "runtime_bound", &ir).unwrap();

            lower_powers_and_unroll_loops(&module, &target, 8).unwrap();

            // One to any exponent is always one, so that loop can still unroll.
            assert_eq!(ensure_no_loops(&module, 8).is_ok(), base == 1);
            assert!(module.get_function("__hugr_qir_ipow_i64").is_none());
            module.verify().unwrap();
        }
    }

    #[test]
    fn rejects_natural_loop_without_array_storage() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
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
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
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
