//! Utilities for squashing any ssa variables to QUBIT pointers.
//!
//! For OG systems, these cannot be used as input to qis functions,
//! because dynamic addressing of qubits is not allowed

use anyhow::{Result, anyhow, bail};
use inkwell::basic_block::BasicBlock;
use inkwell::builder::Builder;
use inkwell::module::Module;
use inkwell::passes::PassManager;
use inkwell::types::{AnyTypeEnum, BasicTypeEnum, PointerType};
use inkwell::values::{AnyValue, InstructionOpcode as Op};
use inkwell::values::{
    AnyValueEnum, AsValueRef, BasicValue, BasicValueEnum, CallSiteValue, InstructionOpcode,
    InstructionValue, Operand, PhiValue, ValueKind,
};
use std::collections::{HashMap, HashSet};

type ValueKey = usize;

fn value_key_from_instruction(inst: InstructionValue) -> ValueKey {
    inst.as_value_ref() as ValueKey
}

fn value_key_from_basic_value(value: BasicValueEnum) -> Option<ValueKey> {
    value.as_instruction_value().map(value_key_from_instruction)
}

fn any_value_as_instruction(value: AnyValueEnum) -> Option<InstructionValue> {
    match value {
        AnyValueEnum::InstructionValue(inst) => Some(inst),
        AnyValueEnum::PhiValue(phi) => Some(phi.as_instruction()),
        AnyValueEnum::IntValue(v) => v.as_instruction(),
        AnyValueEnum::PointerValue(v) => v.as_instruction(),
        AnyValueEnum::FloatValue(v) => v.as_instruction(),
        AnyValueEnum::StructValue(v) => v.as_instruction(),
        AnyValueEnum::ArrayValue(v) => v.as_instruction(),
        AnyValueEnum::VectorValue(v) => v.as_instruction(),
        AnyValueEnum::ScalableVectorValue(v) => v.as_instruction(),
        AnyValueEnum::FunctionValue(_) => None,
        AnyValueEnum::MetadataValue(_) => None,
    }
}

fn instruction_user(value: AnyValueEnum) -> Result<InstructionValue> {
    any_value_as_instruction(value).ok_or_else(|| anyhow!("Unsupported non-instruction value user"))
}

fn collect_instruction_users(value: BasicValueEnum) -> Result<Vec<InstructionValue>> {
    let mut users = Vec::new();
    let mut use_opt = value.get_first_use();
    while let Some(u) = use_opt {
        users.push(instruction_user(u.get_user())?);
        use_opt = u.get_next_use();
    }
    Ok(users)
}

fn collect_external_instruction_users<'ctx>(
    value: BasicValueEnum<'ctx>,
    original_block: BasicBlock<'ctx>,
) -> Result<Vec<InstructionValue<'ctx>>> {
    let mut external_users = Vec::new();
    let mut seen_users: HashSet<ValueKey> = HashSet::new();
    for user_inst in collect_instruction_users(value)? {
        if user_inst.get_parent() != Some(original_block) {
            let user_key = value_key_from_instruction(user_inst);
            if seen_users.insert(user_key) {
                external_users.push(user_inst);
            }
        }
    }
    Ok(external_users)
}

fn incoming_map(phi: PhiValue) -> HashMap<BasicBlock, BasicValueEnum> {
    phi.get_incomings()
        .map(|(val, pred_bb)| (pred_bb, val))
        .collect()
}

fn verify_module(module: &Module) -> Result<()> {
    module
        .verify()
        .map_err(|err| anyhow!("Error verifying module: {}", err.to_string()))
}

/// Lowers select and phi instructions returning QUBIT* to control flow.
/// These can be introduced through llvm optimizations to reduce branching.
/// Lowers select instructions to branching + possible additional phi's,
/// then lowers any remaining phis
pub fn lower_qubit_selects_and_phis(module: &Module) -> Result<bool> {
    if !module_has_lowerable_qubit_selects_or_phis(module) {
        return Ok(false);
    }
    prepare_module(module)?;
    let lowered_selects = lower_qubit_selects(module)?;
    let lowered_phis = lower_qubit_phis(module)?;
    let changed = lowered_selects || lowered_phis;
    if changed {
        simp_cfg(module);
    }
    verify_module(module)?;
    Ok(changed)
}

fn module_has_lowerable_qubit_selects_or_phis(module: &Module) -> bool {
    module.get_functions().any(|function| {
        function.get_basic_blocks().iter().any(|block| {
            block
                .get_instructions()
                .any(is_lowerable_qubit_select_or_phi_instruction)
        })
    })
}

fn is_lowerable_qubit_select_or_phi_instruction(inst: InstructionValue) -> bool {
    matches!(
        inst.get_opcode(),
        InstructionOpcode::Select | InstructionOpcode::Phi
    ) && matches!(inst.get_type(), AnyTypeEnum::PointerType(ptr_ty) if is_qubit_pointer(ptr_ty))
}

