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

/// Returns whether the module contains at least one qubit-pointer `select` or
/// `phi` that this pass is expected to lower.
fn module_has_lowerable_qubit_selects_or_phis(module: &Module) -> bool {
    module.get_functions().any(|function| {
        function.get_basic_blocks().iter().any(|block| {
            block
                .get_instructions()
                .any(is_lowerable_qubit_select_or_phi_instruction)
        })
    })
}

/// Checks whether a single instruction matches the pass entry criteria:
/// opcode `select` or `phi`, result type `PointerType`, and pointer element type `Qubit`.
fn is_lowerable_qubit_select_or_phi_instruction(inst: InstructionValue) -> bool {
    matches!(
        inst.get_opcode(),
        InstructionOpcode::Select | InstructionOpcode::Phi
    ) && matches!(inst.get_type(), AnyTypeEnum::PointerType(ptr_ty) if is_qubit_pointer(ptr_ty))
}

/// Rebuilds a terminator into the builder's current insertion block.
///
/// When `vmap` is present, any value operands are remapped through it before
/// the terminator is recreated. This is used both for record-output block
/// splitting and for rebuilding duplicated/lowered tails.
fn rebuild_terminator<'ctx>(
    builder: &Builder<'ctx>,
    term: InstructionValue<'ctx>,
    vmap: Option<&HashMap<ValueKey, BasicValueEnum<'ctx>>>,
) -> Result<()> {
    let remap_value = |value: BasicValueEnum<'ctx>| match vmap {
        Some(vmap) => remap(vmap, value),
        None => value,
    };

    match term.get_opcode() {
        InstructionOpcode::Br => {
            let is_cond = term.is_conditional();
            if is_cond {
                let cond = remap_value(expect_inst_operand_value(term, 0)).into_int_value();

                let then_bb = required_block_operand(term, 1, "rebuild_terminator")?;
                let else_bb = required_block_operand(term, 2, "rebuild_terminator")?;

                builder.build_conditional_branch(cond, else_bb, then_bb)?;
            } else {
                let dest = required_block_operand(term, 0, "rebuild_terminator")?;
                builder.build_unconditional_branch(dest)?;
            }
            Ok(())
        }

        InstructionOpcode::Return => {
            let ret_val = inst_operand_value(term, 0).map(remap_value);
            let ret_arg: Option<&dyn BasicValue<'ctx>> =
                ret_val.as_ref().map(|v| v as &dyn BasicValue<'ctx>);

            builder.build_return(ret_arg)?;
            Ok(())
        }

        InstructionOpcode::Switch => {
            let discr = remap_value(expect_inst_operand_value(term, 0)).into_int_value();
            let default_bb = required_block_operand(term, 1, "rebuild_terminator")?;
            let mut cases = Vec::new();
            let num_ops = term.get_num_operands();
            let mut idx = 2;
            while idx + 1 < num_ops {
                let case_val = expect_inst_operand_value(term, idx).into_int_value();
                let case_bb = required_block_operand(term, idx + 1, "rebuild_terminator")?;
                cases.push((case_val, case_bb));
                idx += 2;
            }
            builder.build_switch(discr, default_bb, &cases)?;
            Ok(())
        }

        InstructionOpcode::Unreachable => {
            builder.build_unreachable()?;
            Ok(())
        }

        InstructionOpcode::Resume => {
            let resume_val = remap_value(expect_inst_operand_value(term, 0));
            builder.build_resume(resume_val)?;
            Ok(())
        }

        InstructionOpcode::IndirectBr => {
            let address = remap_value(expect_inst_operand_value(term, 0)).into_pointer_value();
            let mut destinations = Vec::new();
            for idx in 1..term.get_num_operands() {
                destinations.push(required_block_operand(term, idx, "rebuild_terminator")?);
            }
            builder.build_indirect_branch(address, &destinations)?;
            Ok(())
        }

        _ => bail!("Terminator kind not supported for rebuild: {}", term),
    }
}

