//! Build direct calls or finite conditional dispatch from proven callee facts.

use hugr::extension::simple_op::MakeRegisteredOp;
use hugr::hugr::hugrmut::HugrMut;
use hugr::ops::{Call, Case, Conditional, Const, Input, LoadConstant, Output, Value};
use hugr::std_extensions::arithmetic::{
    conversions::{self, ConvertOpDef},
    int_ops::{self, IntOpDef},
    int_types::{self, ConstInt},
};
use hugr::types::{Signature, SumType, TypeRow};
use hugr::{HugrView, IncomingPort, Node, PortIndex, Wire};
use hugr_core::hugr::internal::HugrMutInternals;
use tket::passes::dataflow::LoadedFunction;

use super::{
    DevirtualizeDirectCallsError,
    analysis::{Callees, Results},
};

type Target = LoadedFunction<Node>;

fn direct_call<H: HugrView<Node = Node>>(
    h: &H,
    target: &Target,
) -> Result<Call, DevirtualizeDirectCallsError> {
    let sig = match h.get_optype(target.func_node) {
        hugr::ops::OpType::FuncDefn(f) => f.signature().clone(),
        hugr::ops::OpType::FuncDecl(f) => f.signature().clone(),
        _ => {
            return Err(DevirtualizeDirectCallsError::MissingStaticOutput {
                function: target.func_node,
            });
        }
    };
    Ok(Call::try_new(sig, target.args.clone())?)
}

fn connect<H: HugrMut<Node = Node>>(h: &mut H, source: Wire, dest: Node, port: usize) {
    h.connect(source.node(), source.source(), dest, port);
}

fn emit_direct<H: HugrMut<Node = Node>>(
    h: &mut H,
    parent: Node,
    target: &Target,
    args: &[Wire],
) -> Result<Node, DevirtualizeDirectCallsError> {
    let op = direct_call(h, target)?;
    let fp = op.called_function_port();
    let f_out = h.get_optype(target.func_node).static_output_port().ok_or(
        DevirtualizeDirectCallsError::MissingStaticOutput {
            function: target.func_node,
        },
    )?;
    let call = h.add_node_with_parent(parent, op);
    for (i, arg) in args.iter().enumerate() {
        connect(h, *arg, call, i);
    }
    h.connect(target.func_node, f_out, call, fp);
    Ok(call)
}

fn case_nodes<H: HugrMut<Node = Node>>(
    h: &mut H,
    conditional: Node,
    inputs: TypeRow,
    outputs: TypeRow,
) -> (Node, Node, Node) {
    let case = h.add_node_with_parent(
        conditional,
        Case {
            signature: Signature::new(inputs.clone(), outputs.clone()),
        },
    );
    let input = h.add_node_with_parent(case, Input { types: inputs });
    let output = h.add_node_with_parent(case, Output { types: outputs });
    (case, input, output)
}

fn finish_case<H: HugrMut<Node = Node>>(
    h: &mut H,
    input: Node,
    call: Node,
    output: Node,
    n_outputs: usize,
) {
    for i in 0..n_outputs {
        connect(h, Wire::new(call, i), output, i);
    }
    h.add_other_edge(input, call);
    h.add_other_edge(call, output);
}

fn add_int_constant<H: HugrMut<Node = Node>>(h: &mut H, parent: Node, value: usize) -> Wire {
    let value: Value = ConstInt::new_u(6, value as u64).unwrap().into();
    let datatype = value.get_type();
    let cst = h.add_node_with_parent(parent, Const::new(value));
    let load = h.add_node_with_parent(parent, LoadConstant { datatype });
    h.connect(cst, 0, load, 0);
    Wire::new(load, 0)
}

fn emit_table<H: HugrMut<Node = Node>>(
    h: &mut H,
    parent: Node,
    index: Wire,
    targets: &[Target],
    slot: usize,
    args: &[Wire],
    sig: &Signature,
) -> Result<Node, DevirtualizeDirectCallsError> {
    if slot + 1 == targets.len() {
        return emit_direct(h, parent, &targets[slot], args);
    }
    let convert = h.add_node_with_parent(
        parent,
        ConvertOpDef::ifromusize
            .without_log_width()
            .to_extension_op()
            .unwrap(),
    );
    connect(h, index, convert, 0);
    let number = add_int_constant(h, parent, slot);
    let eq = h.add_node_with_parent(
        parent,
        IntOpDef::ieq.with_log_width(6).to_extension_op().unwrap(),
    );
    connect(h, Wire::new(convert, 0), eq, 0);
    connect(h, number, eq, 1);
    let mut other_inputs = vec![hugr::extension::prelude::usize_t()];
    other_inputs.extend(sig.input.iter().cloned());
    let cond = h.add_node_with_parent(
        parent,
        Conditional {
            sum_rows: vec![TypeRow::default(); 2],
            other_inputs: other_inputs.clone().into(),
            outputs: sig.output.clone(),
        },
    );
    connect(h, Wire::new(eq, 0), cond, 0);
    connect(h, index, cond, 1);
    for (i, arg) in args.iter().enumerate() {
        connect(h, *arg, cond, i + 2);
    }
    for branch in 0..2 {
        let (case, input, output) =
            case_nodes(h, cond, other_inputs.clone().into(), sig.output.clone());
        let args: Vec<_> = (0..args.len()).map(|i| Wire::new(input, i + 1)).collect();
        let call = if branch == 1 {
            emit_direct(h, case, &targets[slot], &args)?
        } else {
            emit_table(h, case, Wire::new(input, 0), targets, slot + 1, &args, sig)?
        };
        finish_case(h, input, call, output, sig.output.len());
    }
    Ok(cond)
}

