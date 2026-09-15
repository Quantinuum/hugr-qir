//! QIR-specific control of LLVM's full-loop unroller.

use std::collections::HashMap;
use std::sync::Once;

use crate::compilation_error::CompilationError;
use crate::inkwell::{
    llvm_sys::support::LLVMParseCommandLineOptions, module::Module, passes::PassBuilderOptions,
    targets::TargetMachine,
};
use anyhow::{Result, anyhow};

use crate::lower_ssa_vars::direct_successors;

const MAX_UNROLL_ROUNDS: usize = 16;

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

/// Re-run LLVM's full-loop unroller until all loops have been removed or the
/// module reaches a fixed point.
///
/// LLVM visits inner loops before outer loops. Unrolling an outer loop can
/// therefore specialize inner loops that were not unrollable when first
/// visited. A new pass-manager invocation is needed to revisit those loops.
pub(crate) fn unroll_loops_to_fixpoint(
    module: &Module,
    target: &TargetMachine,
    max_loop_unroll: usize,
) -> Result<()> {
    configure_forced_unrolling();

    for _ in 0..MAX_UNROLL_ROUNDS {
        let before = module.write_bitcode_to_memory();
        run_unroll_round(module, target, max_loop_unroll)?;

        if !module_has_loops(module)? {
            break;
        }

        let after = module.write_bitcode_to_memory();
        if before.as_slice() == after.as_slice() {
            break;
        }
    }

    module
        .run_passes(
            "function(instcombine,simplifycfg)",
            target,
            PassBuilderOptions::create(),
        )
        .map_err(|e| anyhow!("Failed to clean up fully unrolled loops: {e}"))
}

fn run_unroll_round(module: &Module, target: &TargetMachine, max_loop_unroll: usize) -> Result<()> {
    let pipeline = format!(
        "function(loop-unroll<O3;no-runtime;no-partial;full-unroll-max={max_loop_unroll}>,sroa<modify-cfg>,simplifycfg)"
    );
    module
        .run_passes(&pipeline, target, PassBuilderOptions::create())
        .map_err(|e| anyhow!("Failed to fully unroll static loops: {e}"))
}

/// Reject any reachable cyclic control flow that survived LLVM unrolling.
pub(crate) fn ensure_no_loops(module: &Module, max_loop_unroll: usize) -> Result<()> {
    if module_has_loops(module)? {
        return Err(CompilationError::new(format!(
            "Loop cannot be unrolled: its iteration count is not known at compile time or exceeds the limit of {max_loop_unroll}."
        )).into());
    }
    Ok(())
}

fn module_has_loops(module: &Module) -> Result<bool> {
    for function in module.get_functions() {
        let blocks = function.get_basic_blocks();
        if blocks.is_empty() {
            continue;
        }
        let successors = cfg_successors(&blocks)?;
        if graph_has_cycle(&successors) {
            return Ok(true);
        }
    }
    Ok(false)
}

fn cfg_successors(blocks: &[crate::inkwell::basic_block::BasicBlock]) -> Result<Vec<Vec<usize>>> {
    let indices: HashMap<_, _> = blocks
        .iter()
        .enumerate()
        .map(|(index, block)| (block.as_mut_ptr() as usize, index))
        .collect();
    let mut successors = vec![Vec::new(); blocks.len()];
    for (from, block) in blocks.iter().enumerate() {
        for successor in direct_successors(*block)? {
            if let Some(&to) = indices.get(&(successor.as_mut_ptr() as usize)) {
                successors[from].push(to);
            }
        }
    }
    Ok(successors)
}

fn graph_has_cycle(successors: &[Vec<usize>]) -> bool {
    if successors.is_empty() {
        return false;
    }

    let mut state = vec![0; successors.len()];
    state[0] = 1;
    let mut worklist = vec![(0, 0)];

    while let Some((block, next_successor)) = worklist.last_mut() {
        let Some(&successor) = successors[*block].get(*next_successor) else {
            state[*block] = 2;
            worklist.pop();
            continue;
        };
        *next_successor += 1;

        match state[successor] {
            0 => {
                state[successor] = 1;
                worklist.push((successor, 0));
            }
            1 => return true,
            _ => {}
        }
    }

    false
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inkwell::{
        OptimizationLevel,
        context::Context,
        memory_buffer::MemoryBuffer,
        targets::{CodeModel, InitializationConfig, RelocMode, Target, TargetMachine},
    };

    fn default_target_machine() -> TargetMachine {
        Target::initialize_all(&InitializationConfig::default());
        let triple = TargetMachine::get_default_triple();
        Target::from_triple(&triple)
            .unwrap()
            .create_target_machine(
                &triple,
                "generic",
                "",
                OptimizationLevel::None,
                RelocMode::Default,
                CodeModel::Default,
            )
            .unwrap()
    }

    #[test]
    fn unrolls_nested_static_loops() {
        let context = Context::create();
        let llvm = r#"
            declare void @sink(i64)

            define void @main() {
            entry:
              br label %outer.header

            outer.header:
              %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
              br label %inner.header

            inner.header:
              %j = phi i64 [ 0, %outer.header ], [ %j.next, %inner.header ]
              ; INNER_BODY
              %j.next = add nuw i64 %j, 1
              %inner.done = icmp eq i64 %j.next, %i
              br i1 %inner.done, label %outer.latch, label %inner.header

            outer.latch:
              %i.next = add nuw i64 %i, 1
              %outer.done = icmp eq i64 %i.next, 4
              br i1 %outer.done, label %exit, label %outer.header

            exit:
              ret void
            }
        "#;
        let inner_body = "call void @sink(i64 %i)\n".repeat(64);
        let mut llvm = llvm.replace("; INNER_BODY", &inner_body).into_bytes();
        llvm.push(0);
        let buffer = MemoryBuffer::create_from_memory_range_copy(&llvm, "nested_loops");
        let module = context.create_module_from_ir(buffer).unwrap();
        let target = default_target_machine();

        unroll_loops_to_fixpoint(&module, &target, 800).unwrap();
        assert!(!module_has_loops(&module).unwrap());
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

    #[test]
    fn cycle_check_handles_deep_control_flow_without_recursion() {
        const BLOCKS: usize = 100_000;
        let mut successors = (1..BLOCKS).map(|next| vec![next]).collect::<Vec<_>>();
        successors.push(Vec::new());

        assert!(!graph_has_cycle(&successors));
        successors[BLOCKS - 1].push(BLOCKS / 2);
        assert!(graph_has_cycle(&successors));
    }
}
