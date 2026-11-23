use hugr::{
    Hugr,
    builder::{Dataflow, DataflowSubContainer, HugrBuilder, ModuleBuilder},
    core::Visibility,
    ops::{OpTrait, OpType},
    types::PolyFuncType,
};

use anyhow::{Result, anyhow};
use std::sync::Mutex;

use crate::inkwell::{
    OptimizationLevel,
    context::Context,
    memory_buffer::MemoryBuffer,
    module::Module,
    targets::TargetMachine,
    values::{CallSiteValue, FunctionValue},
};
use crate::target::CompileTarget;

/// Global mutex to serialize LLVM/inkwell usage in tests.
///
/// LLVM's IR parsing / printing and some transformations are not reliably safe
/// to run concurrently across threads in this environment, and can manifest as
/// flaky verifier errors, snapshot diffs, or SIGSEGV.
pub(crate) static LLVM_TEST_LOCK: Mutex<()> = Mutex::new(());

/// Parse inline textual LLVM IR into a module owned by `context`.
pub(crate) fn load_module_from_ir<'c>(
    context: &'c Context,
    name: &str,
    ir: &str,
) -> Result<Module<'c>> {
    // Inkwell requires the buffer to be nul-terminated.
    let mut ir_bytes = ir.as_bytes().to_vec();
    if ir_bytes.last() != Some(&0) {
        ir_bytes.push(0);
    }
    let buffer = MemoryBuffer::create_from_memory_range_copy(&ir_bytes, name);
    context
        .create_module_from_ir(buffer)
        .map_err(|err| anyhow!("Failed to parse inline IR {name}: {}", err.to_string()))
}

/// Initialise and return a target machine for the host.
pub(crate) fn native_target_machine() -> TargetMachine {
    CompileTarget::Native.initialise();
    CompileTarget::Native.machine(OptimizationLevel::Default)
}

/// Count the call instructions in `function`.
pub(crate) fn count_calls(function: FunctionValue<'_>) -> usize {
    function
        .get_basic_blocks()
        .iter()
        .flat_map(|block| block.get_instructions())
        .filter(|inst| CallSiteValue::try_from(*inst).is_ok())
        .count()
}

#[test]
fn final_cleanup_removes_dead_instructions_globals_and_declarations() {
    use crate::cli::CliOptimizationLevel;

    let _guard = LLVM_TEST_LOCK.lock().unwrap();
    let context = Context::create();
    let ir = r#"
        declare double @llvm.fabs.f64(double)
        declare double @llvm.sqrt.f64(double)
        declare double @llvm.sin.f64(double)
        declare void @side_effect()
        declare void @referenced_by_global()
        declare void @referenced_only_by_dead_global()
        @callback = global ptr @referenced_by_global
        @dead_callback = private constant ptr @referenced_only_by_dead_global
        @dead_array = private constant [3 x i64] [i64 3, i64 5, i64 8]
        @exported_array = constant [3 x i64] [i64 3, i64 5, i64 8]

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
    let module = load_module_from_ir(&context, "final_cleanup", ir).unwrap();
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
    assert!(
        module
            .get_function("referenced_only_by_dead_global")
            .is_none()
    );
    assert!(module.get_global("dead_callback").is_none());
    assert!(module.get_global("dead_array").is_none());
    assert!(module.get_global("exported_array").is_some());
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
