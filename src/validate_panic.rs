//! Reject reachable runtime panics after LLVM optimization and inlining.

use std::collections::{HashMap, HashSet};

use anyhow::Result;

use crate::compilation_error::CompilationError;

use crate::inkwell::module::Module;
use crate::inkwell::values::{BasicValueEnum, CallSiteValue, Operand};

/// Reject abort calls, reporting whether all control-flow paths lead to a panic.
/// Messages are recovered from the HUGR runtime's preceding printf call. When
/// optimization removed the message, report that explicitly rather than guessing.
pub fn validate_no_panic(module: &Module) -> Result<()> {
    let strings = module
        .get_globals()
        .filter_map(|global| {
            let BasicValueEnum::ArrayValue(value) = global.get_initializer()? else {
                return None;
            };
            let bytes = value.as_const_string()?;
            let bytes = bytes.strip_suffix(&[0]).unwrap_or(bytes);
            Some((
                global.as_pointer_value(),
                String::from_utf8_lossy(bytes).into_owned(),
            ))
        })
        .collect::<HashMap<_, _>>();

    for function in module.get_functions() {
        let Some(entry) = function.get_first_basic_block() else {
            continue;
        };
        let mut reachable = HashSet::new();
        let mut pending = vec![entry];
        let mut successors = HashMap::new();
        let mut panics = HashMap::new();
        while let Some(block) = pending.pop() {
            if !reachable.insert(block) {
                continue;
            }
            let mut message = None;
            for inst in block.get_instructions() {
                let Ok(call) = CallSiteValue::try_from(inst) else {
                    continue;
                };
                let Some(callee) = call.get_called_fn_value() else {
                    continue;
                };
                match callee.get_name().to_bytes() {
                    b"printf" => {
                        // The HUGR emitter calls printf(template, signal, message).
                        message = match inst.get_operand(2) {
                            Some(Operand::Value(BasicValueEnum::PointerValue(ptr))) => {
                                strings.get(&ptr).cloned()
                            }
                            _ => None,
                        };
                    }
                    b"abort" => {
                        panics.insert(
                            block,
                            message.unwrap_or_else(|| "panic message unavailable".to_owned()),
                        );
                        break;
                    }
                    _ => {}
                }
            }
            let next = if panics.contains_key(&block) {
                vec![]
            } else {
                block
                    .get_terminator()
                    .into_iter()
                    .flat_map(|term| {
                        (0..term.get_num_operands()).filter_map(move |i| {
                            match term.get_operand(i) {
                                Some(Operand::Block(block)) => Some(block),
                                _ => None,
                            }
                        })
                    })
                    .collect::<Vec<_>>()
            };
            pending.extend(next.iter().copied());
            successors.insert(block, next);
        }
        if panics.is_empty() {
            continue;
        }

        // Propagate backwards once all outgoing edges lead to known panic blocks.
        // Count duplicate edges in both maps (e.g. both branch arms have the same
        // target). Each block is queued once and each edge is visited once, making
        // this analysis O(blocks + edges). Return paths and cycles remain unproven.
        let mut predecessors = HashMap::<_, Vec<_>>::new();
        let mut remaining = HashMap::new();
        for (block, next) in successors {
            remaining.insert(block, next.len());
            for successor in next {
                predecessors.entry(successor).or_default().push(block);
            }
        }
        let mut must_panic = panics.keys().copied().collect::<HashSet<_>>();
        let mut worklist = must_panic.iter().copied().collect::<Vec<_>>();
        while let Some(block) = worklist.pop() {
            for predecessor in predecessors.get(&block).into_iter().flatten() {
                let count = remaining.get_mut(predecessor).unwrap();
                *count -= 1;
                if *count == 0 && must_panic.insert(*predecessor) {
                    worklist.push(*predecessor);
                }
            }
        }
        let mut messages = panics.into_values().collect::<Vec<_>>();
        messages.sort();
        messages.dedup();
        let message = messages.join("; ");
        if must_panic.contains(&entry) {
            return Err(CompilationError::new(format!("Program always panics: {message}")).into());
        }
        return Err(CompilationError::new(format!(
            "Program may panic: {message}. Runtime panics are unsupported on H-Series."
        ))
        .into());
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inkwell::{context::Context, memory_buffer::MemoryBuffer};

    fn validate(body: &str) -> Result<()> {
        let context = Context::create();
        let ir = format!(
            r#"
            @message = constant [12 x i8] c"bad integer\00"
            @other = constant [13 x i8] c"bad indexing\00"
            declare i32 @printf(ptr, ...)
            declare void @abort()
            define void @main(i1 %condition) {{
            {body}
            }}
            "#
        );
        let module = context
            .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                format!("{ir}\0").as_bytes(),
                "test",
            ))
            .unwrap();
        module.verify().unwrap();
        validate_no_panic(&module)
    }

    #[test]
    fn all_branches_panic_with_distinct_messages() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let error = validate(
            "entry:
                br i1 %condition, label %left, label %right
             left:
                call i32 (ptr, ...) @printf(ptr null, i32 1, ptr @message)
                call void @abort()
                unreachable
             right:
                call i32 (ptr, ...) @printf(ptr null, i32 1, ptr @other)
                call void @abort()
                unreachable",
        )
        .unwrap_err();
        assert_eq!(
            error.to_string(),
            "Program always panics: bad indexing; bad integer"
        );
    }

    #[test]
    fn unreachable_abort_and_unused_declaration_are_allowed() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        validate("entry: ret void").unwrap();
        validate("entry: ret void\ndead: call void @abort()\nunreachable").unwrap();
    }

    #[test]
    fn missing_message_is_reported() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let error = validate("entry: call void @abort()\nunreachable").unwrap_err();
        assert_eq!(
            error.to_string(),
            "Program always panics: panic message unavailable"
        );
    }

    #[test]
    fn duplicate_edges_to_panic_are_counted_consistently() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let error = validate(
            "entry: br i1 %condition, label %panic, label %panic
             panic:
                call i32 (ptr, ...) @printf(ptr null, i32 1, ptr @message)
                call void @abort()
                unreachable",
        )
        .unwrap_err();
        assert_eq!(error.to_string(), "Program always panics: bad integer");
    }

    #[test]
    fn propagates_through_a_long_chain() {
        use std::fmt::Write;

        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let mut body = String::from("entry: br label %block0\n");
        for i in 0..1000 {
            writeln!(body, "block{i}: br label %block{}", i + 1).unwrap();
        }
        body.push_str("block1000: call void @abort()\nunreachable");
        let error = validate(&body).unwrap_err();
        assert_eq!(
            error.to_string(),
            "Program always panics: panic message unavailable"
        );
    }

    #[test]
    fn loop_does_not_imply_unconditional_panic() {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let error = validate(
            "entry: br label %loop
             loop: br i1 %condition, label %loop, label %panic
             panic:
                call i32 (ptr, ...) @printf(ptr null, i32 1, ptr @message)
                call void @abort()
                unreachable",
        )
        .unwrap_err();
        assert_eq!(
            error.to_string(),
            "Program may panic: bad integer. Runtime panics are unsupported on H-Series."
        );
    }
}
