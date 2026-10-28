//! Validate output tags and execution paths before output calls are moved.

use std::collections::{HashMap, HashSet};

use anyhow::Result;

use crate::compilation_error::CompilationError;
use crate::inkwell::{
    module::Module,
    values::{BasicValueEnum, CallSiteValue, Operand},
};
use crate::llvm_unroll::ensure_no_loops;

pub(crate) struct ProgramOperations {
    has_output: bool,
    has_measurement: bool,
}

impl ProgramOperations {
    /// Require recorded values and a quantum measurement in the optimized program.
    pub fn validate_required(self) -> Result<()> {
        if !self.has_output {
            return Err(CompilationError::new(
                "Program records no output values. Add an output call with a scalar or a nonempty array.",
            )
            .into());
        }
        if !self.has_measurement {
            return Err(CompilationError::new(
                "Program has no quantum measurements. Add a quantum measurement; programs containing only classical computations are unsupported.",
            )
            .into());
        }
        Ok(())
    }
}

/// Decode one compiler-added suffix, retaining an array element's index.
fn output_tag(tag: &str) -> (&str, Option<u64>) {
    let Some((name, suffix)) = tag.rsplit_once("___") else {
        return (tag, None);
    };
    if matches!(suffix, "BOOL" | "INT" | "UINT" | "FLOAT") {
        return (name, None);
    }
    let Some((array_type, index)) = suffix.rsplit_once('_') else {
        return (tag, None);
    };
    if !matches!(array_type, "ARRBOOL" | "ARRINT" | "ARRUINT" | "ARRFLOAT") {
        return (tag, None);
    }
    if !index.is_empty()
        && index.bytes().all(|byte| byte.is_ascii_digit())
        && let Ok(index) = index.parse()
    {
        return (name, Some(index));
    }
    (tag, None)
}