fn rebuild_terminator_into<'ctx>(
    builder: &Builder<'ctx>,
    term: InstructionValue<'ctx>,
) -> Result<()> {
    match term.get_opcode() {
        InstructionOpcode::Br => {
            let is_cond = term.is_conditional();
            if is_cond {
                let cond = expect_inst_operand_value(term, 0).into_int_value();

                let then_bb = operand_as_bb(term, 1).unwrap();
                let else_bb = operand_as_bb(term, 2).unwrap();

                builder.build_conditional_branch(cond, else_bb, then_bb)?;
            } else {
                let dest = inst_operand_block(term, 0).unwrap();
                builder.build_unconditional_branch(dest)?;
            }
            Ok(())
        }

        InstructionOpcode::Return => {
            let ret_val = inst_operand_value(term, 0);
            let ret_arg: Option<&dyn BasicValue<'ctx>> =
                ret_val.as_ref().map(|v| v as &dyn BasicValue<'ctx>);

            builder.build_return(ret_arg)?;
            Ok(())
        }

        _ => bail!("terminator kind not supported yet"),
    }
}

pub fn move_matching_calls_to_fresh_block<'ctx>(
    bb: BasicBlock<'ctx>,
    target_fn_name: &str,
) -> Result<Option<BasicBlock<'ctx>>> {
    let function = bb.get_parent().unwrap();
    let context = bb.get_context();
    let builder = context.create_builder();

    // ------------------------------------------------------------
    // 1) Collect matching direct calls
    // ------------------------------------------------------------
    let mut calls_to_rebuild: Vec<InstructionValue<'ctx>> = Vec::new();
    let mut inst_opt = bb.get_first_instruction();

    while let Some(inst) = inst_opt {
        inst_opt = inst.get_next_instruction();

        if inst.get_opcode() != InstructionOpcode::Call {
            continue;
        }

        let callsite: CallSiteValue<'ctx> = CallSiteValue::try_from(inst).expect("bla");

        let callee = match callsite.get_called_fn_value() {
            Some(f) => f,
            None => continue, // indirect call: skip
        };

        if callee.get_name().to_str() == Ok(target_fn_name) {
            calls_to_rebuild.push(inst);
        }
    }

    if calls_to_rebuild.is_empty() {
        return Ok(None);
    }

    // ------------------------------------------------------------
    // 2) Snapshot the old terminator BEFORE changing the block
    // ------------------------------------------------------------
    let old_term = bb.get_terminator().unwrap();

    // ------------------------------------------------------------
    // 3) Create the new block immediately after `bb`
    // ------------------------------------------------------------
    let new_bb = context.append_basic_block(function, "record_branch");
    new_bb.move_after(bb).unwrap();

    // ------------------------------------------------------------
    // 4) Rebuild matching calls into new_bb
    // ------------------------------------------------------------
    builder.position_at_end(new_bb);

    let mut rebuilt_pairs: Vec<(InstructionValue<'ctx>, Option<BasicValueEnum<'ctx>>)> = Vec::new();

    for old_call in &calls_to_rebuild {
        let cs = CallSiteValue::try_from(*old_call).expect("bla");
        let callee = cs.get_called_fn_value().unwrap();

        // For LLVM 14, build_direct_call is the right API path. build_call is only
        // exposed directly on newer LLVM feature sets.
        let mut args = Vec::new();
        for i in 0..cs.count_arguments() {
            if let Some(v) = inst_operand_value(*old_call, i) {
                args.push(v.into());
            }
        }

        let name = old_call
            .get_name()
            .map(|n| n.to_string_lossy().into_owned())
            .unwrap_or_default();

        let new_cs = builder.build_call(callee, &args, &name)?;

        rebuilt_pairs.push((*old_call, new_cs.try_as_basic_value().basic()));
    }

    // ------------------------------------------------------------
    // 5) Rebuild old terminator into new_bb
    // ------------------------------------------------------------
    rebuild_terminator_into(&builder, old_term)?;

    // ------------------------------------------------------------
    // 6) Replace uses of rebuilt calls, then erase originals
    // ------------------------------------------------------------
    for (old_call, maybe_new_val) in rebuilt_pairs {
        if let Some(new_val) = maybe_new_val {
            old_call.replace_all_uses_with(&new_val.as_instruction_value().unwrap());
        }
        old_call.erase_from_basic_block();
    }

    // ------------------------------------------------------------
    // 7) Erase old terminator from bb
    // ------------------------------------------------------------
    old_term.erase_from_basic_block();

    // ------------------------------------------------------------
    // 8) Make bb end with br new_bb
    // ------------------------------------------------------------
    builder.position_at_end(bb);
    builder.build_unconditional_branch(new_bb)?;

    Ok(Some(new_bb))
}

fn prepare_module(module: &Module) -> Result<()> {
    for func in module.get_functions() {
        for block in func.get_basic_blocks() {
            move_matching_calls_to_fresh_block(block, "__quantum__rt__bool_record_output")?;
        }
    }
    Ok(())
}

/// Lowers all phi instructions returning QUBIT* to control flow.
pub fn lower_qubit_phis(module: &Module) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;
    for func in module.get_functions() {
        let mut block_opt = func.get_first_basic_block();
        while let Some(block) = block_opt {
            block_opt = block.get_next_basic_block();
            let phi_candidates = get_block_phis(block);
            if phi_candidates.is_empty() {
                continue;
            }
            if lower_successive_qubit_phis_in_block(&builder, block, phi_candidates)? {
                changed = true;
            }
        }
    }
    Ok(changed)
}

pub fn lower_successive_qubit_phis_in_block(
    builder: &Builder,
    block: BasicBlock,
    phis: Vec<PhiValue>,
) -> Result<bool> {
    // Return if phis empty
    if phis.is_empty() {
        return Ok(false);
    }
    // Make sure phis are all in this block
    if phis
        .iter()
        .any(|phi| phi.as_instruction().get_parent().unwrap().ne(&block))
    {
        bail!("Provided phis are not all in the provided block")
    }

    // Get the predecessors of `block`, i.e. any block that branches directly to it
    // If none, remove this block and continue
    let preds = predecessors(block)?;
    if preds.is_empty() {
        unsafe {
            block
                .delete()
                .expect("Tried to delete block without parent")
        };
        return Ok(false);
    }

    validate_phi_lowering(block, &phis, &preds)?;

    // For each predecessor, duplicate tail and redirect edge
    let mut clone_map: HashMap<BasicBlock, BasicBlock> = HashMap::new();
    let mut clone_value_maps: HashMap<BasicBlock, HashMap<ValueKey, BasicValueEnum>> =
        HashMap::new();
    for pred in preds {
        let mut vmap: HashMap<ValueKey, BasicValueEnum> = HashMap::new();
        let mut cloned_values: HashMap<ValueKey, BasicValueEnum> = HashMap::new();
        let mut all_incomings_present = true;
        for phi in &phis {
            if let Some((val, _)) = incoming_for_predecessor(*phi, pred) {
                let key = value_key_from_instruction(phi.as_instruction());
                vmap.insert(key, val);
            } else {
                all_incomings_present = false;
                break;
            }
        }
        if !all_incomings_present {
            bail!("Missing phi incoming for predecessor during lowering");
        }

        // New block that will hold the duplicated tail
        let clone_block = pred
            .get_context()
            .insert_basic_block_after(pred, &format!("{}_dup", name_of_block(block)));

        // Rebuild non‑PHI instructions from bb into clone_block
        if !rebuild_tail_into(
            builder,
            block,
            clone_block,
            &mut vmap,
            Some(&mut cloned_values),
        ) {
            unsafe {
                clone_block
                    .delete()
                    .expect("Tried to delete failed clone block without parent")
            };
            bail!("Failed to rebuild duplicated phi tail");
        }

        // Redirect edge pred -> bb to pred -> clone_block
        redirect_edge(builder, pred, block, clone_block);
        clone_map.insert(pred, clone_block);
        clone_value_maps.insert(pred, cloned_values);
    }

    reconcile_external_uses_after_duplication(block, &clone_map, &clone_value_maps)?;

    // Now need to take care of any instructions that used the phi ssa variable
    // , e.g. function calls on the variable or additional phis
    for phi in phis {
        handle_phi_users(phi, block, &clone_map)?;
    }

    // Delete no longer needed block
    unsafe {
        block
            .delete()
            .expect("Tried to delete block without parent")
    };
    Ok(true)
}

