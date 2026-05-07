use hugr::{
    Hugr,
    builder::{Dataflow, DataflowSubContainer, HugrBuilder, ModuleBuilder},
    core::Visibility,
    ops::{OpTrait, OpType},
    types::PolyFuncType,
};

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
