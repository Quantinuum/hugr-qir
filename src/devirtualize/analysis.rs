//! Conservative callee propagation through HUGR dataflow and fixed-size arrays.

use std::collections::HashMap;

use hugr::extension::{ExtensionId, prelude::ConstUsize};
use hugr::hugr::{hugrmut::HugrMut, views::ExtractionResult};
use hugr::ops::{DataflowOpTrait, ExtensionOp, OpName, OpTrait, Value, constant::OpaqueValue};
use hugr::std_extensions::{
    arithmetic::int_types::ConstInt,
    collections::{array::ArrayValue, borrow_array::BArrayValue},
};
use hugr::{Extension, HugrView, IncomingPort, Node, NodeIndex, PortIndex, Wire};
use hugr_core::hugr::internal::HugrMutInternals;
use tket::passes::dataflow::{
    AbstractValue, AsConcrete, ConstLoader, ConstLocation, DFContext, LoadedFunction, Machine,
    PartialValue, partial_from_const,
};
use tket::passes::{PassScope, const_fold::value_handle::ValueHandle};

const MAX_ARRAY_SIZE: usize = 1024;
type PV = PartialValue<Fact, Node>;

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub(super) struct Selection {
    pub index: Wire,
    pub targets: Vec<LoadedFunction<Node>>,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub(super) struct Callees {
    pub targets: Vec<LoadedFunction<Node>>,
    pub selection: Option<Selection>,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
struct Slot {
    value: PV,
    available: Option<bool>,
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
enum Fact {
    Constant(ValueHandle<Node>),
    Array(Vec<Slot>),
    Functions(Callees),
}

fn join(a: PV, b: PV) -> PV {
    match (a, b) {
        (PartialValue::Bottom, v) | (v, PartialValue::Bottom) => v,
        (PartialValue::Value(a), PartialValue::Value(b)) => {
            a.try_join(b).map_or(PartialValue::Top, |(v, _)| v.into())
        }
        (PartialValue::PartialSum(mut a), PartialValue::PartialSum(b)) => {
            if a.try_join_mut(b).is_ok() {
                a.into()
            } else {
                PartialValue::Top
            }
        }
        (a, b) if a == b => a,
        _ => PartialValue::Top,
    }
}

impl AbstractValue for Fact {
    fn try_join(self, other: Self) -> Option<(Self, bool)> {
        let old = self.clone();
        let value = match (self, other) {
            (Self::Constant(a), Self::Constant(b)) if a == b => Self::Constant(a),
            (Self::Array(mut a), Self::Array(b)) if a.len() == b.len() => {
                for (a, b) in a.iter_mut().zip(b) {
                    a.value = join(a.value.clone(), b.value);
                    if a.available != b.available {
                        a.available = None;
                    }
                }
                Self::Array(a)
            }
            (Self::Functions(mut a), Self::Functions(b)) => {
                for target in b.targets {
                    if !a.targets.contains(&target) {
                        a.targets.push(target);
                    }
                }
                a.targets
                    .sort_by_key(|f| (f.func_node, format!("{:?}", f.args)));
                if a.selection != b.selection {
                    a.selection = None;
                }
                Self::Functions(a)
            }
            _ => return None,
        };
        let changed = value != old;
        Some((value, changed))
    }
}

fn scalar(v: &PV) -> Option<Value> {
    if let PartialValue::Value(Fact::Constant(c)) = v {
        Some(<Value as AsConcrete<ValueHandle<Node>, Node>>::from_value(c.clone()).unwrap())
    } else {
        None
    }
}

fn constant(v: &PV, typ: &hugr::types::Type) -> Option<Value> {
    if let Some(v) = scalar(v) {
        return Some(v);
    }
    let PartialValue::PartialSum(s) = v else {
        return None;
    };
    if s.0.len() != 1 {
        return None;
    }
    let (&tag, fields) = s.0.iter().next()?;
    let sum = typ.as_sum()?;
    let row = sum.get_variant(tag)?;
    let row = hugr::types::TypeRow::try_from(row.clone()).ok()?;
    if row.len() != fields.len() {
        return None;
    }
    let values: Option<Vec<_>> = fields
        .iter()
        .zip(row.iter())
        .map(|(v, t)| constant(v, t))
        .collect();
    Value::sum(tag, values?, sum.clone()).ok()
}

fn index(v: &PV) -> Option<usize> {
    let Value::Extension { e } = scalar(v)? else {
        return None;
    };
    let value = e.value();
    let n = value
        .downcast_ref::<ConstUsize>()
        .map(ConstUsize::value)
        .or_else(|| value.downcast_ref::<ConstInt>().map(ConstInt::value_u))?;
    usize::try_from(n).ok()
}

fn clear_selection(value: &mut PV) {
    match value {
        PartialValue::Value(Fact::Functions(callees)) => callees.selection = None,
        PartialValue::Value(Fact::Array(slots)) => {
            for slot in slots {
                clear_selection(&mut slot.value);
            }
        }
        PartialValue::PartialSum(sum) => {
            for fields in sum.0.values_mut() {
                for field in fields {
                    clear_selection(field);
                }
            }
        }
        _ => {}
    }
}

struct Context {
    fences: std::collections::HashSet<Node>,
    loads: HashMap<Node, LoadedFunction<Node>>,
    original_nodes: HashMap<Node, Node>,
    inputs: HashMap<Node, Vec<Wire>>,
}

impl ConstLoader<Fact> for Context {
    type Node = Node;
    fn value_from_opaque(&self, loc: ConstLocation<Node>, value: &OpaqueValue) -> Option<Fact> {
        let values = value
            .value()
            .downcast_ref::<ArrayValue>()
            .map(ArrayValue::get_contents)
            .or_else(|| {
                value
                    .value()
                    .downcast_ref::<BArrayValue>()
                    .map(BArrayValue::get_contents)
            });
        if let Some(values) = values {
            if values.len() > MAX_ARRAY_SIZE {
                return None;
            }
            return Some(Fact::Array(
                values
                    .iter()
                    .enumerate()
                    .map(|(i, v)| Slot {
                        value: partial_from_const(self, ConstLocation::Field(i, &loc), v),
                        available: Some(true),
                    })
                    .collect(),
            ));
        }
        Some(Fact::Constant(ValueHandle::new_opaque(loc, value.clone())))
    }
}

impl DFContext<Fact> for Context {
    fn interpret_leaf_op(&mut self, node: Node, op: &ExtensionOp, ins: &[PV], outs: &mut [PV]) {
        if self.fences.contains(&node) {
            outs[0] = ins[0].clone();
            clear_selection(&mut outs[0]);
            return;
        }
        if let Some(target) = self.loads.get(&node) {
            outs[0] = Fact::Functions(Callees {
                targets: vec![target.clone()],
                selection: None,
            })
            .into();
            return;
        }
        let ext: &str = op.extension_id().as_ref();
        let name = op.def().name().as_str();
        if ext == "prelude" && name == "panic" {
            // A panic produces no returning execution, even when its signature has outputs.
            outs.fill(PartialValue::Bottom);
            return;
        }
        let array_op = matches!(ext, "collections.array" | "collections.borrow_arr");
        if array_op && name == "new_array" && ins.len() <= MAX_ARRAY_SIZE {
            outs[0] = Fact::Array(
                ins.iter()
                    .cloned()
                    .map(|value| Slot {
                        value,
                        available: Some(true),
                    })
                    .collect(),
            )
            .into();
            return;
        }
        if array_op && name == "new_all_borrowed" {
            if let Some(hugr::types::TypeArg::BoundedNat(n)) = op.args().first()
                && let Ok(n) = usize::try_from(*n)
                && n <= MAX_ARRAY_SIZE
            {
                outs[0] = Fact::Array(vec![
                    Slot {
                        value: PartialValue::Top,
                        available: Some(false)
                    };
                    n
                ])
                .into();
            }
            return;
        }
        if let Some(PartialValue::Value(Fact::Array(slots))) = ins.first().filter(|_| array_op) {
            match name {
                "unpack" => {
                    for (out, slot) in outs.iter_mut().zip(slots) {
                        if slot.available == Some(true) {
                            *out = slot.value.clone();
                        }
                    }
                    return;
                }
                "clone" => {
                    outs.fill(ins[0].clone());
                    return;
                }
                "get" => {
                    outs[1] = ins[0].clone();
                    if let Some(i) = index(&ins[1]) {
                        outs[0] = match slots.get(i) {
                            Some(slot) if slot.available == Some(true) => {
                                PartialValue::new_variant(1, [slot.value.clone()])
                            }
                            None => PartialValue::new_variant(0, []),
                            _ => PartialValue::Top,
                        };
                    } else {
                        let mut element = PartialValue::Bottom;
                        for slot in slots {
                            element = join(
                                element,
                                if slot.available == Some(true) {
                                    slot.value.clone()
                                } else {
                                    PartialValue::Top
                                },
                            );
                        }
                        if let PartialValue::Value(Fact::Functions(ref mut callees)) = element {
                            let targets: Option<Vec<_>> = slots
                                .iter()
                                .map(|s| match &s.value {
                                    PartialValue::Value(Fact::Functions(c))
                                        if c.targets.len() == 1 && s.available == Some(true) =>
                                    {
                                        Some(c.targets[0].clone())
                                    }
                                    _ => None,
                                })
                                .collect();
                            if let Some(targets) = targets {
                                callees.selection = Some(Selection {
                                    index: self.inputs[&node][1],
                                    targets,
                                });
                            }
                        }
                        // An unknown index may be out of bounds. Preserve the None branch.
                        let mut variants = std::collections::BTreeMap::new();
                        variants.insert(0, vec![]);
                        variants.insert(1, vec![element]);
                        outs[0] = tket::passes::dataflow::PartialSum(variants).into();
                    }
                    return;
                }
                "borrow" => {
                    if let Some(i) = index(&ins[1])
                        && let Some(slot) = slots.get(i)
                        && slot.available == Some(true)
                    {
                        let mut slots = slots.clone();
                        outs[1] = slot.value.clone();
                        slots[i].available = Some(false);
                        outs[0] = Fact::Array(slots).into();
                    }
                    return;
                }
                "return" => {
                    if let Some(i) = index(&ins[1])
                        && i < slots.len()
                    {
                        let mut slots = slots.clone();
                        slots[i] = Slot {
                            value: ins[2].clone(),
                            available: Some(true),
                        };
                        outs[0] = Fact::Array(slots).into();
                    }
                    return;
                }
                "is_borrowed" => {
                    outs[0] = ins[0].clone();
                    if let Some(i) = index(&ins[1])
                        && let Some(slot) = slots.get(i)
                        && let Some(available) = slot.available
                    {
                        outs[1] = PartialValue::new_variant(usize::from(!available), []);
                    }
                    return;
                }
                "set" => {
                    if let Some(i) = index(&ins[1]) {
                        let mut changed = slots.clone();
                        let (tag, old) = if let Some(slot) = changed.get_mut(i) {
                            let old = slot.value.clone();
                            *slot = Slot {
                                value: ins[2].clone(),
                                available: Some(true),
                            };
                            (1, old)
                        } else {
                            (0, ins[2].clone())
                        };
                        outs[0] =
                            PartialValue::new_variant(tag, [old, Fact::Array(changed).into()]);
                    }
                    return;
                }
                _ => {}
            }
        }
        // Delegate scalar arithmetic, comparisons, and conversions to extension folders.
        let known: Vec<_> = ins
            .iter()
            .zip(op.signature().input.iter())
            .enumerate()
            .filter_map(|(i, (v, t))| constant(v, t).map(|v| (IncomingPort::from(i), v)))
            .collect();
        for (port, value) in op.constant_fold(&known).unwrap_or_default() {
            outs[port.index()] = partial_from_const(
                self,
                ConstLocation::Field(port.index(), &self.original_nodes[&node].into()),
                &value,
            );
        }
    }
}

pub(super) struct Results {
    pub values: HashMap<Wire, Callees>,
}

pub(super) fn analyze<H: HugrView<Node = Node>>(
    hugr: &H,
    root: Node,
    scope: &PassScope,
) -> Results {
    let (mut graph, map) = hugr.extract_hugr(hugr.module_root());
    let original_nodes: HashMap<_, _> = hugr.nodes().map(|n| (map.extracted_node(n), n)).collect();
    let mut context = Context {
        fences: Default::default(),
        loads: HashMap::new(),
        original_nodes,
        inputs: HashMap::new(),
    };
    let loads: Vec<_> = hugr
        .nodes()
        .filter_map(|n| {
            let load = hugr.get_optype(n).as_load_function()?;
            Some((
                n,
                load.clone(),
                hugr.static_source(n)?,
                hugr.get_optype(n).dataflow_signature()?.into_owned(),
            ))
        })
        .collect();
    // Loop inputs may carry values selected in an earlier iteration. Their target
    // sets remain useful, but their old selector wires cannot select a current call.
    let fences: Vec<_> = hugr
        .nodes()
        .filter(|&n| {
            hugr.get_optype(n).is_input()
                && hugr.get_parent(n).is_some_and(|parent| {
                    matches!(
                        hugr.get_optype(parent),
                        hugr::ops::OpType::TailLoop(_) | hugr::ops::OpType::DataflowBlock(_)
                    )
                })
        })
        .flat_map(|n| hugr.out_value_types(n).map(move |(p, t)| (n, p, t)))
        .collect();
    // The framework's built-in function lattice retains only singleton targets.
    // In the analysis copy, model loads as leaf ops so the domain can retain finite sets.
    let extension = Extension::new_arc(
        ExtensionId::new_unchecked("hq.callees"),
        hugr::extension::prelude::VERSION,
        |extension, extension_ref| {
            for (n, p, typ) in &fences {
                extension
                    .add_op(
                        OpName::from(format!("fence_{}_{}", n.index(), p.index())),
                        "Loop input for callee analysis".into(),
                        hugr::types::Signature::new_endo([typ.clone()]),
                        extension_ref,
                    )
                    .unwrap();
            }
            for (n, _, _, sig) in &loads {
                extension
                    .add_op(
                        OpName::from(format!("load_{}", n.index())),
                        "Function identity for callee analysis".into(),
                        sig.clone(),
                        extension_ref,
                    )
                    .unwrap();
            }
        },
    );
    for (n, load, function, _) in &loads {
        let new = map.extracted_node(*n);
        graph.disconnect(new, load.function_port());
        let def = extension
            .get_op(&format!("load_{}", n.index()))
            .unwrap()
            .clone();
        graph.replace_op(new, ExtensionOp::new(def, vec![]).unwrap());
        let op = graph.get_optype(new);
        graph.set_num_ports(new, op.input_count(), op.output_count());
        context.loads.insert(
            new,
            LoadedFunction {
                func_node: *function,
                args: load.type_args.clone(),
            },
        );
    }
    for n in hugr.nodes() {
        let ins = hugr
            .in_value_types(n)
            .filter_map(|(p, _)| {
                hugr.single_linked_output(n, p)
                    .map(|(n, p)| Wire::new(n, p))
            })
            .collect();
        context.inputs.insert(map.extracted_node(n), ins);
    }
    let mut fenced_wires = HashMap::new();
    for (n, p, _) in fences {
        let input = map.extracted_node(n);
        let def = extension
            .get_op(&format!("fence_{}_{}", n.index(), p.index()))
            .unwrap()
            .clone();
        let consumers: Vec<_> = graph.linked_inputs(input, p).collect();
        let fence = graph.add_node_with_parent(
            graph.get_parent(input).unwrap(),
            ExtensionOp::new(def, vec![]).unwrap(),
        );
        for (consumer, port) in consumers {
            graph.disconnect(consumer, port);
            graph.connect(fence, 0, consumer, port);
        }
        graph.connect(input, p, fence, 0);
        context.fences.insert(fence);
        fenced_wires.insert(Wire::new(n, p), Wire::new(fence, 0));
    }
    let mut machine = Machine::new(&graph);
    for n in scope
        .preserve_interface(hugr)
        .chain(loads.iter().map(|(_, _, f, _)| *f))
    {
        let n = map.extracted_node(n);
        if n != graph.module_root() && graph.children(n).next().is_some() {
            let _ = machine.prepopulate_inputs(n, std::iter::empty::<(IncomingPort, PV)>());
        }
    }
    let results = machine.run_subtree(context, map.extracted_node(root));
    let mut values = HashMap::new();
    for n in hugr.descendants(root) {
        for (p, _) in hugr.out_value_types(n) {
            if let Some(PartialValue::Value(Fact::Functions(c))) = results.read_out_wire(
                *fenced_wires
                    .get(&Wire::new(n, p))
                    .unwrap_or(&Wire::new(map.extracted_node(n), p)),
            ) {
                values.insert(Wire::new(n, p), c);
            }
        }
    }
    Results { values }
}