fn validate_phi_lowering<'ctx>(
    block: BasicBlock<'ctx>,
    phis: &[PhiValue<'ctx>],
    preds: &[BasicBlock<'ctx>],
) -> Result<()> {
    for pred in preds {
        for phi in phis {
            if incoming_for_predecessor(*phi, *pred).is_none() {
                bail!("Phi block is missing an incoming edge for one predecessor");
            }
        }
    }

    if !can_rebuild_tail(block) {
        bail!("Phi block tail contains instructions the lowering pass cannot rebuild");
    }

    for phi in phis {
        validate_phi_users(*phi, block, preds)?;
    }

    Ok(())
}

fn get_block_phis(block: BasicBlock) -> Vec<PhiValue> {
    let mut inst_opt = block.get_first_instruction();
    let mut phi_candidates: Vec<PhiValue> = Vec::new();
    while let Some(inst) = inst_opt {
        if inst.get_opcode() != InstructionOpcode::Phi {
            // phis are always first instructions, so we are done here
            break;
        }
        // Turn the inst into PhiValue (safe since we checked opcode)
        let phi = unsafe { PhiValue::new(inst.as_value_ref()) };
        if let BasicTypeEnum::PointerType(ptr_ty) = phi.as_basic_value().get_type()
            && is_qubit_pointer(ptr_ty)
        {
            phi_candidates.push(phi);
        }
        inst_opt = inst.get_next_instruction();
    }
    phi_candidates
}

fn is_qubit_pointer(ptr_ty: PointerType) -> bool {
    ptr_ty
        .get_element_type()
        .into_struct_type()
        .get_name()
        .unwrap()
        .eq(c"Qubit")
}

/// For a PHI `%phi` in block `B`, replace every PHI-use of `%phi`
/// so that an incoming `(%phi, B)` becomes many `([val_from_pred], [block_from_pred])`,
/// one per original predecessor of `B`.
///
/// For a Call that uses `%phi`, replace every use of `%phi` by
/// adding a new PHI at the beginning of its block that merges the possible cases
/// of the original phi
///
/// Inputs:
/// - `phi`:  the PHI you plan to delete (in block `B`)
/// - `phi_block`: the block of the PHI you plan to delete (`B`)
/// - `clone_for_pred`: mapping P -> the block that now replaces the (P->B) edge
///   when flowing to successors (e.g., your per-pred clone of B).
///   This block *must* be an immediate predecessor of the user PHI's block.
///   If you don't duplicate, you must split edges so this is true.
///
/// Returns: number of rewritten instructions.
pub fn handle_phi_users<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
) -> Result<usize> {
    let phi_users = plan_phi_user_rewrites(phi, phi_block, clone_for_pred)?;
    apply_phi_user_rewrites(phi, phi_block, clone_for_pred, &phi_users)
}

fn plan_phi_user_rewrites<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
) -> Result<Vec<InstructionValue<'ctx>>> {
    let incoming_by_pred = incoming_map(phi);
    let phi_users = collect_instruction_users(phi.as_basic_value())?;

    for u_inst in &phi_users {
        if u_inst.get_parent().unwrap() == phi_block {
            continue;
        }
        match u_inst.get_opcode() {
            InstructionOpcode::Phi | InstructionOpcode::Call => {
                for pred in incoming_by_pred.keys() {
                    if !clone_for_pred.contains_key(pred) {
                        bail!("Detected error in phi predecessors");
                    }
                }
            }
            opcode => {
                bail!(
                    "Unsupported Opcode ({:?}) for user rewriting of deleted phi instruction",
                    opcode
                );
            }
        }
    }

    Ok(phi_users)
}

fn apply_phi_user_rewrites<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    phi_users: &[InstructionValue<'ctx>],
) -> Result<usize> {
    let incoming_by_pred = incoming_map(phi);

    let mut rewritten = 0usize;
    for &u_inst in phi_users {
        if u_inst.get_parent().unwrap() == phi_block {
            continue;
        }
        match u_inst.get_opcode() {
            InstructionOpcode::Phi => {
                let u_phi = unsafe { PhiValue::new(u_inst.as_value_ref()) };
                let succ_bb = u_inst.get_parent().expect("user phi must be in a block");
                let incomings = u_phi.get_incomings();

                let ty: BasicTypeEnum = u_phi.as_basic_value().get_type();
                let builder = succ_bb.get_context().create_builder();
                builder.position_before(&u_inst);
                let new_phi = builder.build_phi(ty, "phi.expanded").expect("build_phi");

                for (val, inc_bb) in incomings {
                    if val != phi.as_basic_value() {
                        new_phi.add_incoming(&[(&val, inc_bb)]);
                        continue;
                    }
                    for (pred, edge_val) in &incoming_by_pred {
                        let &clone_block = clone_for_pred
                            .get(pred)
                            .expect("planned phi predecessors must exist during apply");
                        new_phi.add_incoming(&[(edge_val, clone_block)]);
                    }
                }
                u_phi.replace_all_uses_with(&new_phi);
                u_inst.erase_from_basic_block();
            }
            InstructionOpcode::Call => {
                let succ_bb = u_inst.get_parent().expect("user call must be in a block");
                let local_builder = succ_bb.get_context().create_builder();
                local_builder.position_before(&u_inst);

                let phi_ty: BasicTypeEnum = phi.as_basic_value().get_type();
                let arg_phi = local_builder
                    .build_phi(phi_ty, "phi.arg")
                    .expect("error building phi");

                for (pred, edge_val) in &incoming_by_pred {
                    let &clone_bb = clone_for_pred
                        .get(pred)
                        .expect("planned phi predecessors must exist during apply");
                    arg_phi.add_incoming(&[(edge_val, clone_bb)]);
                }

                let cs: CallSiteValue = u_inst
                    .try_into()
                    .expect("planned call rewrite must be a call");
                let callee = cs
                    .get_called_fn_value()
                    .expect("planned call rewrite must have a direct callee");

                let old_val_ref = phi.as_basic_value().as_value_ref();
                let mut args: Vec<inkwell::values::BasicMetadataValueEnum> = Vec::new();
                for i in 0..cs.count_arguments() {
                    if let Some(op_bv) = inst_operand_value(u_inst, i) {
                        let vref = op_bv.as_value_ref();
                        if vref == old_val_ref {
                            args.push(arg_phi.as_basic_value().into());
                        } else {
                            args.push(op_bv.into());
                        }
                    }
                }

                let name = u_inst
                    .get_name()
                    .map(|c| c.to_string_lossy())
                    .unwrap_or_default();
                let new_cs = local_builder.build_call(callee, &args, &name)?;

                if let Some(ret) = new_cs.try_as_basic_value().basic() {
                    u_inst.replace_all_uses_with(&ret.as_instruction_value().unwrap());
                }
                u_inst.erase_from_basic_block();
            }
            opcode => {
                bail!(
                    "Unsupported Opcode ({:?}) for user rewriting of deleted phi instruction",
                    opcode
                );
            }
        }
        rewritten += 1;
    }
    Ok(rewritten)
}