/// Require a single call site per scalar output or array element, executed on
/// every returning path. A user tag cannot be shared by scalar and array outputs.
/// Reject reachable loops. This must run before output-call sinking.
pub(crate) fn validate_outputs(
    module: &Module,
    max_loop_unroll: usize,
) -> Result<ProgramOperations> {
    let graphs = ensure_no_loops(module, max_loop_unroll)?;
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

    let mut has_output = false;
    let mut has_measurement = false;
    for graph in graphs {
        let required = graph.required_on_return_paths();
        let mut tags = HashMap::<&str, HashSet<Option<u64>>>::new();
        for (i, block) in graph.blocks.iter().enumerate() {
            if !graph.reachable[i] {
                continue;
            }
            for inst in block.get_instructions() {
                let Ok(call) = CallSiteValue::try_from(inst) else {
                    continue;
                };
                let Some(callee) = call.get_called_fn_value() else {
                    continue;
                };
                let name = callee.get_name().to_bytes();
                has_measurement |= name == b"__quantum__qis__mz__body";
                if !name.starts_with(b"__quantum__rt__") || !name.ends_with(b"_record_output") {
                    continue;
                }
                has_output = true;
                let tag = match inst.get_operand(1) {
                    Some(Operand::Value(BasicValueEnum::PointerValue(ptr))) => strings.get(&ptr),
                    _ => None,
                }
                .ok_or_else(|| {
                    CompilationError::new("Detected a conditionally selected output tag. Each tag must be output exactly once on every run. Move the output outside conditional branches and loops.")
                })?;
                let (user_tag, array_index) = output_tag(tag);
                let indices = tags.entry(user_tag).or_default();
                let duplicate = indices.contains(&None)
                    || (array_index.is_none() && !indices.is_empty())
                    || !indices.insert(array_index);
                if duplicate {
                    return Err(CompilationError::new(format!("Detected duplicate output tag {user_tag:?} after optimization. Every output tag must have a single call site. Move output calls outside of loops")).into());
                }
                if !required[i] {
                    return Err(CompilationError::new(format!("Detected conditional output tag {user_tag:?}. Each tag must be output exactly once on every run. Move the output outside conditional branches and loops.")).into());
                }
            }
        }
    }
    Ok(ProgramOperations {
        has_output,
        has_measurement,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inkwell::{context::Context, memory_buffer::MemoryBuffer};

    #[test]
    fn output_tags_decode_only_the_compiler_suffix() {
        for (label, name, index) in [
            ("out___BOOL", "out", None),
            ("out___INT", "out", None),
            ("out___UINT", "out", None),
            ("out___FLOAT", "out", None),
            ("out___ARRBOOL_0", "out", Some(0)),
            ("out___ARRINT_12", "out", Some(12)),
            ("out___ARRUINT_3", "out", Some(3)),
            ("out___ARRFLOAT_4", "out", Some(4)),
            ("out___INT___BOOL", "out___INT", None),
            ("out___ARRINT_0___INT", "out___ARRINT_0", None),
            ("out___UNKNOWN", "out___UNKNOWN", None),
            ("out___ARRINT_x", "out___ARRINT_x", None),
            ("out___ARRINT_", "out___ARRINT_", None),
            ("out___ARRINT_+1", "out___ARRINT_+1", None),
        ] {
            assert_eq!(output_tag(label), (name, index), "{label}");
        }
    }

    fn validate(body: &str) -> Result<()> {
        let body = body.replacen(
            "entry:",
            "entry: call void @__quantum__qis__mz__body(ptr null, ptr null)",
            1,
        );
        validate_ir(&body)
    }

    fn validate_ir(body: &str) -> Result<()> {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let ir = format!(
            r#"
            @tag = private constant [4 x i8] c"out\00"
            @int_tag = private constant [10 x i8] c"out___INT\00"
            @bool_tag = private constant [11 x i8] c"out___BOOL\00"
            @element0 = private constant [15 x i8] c"out___ARRINT_0\00"
            @element1 = private constant [15 x i8] c"out___ARRINT_1\00"
            @bool_element0 = private constant [16 x i8] c"out___ARRBOOL_0\00"
            declare void @__quantum__rt__int_record_output(i64, ptr)
            declare void @__quantum__rt__bool_record_output(i1, ptr)
            declare void @__quantum__qis__mz__body(ptr, ptr)
            define void @main(i1 %condition) {{ {body} }}
        "#
        );
        let module = context
            .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
                format!("{ir}\0").as_bytes(),
                "outputs",
            ))
            .unwrap();
        module.verify().unwrap();
        validate_outputs(&module, crate::DEFAULT_MAX_LOOP_UNROLL)?.validate_required()
    }

    #[test]
    fn duplicate_tags_ignore_type_suffixes() {
        let error = validate(
            "entry:
             call void @__quantum__rt__int_record_output(i64 1, ptr @int_tag)
             call void @__quantum__rt__bool_record_output(i1 false, ptr @bool_tag)
             ret void",
        )
        .unwrap_err();
        assert!(
            error
                .to_string()
                .contains("Detected duplicate output tag \"out\"")
        );
    }

    #[test]
    fn distinct_array_elements_are_allowed() {
        validate(
            "entry:
             call void @__quantum__rt__int_record_output(i64 1, ptr @element0)
             call void @__quantum__rt__int_record_output(i64 2, ptr @element1)
             ret void",
        )
        .unwrap();
    }

    #[test]
    fn duplicate_array_elements_ignore_type_suffixes() {
        let error = validate(
            "entry:
             call void @__quantum__rt__int_record_output(i64 1, ptr @element0)
             call void @__quantum__rt__bool_record_output(i1 false, ptr @bool_element0)
             ret void",
        )
        .unwrap_err();
        assert!(
            error
                .to_string()
                .contains("Detected duplicate output tag \"out\"")
        );
    }

    #[test]
    fn scalar_and_array_cannot_share_a_tag() {
        for labels in [["int_tag", "element0"], ["element0", "int_tag"]] {
            let error = validate(&format!(
                "entry:
                 call void @__quantum__rt__int_record_output(i64 1, ptr @{})
                 call void @__quantum__rt__int_record_output(i64 2, ptr @{})
                 ret void",
                labels[0], labels[1]
            ))
            .unwrap_err();
            assert!(
                error
                    .to_string()
                    .contains("Detected duplicate output tag \"out\"")
            );
        }
    }

    #[test]
    fn output_after_merge_is_unconditional() {
        validate(
            "entry: br i1 %condition, label %left, label %right
            left: br label %merge
            right: br label %merge
            merge: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            ret void",
        )
        .unwrap();
    }

    #[test]
    fn conditional_output_is_rejected() {
        let error = validate(
            "entry: br i1 %condition, label %left, label %exit
            left: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            br label %exit
            exit: ret void",
        )
        .unwrap_err();
        assert!(error.downcast_ref::<CompilationError>().is_some());
        assert!(
            error
                .to_string()
                .contains("Detected conditional output tag \"out\"")
        );
    }

    #[test]
    fn conditionally_selected_output_tag_is_rejected() {
        let error = validate(
            "entry:
             %tag = select i1 %condition, ptr @int_tag, ptr @tag
             call void @__quantum__rt__int_record_output(i64 1, ptr %tag)
             ret void",
        )
        .unwrap_err();
        assert_eq!(
            error.to_string(),
            "Detected a conditionally selected output tag. Each tag must be output exactly once on every run. Move the output outside conditional branches and loops."
        );
    }

    #[test]
    fn early_return_skips_output() {
        assert!(
            validate(
                "entry: br i1 %condition, label %left, label %right
            left: ret void
            right: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            ret void"
            )
            .is_err()
        );
    }

    #[test]
    fn output_before_multiple_returns_is_allowed() {
        validate(
            "entry: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            br i1 %condition, label %left, label %right
            left: ret void
            right: ret void",
        )
        .unwrap();
    }

    #[test]
    fn duplicated_output_is_rejected() {
        let error = validate(
            "entry:
            call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            call void @__quantum__rt__int_record_output(i64 2, ptr @tag)
            ret void",
        )
        .unwrap_err();
        assert!(error.to_string().contains("Detected duplicate output tag"));
    }

    #[test]
    fn dead_outputs_do_not_satisfy_output_requirement() {
        let error = validate(
            "entry: ret void
            dead: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            ret void",
        )
        .unwrap_err();
        assert!(
            error
                .to_string()
                .contains("Program records no output values")
        );
    }

    #[test]
    fn measurement_without_recording_is_rejected() {
        let error = validate("entry: ret void").unwrap_err();
        assert!(
            error
                .to_string()
                .contains("Program records no output values")
        );
    }

    #[test]
    fn measurement_declaration_or_dead_call_is_insufficient() {
        for dead in [
            "",
            "dead: call void @__quantum__qis__mz__body(ptr null, ptr null) ret void",
        ] {
            let error = validate_ir(&format!(
                "entry: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
                 ret void
                 {dead}"
            ))
            .unwrap_err();
            assert!(
                error
                    .to_string()
                    .contains("Program has no quantum measurements")
            );
        }
    }

    #[test]
    fn duplicate_edges_are_allowed() {
        validate(
            "entry: br i1 %condition, label %exit, label %exit
            exit: call void @__quantum__rt__int_record_output(i64 1, ptr @tag)
            ret void",
        )
        .unwrap();
    }
}