/// Moves all direct calls in `bb` whose callee name satisfies `should_match`
/// into a fresh block placed immediately after `bb`.
///
/// The original block is rewritten to end in an unconditional branch to the new
/// block, and the original terminator is rebuilt in the new block after the moved calls.
pub fn move_matching_calls_to_fresh_block<'ctx>(
    bb: BasicBlock<'ctx>,
    should_match: impl Fn(&str) -> bool,
) -> Result<Option<BasicBlock<'ctx>>> {
    let function = required_parent_function(bb, "move_matching_calls_to_fresh_block")?;
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

        let callsite: CallSiteValue<'ctx> = CallSiteValue::try_from(inst)
            .map_err(|_| anyhow!("move_matching_calls_to_fresh_block: failed to parse call"))?;

        let callee = match callsite.get_called_fn_value() {
            Some(f) => f,
            None => continue, // indirect call: skip
        };

        if callee.get_name().to_str().is_ok_and(&should_match) {
            calls_to_rebuild.push(inst);
        }
    }

    if calls_to_rebuild.is_empty() {
        return Ok(None);
    }

    // ------------------------------------------------------------
    // 2) Snapshot the old terminator BEFORE changing the block
    // ------------------------------------------------------------
    let old_term = bb
        .get_terminator()
        .ok_or_else(|| anyhow!("move_matching_calls_to_fresh_block: block has no terminator"))?;

    // ------------------------------------------------------------
    // 3) Create the new block immediately after `bb`
    // ------------------------------------------------------------
    let new_bb = context.append_basic_block(function, "record_block");
    new_bb
        .move_after(bb)
        .map_err(|_| anyhow!("move_matching_calls_to_fresh_block: failed to move block"))?;

    // ------------------------------------------------------------
    // 4) Rebuild matching calls into new_bb
    // ------------------------------------------------------------
    builder.position_at_end(new_bb);

    let mut rebuilt_pairs: Vec<(InstructionValue<'ctx>, Option<BasicValueEnum<'ctx>>)> = Vec::new();

    for old_call in &calls_to_rebuild {
        let cs = CallSiteValue::try_from(*old_call)
            .map_err(|_| anyhow!("move_matching_calls_to_fresh_block: failed to parse call"))?;
        let callee = required_called_function(cs, "move_matching_calls_to_fresh_block")?;

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
    rebuild_terminator(&builder, old_term, None)?;

    // ------------------------------------------------------------
    // 6) Replace uses of rebuilt calls, then erase originals
    // ------------------------------------------------------------
    for (old_call, maybe_new_val) in rebuilt_pairs {
        if let Some(new_val) = maybe_new_val {
            old_call.replace_all_uses_with(&required_instruction_value(
                new_val,
                "move_matching_calls_to_fresh_block",
            )?);
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

/// Returns true for runtime record-output functions such as
/// `__quantum__rt__bool_record_output` and `__quantum__rt__int_record_output`.
fn is_record_output_runtime_call(name: &str) -> bool {
    name.starts_with("__quantum__rt__") && name.ends_with("_record_output")
}

/// Normalizes the module before select/phi lowering.
///
/// At present this isolates runtime `*_record_output` calls into dedicated
/// blocks so later tail duplication does not duplicate them.
fn prepare_module(module: &Module) -> Result<()> {
    for func in module.get_functions() {
        for block in func.get_basic_blocks() {
            move_matching_calls_to_fresh_block(block, is_record_output_runtime_call)?;
        }
    }
    Ok(())
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
            if let Some(first_sel) = get_first_qubit_select_in_block(bb) {
                lower_one_select_to_control_flow(&builder, first_sel)?;
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

/// Returns the first `select` in `bb` that produces a qubit pointer, if any.
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

/// Lowers one qubit-pointer `select` into an explicit then/else/merge diamond and then duplicates
/// the merge block using tail duplication
///
/// The original tail after the select is rebuilt into the merge block. Afterward, this introduces
/// a phi instruction in the merge block which is immediately lowered. This will introduce new qubit
/// typed phis downstream if there were downstream users of the select and these phis
/// are not lowered here. They can be removed using the dedicated phi lowering pass.
fn lower_one_select_to_control_flow<'ctx>(
    builder: &Builder<'ctx>,
    sel: InstructionValue<'ctx>,
) -> Result<()> {
    let bb = required_parent_block(sel, "lower_one_select_to_control_flow")?;

    // Extract select operands (per LangRef: 0=cond,1=true,2=false)
    let cond = inst_operand_value(sel, 0)
        .ok_or_else(|| anyhow!("lower_one_select_to_control_flow: missing select condition"))?
        .into_int_value();
    let tval = inst_operand_value(sel, 1)
        .ok_or_else(|| anyhow!("lower_one_select_to_control_flow: missing true select value"))?;
    let fval = inst_operand_value(sel, 2)
        .ok_or_else(|| anyhow!("lower_one_select_to_control_flow: missing false select value"))?;

    // Gather the tail (all instructions after `sel`, including the original terminator)
    let tail = collect_instruction_tail(sel.get_next_instruction());

    let phi_ty: BasicTypeEnum = sel.get_type().try_into().map_err(|_| {
        anyhow!("lower_one_select_to_control_flow: select result is not a basic type")
    })?;

    validate_select_lowering(sel, &tail)?;

    // Create THEN, ELSE, MERGE blocks and append to function
    let ctx = bb.get_context();

    let then_bb = ctx.insert_basic_block_after(bb, &format!("{}.select.then", name_of_block(bb)));
    let else_bb =
        ctx.insert_basic_block_after(then_bb, &format!("{}.select.else", name_of_block(bb)));
    let merge_bb =
        ctx.insert_basic_block_after(else_bb, &format!("{}.select.merge", name_of_block(bb)));

    // Build PHI in merge (must be first in the block)
    builder.position_at_end(merge_bb);
    let phi = builder.build_phi(phi_ty, "select.merge.val")?;
    phi.add_incoming(&[(&tval, then_bb), (&fval, else_bb)]);

    // Rebuild the original tail into merge, remapping %sel -> %phi
    let mut vmap: HashMap<ValueKey, BasicValueEnum> = HashMap::new();
    vmap.insert(value_key_from_instruction(sel), phi.as_basic_value());

    rebuild_tail(
        builder,
        merge_bb,
        &tail,
        &mut vmap,
        None,
        "select block tail",
    )?;
    rewrite_external_uses_to_vmap(bb, &vmap)?;

    // Now that merge has a full copy of the tail (including the original terminator),
    // erase the original tail from `bb` and replace it with br i1 %cond, %then, %else.
    builder.position_at_end(bb);
    for &i in tail.iter().rev() {
        i.erase_from_basic_block();
    }
    builder.build_conditional_branch(cond, then_bb, else_bb)?;
    builder.position_at_end(then_bb);
    builder.build_unconditional_branch(merge_bb)?;
    builder.position_at_end(else_bb);
    builder.build_unconditional_branch(merge_bb)?;

    if let Some(merge_term) = merge_bb.get_terminator() {
        fix_successor_phis_block_rename(merge_term, bb, merge_bb, &vmap)?;
    }
    sel.erase_from_basic_block();
    lower_successive_qubit_phis_in_block(builder, merge_bb, vec![phi])?;
    Ok(())
}

/// Rebuilds an instruction tail into `into_block`, remapping operands through `vmap`.
///
/// `slice` is expected to end in a terminator. When `produced_values` is
/// provided, any rebuilt value-producing instructions are also recorded there.
/// `context` is used to produce more specific error messages for the caller.
fn rebuild_tail<'ctx>(
    builder: &Builder<'ctx>,
    into_block: BasicBlock<'ctx>,
    slice: &[InstructionValue<'ctx>],
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
    mut produced_values: Option<&mut HashMap<ValueKey, BasicValueEnum<'ctx>>>,
    context: &str,
) -> Result<()> {
    builder.position_at_end(into_block);

    for &orig_inst in slice {
        if orig_inst.is_terminator() {
            rebuild_terminator(builder, orig_inst, Some(vmap)).map_err(|err| {
                anyhow!("{context} contains a terminator the lowering pass cannot rebuild: {err}")
            })?;
            return Ok(());
        }

        match rebuild_inst(builder, into_block, orig_inst, vmap) {
            Ok(RebuildOutcome::Value(bv)) => {
                let key = value_key_from_instruction(orig_inst);
                vmap.insert(key, bv);
                if let Some(ref mut produced_values) = produced_values {
                    produced_values.insert(key, bv);
                }
            }
            Ok(RebuildOutcome::Void) => {}
            Err(err) => {
                bail!("Failed to rebuild {context} instruction: {err}");
            }
        }
    }
    bail!("{context} did not end in a terminator")
}

/// Validates that a qubit-pointer `select` can be lowered by this pass.
fn validate_select_lowering(sel: InstructionValue, tail: &[InstructionValue]) -> Result<()> {
    validate_rebuildable_tail_slice(tail)
        .map_err(|err| anyhow!("Select block tail cannot be lowered: {err}"))?;
    match sel.get_type() {
        AnyTypeEnum::PointerType(pt) if is_qubit_pointer(pt) => Ok(()),
        AnyTypeEnum::PointerType(_) => {
            bail!("Select lowering only supports qubit pointer results")
        }
        _ => bail!("Select lowering only supports pointer-typed results"),
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
                [
                    required_block_operand(term, 1, "fix_successor_phis_block_rename")?,
                    required_block_operand(term, 2, "fix_successor_phis_block_rename")?,
                ]
                .to_vec()
            } else {
                [required_block_operand(
                    term,
                    0,
                    "fix_successor_phis_block_rename",
                )?]
                .to_vec()
            };
            for s in succs {
                rename_incoming_block_in_phis(s, old_bb, new_bb, vmap)?;
            }
            Ok(())
        }
        Op::Switch => {
            let mut succs = Vec::new();
            succs.push(required_block_operand(
                term,
                1,
                "fix_successor_phis_block_rename",
            )?);
            let mut idx = 3;
            while idx < term.get_num_operands() {
                succs.push(required_block_operand(
                    term,
                    idx,
                    "fix_successor_phis_block_rename",
                )?);
                idx += 2;
            }
            for succ in succs {
                rename_incoming_block_in_phis(succ, old_bb, new_bb, vmap)?;
            }
            Ok(())
        }
        _ => Ok(()),
    }
}

/// Rebuilds all leading PHIs in `succ_bb` whose incoming block is `old_bb`,
/// replacing that incoming edge by `new_bb` and remapping values through `vmap`.
fn rename_incoming_block_in_phis<'ctx>(
    succ_bb: BasicBlock<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<()> {
    let mut it = succ_bb.get_first_instruction();
    while let Some(inst) = it {
        if inst.get_opcode() != Op::Phi {
            break;
        }
        let phi = unsafe { PhiValue::new(inst.as_value_ref()) };
        let incomings = phi.get_incomings();

        if !incomings.into_iter().any(|(_, b)| b == old_bb) {
            it = inst.get_next_instruction();
            continue;
        }

        let incomings = phi.get_incomings();
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

        phi.replace_all_uses_with(&new_phi);
        inst.erase_from_basic_block();
        it = new_phi.as_instruction().get_next_instruction();
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
                verify_module(module).map_err(|err| {
                    anyhow!(
                        "Module verification failed after lowering qubit phis in block {}: {err}",
                        name_of_block(block)
                    )
                })?;
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
    let duplicated_tail = collect_instruction_tail(first_non_phi(block));
    for pred in preds {
        let (clone_block, cloned_values) =
            duplicate_phi_tail_for_predecessor(builder, block, pred, &phis, &duplicated_tail)?;

        // Redirect edge pred -> bb to pred -> clone_block
        redirect_edge(builder, pred, block, clone_block);
        clone_map.insert(pred, clone_block);
        clone_value_maps.insert(pred, cloned_values);
    }

    let lowered_phi_keys: HashSet<ValueKey> = phis
        .iter()
        .map(|phi| value_key_from_instruction(phi.as_instruction()))
        .collect();
    reconcile_external_uses_after_duplication(
        block,
        &clone_map,
        &clone_value_maps,
        &lowered_phi_keys,
    )?;

    // Now need to take care of any instructions that used the phi ssa variable
    // , e.g. function calls on the variable or additional phis
    for phi in phis {
        handle_phi_users(phi, block, &clone_map)?;
        phi.as_instruction().erase_from_basic_block();
    }

    // Delete no longer needed block
    unsafe {
        block
            .delete()
            .expect("Tried to delete block without parent")
    };
    Ok(true)
}

/// Validates that a block of qubit-pointer PHIs can be eliminated by tail duplication.
fn validate_phi_lowering<'ctx>(
    block: BasicBlock<'ctx>,
    phis: &[PhiValue<'ctx>],
    preds: &[BasicBlock<'ctx>],
) -> Result<()> {
    for pred in preds {
        for phi in phis {
            if incoming_for_predecessor(*phi, *pred).is_none() {
                bail!(
                    "Phi block {} is missing an incoming edge for predecessor {}",
                    name_of_block(block),
                    name_of_block(*pred)
                );
            }
        }
    }

    let tail: Vec<_> = block
        .get_instructions()
        .skip_while(|inst| inst.get_opcode() == InstructionOpcode::Phi)
        .collect();
    if let Err(err) = validate_rebuildable_tail_slice(&tail) {
        bail!("Phi block tail cannot be lowered: {err}");
    }

    for phi in phis {
        validate_phi_users(*phi, block, preds)?;
    }

    Ok(())
}

/// Collects the leading qubit-pointer PHIs from a block.
///
/// PHIs are always clustered at block start in LLVM IR, so the scan stops on the
/// first non-PHI instruction.
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

/// Returns whether a pointer type is the LLVM `%Qubit*` type used by QIR.
fn is_qubit_pointer(ptr_ty: PointerType) -> bool {
    ptr_ty
        .get_element_type()
        .into_struct_type()
        .get_name()
        .unwrap_or_default()
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

/// Plans rewrites for uses of a phi that will be deleted.
///
/// This stage performs the support checks first so the apply phase can proceed
/// without partially mutating the IR and then bailing.
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

/// Applies the rewrites planned for uses of a deleted phi.
///
/// Supported external users are downstream PHIs and direct calls.
fn apply_phi_user_rewrites<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    phi_users: &[InstructionValue<'ctx>],
) -> Result<usize> {
    let incoming_by_pred = incoming_map(phi);
    let sorted_incoming_by_pred = sorted_incoming_entries(&incoming_by_pred);
    let mut available_value_cache: HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>> = HashMap::new();

    let mut rewritten = 0usize;
    for &u_inst in phi_users {
        if required_parent_block(u_inst, "apply_phi_user_rewrites")? == phi_block {
            continue;
        }
        match u_inst.get_opcode() {
            InstructionOpcode::Phi => rewrite_phi_user_as_phi(
                phi,
                phi_block,
                u_inst,
                clone_for_pred,
                &sorted_incoming_by_pred,
                &mut available_value_cache,
            )?,
            InstructionOpcode::Call => rewrite_phi_user_as_call(
                phi,
                phi_block,
                u_inst,
                clone_for_pred,
                &sorted_incoming_by_pred,
                &mut available_value_cache,
            )?,
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

/// Rewrites a downstream PHI that uses `phi` so its incoming from the original
/// block is expanded into one incoming per duplicated predecessor tail.
fn rewrite_phi_user_as_phi<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    user_inst: InstructionValue<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    sorted_incoming_by_pred: &[(BasicBlock<'ctx>, BasicValueEnum<'ctx>)],
    available_value_cache: &mut HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>>,
) -> Result<()> {
    let user_phi = unsafe { PhiValue::new(user_inst.as_value_ref()) };
    let succ_bb = required_parent_block(user_inst, "rewrite_phi_user_as_phi")?;
    let incomings = user_phi.get_incomings();

    let ty: BasicTypeEnum = user_phi.as_basic_value().get_type();
    let builder = succ_bb.get_context().create_builder();
    builder.position_before(&user_inst);
    let new_phi = builder.build_phi(ty, "phi.expanded")?;

    for (val, inc_bb) in incomings {
        if val != phi.as_basic_value() {
            new_phi.add_incoming(&[(&val, inc_bb)]);
            continue;
        }
        if inc_bb == phi_block {
            for (pred, edge_val) in sorted_incoming_by_pred {
                let &clone_block = clone_for_pred.get(pred).ok_or_else(|| {
                    anyhow!("rewrite_phi_user_as_phi: missing planned phi predecessor")
                })?;
                new_phi.add_incoming(&[(edge_val, clone_block)]);
            }
        } else {
            let available_value = value_available_in_block_after_phi_lowering(
                phi,
                inc_bb,
                clone_for_pred,
                sorted_incoming_by_pred,
                available_value_cache,
            )?;
            new_phi.add_incoming(&[(&available_value, inc_bb)]);
        }
    }

    user_phi.replace_all_uses_with(&new_phi);
    user_inst.erase_from_basic_block();
    Ok(())
}

/// Rewrites a downstream call that uses `phi` by inserting a local merge phi for
/// the call argument and rebuilding the call with that merged value.
fn rewrite_phi_user_as_call<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    user_inst: InstructionValue<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    sorted_incoming_by_pred: &[(BasicBlock<'ctx>, BasicValueEnum<'ctx>)],
    available_value_cache: &mut HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>>,
) -> Result<()> {
    let succ_bb = required_parent_block(user_inst, "rewrite_phi_user_as_call")?;
    let local_builder = succ_bb.get_context().create_builder();
    local_builder.position_before(&user_inst);
    let replacement_value = if succ_bb == phi_block {
        bail!("rewrite_phi_user_as_call: call user unexpectedly remained in phi block");
    } else {
        value_available_in_block_after_phi_lowering(
            phi,
            succ_bb,
            clone_for_pred,
            sorted_incoming_by_pred,
            available_value_cache,
        )?
    };

    let cs: CallSiteValue = user_inst
        .try_into()
        .map_err(|_| anyhow!("rewrite_phi_user_as_call: planned call rewrite is not a call"))?;
    let callee = required_called_function(cs, "rewrite_phi_user_as_call")?;

    let old_val_ref = phi.as_basic_value().as_value_ref();
    let mut args: Vec<inkwell::values::BasicMetadataValueEnum> = Vec::new();
    for i in 0..cs.count_arguments() {
        if let Some(op_bv) = inst_operand_value(user_inst, i) {
            let vref = op_bv.as_value_ref();
            if vref == old_val_ref {
                args.push(replacement_value.into());
            } else {
                args.push(op_bv.into());
            }
        }
    }

    let name = user_inst
        .get_name()
        .map(|c| c.to_string_lossy())
        .unwrap_or_default();
    let new_cs = local_builder.build_call(callee, &args, &name)?;

    if let Some(ret) = new_cs.try_as_basic_value().basic() {
        user_inst.replace_all_uses_with(&required_instruction_value(
            ret,
            "rewrite_phi_user_as_call",
        )?);
    }
    user_inst.erase_from_basic_block();
    Ok(())
}

/// Returns a value in `block` that represents the eliminated phi after its
/// defining block has been duplicated away.
///
/// If `block` is directly reached from the clone blocks, this creates a helper
/// phi at the top of `block` and caches it so downstream users in the same block
/// reuse the same merged value.
fn value_available_in_block_after_phi_lowering<'ctx>(
    phi: PhiValue<'ctx>,
    block: BasicBlock<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    sorted_incoming_by_pred: &[(BasicBlock<'ctx>, BasicValueEnum<'ctx>)],
    available_value_cache: &mut HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>>,
) -> Result<BasicValueEnum<'ctx>> {
    if let Some(&cached) = available_value_cache.get(&block) {
        return Ok(cached);
    }

    let phi_block = required_parent_block(
        phi.as_instruction(),
        "value_available_in_block_after_phi_lowering",
    )?;
    let reverse_clone_map: HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>> = clone_for_pred
        .iter()
        .map(|(pred, clone_block)| (*clone_block, *pred))
        .collect();
    let preds = predecessors(block)?;
    let clone_pred_keys: HashSet<usize> = reverse_clone_map
        .keys()
        .map(|bb| bb.as_mut_ptr() as usize)
        .collect();
    let has_direct_clone_pred = preds
        .iter()
        .any(|pred_block| clone_pred_keys.contains(&(pred_block.as_mut_ptr() as usize)));

    if preds.is_empty() {
        bail!(
            "value_available_in_block_after_phi_lowering: block {} is unreachable from duplicated phi tails",
            name_of_block(block)
        );
    }

    let builder = block.get_context().create_builder();
    if let Some(first_inst) = block.get_first_instruction() {
        builder.position_before(&first_inst);
    } else {
        builder.position_at_end(block);
    }
    let helper_phi = builder.build_phi(phi.as_basic_value().get_type(), "phi.available")?;
    let mut added_pred_keys: HashSet<usize> = HashSet::new();

    for pred_block in preds {
        if pred_block == phi_block {
            if has_direct_clone_pred {
                continue;
            }
            for (pred, edge_val) in sorted_incoming_by_pred {
                let &clone_block = clone_for_pred.get(pred).ok_or_else(|| {
                    anyhow!(
                        "value_available_in_block_after_phi_lowering: missing planned phi predecessor"
                    )
                })?;
                let clone_key = clone_block.as_mut_ptr() as usize;
                if block_has_successor(clone_block, block)? && added_pred_keys.insert(clone_key) {
                    helper_phi.add_incoming(&[(edge_val, clone_block)]);
                }
            }
            continue;
        }

        let incoming_value = if let Some(original_pred) = reverse_clone_map.get(&pred_block) {
            sorted_incoming_by_pred
                .iter()
                .find_map(|(pred, edge_val)| (*pred == *original_pred).then_some(*edge_val))
                .ok_or_else(|| {
                    anyhow!(
                        "value_available_in_block_after_phi_lowering: missing incoming value for duplicated predecessor"
                    )
                })?
        } else {
            value_available_in_block_after_phi_lowering(
                phi,
                pred_block,
                clone_for_pred,
                sorted_incoming_by_pred,
                available_value_cache,
            )?
        };
        if added_pred_keys.insert(pred_block.as_mut_ptr() as usize) {
            helper_phi.add_incoming(&[(&incoming_value, pred_block)]);
        }
    }

    let helper_value = helper_phi.as_basic_value();
    available_value_cache.insert(block, helper_value);
    Ok(helper_value)
}

/// Validates that all external users of a phi are supported by the phi-user rewrite logic.
fn validate_phi_users<'ctx>(
    phi: PhiValue<'ctx>,
    phi_block: BasicBlock<'ctx>,
    preds: &[BasicBlock<'ctx>],
) -> Result<()> {
    for user_inst in collect_instruction_users(phi.as_basic_value())? {
        if required_parent_block(user_inst, "validate_phi_users")? == phi_block {
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

/// Returns the predecessor blocks of `to`.
///
/// Only direct branch predecessors are supported here; unsupported terminators
/// cause an error because the lowering logic depends on explicit CFG structure.
fn predecessors(to: BasicBlock) -> Result<Vec<BasicBlock>> {
    let mut preds = Vec::new();
    let func = required_parent_function(to, "predecessors")?;
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
                Op::Switch => {
                    if operand_as_bb(term, 1) == Some(to) {
                        preds.push(b);
                        continue;
                    }
                    let mut idx = 3;
                    while idx < term.get_num_operands() {
                        if operand_as_bb(term, idx) == Some(to) {
                            preds.push(b);
                            break;
                        }
                        idx += 2;
                    }
                }
                Op::IndirectBr
                | Op::Invoke
                | Op::CallBr
                | Op::CatchSwitch
                | Op::CatchRet
                | Op::CleanupRet => {
                    // These cases could be predecessors, but we don't handle them for now
                    // Not sure if these can occur for this pass.
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

/// Returns whether `from` has `to` as a direct successor through a supported terminator.
fn block_has_successor(from: BasicBlock, to: BasicBlock) -> Result<bool> {
    let Some(term) = from.get_terminator() else {
        return Ok(false);
    };

    match term.get_opcode() {
        Op::Br => {
            if !term.is_conditional() {
                Ok(operand_as_bb(term, 0) == Some(to))
            } else {
                Ok(operand_as_bb(term, 1) == Some(to) || operand_as_bb(term, 2) == Some(to))
            }
        }
        Op::Switch
        | Op::IndirectBr
        | Op::Invoke
        | Op::CallBr
        | Op::CatchSwitch
        | Op::CatchRet
        | Op::CleanupRet => {
            bail!("Found unsupported terminal case when checking whether one block reaches another")
        }
        _ => Ok(false),
    }
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

/// Collects a linear instruction tail starting at `start`, including the first
/// terminator encountered if present.
fn collect_instruction_tail(start: Option<InstructionValue>) -> Vec<InstructionValue> {
    let mut tail = Vec::new();
    let mut current = start;
    while let Some(inst) = current {
        tail.push(inst);
        if inst.is_terminator() {
            break;
        }
        current = inst.get_next_instruction();
    }
    tail
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

/// Seeds the value map for one duplicated predecessor edge using the incoming
/// values that each eliminated phi contributes on that edge.
fn phi_incoming_vmap_for_predecessor<'ctx>(
    phis: &[PhiValue<'ctx>],
    pred: BasicBlock<'ctx>,
) -> Result<HashMap<ValueKey, BasicValueEnum<'ctx>>> {
    let mut vmap = HashMap::new();
    for phi in phis {
        let (val, _) = incoming_for_predecessor(*phi, pred)
            .ok_or_else(|| anyhow!("Missing phi incoming for predecessor during lowering"))?;
        let key = value_key_from_instruction(phi.as_instruction());
        vmap.insert(key, val);
    }
    Ok(vmap)
}

/// Builds one predecessor-specific clone block for a phi-only block lowering.
fn duplicate_phi_tail_for_predecessor<'ctx>(
    builder: &Builder<'ctx>,
    original_block: BasicBlock<'ctx>,
    pred: BasicBlock<'ctx>,
    phis: &[PhiValue<'ctx>],
    duplicated_tail: &[InstructionValue<'ctx>],
) -> Result<(BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>)> {
    let mut vmap = phi_incoming_vmap_for_predecessor(phis, pred)?;
    let mut cloned_values: HashMap<ValueKey, BasicValueEnum<'ctx>> = HashMap::new();

    let clone_block = pred
        .get_context()
        .insert_basic_block_after(pred, &format!("{}.dup", name_of_block(original_block)));

    if let Err(err) = rebuild_tail(
        builder,
        clone_block,
        duplicated_tail,
        &mut vmap,
        Some(&mut cloned_values),
        "duplicated phi tail",
    ) {
        unsafe {
            clone_block
                .delete()
                .expect("Tried to delete failed clone block without parent")
        };
        bail!("Failed to rebuild duplicated phi tail: {err}");
    }

    Ok((clone_block, cloned_values))
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

/// Rewrites external uses of values rebuilt through `vmap` so that users outside
/// `original_block` read the rebuilt values instead of the soon-to-be-erased originals.
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

/// Reconciles external users after a block has been duplicated per predecessor.
///
/// For each value defined in `original_block`, downstream users are rewritten so
/// they merge the per-clone values instead of referring to the deleted original block.
fn reconcile_external_uses_after_duplication<'ctx>(
    original_block: BasicBlock<'ctx>,
    clone_map: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    clone_value_maps: &HashMap<BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>>,
    skipped_value_keys: &HashSet<ValueKey>,
) -> Result<()> {
    let mut resolver = DuplicationValueResolver::new(original_block, clone_map, clone_value_maps);

    for inst in original_block.get_instructions() {
        if skipped_value_keys.contains(&value_key_from_instruction(inst)) {
            continue;
        }
        let Ok(old_value): Result<BasicValueEnum<'ctx>, ()> = inst.as_any_value_enum().try_into()
        else {
            continue;
        };
        let value_key = value_key_from_instruction(inst);

        let external_users = collect_external_instruction_users(old_value, original_block)?;

        for user in external_users {
            if user.get_opcode() == InstructionOpcode::Phi {
                let user_phi = unsafe { PhiValue::new(user.as_value_ref()) };
                let user_block =
                    required_parent_block(user, "reconcile_external_uses_after_duplication")?;
                let incomings = user_phi.get_incomings();
                let builder = user_block.get_context().create_builder();
                builder.position_before(&user);
                let replacement_phi =
                    builder.build_phi(user_phi.as_basic_value().get_type(), "phi.calluser")?;
                let sorted_clone_entries = sorted_clone_entries(clone_map);

                for (incoming_val, incoming_bb) in incomings {
                    if incoming_bb == original_block {
                        for (orig_pred, clone_block) in &sorted_clone_entries {
                            if !block_has_successor(*clone_block, user_block)? {
                                continue;
                            }
                            let replacement_val = resolver
                                .value_for_duplicated_original_predecessor(
                                    *orig_pred,
                                    incoming_val,
                                )?;
                            replacement_phi.add_incoming(&[(&replacement_val, *clone_block)]);
                        }
                        continue;
                    }

                    let replacement_val = if incoming_val.as_value_ref() == old_value.as_value_ref()
                    {
                        resolver.value_available_in_block(
                            inst,
                            incoming_bb,
                            value_key,
                            old_value,
                        )?
                    } else {
                        incoming_val
                    };
                    replacement_phi.add_incoming(&[(&replacement_val, incoming_bb)]);
                }

                user_phi.replace_all_uses_with(&replacement_phi);
                user.erase_from_basic_block();
                continue;
            }

            // If not phi

            let user_block =
                required_parent_block(user, "reconcile_external_uses_after_duplication")?;
            let replacement_value =
                resolver.value_available_in_block(inst, user_block, value_key, old_value)?;
            replace_value_uses_in_instruction(user, old_value, replacement_value);
        }
    }

    Ok(())
}

/// Carries the shared state needed to resolve SSA values after a block has been
/// duplicated per predecessor.
struct DuplicationValueResolver<'a, 'ctx> {
    original_block: BasicBlock<'ctx>,
    clone_value_maps: &'a HashMap<BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>>,
    sorted_clone_entries: Vec<(BasicBlock<'ctx>, BasicBlock<'ctx>)>,
    reverse_clone_map: HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    available_value_cache: HashMap<(BasicBlock<'ctx>, ValueKey), BasicValueEnum<'ctx>>,
}

impl<'a, 'ctx> DuplicationValueResolver<'a, 'ctx> {
    fn new(
        original_block: BasicBlock<'ctx>,
        clone_map: &'a HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
        clone_value_maps: &'a HashMap<BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>>,
    ) -> Self {
        Self {
            original_block,
            clone_value_maps,
            sorted_clone_entries: sorted_clone_entries(clone_map),
            reverse_clone_map: clone_map
                .iter()
                .map(|(pred, clone_bb)| (*clone_bb, *pred))
                .collect(),
            available_value_cache: HashMap::new(),
        }
    }

    /// Resolves the value that should flow along the duplicated edge corresponding
    /// to `original_pred` for a phi incoming that originally came from `original_block`.
    ///
    /// If the incoming value was produced in `original_block`, this returns the
    /// cloned value rebuilt for `original_pred`. Otherwise the incoming is already
    /// available on all duplicated edges and is returned unchanged.
    fn value_for_duplicated_original_predecessor(
        &self,
        original_pred: BasicBlock<'ctx>,
        incoming_val: BasicValueEnum<'ctx>,
    ) -> Result<BasicValueEnum<'ctx>> {
        let Some(incoming_inst) = incoming_val.as_instruction_value() else {
            return Ok(incoming_val);
        };
        if incoming_inst.get_parent() != Some(self.original_block) {
            return Ok(incoming_val);
        }

        self.resolve_original_instruction_for_predecessor(
            original_pred,
            incoming_inst,
            value_key_from_instruction(incoming_inst),
            "value_for_duplicated_original_predecessor",
        )
    }

    /// Resolves the value contributed by `original_inst` along the duplicated
    /// predecessor edge `original_pred`.
    ///
    /// This prefers the rebuilt SSA value in the duplicated predecessor, but if
    /// the original instruction is itself a phi then the value for that edge is
    /// taken from the phi incoming corresponding to `original_pred`.
    fn resolve_original_instruction_for_predecessor(
        &self,
        original_pred: BasicBlock<'ctx>,
        original_inst: InstructionValue<'ctx>,
        value_key: ValueKey,
        context: &str,
    ) -> Result<BasicValueEnum<'ctx>> {
        self.clone_value_maps
            .get(&original_pred)
            .and_then(|m| m.get(&value_key))
            .copied()
            .or_else(|| {
                (original_inst.get_opcode() == InstructionOpcode::Phi).then(|| {
                    let phi = unsafe { PhiValue::new(original_inst.as_value_ref()) };
                    incoming_for_predecessor(phi, original_pred).map(|(val, _)| val)
                })?
            })
            .ok_or_else(|| {
                anyhow!(
                    "{context}: missing cloned value for predecessor {}",
                    name_of_block(original_pred)
                )
            })
    }

    /// Returns a value available in `block` for an SSA originally defined in
    /// `original_block` after that block has been duplicated away.
    ///
    /// If `block` is not itself one of the clone blocks, this creates a helper
    /// phi in `block` that merges the value flowing from its current predecessors.
    fn value_available_in_block(
        &mut self,
        original_inst: InstructionValue<'ctx>,
        block: BasicBlock<'ctx>,
        value_key: ValueKey,
        value_type_source: BasicValueEnum<'ctx>,
    ) -> Result<BasicValueEnum<'ctx>> {
        if let Some(&cached) = self.available_value_cache.get(&(block, value_key)) {
            return Ok(cached);
        }

        let preds = predecessors(block)?;
        let clone_pred_keys: HashSet<usize> = self
            .reverse_clone_map
            .keys()
            .map(|bb| bb.as_mut_ptr() as usize)
            .collect();
        let has_direct_clone_pred = preds
            .iter()
            .any(|pred_block| clone_pred_keys.contains(&(pred_block.as_mut_ptr() as usize)));
        if preds.is_empty() {
            bail!(
                "value_available_in_block_after_duplication: block {} is unreachable from duplicated values",
                name_of_block(block)
            );
        }

        let builder = block.get_context().create_builder();
        if let Some(first_inst) = block.get_first_instruction() {
            builder.position_before(&first_inst);
        } else {
            builder.position_at_end(block);
        }
        let helper_phi = builder.build_phi(value_type_source.get_type(), "phi.calluser.edge")?;
        let mut added_pred_keys: HashSet<usize> = HashSet::new();

        for pred_block in preds {
            if pred_block == self.original_block {
                if has_direct_clone_pred {
                    continue;
                }
                for (orig_pred, clone_block) in &self.sorted_clone_entries {
                    let clone_key = clone_block.as_mut_ptr() as usize;
                    if block_has_successor(*clone_block, block)?
                        && added_pred_keys.insert(clone_key)
                    {
                        let incoming_val = self.resolve_original_instruction_for_predecessor(
                            *orig_pred,
                            original_inst,
                            value_key,
                            "value_available_in_block_after_duplication",
                        )?;
                        helper_phi.add_incoming(&[(&incoming_val, *clone_block)]);
                    }
                }
                continue;
            }

            let incoming_val = if let Some(original_pred) = self.reverse_clone_map.get(&pred_block)
            {
                self.resolve_original_instruction_for_predecessor(
                    *original_pred,
                    original_inst,
                    value_key,
                    "value_available_in_block_after_duplication",
                )?
            } else {
                self.value_available_in_block(
                    original_inst,
                    pred_block,
                    value_key,
                    value_type_source,
                )?
            };

            if added_pred_keys.insert(pred_block.as_mut_ptr() as usize) {
                helper_phi.add_incoming(&[(&incoming_val, pred_block)]);
            }
        }

        let helper_value = helper_phi.as_basic_value();
        self.available_value_cache
            .insert((block, value_key), helper_value);
        Ok(helper_value)
    }
}

/// Returns whether `rebuild_inst` has support for the given non-terminator opcode.
fn can_rebuild_inst(inst: InstructionValue) -> bool {
    match inst.get_opcode() {
        Op::GetElementPtr
        | Op::BitCast
        | Op::Trunc
        | Op::ZExt
        | Op::SExt
        | Op::FPTrunc
        | Op::FPExt
        | Op::UIToFP
        | Op::SIToFP
        | Op::FPToUI
        | Op::FPToSI
        | Op::PtrToInt
        | Op::IntToPtr
        | Op::Load
        | Op::Store
        | Op::ICmp
        | Op::FCmp
        | Op::Select
        | Op::Add
        | Op::Sub
        | Op::Mul
        | Op::UDiv
        | Op::SDiv
        | Op::URem
        | Op::SRem
        | Op::Shl
        | Op::LShr
        | Op::AShr
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

/// Validates that a rebuilt tail is non-empty, ends in a supported terminator,
/// and contains only instructions that the rebuilder knows how to recreate.
fn validate_rebuildable_tail_slice(slice: &[InstructionValue]) -> Result<()> {
    if slice.is_empty() {
        bail!("Block tail is empty");
    }

    for &inst in slice {
        if inst.is_terminator() {
            if !can_rebuild_terminator_opcode(inst) {
                bail!(
                    "Block tail contains an unsupported terminator for rebuilding: {}",
                    inst
                );
            }
            return Ok(());
        }
        if !can_rebuild_inst(inst) {
            bail!(
                "Block tail contains an instruction the lowering pass cannot rebuild: {}",
                inst
            );
        }
    }

    bail!("Block tail did not end in a terminator")
}

/// Returns whether `rebuild_terminator` supports the given terminator opcode.
fn can_rebuild_terminator_opcode(inst: InstructionValue) -> bool {
    matches!(
        inst.get_opcode(),
        Op::Br | Op::Return | Op::Switch | Op::Unreachable | Op::Resume | Op::IndirectBr
    )
}

/// Remaps a value through `vmap` when that value was originally produced by an instruction.
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

/// Redirects a CFG edge `from -> old_to` so that it instead targets `new_to`.
///
/// This is used after a predecessor-specific clone block has been created.
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

/// Rebuilds a single non-terminator instruction into `into_block`, remapping operands through `vmap`.
///
/// The returned `RebuildOutcome` indicates whether the rebuilt instruction produces
/// an SSA value that should be inserted back into the remapping table.
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

        Op::Trunc => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_int_truncate(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::ZExt => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_int_z_extend(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::SExt => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_int_s_extend(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::FPTrunc => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let dst_ty = inst.get_type().into_float_type();
            let cast = builder.build_float_trunc(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::FPExt => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let dst_ty = inst.get_type().into_float_type();
            let cast = builder.build_float_ext(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::UIToFP => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_float_type();
            let cast = builder.build_unsigned_int_to_float(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::SIToFP => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_float_type();
            let cast = builder.build_signed_int_to_float(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::FPToUI => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_float_to_unsigned_int(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::FPToSI => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_float_to_signed_int(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::PtrToInt => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_pointer_value();
            let dst_ty = inst.get_type().into_int_type();
            let cast = builder.build_ptr_to_int(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
        }

        Op::IntToPtr => {
            let src = remap(vmap, expect_inst_operand_value(inst, 0)).into_int_value();
            let dst_ty = inst.get_type().into_pointer_type();
            let cast = builder.build_int_to_ptr(src, dst_ty, &name)?;
            Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
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

        Op::FCmp => {
            let pred = inst
                .get_fcmp_predicate()
                .ok_or_else(|| anyhow!("Failed to get fcmp predicate"))?;
            let lhs = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let rhs = remap(vmap, expect_inst_operand_value(inst, 1)).into_float_value();
            let cmp = builder.build_float_compare(pred, lhs, rhs, &name)?;
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
        | Op::Shl
        | Op::LShr
        | Op::AShr
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
                Op::Shl => builder.build_left_shift(lhs, rhs, &name),
                Op::LShr => builder.build_right_shift(lhs, rhs, false, &name),
                Op::AShr => builder.build_right_shift(lhs, rhs, true, &name),
                Op::And => builder.build_and(lhs, rhs, &name),
                Op::Or => builder.build_or(lhs, rhs, &name),
                Op::Xor => builder.build_xor(lhs, rhs, &name),
                _ => unreachable!(),
            }?;
            Ok(RebuildOutcome::Value(res.as_basic_value_enum()))
        }

        // ---------------- Calls ----------------
        Op::Call => {
            let orig_callsite = CallSiteValue::try_from(inst)
                .map_err(|_| anyhow!("rebuild_inst: could not convert to CallSiteValue"))?;
            let orig_callee = required_called_function(orig_callsite, "rebuild_inst")?;

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
        _ => bail!("Instruction type not yet supported for rebuild: {}", inst),
    }
}
#[inline]
/// Converts an operand into a `BasicValueEnum` when possible.
fn operand_as_value(op: Operand) -> Option<BasicValueEnum> {
    match op {
        Operand::Value(bv) => Some(bv),
        Operand::Block(_) => None,
    }
}

#[inline]
/// Returns operand `i` of `inst` as a value operand, if present.
fn inst_operand_value(inst: InstructionValue, i: u32) -> Option<BasicValueEnum> {
    inst.get_operand(i).and_then(operand_as_value)
}

#[inline]
/// Returns operand `i` of `inst` as a value operand and panics if it is missing.
///
/// This is reserved for internal sites where the LLVM instruction shape is already known.
fn expect_inst_operand_value(inst: InstructionValue, i: u32) -> BasicValueEnum {
    inst.get_operand(i)
        .and_then(operand_as_value)
        .expect("Cound not get operand value")
}

/// Runs LLVM's CFG simplification pass over every function in the module.
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

/// Produces a stable key for instruction-produced SSA values.
fn value_key_from_instruction(inst: InstructionValue) -> ValueKey {
    inst.as_value_ref() as ValueKey
}

/// Returns the instruction key for a basic value if that value is instruction-backed.
fn value_key_from_basic_value(value: BasicValueEnum) -> Option<ValueKey> {
    value.as_instruction_value().map(value_key_from_instruction)
}

/// Converts an arbitrary LLVM value wrapper back to its underlying `InstructionValue`
/// when the value is produced by an instruction.
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

/// Converts a user returned by LLVM use-walking into an instruction or errors if it is unsupported.
fn instruction_user(value: AnyValueEnum) -> Result<InstructionValue> {
    any_value_as_instruction(value).ok_or_else(|| anyhow!("Unsupported non-instruction value user"))
}

/// Collects all instruction users of a value through LLVM's use-def chain.
fn collect_instruction_users(value: BasicValueEnum) -> Result<Vec<InstructionValue>> {
    let mut users = Vec::new();
    let mut use_opt = value.get_first_use();
    while let Some(u) = use_opt {
        users.push(instruction_user(u.get_user())?);
        use_opt = u.get_next_use();
    }
    Ok(users)
}

/// Collects the distinct users of `value` that are outside `original_block`.
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

/// Materializes a phi's incoming list as a predecessor-to-value map.
fn incoming_map(phi: PhiValue) -> HashMap<BasicBlock, BasicValueEnum> {
    phi.get_incomings()
        .map(|(val, pred_bb)| (pred_bb, val))
        .collect()
}

/// Verifies the module and converts LLVM's verifier output into `anyhow::Error`.
fn verify_module(module: &Module) -> Result<()> {
    module
        .verify()
        .map_err(|err| anyhow!("Error verifying module: {}", err.to_string()))
}

/// Returns the parent block of an instruction or a contextual error.
fn required_parent_block<'ctx>(
    inst: InstructionValue<'ctx>,
    context: &str,
) -> Result<BasicBlock<'ctx>> {
    inst.get_parent()
        .ok_or_else(|| anyhow!("{context}: instruction has no parent block"))
}

/// Returns the parent function of a block or a contextual error.
fn required_parent_function<'ctx>(
    bb: BasicBlock<'ctx>,
    context: &str,
) -> Result<inkwell::values::FunctionValue<'ctx>> {
    bb.get_parent()
        .ok_or_else(|| anyhow!("{context}: block has no parent function"))
}

/// Returns operand `idx` of `inst` as a block operand or a contextual error.
fn required_block_operand<'ctx>(
    inst: InstructionValue<'ctx>,
    idx: u32,
    context: &str,
) -> Result<BasicBlock<'ctx>> {
    operand_as_bb(inst, idx).ok_or_else(|| anyhow!("{context}: missing block operand {idx}"))
}

/// Returns the direct callee of a callsite or a contextual error for indirect calls.
fn required_called_function<'ctx>(
    callsite: CallSiteValue<'ctx>,
    context: &str,
) -> Result<inkwell::values::FunctionValue<'ctx>> {
    callsite
        .get_called_fn_value()
        .ok_or_else(|| anyhow!("{context}: indirect call is not supported"))
}

/// Returns an instruction-backed value as an `InstructionValue` or a contextual error.
fn required_instruction_value<'ctx>(
    value: BasicValueEnum<'ctx>,
    context: &str,
) -> Result<InstructionValue<'ctx>> {
    value
        .as_instruction_value()
        .ok_or_else(|| anyhow!("{context}: expected instruction-backed value"))
}

/// Returns incoming entries sorted by predecessor block name for deterministic phi construction.
fn sorted_incoming_entries<'ctx>(
    incoming_by_pred: &HashMap<BasicBlock<'ctx>, BasicValueEnum<'ctx>>,
) -> Vec<(BasicBlock<'ctx>, BasicValueEnum<'ctx>)> {
    let mut entries: Vec<_> = incoming_by_pred
        .iter()
        .map(|(pred, value)| (*pred, *value))
        .collect();
    entries.sort_by_key(|(pred, _)| name_of_block(*pred));
    entries
}

/// Returns clone-map entries sorted by predecessor and clone block names for deterministic phi construction.
fn sorted_clone_entries<'ctx>(
    clone_map: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
) -> Vec<(BasicBlock<'ctx>, BasicBlock<'ctx>)> {
    let mut entries: Vec<_> = clone_map
        .iter()
        .map(|(pred, clone_block)| (*pred, *clone_block))
        .collect();
    entries.sort_by_key(|(pred, clone_block)| (name_of_block(*pred), name_of_block(*clone_block)));
    entries
}

#[cfg(test)]
mod test {
    use super::*;
    use inkwell::context::Context;
    use inkwell::memory_buffer::MemoryBuffer;
    use insta::assert_snapshot;
    use rstest::rstest;
    use std::path::PathBuf;

    fn fixture_path(name: &str) -> PathBuf {
        PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("src")
            .join("test_resources")
            .join("ssa_lowering_pass")
            .join(name)
    }

    fn load_module_from_fixture<'ctx>(context: &'ctx Context, name: &str) -> Result<Module<'ctx>> {
        let buffer = MemoryBuffer::create_from_file(&fixture_path(name))
            .map_err(|err| anyhow!("Failed to read fixture {name}: {err}"))?;
        context
            .create_module_from_ir(buffer)
            .map_err(|err| anyhow!("Failed to parse fixture {name}: {}", err.to_string()))
    }

    fn count_lowerable_qubit_selects_and_phis(module: &Module) -> usize {
        module
            .get_functions()
            .flat_map(|function| function.get_basic_blocks())
            .flat_map(|block| block.get_instructions())
            .filter(|inst| is_lowerable_qubit_select_or_phi_instruction(*inst))
            .count()
    }

    fn fixture_snapshot_suffix(fixture: &str) -> String {
        fixture
            .strip_suffix(".ll")
            .unwrap_or(fixture)
            .replace(|ch: char| !ch.is_ascii_alphanumeric(), "_")
    }

    #[rstest]
    #[case("generates-qubit-selects-1-example.ll")]
    #[case("generates-qubit-selects-2-example.ll")]
    #[case("toric_code_example.ll")]
    #[case("simple_qubit_select.ll")]
    #[case("simple_qubit_phi.ll")]
    #[case("select_with_record_output.ll")]
    #[case("select_with_downstream_phi.ll")]
    #[case("tail_int_ptr_casts.ll")]
    #[case("tail_float_casts_and_cmp.ll")]
    #[case("tail_gep_bitcast_and_call.ll")]
    #[case("tail_switch_terminator.ll")]
    #[case("tail_unreachable_terminator.ll")]
    #[case("tail_record_output_and_downstream_phi.ll")]
    #[case("tail_call_result_downstream_phi.ll")]
    fn lowers_all_lowerable_qubit_selects_and_phis_from_fixture(#[case] fixture: &str) {
        let context = Context::create();
        let module = load_module_from_fixture(&context, fixture).unwrap();

        let before = count_lowerable_qubit_selects_and_phis(&module);
        assert!(
            before > 0,
            "expected fixture {fixture} to contain at least one lowerable qubit select or phi"
        );

        let changed = lower_qubit_selects_and_phis(&module).unwrap();
        let after = count_lowerable_qubit_selects_and_phis(&module);

        assert!(changed, "expected pass to change fixture {fixture}");
        assert_eq!(
            after, 0,
            "expected pass to remove all lowerable qubit selects/phis in fixture {fixture}"
        );
        module.verify().unwrap();

        let mut settings = insta::Settings::clone_current();
        let suffix = settings.snapshot_suffix().map_or_else(
            || fixture_snapshot_suffix(fixture),
            |existing| format!("{existing}_{}", fixture_snapshot_suffix(fixture)),
        );
        settings.set_snapshot_suffix(suffix);
        settings.bind(|| {
            assert_snapshot!("lowered_qubit_selects_and_phis", module.to_string());
        });
    }
}