fn validate_phi_users<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    preds: &[BasicBlock<'ctx>],
) -> Result<()> {
    for user_inst in collect_instruction_users(phi.as_basic_value())? {
        if user_inst.get_parent().unwrap() == phi_block {
            continue;
        }

        match user_inst.get_opcode() {
            InstructionOpcode::Phi => {}
            InstructionOpcode::Call => {
                let cs: CallSiteValue = user_inst
                    .try_into()
                    .map_err(|_| anyhow!("Failed to interpret phi user as call"))?;
                if cs.get_called_fn_value().is_none() {
                    bail!("Indirect calls that use qubit phi values are not supported");
                }
            }
            opcode => {
                bail!(
                    "Unsupported Opcode ({:?}) for user rewriting of deleted phi instruction",
                    opcode
                );
            }
        }

        for pred in preds {
            if pred.get_terminator().is_none() {
                bail!("Phi predecessor has no terminator");
            }
        }
    }
    Ok(())
}

/// Extract BasicBlock operand i from instruction (works for Br/Switch operands).
fn operand_as_bb(inst: InstructionValue, idx: u32) -> Option<BasicBlock> {
    inst.get_operand(idx)?.block()
}

fn predecessors(to: BasicBlock) -> Result<Vec<BasicBlock>> {
    let mut preds = Vec::new();
    let func = to.get_parent().unwrap();
    for b in func.get_basic_blocks() {
        if let Some(term) = b.get_terminator() {
            match term.get_opcode() {
                Op::Br => {
                    // Unconditional: operand 0 = target BB
                    if !term.is_conditional() {
                        if operand_as_bb(term, 0) == Some(to) {
                            preds.push(b);
                        }
                    } else {
                        // Conditional: operand 1 = then BB, operand 2 = else BB
                        if operand_as_bb(term, 1) == Some(to) || operand_as_bb(term, 2) == Some(to)
                        {
                            preds.push(b);
                        }
                    }
                }
                Op::Switch
                | Op::IndirectBr
                | Op::Invoke
                | Op::CallBr
                | Op::CatchSwitch
                | Op::CatchRet
                | Op::CleanupRet => {
                    // These cases could be predecessors, but we don't handle them for now
                    // Switch is not supported for OG systems, not sure if the others can occur
                    bail!(
                        "Found unsupported terminal case when searching for phi predecessor blocks"
                    );
                }
                _ => { /* Cases that do not point to successors cannot be predecessors */ }
            }
        }
    }
    Ok(preds)
}

/// First non‑PHI in a block
fn first_non_phi(bb: BasicBlock) -> Option<InstructionValue> {
    let mut it = bb.get_first_instruction();
    while let Some(i) = it {
        if i.get_opcode() != InstructionOpcode::Phi {
            return Some(i);
        }
        it = i.get_next_instruction();
    }
    None
}

fn name_of_block(bb: BasicBlock<'_>) -> String {
    bb.get_name().to_string_lossy().to_string()
}

fn incoming_for_predecessor<'ctx>(
    phi: PhiValue<'ctx>,
    pred: BasicBlock<'ctx>,
) -> Option<(BasicValueEnum<'ctx>, BasicBlock<'ctx>)> {
    for (val, inc_bb) in phi.get_incomings() {
        if inc_bb == pred {
            return Some((val, inc_bb));
        }
    }
    None
}

/// The result of rebuilding a *non-terminator* instruction.
pub enum RebuildOutcome<'ctx> {
    /// The instruction was rebuilt and produced a BasicValue (SSA value).
    Value(BasicValueEnum<'ctx>),
    /// The instruction was rebuilt but produces no value (e.g., `store`, `call void`).
    Void,
}

fn replace_value_uses_in_instruction<'ctx>(
    inst: InstructionValue<'ctx>,
    old_value: BasicValueEnum<'ctx>,
    new_value: BasicValueEnum<'ctx>,
) {
    let old_ref = old_value.as_value_ref();
    for operand_idx in 0..inst.get_num_operands() {
        let Some(operand) = inst_operand_value(inst, operand_idx) else {
            continue;
        };
        if operand.as_value_ref() == old_ref {
            inst.set_operand(operand_idx, new_value);
        }
    }
}

fn rewrite_external_uses_to_vmap<'ctx>(
    original_block: BasicBlock<'ctx>,
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<()> {
    for inst in original_block.get_instructions() {
        let key = value_key_from_instruction(inst);
        let Some(&new_value) = vmap.get(&key) else {
            continue;
        };
        let Some(new_inst) = new_value.as_instruction_value() else {
            continue;
        };

        let Ok(old_value): Result<BasicValueEnum<'ctx>, ()> = inst.as_any_value_enum().try_into()
        else {
            continue;
        };
        let external_users = collect_external_instruction_users(old_value, original_block)?;

        for user in external_users {
            replace_value_uses_in_instruction(user, old_value, new_value);
        }

        if old_value.get_first_use().is_some() {
            inst.replace_all_uses_with(&new_inst);
        }
    }
    Ok(())
}