fn redirect<H: HugrMut<Node = Node>>(h: &mut H, old: Node, new: Node, sig: &Signature) {
    let old_op = h.get_optype(old).clone();
    let new_op = h.get_optype(new).clone();
    for i in 0..sig.output.len() {
        for (dest, port) in h.linked_inputs(old, i).collect::<Vec<_>>() {
            h.disconnect(dest, port);
            h.connect(new, i, dest, port);
        }
    }
    if let (Some(old_port), Some(new_port)) = (old_op.other_input_port(), new_op.other_input_port())
    {
        let incoming = h.linked_outputs(old, old_port).collect::<Vec<_>>();
        h.disconnect(old, old_port);
        for (src, port) in incoming {
            h.connect(src, port, new, new_port);
        }
    }
    if let (Some(old_port), Some(new_port)) =
        (old_op.other_output_port(), new_op.other_output_port())
    {
        for (dest, port) in h.linked_inputs(old, old_port).collect::<Vec<_>>() {
            h.disconnect(dest, port);
            h.connect(new, new_port, dest, port);
        }
    }
    h.remove_node(old);
}

pub(super) fn rewrite<H: HugrMut<Node = Node> + HugrMutInternals<Node = Node>>(
    h: &mut H,
    call: Node,
    facts: &Results,
    callees: &Callees,
) -> Result<bool, DevirtualizeDirectCallsError> {
    let sig = h
        .get_optype(call)
        .as_call_indirect()
        .unwrap()
        .signature
        .clone();
    let Some(parent) = h.get_parent(call) else {
        return Ok(false);
    };
    let args: Vec<_> = (0..sig.input.len())
        .map(|i| {
            h.single_linked_output(call, IncomingPort::from(i + 1))
                .map(|(n, p)| Wire::new(n, p))
                .ok_or(DevirtualizeDirectCallsError::MissingArgument { call, index: i })
        })
        .collect::<Result<_, _>>()?;
    for target in &callees.targets {
        if direct_call(h, target)?.instantiation != sig {
            return Ok(false);
        }
    }
    if let [target] = callees.targets.as_slice() {
        let direct = direct_call(h, target)?;
        let function_port = direct.called_function_port();
        let function_output = h.get_optype(target.func_node).static_output_port().ok_or(
            DevirtualizeDirectCallsError::MissingStaticOutput {
                function: target.func_node,
            },
        )?;
        for i in 0..=args.len() {
            h.disconnect(call, IncomingPort::from(i));
        }
        // Call's static input occupies the old extra function-value input, so order ports stay in place.
        h.replace_op(call, direct);
        for (i, arg) in args.iter().enumerate() {
            connect(h, *arg, call, i);
        }
        h.connect(target.func_node, function_output, call, function_port);
        return Ok(true);
    }
    let new = if let Some(selection) = &callees.selection {
        if selection.targets.is_empty() || h.get_parent(selection.index.node()) != Some(parent) {
            return Ok(false);
        }
        // The checked array lookup remains in place and still rejects out-of-bounds indices.
        h.use_extension(conversions::EXTENSION.clone());
        h.use_extension(int_ops::EXTENSION.clone());
        h.use_extension(int_types::EXTENSION.clone());
        emit_table(
            h,
            parent,
            selection.index,
            &selection.targets,
            0,
            &args,
            &sig,
        )?
    } else {
        let (source, port) = h.single_linked_output(call, IncomingPort::from(0)).unwrap();
        let Some(cond) = h.get_optype(source).as_conditional().cloned() else {
            return Ok(false);
        };
        let Some((control_node, control_port)) =
            h.single_linked_output(source, IncomingPort::from(0))
        else {
            return Ok(false);
        };
        if h.get_parent(control_node) != Some(parent) {
            return Ok(false);
        }
        let selector_ty: hugr::types::Type = SumType::new(cond.sum_rows.clone()).into();
        // Reusing a linear sum would consume its payload twice.
        if !selector_ty.copyable() {
            return Ok(false);
        }
        let mut targets = Vec::new();
        for case in h.children(source) {
            let Some([_, output]) = h.get_io(case) else {
                return Ok(false);
            };
            let Some((n, p)) = h.single_linked_output(output, IncomingPort::from(port.index()))
            else {
                return Ok(false);
            };
            let Some(c) = facts.values.get(&Wire::new(n, p)) else {
                return Ok(false);
            };
            let [target] = c.targets.as_slice() else {
                return Ok(false);
            };
            targets.push(target.clone());
        }
        if targets.len() != cond.sum_rows.len() {
            return Ok(false);
        }
        let dispatch = h.add_node_with_parent(
            parent,
            Conditional {
                sum_rows: cond.sum_rows.clone(),
                other_inputs: sig.input.clone(),
                outputs: sig.output.clone(),
            },
        );
        h.connect(control_node, control_port, dispatch, 0);
        for (i, arg) in args.iter().enumerate() {
            connect(h, *arg, dispatch, i + 1);
        }
        for (row, target) in cond.sum_rows.iter().zip(targets) {
            let inputs = row.extend(sig.input.iter());
            let (case, input, output) = case_nodes(h, dispatch, inputs, sig.output.clone());
            let args: Vec<_> = (0..args.len())
                .map(|i| Wire::new(input, row.len() + i))
                .collect();
            let call = emit_direct(h, case, &target, &args)?;
            finish_case(h, input, call, output, sig.output.len());
        }
        dispatch
    };
    redirect(h, call, new, &sig);
    Ok(true)
}
