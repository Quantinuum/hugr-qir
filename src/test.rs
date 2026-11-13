use hugr::{
    Hugr,
    builder::{Dataflow, DataflowSubContainer, HugrBuilder, ModuleBuilder},
    core::Visibility,
    ops::{OpTrait, OpType},
    types::PolyFuncType,
};

use std::sync::Mutex;

/// Global mutex to serialize LLVM/inkwell usage in tests.
///
/// LLVM's IR parsing / printing and some transformations are not reliably safe
/// to run concurrently across threads in this environment, and can manifest as
/// flaky verifier errors, snapshot diffs, or SIGSEGV.
pub(crate) static LLVM_TEST_LOCK: Mutex<()> = Mutex::new(());

#[test]
fn final_cleanup_removes_dead_instructions_and_unused_declarations() {
    use crate::inkwell::{context::Context, memory_buffer::MemoryBuffer};
    use crate::{cli::CliOptimizationLevel, target::CompileTarget};

    let _guard = LLVM_TEST_LOCK.lock().unwrap();
    let context = Context::create();
    let ir = r#"
        declare double @llvm.fabs.f64(double)
        declare double @llvm.sqrt.f64(double)
        declare double @llvm.sin.f64(double)
        declare void @side_effect()
        declare void @referenced_by_global()
        @callback = global ptr @referenced_by_global

        define double @main(double %x) {
            %dead = call double @llvm.sin.f64(double %x)
            %dead_add = fadd double %dead, 1.0
            call void @side_effect()
            %result = call double @llvm.sqrt.f64(double %x)
            ret double %result
        }

        define void @unused_definition() {
            ret void
        }
    "#;
    let ir = std::ffi::CString::new(ir).unwrap();
    let module = context
        .create_module_from_ir(MemoryBuffer::create_from_memory_range_copy(
            ir.as_bytes_with_nul(),
            "final_cleanup",
        ))
        .unwrap();
    module.verify().unwrap();
    let target = CompileTarget::QuantinuumHardware;
    target.initialise();
    let machine = target.machine(CliOptimizationLevel::Default.into());

    crate::cleanup_module_llvm(&module, &machine).unwrap();

    module.verify().unwrap();
    assert!(module.get_function("llvm.fabs.f64").is_none());
    assert!(module.get_function("llvm.sin.f64").is_none());
    assert!(module.get_function("llvm.sqrt.f64").is_some());
    assert!(module.get_function("side_effect").is_some());
    assert!(module.get_function("referenced_by_global").is_some());
    assert!(module.get_function("unused_definition").is_some());
    assert_eq!(
        module
            .get_function("main")
            .unwrap()
            .get_first_basic_block()
            .unwrap()
            .get_instructions()
            .count(),
        3
    );
}

pub fn single_op_hugr(op: OpType) -> Hugr {
    let Some(sig) = op.dataflow_signature() else {
        panic!("not a dataflow op")
    };
    let sig = sig.into_owned();

    let mut module_builder = ModuleBuilder::new();
    {
        let mut func_builder = module_builder
            .define_function_vis("main", PolyFuncType::from(sig), Visibility::Public)
            .unwrap();
        let op = func_builder
            .add_dataflow_op(op, func_builder.input_wires())
            .unwrap();
        func_builder.finish_with_outputs(op.outputs()).unwrap()
    };
    module_builder.finish_hugr().unwrap()
}