fn reconcile_external_uses_after_duplication<'ctx>(
    original_block: BasicBlock<'ctx>,
    clone_map: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    clone_value_maps: &HashMap<BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>>,
) -> Result<()> {
    let mut merge_phi_by_block_and_value: HashMap<(BasicBlock<'ctx>, ValueKey), PhiValue<'ctx>> =
        HashMap::new();

    for inst in original_block.get_instructions() {
        let Ok(old_value): Result<BasicValueEnum<'ctx>, ()> = inst.as_any_value_enum().try_into()
        else {
            continue;
        };
        let value_key = value_key_from_instruction(inst);
        let incoming_value_for_clone = |pred: &BasicBlock<'ctx>| -> Option<BasicValueEnum<'ctx>> {
            clone_value_maps
                .get(pred)
                .and_then(|m| m.get(&value_key))
                .copied()
                .or_else(|| {
                    (inst.get_opcode() == InstructionOpcode::Phi).then(|| {
                        let phi = unsafe { PhiValue::new(inst.as_value_ref()) };
                        incoming_for_predecessor(phi, *pred).map(|(val, _)| val)
                    })?
                })
        };

        let external_users = collect_external_instruction_users(old_value, original_block)?;

        for user in external_users {
            if user.get_opcode() == InstructionOpcode::Phi {
                let user_phi = unsafe { PhiValue::new(user.as_value_ref()) };
                let user_block = user.get_parent().unwrap();
                let incomings = user_phi.get_incomings();
                let incoming_by_block: HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>> =
                    incomings.into_iter().map(|(val, bb)| (bb, val)).collect();
                let user_preds = predecessors(user_block)?;
                let builder = user_block.get_context().create_builder();
                builder.position_before(&user);
                let replacement_phi = builder
                    .build_phi(user_phi.as_basic_value().get_type(), "phi.calluser")
                    .expect("error building phi for external duplicated SSA user");

                for pred_bb in user_preds {
                    if pred_bb == original_block {
                        continue;
                    }

                    let clone_source = clone_map
                        .iter()
                        .find_map(|(pred, clone_bb)| (*clone_bb == pred_bb).then_some(pred));

                    if let Some(pred) = clone_source {
                        let clone_value = incoming_value_for_clone(pred)
                            .expect("missing cloned value for external phi-use reconciliation");
                        replacement_phi.add_incoming(&[(&clone_value, pred_bb)]);
                        continue;
                    }

                    if let Some(incoming_val) = incoming_by_block.get(&pred_bb).copied() {
                        replacement_phi.add_incoming(&[(&incoming_val, pred_bb)]);
                    }
                }

                user_phi.replace_all_uses_with(&replacement_phi);
                user.erase_from_basic_block();
                continue;
            }

            let user_block = user.get_parent().unwrap();
            let phi = *merge_phi_by_block_and_value
                .entry((user_block, value_key))
                .or_insert_with(|| {
                    let builder = user_block.get_context().create_builder();
                    builder.position_before(&user_block.get_first_instruction().unwrap());
                    let phi = builder
                        .build_phi(old_value.get_type(), "phi.calluser")
                        .expect("error building phi");
                    for (pred, clone_block) in clone_map {
                        let clone_value = incoming_value_for_clone(pred)
                            .expect("missing cloned value for external-use reconciliation");
                        phi.add_incoming(&[(&clone_value, *clone_block)]);
                    }
                    phi
                });
            replace_value_uses_in_instruction(user, old_value, phi.as_basic_value());
        }
    }

    Ok(())
}

fn can_rebuild_inst(inst: InstructionValue) -> bool {
    match inst.get_opcode() {
        Op::GetElementPtr
        | Op::BitCast
        | Op::Load
        | Op::Store
        | Op::ICmp
        | Op::Select
        | Op::Add
        | Op::Sub
        | Op::Mul
        | Op::UDiv
        | Op::SDiv
        | Op::URem
        | Op::SRem
        | Op::And
        | Op::Or
        | Op::Xor => true,
        Op::Call => {
            let Ok(callsite) = CallSiteValue::try_from(inst) else {
                return false;
            };
            callsite.get_called_fn_value().is_some()
        }
        _ => false,
    }
}

fn can_rebuild_terminator(inst: InstructionValue) -> bool {
    matches!(inst.get_opcode(), Op::Br | Op::Return)
}

fn can_rebuild_tail(bb: BasicBlock) -> bool {
    let mut it = first_non_phi(bb);
    while let Some(inst) = it {
        if inst.is_terminator() {
            return can_rebuild_terminator(inst);
        }
        if !can_rebuild_inst(inst) {
            return false;
        }
        it = inst.get_next_instruction();
    }
    false
}

fn can_rebuild_tail_slice(slice: &[InstructionValue]) -> bool {
    for &inst in slice {
        if inst.is_terminator() {
            return can_rebuild_terminator(inst);
        }
        if !can_rebuild_inst(inst) {
            return false;
        }
    }
    false
}

/// Rebuild all non‑PHI instructions from `from_bb` into `into_bb`.
fn rebuild_tail_into<'ctx>(
    builder: &Builder<'ctx>,
    from_bb: BasicBlock<'ctx>,
    into_bb: BasicBlock<'ctx>,
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
    produced_values: Option<&mut HashMap<ValueKey, BasicValueEnum<'ctx>>>,
) -> bool {
    builder.position_at_end(into_bb);
    let mut it = first_non_phi(from_bb);
    let mut produced_values = produced_values;
    while let Some(inst) = it {
        if inst.is_terminator() {
            if !rebuild_terminator(builder, inst, vmap) {
                return false;
            }
            break;
        }
        match rebuild_inst(builder, into_bb, inst, vmap) {
            Ok(RebuildOutcome::Value(bv)) => {
                // only value-producing instructions enter vmap
                let key = value_key_from_instruction(inst);
                vmap.insert(key, bv);
                if let Some(ref mut produced_values) = produced_values {
                    produced_values.insert(key, bv);
                }
            }
            Ok(RebuildOutcome::Void) => {
                // built successfully, but nothing to map → keep going
            }
            Err(_) => {
                // unsupported/failed to rebuild → bail on this path
                return false;
            }
        }
        it = inst.get_next_instruction();
    }
    true
}

/// Remap a BasicValue through vmap using the original instruction’s name as key.
fn remap<'ctx>(
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
    v: BasicValueEnum<'ctx>,
) -> BasicValueEnum<'ctx> {
    if let Some(orig) = value_key_from_basic_value(v)
        && let Some(mapped) = vmap.get(&orig)
    {
        return *mapped;
    }
    v
}

fn rebuild_terminator<'ctx>(
    builder: &Builder<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> bool {
    match inst.get_opcode() {
        Op::Br => {
            if inst.is_conditional() {
                let cond = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();

                let tbb = operand_as_bb(inst, 1).unwrap();
                let fbb = operand_as_bb(inst, 2).unwrap();
                // This order of fbb and tbb is not what I would expect but
                // if you do it the other way the branches get switched...
                builder.build_conditional_branch(cond, fbb, tbb).is_ok()
            } else {
                let bb = operand_as_bb(inst, 0).unwrap();
                builder.build_unconditional_branch(bb).is_ok()
            }
        }
        Op::Return => {
            let val = inst
                .get_operand(0)
                .and_then(|o| operand_as_value(o))
                .map(|v| remap(vmap, v));

            use inkwell::values::BasicValue; // bring the trait into scope
            builder
                .build_return(
                    val.as_ref().map(|v| v as &dyn BasicValue), // coerce &BasicValueEnum -> &dyn BasicValue
                )
                .is_ok()
        }
        // TODO: handle Switch if your IR uses it (map default and cases)
        _ => false,
    }
}

fn redirect_edge<'ctx>(
    builder: &Builder<'ctx>,
    from: BasicBlock<'ctx>,
    old_to: BasicBlock<'ctx>,
    new_to: BasicBlock<'ctx>,
) {
    if let Some(term) = from.get_terminator() {
        builder.position_at_end(from);
        match term.get_opcode() {
            Op::Br => {
                if term.is_conditional() {
                    let cond = expect_inst_operand_value(term, 0).into_int_value();
                    let then_bb = operand_as_bb(term, 1).unwrap();
                    let else_bb = operand_as_bb(term, 2).unwrap();
                    let new_then = if then_bb == old_to { new_to } else { then_bb };
                    let new_else = if else_bb == old_to { new_to } else { else_bb };

                    // This order of fbb and tbb is not what I would expect but
                    // if you do it the other way the branches get switched...
                    builder
                        .build_conditional_branch(cond, new_else, new_then)
                        .ok();
                } else {
                    builder.build_unconditional_branch(new_to).ok();
                }
                term.erase_from_basic_block();
            }
            _ => { /* extend for switch if needed */ }
        }
    }
}

pub fn rebuild_inst<'ctx>(
    builder: &Builder<'ctx>,
    into_block: BasicBlock<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<RebuildOutcome<'ctx>> {
    let name = inst.get_name().unwrap_or(c"").to_string_lossy();
    builder.position_at_end(into_block);
    match inst.get_opcode() {
        // ---------------- Pointer / aggregate ops ----------------
        Op::GetElementPtr => unsafe {
            let base = remap(vmap, expect_inst_operand_value(inst, 0));
            let num_ops = inst.get_num_operands();
            let mut indices = Vec::new();
            for i in 1..num_ops {
                let idx = expect_inst_operand_value(inst, i);
                indices.push(remap(vmap, idx).into_int_value());
            }
            let built = builder.build_gep(base.into_pointer_value(), &indices, &name)?;
            Ok(RebuildOutcome::Value(built.as_basic_value_enum()))
        },

        // ---------------- Casts (no `build_bitcast` fallback) ----------------
        Op::BitCast => {
            // We implement bitcast via specialized casts. See comments in our previous message.
            let src_val = remap(vmap, expect_inst_operand_value(inst, 0));
            let dst_any = inst.get_type(); // LLVM 14: typed pointers still exist

            match dst_any.try_into() {
                Ok(BasicTypeEnum::PointerType(dst_ptr_ty)) => {
                    let src_ptr = match src_val {
                        BasicValueEnum::PointerValue(p) => p,
                        _ => bail!("Could not cast to PointerType"),
                    };
                    let cast = builder.build_pointer_cast(src_ptr, dst_ptr_ty, &name)?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::IntType(dst_int_ty)) => {
                    let src_int = match src_val {
                        BasicValueEnum::IntValue(i) => i,
                        _ => bail!("Could not cast to IntValue"),
                    };
                    if src_int.get_type().get_bit_width() != dst_int_ty.get_bit_width() {
                        bail!("Bit width mismatch");
                    }
                    let cast = builder.build_int_cast(src_int, dst_int_ty, &name)?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::FloatType(dst_fp_ty)) => {
                    let src_fp = match src_val {
                        BasicValueEnum::FloatValue(f) => f,
                        _ => bail!("Could not cast to FloatValue"),
                    };
                    if src_fp.get_type() != dst_fp_ty {
                        bail!("Floating type mismatch");
                    }
                    let cast = builder.build_float_cast(src_fp, dst_fp_ty, &name)?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                _ => bail!("Unsupported BitCase type"),
            }
        }

        // ---------------- Memory ops ----------------
        Op::Load => {
            let addr = remap(vmap, expect_inst_operand_value(inst, 0)).into_pointer_value();
            //let ty   = inst.get_type();
            let load = builder.build_load(addr, &name)?;
            Ok(RebuildOutcome::Value(load))
        }

        Op::Store => {
            let val = remap(vmap, expect_inst_operand_value(inst, 0));
            let addr = remap(vmap, expect_inst_operand_value(inst, 1)).into_pointer_value();
            builder.build_store(addr, val)?;
            Ok(RebuildOutcome::Void)
        }

        // ---------------- Comparisons / select ----------------
        Op::ICmp => {
            let pred = inst.get_icmp_predicate().expect("Failed to get predicate");
            let lhs = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let rhs = remap(vmap, expect_inst_operand_value(inst, 1)).into_int_value();
            let cmp = builder.build_int_compare(pred, lhs, rhs, &name)?;
            Ok(RebuildOutcome::Value(cmp.as_basic_value_enum()))
        }

        Op::Select => {
            let cond = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let tval = remap(vmap, expect_inst_operand_value(inst, 1));
            let fval = remap(vmap, expect_inst_operand_value(inst, 2));
            let sel = builder.build_select(cond, tval, fval, &name)?;
            Ok(RebuildOutcome::Value(sel))
        }

        // ---------------- Integer arithmetic ----------------
        Op::Add
        | Op::Sub
        | Op::Mul
        | Op::UDiv
        | Op::SDiv
        | Op::URem
        | Op::SRem
        | Op::And
        | Op::Or
        | Op::Xor => {
            let lhs = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let rhs = remap(vmap, expect_inst_operand_value(inst, 1)).into_int_value();
            let res = match inst.get_opcode() {
                Op::Add => builder.build_int_add(lhs, rhs, &name),
                Op::Sub => builder.build_int_sub(lhs, rhs, &name),
                Op::Mul => builder.build_int_mul(lhs, rhs, &name),
                Op::UDiv => builder.build_int_unsigned_div(lhs, rhs, &name),
                Op::SDiv => builder.build_int_signed_div(lhs, rhs, &name),
                Op::URem => builder.build_int_unsigned_rem(lhs, rhs, &name),
                Op::SRem => builder.build_int_signed_rem(lhs, rhs, &name),
                Op::And => builder.build_and(lhs, rhs, &name),
                Op::Or => builder.build_or(lhs, rhs, &name),
                Op::Xor => builder.build_xor(lhs, rhs, &name),
                _ => unreachable!(),
            }?;
            Ok(RebuildOutcome::Value(res.as_basic_value_enum()))
        }

        // ---------------- Calls ----------------
        Op::Call => {
            let orig_callsite =
                CallSiteValue::try_from(inst).expect("could not convert to CallSiteValue");
            let orig_callee = orig_callsite
                .get_called_fn_value()
                .expect("Failed to get callee");

            // Collect value operands as args (calls don't have block operands).
            let mut args = Vec::new();
            for i in 0..orig_callsite.count_arguments() {
                if let Some(v) = inst_operand_value(inst, i) {
                    args.push(remap(vmap, v).into());
                }
            }
            let dup_callsite = builder.build_call(orig_callee, &args, &name)?;
            let dup_value = dup_callsite.try_as_basic_value();
            builder.position_at_end(into_block);

            // If return type is void → Void; else produce the resulting SSA value
            match dup_value {
                ValueKind::Basic(bv) => Ok(RebuildOutcome::Value(bv)),
                ValueKind::Instruction(_) => Ok(RebuildOutcome::Void),
            }
        }
        // Add more opcodes as needed (sext/zext/trunc, ptrtoint/inttoptr, FP ops, vectors, etc.)
        _ => bail!("Instruction type not yet supported for rebuild"),
    }
}
#[inline]
fn operand_as_value(op: Operand) -> Option<BasicValueEnum> {
    match op {
        Operand::Value(bv) => Some(bv),
        Operand::Block(_) => None,
    }
}

// Convenience wrappers around InstructionValue::get_operand(i)
#[inline]
fn inst_operand_value(inst: InstructionValue, i: u32) -> Option<BasicValueEnum> {
    inst.get_operand(i).and_then(operand_as_value)
}

#[inline]
fn expect_inst_operand_value(inst: InstructionValue, i: u32) -> BasicValueEnum {
    inst.get_operand(i)
        .and_then(operand_as_value)
        .expect("Cound not get operand value")
}

/// Lower all pointer-typed `select` on qubits to explicit control flow by introducing
/// a then/else diamond and a merge PHI, then using phi elimination to remove phi.
/// May introduce new phis downstream
pub fn lower_qubit_selects(module: &Module) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;

    for func in module.get_functions() {
        let mut block_opt = func.get_first_basic_block();
        while let Some(bb) = block_opt {
            if let Some(first_sel) = get_first_qubit_select_in_block(bb)
                && lower_one_select_to_control_flow(&builder, first_sel)?
            {
                changed = true;
            }
            // If we found a select we will have added new blocks just after
            // the current one. Need to check those blocks for further selects
            // so only get the next block here, not before handling first select
            block_opt = bb.get_next_basic_block();
        }
    }
    Ok(changed)
}

fn get_first_qubit_select_in_block(bb: BasicBlock) -> Option<InstructionValue> {
    let mut it = bb.get_first_instruction();
    while let Some(i) = it {
        it = i.get_next_instruction();
        if i.get_opcode() == InstructionOpcode::Select
            && let AnyTypeEnum::PointerType(pt) = i.get_type()
            && is_qubit_pointer(pt)
        {
            return Some(i);
        }
    }
    None
}

fn lower_one_select_to_control_flow<'ctx>(
    builder: &Builder<'ctx>,
    sel: InstructionValue<'ctx>,
) -> Result<bool> {
    let bb = match sel.get_parent() {
        Some(b) => b,
        None => return Ok(false),
    };

    // Extract select operands (per LangRef: 0=cond,1=true,2=false)
    let cond = match inst_operand_value(sel, 0) {
        Some(v) => v.into_int_value(),
        None => return Ok(false),
    };
    let tval = match inst_operand_value(sel, 1) {
        Some(v) => v,
        None => return Ok(false),
    };
    let fval = match inst_operand_value(sel, 2) {
        Some(v) => v,
        None => return Ok(false),
    };

    // Gather the tail (all instructions after `sel`, including the original terminator)
    let mut tail: Vec<InstructionValue> = Vec::new();
    let mut it = sel.get_next_instruction();
    while let Some(i) = it {
        tail.push(i);
        it = i.get_next_instruction();
    }

    let phi_ty: BasicTypeEnum = match sel.get_type().try_into() {
        Ok(bt) => bt,
        Err(_) => return Ok(false),
    };
    if !validate_select_lowering(sel, &tail) {
        return Ok(false);
    }

    // Create THEN, ELSE, MERGE blocks and append to function
    let ctx = bb.get_context();

    let then_bb = ctx.insert_basic_block_after(bb, &format!("{}.select.then", name_of_block(bb)));
    let else_bb =
        ctx.insert_basic_block_after(then_bb, &format!("{}select.else", name_of_block(bb)));
    let merge_bb =
        ctx.insert_basic_block_after(else_bb, &format!("{}select.merge", name_of_block(bb)));

    // Build PHI in merge (must be first in the block)  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
    builder.position_at_end(merge_bb);
    let phi = builder.build_phi(phi_ty, "select.merge.val")?;
    phi.add_incoming(&[(&tval, then_bb), (&fval, else_bb)]);

    // Rebuild the original tail into merge, remapping %sel -> %phi
    let mut vmap: HashMap<ValueKey, BasicValueEnum> = HashMap::new();
    vmap.insert(value_key_from_instruction(sel), phi.as_basic_value());

    if !rebuild_tail_slice(builder, merge_bb, &tail, &mut vmap) {
        return Ok(false);
    }
    rewrite_external_uses_to_vmap(bb, &vmap)?;

    // Now that merge has a full copy of the tail (including the original terminator),
    // erase the original tail from `bb` and replace it with br i1 %cond, %then, %else.
    builder.position_at_end(bb);
    for &i in tail.iter().rev() {
        i.erase_from_basic_block();
    }
    // Build: br i1 %cond, label %then_bb, label %else_bb  (0=cond,1=true,2=false)  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
    builder.build_conditional_branch(cond, then_bb, else_bb)?;
    builder.position_at_end(then_bb);
    builder.build_unconditional_branch(merge_bb)?;
    builder.position_at_end(else_bb);
    builder.build_unconditional_branch(merge_bb)?;
    // PHI fixups: any successor that previously had incoming from `bb`
    // must now have incoming from `merge_bb`.
    if let Some(merge_term) = merge_bb.get_terminator() {
        fix_successor_phis_block_rename(merge_term, bb, merge_bb, &vmap)?;
    }
    // Finally, drop the original %sel itself (all uses now read %phi)
    sel.erase_from_basic_block();

    // Now use phi removal to completely eliminate ssa
    lower_successive_qubit_phis_in_block(builder, merge_bb, vec![phi])?;

    Ok(true)
}

/// Rebuild an instruction slice (the "tail") into the current insertion block,
/// using the same `rebuild_inst` / `rebuild_terminator` strategy you already have.
/// `slice` comes from the original block; it’s safe to iterate because we erased them from `bb`.
fn rebuild_tail_slice<'ctx>(
    builder: &Builder<'ctx>,
    into_block: BasicBlock<'ctx>,
    slice: &[InstructionValue<'ctx>],
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> bool {
    for &orig_inst in slice {
        if orig_inst.is_terminator() {
            return rebuild_terminator(builder, orig_inst, vmap);
        } else {
            match rebuild_inst(builder, into_block, orig_inst, vmap) {
                Ok(RebuildOutcome::Value(bv)) => {
                    vmap.insert(value_key_from_instruction(orig_inst), bv);
                }
                Ok(RebuildOutcome::Void) => { /* fine */ }
                Err(_) => return false,
            }
        }
    }
    true
}

fn validate_select_lowering(sel: InstructionValue, tail: &[InstructionValue]) -> bool {
    if tail.is_empty() {
        return false;
    }
    if !tail.last().is_some_and(|inst| inst.is_terminator()) {
        return false;
    }
    if !can_rebuild_tail_slice(tail) {
        return false;
    }
    match sel.get_type() {
        AnyTypeEnum::PointerType(pt) => is_qubit_pointer(pt),
        _ => false,
    }
}

/// Replace PHI incoming `(…, old_bb)` → `(…, new_bb)` for *all* PHIs in each successor
/// of `term` (supports unconditional/conditional br). Extend for `switch` if needed.
fn fix_successor_phis_block_rename<'ctx>(
    term: InstructionValue<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<()> {
    match term.get_opcode() {
        Op::Br => {
            let is_cond = term.is_conditional();
            let succs: Vec<BasicBlock> = if is_cond {
                // br i1 %cond, %then, %else  → operands 1/2 are the successors  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
                [
                    inst_operand_block(term, 1).unwrap(),
                    inst_operand_block(term, 2).unwrap(),
                ]
                .to_vec()
            } else {
                // br %dest  → operand 0 is the successor  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
                [inst_operand_block(term, 0).unwrap()].to_vec()
            };
            for s in succs {
                rename_incoming_block_in_phis(s, old_bb, new_bb, vmap)?;
            }
            Ok(())
        }
        Op::Switch => {
            bail!("Found switch instruction, but switch is not supported")
        }
        _ => Ok(()),
    }
}

/// For every PHI at the start of `succ_bb`, if it has an incoming from `old_bb`,
/// rebuild that PHI with the incoming block replaced by `new_bb`.
fn rename_incoming_block_in_phis<'ctx>(
    succ_bb: BasicBlock<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<()> {
    // Iterate PHIs at block start
    let mut it = succ_bb.get_first_instruction();
    while let Some(inst) = it {
        if inst.get_opcode() != Op::Phi {
            break;
        }
        // Defensive: clone the incoming list
        let phi = unsafe { PhiValue::new(inst.as_value_ref()) }; // safe: opcode checked
        let incomings = phi.get_incomings();

        // If no incoming from old_bb, skip
        if !incomings.into_iter().any(|(_, b)| b == old_bb) {
            it = inst.get_next_instruction();
            continue;
        }

        let incomings = phi.get_incomings();

        // Build a replacement PHI with the same type, before the old PHI
        let ty: BasicTypeEnum = phi.as_basic_value().get_type();
        let builder = succ_bb.get_context().create_builder();
        builder.position_before(&inst);
        let new_phi = builder.build_phi(ty, "phi.fix")?;

        for (val, inc_bb) in incomings {
            let mapped_bb = if inc_bb == old_bb { new_bb } else { inc_bb };
            let mapped_val = if inc_bb == old_bb {
                remap(vmap, val)
            } else {
                val
            };
            new_phi.add_incoming(&[(&mapped_val, mapped_bb)]);
        }

        // Replace all uses and erase old phi
        phi.replace_all_uses_with(&new_phi);
        inst.erase_from_basic_block();

        // Move iterator to the *next* instruction after the newly inserted PHI
        it = new_phi.as_instruction().get_next_instruction();
    }
    Ok(())
}

/// Convert an `Operand` into a `BasicBlock` if it *is* a block operand.
#[inline]
fn operand_as_block(op: Operand) -> Option<BasicBlock> {
    match op {
        Operand::Block(bb) => Some(bb),
        Operand::Value(_) => None,
    }
}

/// Fetch the i-th operand of `inst` and return it as a `BasicBlock`
/// (returns `None` if the operand doesn't exist or isn't a block).
#[inline]
fn inst_operand_block(inst: InstructionValue, i: u32) -> Option<BasicBlock> {
    inst.get_operand(i).and_then(operand_as_block)
}

fn simp_cfg(module: &Module) -> bool {
    let pm = PassManager::create(module);
    let mut changed = false;
    pm.add_cfg_simplification_pass();
    pm.initialize();
    for func in module.get_functions() {
        if pm.run_on(&func) {
            changed = true;
        }
    }
    pm.finalize();
    changed
}
