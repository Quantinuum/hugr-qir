//! Lowering of qubit-pointer and floating-point `select` and `phi` instructions
//! into explicit control flow.
//!
//! Quantum systems that don't support dynamic qubit addressing require all
//! qubit-pointer values passed to QIS functions to be statically known. This
//! pass identifies `select` and `phi` instructions producing qubit-pointer or
//! floating-point values, and replaces the containing basic blocks with
//! specialized copies where those values are resolved to constants.
//!
//! # Pass structure
//!
//! The entry point is [`lower_qubit_and_float_selects_and_phis`], which runs
//! the following steps:
//!
//! 1. **Module preparation** (`prepare_module`): consolidates all
//!    `*_record_output` calls into a single final block per function so that
//!    later block duplication cannot multiply them.
//!
//! 2. **Per-function lowering** (`lower_function`):
//!    - **Cycle detection** (`detect_loops`): verifies the CFG is a DAG.
//!    - **Analysis** (`analyze_function`): discovers all lowerable
//!      `select`/`phi` instructions. Qubit values are found by tracing
//!      backward from QIS call sites through `inttoptr`/`ptrtoint` casts
//!      (`trace_qubit_value`). Float values are found by type
//!      (`trace_float_value`).
//!    - **Iterative block lowering**: repeatedly picks the first block with
//!      lowerable values and calls `lower_block`, which:
//!      - Collects the lowerable phis and selects and the distinct select
//!        conditions (S conditions total).
//!      - Creates P × 2^S *duplicated successor blocks* (P predecessors ×
//!        2^S truth assignments), each with all phis and selects resolved to
//!        concrete values.
//!      - Builds a binary *routing tree* (`build_routing_subtree`) that
//!        dispatches to the correct duplicated successor based on the select
//!        conditions.
//!      - Fixes downstream phis (`fix_successor_phis`) and external value
//!        users (`fix_external_value_uses`) to reference the new duplicated
//!        successor blocks.
//!      - Deletes the original block (full-block mode) or erases its
//!        lowered tail (select-only mode).
//!
//! 3. **Cleanup**: runs LLVM `simplifycfg`, re-runs `prepare_module`, and
//!    normalizes block names ([`normalize_block_names`]).

use crate::inkwell::basic_block::BasicBlock;
use crate::inkwell::builder::Builder;
use crate::inkwell::module::Module;
use crate::inkwell::passes::PassBuilderOptions;
use crate::inkwell::targets::TargetMachine;
use crate::inkwell::types::BasicTypeEnum;
use crate::inkwell::values::{AnyValue, InstructionOpcode as Op};
use crate::inkwell::values::{
    AnyValueEnum, AsValueRef, BasicValue, BasicValueEnum, CallSiteValue, FunctionValue,
    InstructionOpcode, InstructionValue, IntValue, Operand, PhiValue, ValueKind,
};
use anyhow::{Result, anyhow, bail};
use std::collections::{BTreeMap, HashMap, HashSet};

type ValueKey = usize;

/// Maximum number of duplicated successor blocks that may be created when
/// lowering a single block (across all predecessors). Lowering is aborted with
/// an error if this limit would be exceeded.
const MAX_LOWERED_DUP_BLOCKS: usize = 16;

// ═══════════════════════════════════════════════════════════════════════════
// Entry point
// ═══════════════════════════════════════════════════════════════════════════

/// Lowers all qubit-pointer and floating-point `select` and `phi` instructions
/// in the module into explicit control flow.
///
/// Returns `true` if the module was modified. The input module must pass LLVM
/// verification; the output module is verified before returning.
pub fn lower_qubit_and_float_selects_and_phis(
    module: &Module,
    target: &TargetMachine,
) -> Result<bool> {
    verify_module(module).map_err(|err| {
        anyhow!(
            "Verification failed for input module to lower_qubit_and_float_selects_and_phis pass: {err}"
        )
    })?;
    if !module_has_lowerable_values(module)? {
        normalize_block_names(module);
        verify_module(module)?;
        return Ok(false);
    }

    prepare_module(module)?;

    let mut changed = false;
    for func in module.get_functions() {
        changed |= lower_function(func)?;
    }

    // A second pass may be needed if "simplifycfg" reintroduces phis or selects.
    // In that case we don't re-run `simp_cfg` after the second pass.
    if changed {
        simp_cfg(module, target)?;
        prepare_module(module)?;
        if module_has_lowerable_values(module)? {
            for func in module.get_functions() {
                lower_function(func)?;
            }
        }
    }

    if module_has_lowerable_values(module)? {
        bail!("lower_qubit_and_float_selects_and_phis: lowerable values remain after two passes");
    }

    normalize_block_names(module);
    verify_module(module)?;
    Ok(changed)
}

// ═══════════════════════════════════════════════════════════════════════════
// Analysis
// ═══════════════════════════════════════════════════════════════════════════

/// Returns whether any function in the module contains a lowerable value.
/// Propagates analysis errors (e.g. unsupported qubit pointer arithmetic).
fn module_has_lowerable_values(module: &Module) -> Result<bool> {
    for func in module.get_functions() {
        if !analyze_function(func)?.is_empty() {
            return Ok(true);
        }
    }
    Ok(false)
}

/// Discovers all lowerable `select` and `phi` instructions in `func`.
///
/// Qubit-pointer values are found by scanning QIS call sites and tracing
/// their qubit arguments backward through `select`, `phi`, `inttoptr`, and
/// `ptrtoint` chains. Float values are found by checking the result type of
/// every `select` and `phi`.
///
/// Returns a set of [`ValueKey`]s identifying the lowerable instructions.
fn analyze_function(func: FunctionValue) -> Result<HashSet<ValueKey>> {
    let mut lowerable = HashSet::new();

    for block in func.get_basic_blocks() {
        for inst in block.get_instructions() {
            if inst.get_opcode() == InstructionOpcode::Call {
                let Ok(callsite) = CallSiteValue::try_from(inst) else {
                    continue;
                };
                let Some(callee) = callsite.get_called_fn_value() else {
                    continue;
                };
                let Ok(func_name) = callee.get_name().to_str() else {
                    continue;
                };
                let Some(qubit_arg_positions) = qis_qubit_arg_positions(func_name) else {
                    continue;
                };

                for &arg_idx in qubit_arg_positions {
                    let Some(arg) = inst_operand_value(inst, arg_idx as u32) else {
                        continue;
                    };
                    let Some(arg_inst) = arg.as_instruction_value() else {
                        continue;
                    };
                    trace_qubit_value(arg_inst, &mut lowerable)?;
                }
            }

            if matches!(
                inst.get_opcode(),
                InstructionOpcode::Select | InstructionOpcode::Phi
            ) {
                trace_float_value(inst, &mut lowerable);
            }
        }
    }

    Ok(lowerable)
}

/// Recursively marks `inst` (and its upstream `select`/`phi` operands) as
/// lowerable qubit-pointer values.
///
/// `inttoptr` and `ptrtoint` casts are transparent: the chain is followed
/// through them without marking the cast itself. For `select`, operand 0
/// (the i1 condition) is skipped; for `phi`, interleaved basic-block operands
/// are skipped automatically by `inst_operand_value`.
///
/// Returns an error if an unsupported instruction (e.g. arithmetic) is found
/// in the qubit value chain.
fn trace_qubit_value(inst: InstructionValue, lowerable: &mut HashSet<ValueKey>) -> Result<()> {
    match inst.get_opcode() {
        InstructionOpcode::IntToPtr | InstructionOpcode::PtrToInt => {
            if let Some(operand) = inst_operand_value(inst, 0)
                && let Some(operand_inst) = operand.as_instruction_value()
            {
                trace_qubit_value(operand_inst, lowerable)?;
            }
        }
        InstructionOpcode::Select | InstructionOpcode::Phi => {
            let key = value_key_from_instruction(inst);
            if !lowerable.insert(key) {
                return Ok(());
            }

            let start = if inst.get_opcode() == InstructionOpcode::Select {
                1
            } else {
                0
            };
            for i in start..inst.get_num_operands() {
                if let Some(operand) = inst_operand_value(inst, i)
                    && let Some(operand_inst) = operand.as_instruction_value()
                {
                    trace_qubit_value(operand_inst, lowerable)?;
                }
            }
        }
        other => {
            bail!(
                "unsupported operation on qubit pointer value: {:?} in {}",
                other,
                inst
            );
        }
    }
    Ok(())
}

/// Recursively marks `inst` (and its upstream `select`/`phi` operands) as
/// lowerable floating-point values, if the result type is a float.
fn trace_float_value(inst: InstructionValue, lowerable: &mut HashSet<ValueKey>) {
    if !matches!(
        inst.get_opcode(),
        InstructionOpcode::Select | InstructionOpcode::Phi
    ) {
        return;
    }
    let Ok(ty) = TryInto::<BasicTypeEnum>::try_into(inst.get_type()) else {
        return;
    };
    if !is_float_type(ty) {
        return;
    }

    let key = value_key_from_instruction(inst);
    if !lowerable.insert(key) {
        return;
    }

    let start = if inst.get_opcode() == InstructionOpcode::Select {
        1
    } else {
        0
    };
    for i in start..inst.get_num_operands() {
        if let Some(operand) = inst_operand_value(inst, i)
            && let Some(operand_inst) = operand.as_instruction_value()
        {
            trace_float_value(operand_inst, lowerable);
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// Function-level lowering
// ═══════════════════════════════════════════════════════════════════════════

/// Iteratively lowers all blocks in `func` that contain lowerable values.
///
/// Verifies the CFG is a DAG, runs analysis, then repeatedly picks the first
/// block with a lowerable instruction and calls [`lower_block`] until none
/// remain. Returns `true` if any block was modified.
fn lower_function(func: FunctionValue) -> Result<bool> {
    detect_loops(func)?;
    let mut lowerable = analyze_function(func)?;
    if lowerable.is_empty() {
        return Ok(false);
    }

    let mut changed = false;
    loop {
        let mut block_to_lower = None;
        for block in func.get_basic_blocks() {
            let has_lowerable = block.get_instructions().any(|inst| {
                matches!(
                    inst.get_opcode(),
                    InstructionOpcode::Phi | InstructionOpcode::Select
                ) && lowerable.contains(&value_key_from_instruction(inst))
            });
            if has_lowerable {
                block_to_lower = Some(block);
                break;
            }
        }

        let Some(block) = block_to_lower else {
            break;
        };
        lower_block(block, &mut lowerable)?;
        changed = true;
    }

    Ok(changed)
}

/// Verifies that the CFG of `func` is a DAG by running a DFS and checking
/// for back edges. Fails with an error if a cycle is detected.
fn detect_loops(func: FunctionValue) -> Result<()> {
    fn dfs(block: BasicBlock, colors: &mut HashMap<ValueKey, u8>) -> Result<()> {
        let key = block.as_mut_ptr() as ValueKey;
        match colors.get(&key).copied() {
            Some(1) => bail!(
                "lower_ssa_vars requires DAG CFGs; detected a cycle at block {}",
                name_of_block(block)
            ),
            Some(2) => return Ok(()),
            _ => {}
        }

        colors.insert(key, 1);
        for succ in direct_successors(block)? {
            dfs(succ, colors)?;
        }
        colors.insert(key, 2);
        Ok(())
    }

    let mut colors = HashMap::new();
    for block in func.get_basic_blocks() {
        let key = block.as_mut_ptr() as ValueKey;
        if !colors.contains_key(&key) {
            dfs(block, &mut colors)?;
        }
    }
    Ok(())
}

// ═══════════════════════════════════════════════════════════════════════════
// Block-level lowering
// ═══════════════════════════════════════════════════════════════════════════

/// Lowers a single basic block by replacing its lowerable phis and selects
/// with duplicated successor blocks.
///
/// Operates in one of two modes:
///
/// - **Full-block mode** (block has leading phis): the entire block is replaced
///   by P × 2^S duplicated successor blocks, one per predecessor × condition
///   truth assignment. A routing tree per predecessor dispatches to the correct
///   duplicate. The original block is deleted.
///
/// - **Select-only mode** (no leading phis): the block is split at the first
///   lowerable select. The prefix is kept, and 2^S duplicated successor blocks
///   are created for the tail. A routing tree is appended to the prefix block.
fn lower_block(block: BasicBlock, lowerable: &mut HashSet<ValueKey>) -> Result<()> {
    let func = required_parent_function(block, "lower_block")?;
    let context = block.get_context();
    let builder = context.create_builder();
    let base_name = synthetic_block_base_name(block);

    let leading_phi_insts: Vec<_> = block
        .get_instructions()
        .take_while(|inst| inst.get_opcode() == InstructionOpcode::Phi)
        .collect();
    let lo_phis: Vec<_> = leading_phi_insts
        .iter()
        .copied()
        .filter(|inst| lowerable.contains(&value_key_from_instruction(*inst)))
        .collect();
    let lo_selects: Vec<_> = block
        .get_instructions()
        .filter(|inst| {
            inst.get_opcode() == InstructionOpcode::Select
                && lowerable.contains(&value_key_from_instruction(*inst))
        })
        .collect();

    if lo_phis.is_empty() && lo_selects.is_empty() {
        return Ok(());
    }

    let has_any_phis = !leading_phi_insts.is_empty();
    let lo_select_keys: HashSet<_> = lo_selects
        .iter()
        .map(|inst| value_key_from_instruction(*inst))
        .collect();

    let mut conditions = Vec::new();
    let mut cond_map = BTreeMap::new();
    for sel in &lo_selects {
        let cond = expect_inst_operand_value(*sel, 0).into_int_value();
        let cond_key = cond.as_value_ref() as ValueKey;
        if let std::collections::btree_map::Entry::Vacant(entry) = cond_map.entry(cond_key) {
            entry.insert(conditions.len());
            conditions.push(cond);
        }
    }

    let dups_per_pred = 1usize << conditions.len();

    if has_any_phis {
        let preds = predecessors(block)?;
        let total_dups = preds.len() * dups_per_pred;
        if total_dups > MAX_LOWERED_DUP_BLOCKS {
            bail!(
                "lower_block: lowering block {} would create {total_dups} duplicated successor blocks \
                 ({} predecessors × 2^{} select conditions), exceeding the limit of \
                 {MAX_LOWERED_DUP_BLOCKS}",
                name_of_block(block),
                preds.len(),
                conditions.len(),
            );
        }

        for cond in &conditions {
            if let Some(cond_inst) = cond.as_instruction_value()
                && cond_inst.get_parent() == Some(block)
                && cond_inst.get_opcode() != InstructionOpcode::Phi
            {
                bail!(
                    "lower_block: select condition {} is defined inside phi block {}",
                    cond_inst,
                    name_of_block(block)
                );
            }
        }

        let body: Vec<_> = block
            .get_instructions()
            .filter(|inst| inst.get_opcode() != InstructionOpcode::Phi)
            .filter(|inst| !lo_select_keys.contains(&value_key_from_instruction(*inst)))
            .collect();
        validate_rebuildable_tail_slice(&body)?;

        let mut leaves: Vec<(BasicBlock, HashMap<ValueKey, BasicValueEnum>)> = Vec::new();

        for (pred_idx, pred) in preds.iter().enumerate() {
            for bits in 0..dups_per_pred {
                let mut vmap = HashMap::new();

                for phi_inst in &leading_phi_insts {
                    let phi: PhiValue = (*phi_inst).try_into().unwrap();
                    let (val, _) = incoming_for_predecessor(phi, *pred).ok_or_else(|| {
                        anyhow!("Missing phi incoming for predecessor during lowering")
                    })?;
                    vmap.insert(value_key_from_instruction(*phi_inst), val);
                }

                for sel in &lo_selects {
                    let cond_idx =
                        cond_map[&(expect_inst_operand_value(*sel, 0).as_value_ref() as ValueKey)];
                    let is_true = ((bits >> cond_idx) & 1) == 1;
                    let selected = if is_true {
                        expect_inst_operand_value(*sel, 1)
                    } else {
                        expect_inst_operand_value(*sel, 2)
                    };
                    let resolved = remap(&vmap, selected);
                    vmap.insert(value_key_from_instruction(*sel), resolved);
                }

                let dup_bb = context
                    .append_basic_block(func, &format!("{base_name}.dup.p{pred_idx}.{bits}"));
                rebuild_tail(&builder, dup_bb, &body, &mut vmap, None, "dup_succ")?;
                leaves.push((dup_bb, vmap));
            }
        }

        for (pred_idx, pred) in preds.iter().enumerate() {
            let start = pred_idx * dups_per_pred;
            let end = start + dups_per_pred;
            let pred_dups = &leaves[start..end];
            let dup_blocks: Vec<_> = pred_dups.iter().map(|(bb, _)| *bb).collect();
            let mut pred_conditions = Vec::new();
            for cond in &conditions {
                let remapped =
                    remap(&pred_dups[0].1, (*cond).as_basic_value_enum()).into_int_value();
                if let Some(cond_inst) = remapped.as_instruction_value()
                    && cond_inst.get_parent() == Some(block)
                {
                    bail!(
                        "lower_block: unresolved routing condition {} in block {}",
                        cond_inst,
                        name_of_block(block)
                    );
                }
                pred_conditions.push(remapped);
            }
            let root = build_routing_subtree(
                &builder,
                func,
                &format!("{base_name}.route.p{pred_idx}"),
                &pred_conditions,
                &dup_blocks,
            )?;
            redirect_edge(&builder, *pred, block, root);
        }

        fix_successor_phis(block, &leaves, lowerable)?;
        fix_external_value_uses(block, &leaves, lowerable, None)?;

        for inst in block.get_instructions() {
            let Ok(value): Result<BasicValueEnum, ()> = inst.as_any_value_enum().try_into() else {
                continue;
            };
            if !collect_external_instruction_users(value, block)?.is_empty() {
                bail!(
                    "lower_block: value still has external users after full-block lowering: {}",
                    inst
                );
            }
        }

        for inst in block.get_instructions() {
            lowerable.remove(&value_key_from_instruction(inst));
        }
        erase_all_instructions(block);
        block.remove_from_function().map_err(|_| {
            anyhow!(
                "lower_block: failed to remove fully lowered block {}",
                name_of_block(block)
            )
        })?;
        return Ok(());
    }

    if dups_per_pred > MAX_LOWERED_DUP_BLOCKS {
        bail!(
            "lower_block: lowering block {} would create {dups_per_pred} duplicated successor blocks \
             (2^{} select conditions), exceeding the limit of {MAX_LOWERED_DUP_BLOCKS}",
            name_of_block(block),
            conditions.len(),
        );
    }

    let first_lo = block
        .get_instructions()
        .find(|inst| lo_select_keys.contains(&value_key_from_instruction(*inst)))
        .ok_or_else(|| anyhow!("lower_block: expected at least one lowerable select"))?;

    for cond in &conditions {
        if let Some(cond_inst) = cond.as_instruction_value()
            && cond_inst.get_parent() == Some(block)
        {
            let mut current = block.get_first_instruction();
            let mut available = false;
            while let Some(inst) = current {
                if inst == first_lo {
                    break;
                }
                if inst == cond_inst {
                    available = true;
                    break;
                }
                current = inst.get_next_instruction();
            }
            if !available {
                bail!(
                    "lower_block: select condition {} is not available before block split in {}",
                    cond_inst,
                    name_of_block(block)
                );
            }
        }
    }

    let body: Vec<_> = collect_instruction_tail(Some(first_lo))
        .into_iter()
        .filter(|inst| !lo_select_keys.contains(&value_key_from_instruction(*inst)))
        .collect();
    validate_rebuildable_tail_slice(&body)?;

    let mut leaves: Vec<(BasicBlock, HashMap<ValueKey, BasicValueEnum>)> = Vec::new();
    for bits in 0..dups_per_pred {
        let mut vmap = HashMap::new();
        for sel in &lo_selects {
            let cond_idx =
                cond_map[&(expect_inst_operand_value(*sel, 0).as_value_ref() as ValueKey)];
            let is_true = ((bits >> cond_idx) & 1) == 1;
            let selected = if is_true {
                expect_inst_operand_value(*sel, 1)
            } else {
                expect_inst_operand_value(*sel, 2)
            };
            let resolved = remap(&vmap, selected);
            vmap.insert(value_key_from_instruction(*sel), resolved);
        }

        let dup_bb = context.append_basic_block(func, &format!("{base_name}.dup.{bits}"));
        rebuild_tail(&builder, dup_bb, &body, &mut vmap, None, "dup_succ")?;
        leaves.push((dup_bb, vmap));
    }

    fix_successor_phis(block, &leaves, lowerable)?;
    let to_erase = collect_instruction_tail(Some(first_lo));
    let erased_keys: HashSet<_> = to_erase
        .iter()
        .map(|inst| value_key_from_instruction(*inst))
        .collect();
    fix_external_value_uses(block, &leaves, lowerable, Some(&erased_keys))?;

    for inst in to_erase.iter().rev() {
        lowerable.remove(&value_key_from_instruction(*inst));
        inst.erase_from_basic_block();
    }

    let dup_blocks: Vec<_> = leaves.iter().map(|(bb, _)| *bb).collect();
    if conditions.len() == 1 {
        builder.position_at_end(block);
        builder.build_conditional_branch(conditions[0], dup_blocks[1], dup_blocks[0])?;
    } else {
        let half = dup_blocks.len() / 2;
        let false_subtree = build_routing_subtree(
            &builder,
            func,
            &format!("{base_name}.route.false"),
            &conditions[..conditions.len() - 1],
            &dup_blocks[..half],
        )?;
        let true_subtree = build_routing_subtree(
            &builder,
            func,
            &format!("{base_name}.route.true"),
            &conditions[..conditions.len() - 1],
            &dup_blocks[half..],
        )?;
        builder.position_at_end(block);
        builder.build_conditional_branch(
            conditions[conditions.len() - 1],
            true_subtree,
            false_subtree,
        )?;
    }

    for sel in lo_selects {
        lowerable.remove(&value_key_from_instruction(sel));
    }

    Ok(())
}

/// Recursively builds a binary routing tree that dispatches to the correct
/// duplicated successor block based on a sequence of boolean conditions.
///
/// The tree tests the *last* condition first, splitting `dup_succs` in half:
/// the lower half is reached when the last condition is false, the upper half
/// when true. This recurses until a single block remains (base case).
///
/// Returns the root block of the routing tree.
fn build_routing_subtree<'ctx>(
    builder: &Builder<'ctx>,
    func: FunctionValue<'ctx>,
    name: &str,
    conditions: &[IntValue<'ctx>],
    leaves: &[BasicBlock<'ctx>],
) -> Result<BasicBlock<'ctx>> {
    if conditions.is_empty() {
        return leaves
            .first()
            .copied()
            .ok_or_else(|| anyhow!("build_routing_subtree: empty dup_succs"));
    }

    let context = leaves[0].get_context();
    let route_bb = context.append_basic_block(func, name);
    let last = conditions.len() - 1;
    let half = leaves.len() / 2;
    let false_subtree =
        build_routing_subtree(builder, func, name, &conditions[..last], &leaves[..half])?;
    let true_subtree =
        build_routing_subtree(builder, func, name, &conditions[..last], &leaves[half..])?;
    builder.position_at_end(route_bb);
    builder.build_conditional_branch(conditions[last], true_subtree, false_subtree)?;
    Ok(route_bb)
}

/// Rewrites phi instructions in direct successors of `original_block` to
/// replace incoming edges from the original block with per-duplicate incoming
/// edges, resolving values through each duplicate's value map.
fn fix_successor_phis<'ctx>(
    original_block: BasicBlock<'ctx>,
    leaves: &[(BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>)],
    lowerable: &mut HashSet<ValueKey>,
) -> Result<()> {
    for succ in direct_successors(original_block)? {
        let phi_insts: Vec<_> = succ
            .get_instructions()
            .take_while(|inst| inst.get_opcode() == InstructionOpcode::Phi)
            .collect();

        for phi_inst in phi_insts {
            let phi: PhiValue = phi_inst.try_into().unwrap();
            let incomings: Vec<_> = phi.get_incomings().collect();
            if !incomings
                .iter()
                .any(|(_, incoming_bb)| *incoming_bb == original_block)
            {
                continue;
            }

            let builder = succ.get_context().create_builder();
            builder.position_before(&phi_inst);
            let new_phi = builder.build_phi(phi.as_basic_value().get_type(), "phi.fix")?;

            let old_key = value_key_from_instruction(phi_inst);
            if lowerable.contains(&old_key) || is_float_type(phi.as_basic_value().get_type()) {
                lowerable.insert(value_key_from_instruction(new_phi.as_instruction()));
            }

            for (val, incoming_bb) in incomings {
                if incoming_bb == original_block {
                    for (dup_bb, dup_vmap) in leaves {
                        if block_has_successor(*dup_bb, succ)? {
                            let resolved = remap(dup_vmap, val);
                            new_phi.add_incoming(&[(&resolved, *dup_bb)]);
                        }
                    }
                } else {
                    new_phi.add_incoming(&[(&val, incoming_bb)]);
                }
            }

            phi.replace_all_uses_with(&new_phi);
            lowerable.remove(&old_key);
            phi_inst.erase_from_basic_block();
        }
    }

    Ok(())
}

/// Creates merge phis in direct successor blocks for values defined in
/// `original_block` that have users outside it, then rewrites those external
/// users to reference the merge phis.
///
/// When `only_keys` is `Some`, only values whose keys are in the set are
/// considered (used in select-only mode to limit to erased instructions).
fn fix_external_value_uses<'ctx>(
    original_block: BasicBlock<'ctx>,
    leaves: &[(BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>)],
    lowerable: &mut HashSet<ValueKey>,
    only_keys: Option<&HashSet<ValueKey>>,
) -> Result<()> {
    let succs = direct_successors(original_block)?;
    let dup_keys: HashSet<_> = leaves
        .iter()
        .map(|(dup, _)| dup.as_mut_ptr() as usize)
        .collect();

    for inst in original_block.get_instructions() {
        let Ok(value): Result<BasicValueEnum<'ctx>, ()> = inst.as_any_value_enum().try_into()
        else {
            continue;
        };
        let key = value_key_from_instruction(inst);
        if only_keys.is_some_and(|keys| !keys.contains(&key)) {
            continue;
        }
        let external_users = collect_external_instruction_users(value, original_block)?;
        if external_users.is_empty() {
            continue;
        }

        let mut merge_phis: HashMap<usize, BasicValueEnum<'ctx>> = HashMap::new();
        let mut resolver_cache = HashMap::new();
        for succ in &succs {
            let incomings: Vec<_> = leaves
                .iter()
                .filter_map(|(dup, vmap)| {
                    block_has_successor(*dup, *succ)
                        .ok()
                        .and_then(|reaches| reaches.then_some((*dup, vmap)))
                })
                .map(|(dup, vmap)| {
                    let resolved = vmap.get(&key).copied().expect(
                        "fix_external_value_uses: dup successor vmap missing key for value from original block",
                    );
                    (resolved, dup)
                })
                .collect();
            if incomings.is_empty() {
                continue;
            }

            let builder = succ.get_context().create_builder();
            if let Some(first_np) = first_non_phi(*succ) {
                builder.position_before(&first_np);
            } else {
                builder.position_at_end(*succ);
            }
            let merge = builder.build_phi(value.get_type(), "val.merge")?;
            for (incoming_val, dup) in incomings {
                merge.add_incoming(&[(&incoming_val, dup)]);
            }

            for pred in predecessors(*succ)? {
                let pred_key = pred.as_mut_ptr() as usize;
                if dup_keys.contains(&pred_key) {
                    continue;
                }
                if pred == original_block {
                    continue;
                }
                let incoming = resolve_available_value_in_block(
                    original_block,
                    pred,
                    key,
                    value,
                    leaves,
                    &merge_phis,
                    lowerable,
                    &mut resolver_cache,
                )?;
                merge.add_incoming(&[(&incoming, pred)]);
            }

            if lowerable.contains(&key) || is_float_type(value.get_type()) {
                lowerable.insert(value_key_from_instruction(merge.as_instruction()));
            }
            merge_phis.insert(succ.as_mut_ptr() as usize, merge.as_basic_value());
        }

        let mut cache = HashMap::new();
        for user in external_users {
            if user.get_opcode() == InstructionOpcode::Phi {
                let user_block = required_parent_block(user, "fix_external_value_uses")?;
                let user_phi: PhiValue = user.try_into().unwrap();
                let incomings: Vec<_> = user_phi.get_incomings().collect();
                let builder = user_block.get_context().create_builder();
                builder.position_before(&user);
                let new_phi =
                    builder.build_phi(user_phi.as_basic_value().get_type(), "phi.external")?;
                let old_user_key = value_key_from_instruction(user);
                if lowerable.contains(&old_user_key)
                    || is_float_type(user_phi.as_basic_value().get_type())
                {
                    lowerable.insert(value_key_from_instruction(new_phi.as_instruction()));
                }

                for (incoming_val, incoming_bb) in incomings {
                    let mapped_val = if incoming_val.as_value_ref() == value.as_value_ref() {
                        if let Some(&merge_phi) =
                            merge_phis.get(&(incoming_bb.as_mut_ptr() as usize))
                        {
                            merge_phi
                        } else {
                            resolve_available_value_in_block(
                                original_block,
                                incoming_bb,
                                key,
                                value,
                                leaves,
                                &merge_phis,
                                lowerable,
                                &mut cache,
                            )?
                        }
                    } else {
                        incoming_val
                    };
                    new_phi.add_incoming(&[(&mapped_val, incoming_bb)]);
                }

                user_phi.replace_all_uses_with(&new_phi);
                lowerable.remove(&old_user_key);
                user.erase_from_basic_block();
                continue;
            }

            let user_block = required_parent_block(user, "fix_external_value_uses")?;
            let user_block_key = user_block.as_mut_ptr() as usize;
            let replacement = if let Some(&merge_phi) = merge_phis.get(&user_block_key) {
                merge_phi
            } else {
                resolve_available_value_in_block(
                    original_block,
                    user_block,
                    key,
                    value,
                    leaves,
                    &merge_phis,
                    lowerable,
                    &mut cache,
                )?
            };
            replace_value_uses_in_instruction(user, value, replacement);
        }
    }

    Ok(())
}

/// Returns a value available in `block` that represents a value originally
/// defined in `original_block` after that block has been replaced by
/// duplicated successor blocks.
///
/// If `block` is a duplicated successor or direct successor with a merge phi,
/// returns that directly. Otherwise, creates a helper phi in `block` that
/// merges values from its predecessors, recursing as needed. Results are
/// cached to avoid duplicate helper phis.
#[allow(clippy::too_many_arguments)]
fn resolve_available_value_in_block<'ctx>(
    original_block: BasicBlock<'ctx>,
    block: BasicBlock<'ctx>,
    key: ValueKey,
    value: BasicValueEnum<'ctx>,
    leaves: &[(BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>)],
    merge_phis: &HashMap<usize, BasicValueEnum<'ctx>>,
    lowerable: &mut HashSet<ValueKey>,
    cache: &mut HashMap<usize, BasicValueEnum<'ctx>>,
) -> Result<BasicValueEnum<'ctx>> {
    let block_key = block.as_mut_ptr() as usize;
    if let Some(&merge_phi) = merge_phis.get(&block_key) {
        return Ok(merge_phi);
    }
    if let Some(&cached) = cache.get(&block_key) {
        return Ok(cached);
    }

    let builder = block.get_context().create_builder();
    if let Some(first_np) = first_non_phi(block) {
        builder.position_before(&first_np);
    } else {
        builder.position_at_end(block);
    }
    let helper = builder.build_phi(value.get_type(), "val.available")?;
    if lowerable.contains(&key) || is_float_type(value.get_type()) {
        lowerable.insert(value_key_from_instruction(helper.as_instruction()));
    }

    let mut added_preds = HashSet::new();
    for pred in predecessors(block)? {
        let pred_key = pred.as_mut_ptr() as usize;
        let incoming = if let Some(&merge_phi) = merge_phis.get(&pred_key) {
            merge_phi
        } else if let Some((_, vmap)) = leaves
            .iter()
            .find(|(dup, _)| dup.as_mut_ptr() as usize == pred_key)
        {
            vmap.get(&key).copied().expect(
                "resolve_available_value_in_block: dup successor vmap missing key for value from original block",
            )
        } else {
            if pred == original_block {
                continue;
            }
            resolve_available_value_in_block(
                original_block,
                pred,
                key,
                value,
                leaves,
                merge_phis,
                lowerable,
                cache,
            )?
        };
        if added_preds.insert(pred_key) {
            helper.add_incoming(&[(&incoming, pred)]);
        }
    }

    let helper_value = helper.as_basic_value();
    cache.insert(block_key, helper_value);
    Ok(helper_value)
}

// ═══════════════════════════════════════════════════════════════════════════
// Utilities
// ═══════════════════════════════════════════════════════════════════════════

fn erase_all_instructions(block: BasicBlock) {
    let mut inst_opt = block.get_last_instruction();
    while let Some(inst) = inst_opt {
        inst_opt = inst.get_previous_instruction();
        inst.erase_from_basic_block();
    }
}

fn is_float_type(ty: BasicTypeEnum) -> bool {
    matches!(ty, BasicTypeEnum::FloatType(_))
}

/// Returns the positional indices of qubit-pointer arguments for known QIS
/// intrinsics. Returns `None` if the function name is not a recognized QIS
/// intrinsic.
fn qis_qubit_arg_positions(func_name: &str) -> Option<&'static [usize]> {
    Some(match func_name {
        "__quantum__qis__h__body" => &[0],
        "__quantum__qis__x__body" => &[0],
        "__quantum__qis__y__body" => &[0],
        "__quantum__qis__z__body" => &[0],
        "__quantum__qis__s__body" => &[0],
        "__quantum__qis__s__adj" => &[0],
        "__quantum__qis__t__body" => &[0],
        "__quantum__qis__t__adj" => &[0],
        "__quantum__qis__reset__body" => &[0],
        "__quantum__qis__cx__body" => &[0, 1],
        "__quantum__qis__cy__body" => &[0, 1],
        "__quantum__qis__cz__body" => &[0, 1],
        "__quantum__qis__rx__body" => &[1],
        "__quantum__qis__ry__body" => &[1],
        "__quantum__qis__rz__body" => &[1],
        "__quantum__qis__phasedx__body" => &[2],
        "__quantum__qis__rzz__body" => &[1, 2],
        "__quantum__qis__mz__body" => &[0],
        "__quantum__rt__qubit_release" => &[0],
        "__QIR__CONV_Qubit_TO_Result" => &[0],
        _ => return None,
    })
}

/// Rebuilds a terminator instruction in the current builder position, optionally
/// remapping its operands through `vmap`. Supports unconditional/conditional
/// branches, switches, returns, and unreachable.
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
            let is_cond = term.is_conditional().unwrap();
            if is_cond {
                let cond = remap_value(expect_inst_operand_value(term, 0)).into_int_value();

                // inkwell operand(1) = false target, operand(2) = true target
                let else_bb = required_block_operand(term, 1, "rebuild_terminator")?;
                let then_bb = required_block_operand(term, 2, "rebuild_terminator")?;

                builder.build_conditional_branch(cond, then_bb, else_bb)?;
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

fn is_record_output_runtime_call(name: &str) -> bool {
    name.starts_with("__quantum__rt__") && name.ends_with("_record_output")
}

const PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME: &str = "__prepare_module_record_output_final";

/// Consolidates all `*_record_output` calls in each function into a single
/// final block, so that block duplication during lowering does not multiply
/// output-recording side effects.
fn prepare_module(module: &Module) -> Result<()> {
    for func in module.get_functions() {
        move_record_output_calls_to_function_end(func)?;
    }
    Ok(())
}

/// Moves all `*_record_output` calls in `function` to a single dedicated final
/// block, creating it if necessary. Existing `record_output` calls are removed
/// from their original blocks and rebuilt in the final block. All return blocks
/// are redirected to branch to this final block first.
fn move_record_output_calls_to_function_end<'ctx>(function: FunctionValue<'ctx>) -> Result<bool> {
    let Some(first_block) = function.get_first_basic_block() else {
        return Ok(false);
    };
    let context = first_block.get_context();
    let builder = context.create_builder();

    let existing_final_block = find_prepare_module_record_final_block(function)?;

    let mut calls_to_rebuild: Vec<InstructionValue<'ctx>> = Vec::new();
    for block in function.get_basic_blocks() {
        if Some(block) == existing_final_block {
            continue;
        }
        for inst in block.get_instructions() {
            if inst.get_opcode() != InstructionOpcode::Call {
                continue;
            }
            let callsite: CallSiteValue<'ctx> = CallSiteValue::try_from(inst).map_err(|_| {
                anyhow!("move_record_output_calls_to_function_end: failed to parse call")
            })?;
            let Some(callee) = callsite.get_called_fn_value() else {
                continue;
            };
            if callee
                .get_name()
                .to_str()
                .is_ok_and(is_record_output_runtime_call)
            {
                calls_to_rebuild.push(inst);
            }
        }
    }

    if calls_to_rebuild.is_empty() {
        return Ok(false);
    }

    let mut return_sites: Vec<(BasicBlock<'ctx>, InstructionValue<'ctx>)> = Vec::new();
    for block in function.get_basic_blocks() {
        let Some(term) = block.get_terminator() else {
            continue;
        };
        if term.get_opcode() == InstructionOpcode::Return {
            return_sites.push((block, term));
        }
    }

    if return_sites.is_empty() {
        bail!(
            "move_record_output_calls_to_function_end: function with record_output calls has no return terminator"
        );
    }

    let record_final_bb = if let Some(existing_final_block) = existing_final_block {
        existing_final_block
    } else {
        let record_final_bb =
            context.append_basic_block(function, PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME);

        let return_type = function.get_type().get_return_type();
        builder.position_at_end(record_final_bb);
        let return_value = if let Some(ret_ty) = return_type {
            let return_phi = builder.build_phi(ret_ty, "record.return")?;
            for (ret_block, ret_inst) in &return_sites {
                let ret_val = inst_operand_value(*ret_inst, 0).ok_or_else(|| {
                    anyhow!(
                        "move_record_output_calls_to_function_end: non-void return without value"
                    )
                })?;
                return_phi.add_incoming(&[(&ret_val, *ret_block)]);
            }
            Some(return_phi.as_basic_value())
        } else {
            None
        };
        if let Some(ret_val) = return_value {
            builder.build_return(Some(&ret_val))?;
        } else {
            builder.build_return(None)?;
        }

        for (ret_block, ret_inst) in &return_sites {
            builder.position_at_end(*ret_block);
            ret_inst.erase_from_basic_block();
            builder.build_unconditional_branch(record_final_bb)?;
        }

        record_final_bb
    };

    if let Some(first_non_phi) = first_non_phi(record_final_bb) {
        builder.position_before(&first_non_phi);
    } else {
        builder.position_at_end(record_final_bb);
    }
    let mut rebuilt_pairs: Vec<(InstructionValue<'ctx>, Option<BasicValueEnum<'ctx>>)> = Vec::new();
    for old_call in &calls_to_rebuild {
        let cs = CallSiteValue::try_from(*old_call).map_err(|_| {
            anyhow!("move_record_output_calls_to_function_end: failed to parse call")
        })?;
        let callee = required_called_function(cs, "move_record_output_calls_to_function_end")?;
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

    for (old_call, maybe_new_val) in rebuilt_pairs {
        if let Some(new_val) = maybe_new_val {
            old_call.replace_all_uses_with(&required_instruction_value(
                new_val,
                "move_record_output_calls_to_function_end",
            )?);
        }
        old_call.erase_from_basic_block();
    }

    Ok(true)
}

/// Searches `function` for the dedicated final record-output block created by
/// [`prepare_module`]. Returns `None` if the function has not been prepared yet.
fn find_prepare_module_record_final_block<'ctx>(
    function: FunctionValue<'ctx>,
) -> Result<Option<BasicBlock<'ctx>>> {
    let mut matching_blocks = Vec::new();
    let mut return_blocks = Vec::new();

    for block in function.get_basic_blocks() {
        if block
            .get_name()
            .to_str()
            .is_ok_and(|name| name == PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME)
        {
            matching_blocks.push(block);
        }
        if block
            .get_terminator()
            .is_some_and(|term| term.get_opcode() == InstructionOpcode::Return)
        {
            return_blocks.push(block);
        }
    }

    if matching_blocks.is_empty() {
        return Ok(None);
    }
    if matching_blocks.len() > 1 {
        bail!("prepare_module: found multiple final record-output blocks in one function");
    }

    let block = matching_blocks[0];
    if !block_is_prepare_module_record_final_block(block)? {
        bail!("prepare_module: found named final record-output block with unexpected structure");
    }
    if return_blocks.len() != 1 || return_blocks[0] != block {
        bail!(
            "prepare_module: found named final record-output block but it is not the only return point"
        );
    }

    Ok(Some(block))
}

/// Returns `true` if `block` has the structure expected of the dedicated final
/// record-output block: correct name, all non-terminator instructions are
/// `record_output` calls, and the terminator is a return.
fn block_is_prepare_module_record_final_block(block: BasicBlock) -> Result<bool> {
    if !block
        .get_name()
        .to_str()
        .is_ok_and(|name| name == PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME)
    {
        return Ok(false);
    }

    let Some(term) = block.get_terminator() else {
        return Ok(false);
    };
    if term.get_opcode() != InstructionOpcode::Return {
        return Ok(false);
    }

    for inst in block.get_instructions() {
        if inst.is_terminator() || inst.get_opcode() == InstructionOpcode::Phi {
            continue;
        }
        if inst.get_opcode() != InstructionOpcode::Call {
            return Ok(false);
        }
        let callsite: CallSiteValue = CallSiteValue::try_from(inst).map_err(|_| {
            anyhow!("block_is_prepare_module_record_final_block: failed to parse call")
        })?;
        let Some(callee) = callsite.get_called_fn_value() else {
            return Ok(false);
        };
        if !callee
            .get_name()
            .to_str()
            .is_ok_and(is_record_output_runtime_call)
        {
            return Ok(false);
        }
    }

    Ok(true)
}

pub enum RebuildOutcome<'ctx> {
    /// The instruction was rebuilt and produced a BasicValue (SSA value).
    Value(BasicValueEnum<'ctx>),
    /// The instruction was rebuilt but produces no value (e.g., `store`, `call void`).
    Void,
}

/// Returns all predecessor basic blocks of `to` by walking the LLVM use-list
/// of `to` (as a value). Every user of a basic block value is a terminator
/// instruction that branches to it; collecting their parent blocks gives the
/// predecessors in O(predecessors) time rather than O(blocks).
///
/// # Safety
/// Uses raw llvm-sys FFI to walk the use-list. This is safe as long as the
/// LLVM module is well-formed (basic block values are only used by
/// terminators).
fn predecessors(to: BasicBlock) -> Result<Vec<BasicBlock>> {
    use crate::inkwell::llvm_sys::core::{
        LLVMBasicBlockAsValue, LLVMGetFirstUse, LLVMGetInstructionParent, LLVMGetNextUse,
        LLVMGetUser, LLVMIsATerminatorInst,
    };

    let mut preds = Vec::new();
    let mut seen = HashSet::new();
    unsafe {
        let bb_value = LLVMBasicBlockAsValue(to.as_mut_ptr());
        let mut use_ref = LLVMGetFirstUse(bb_value);
        while !use_ref.is_null() {
            let user = LLVMGetUser(use_ref);
            if !LLVMIsATerminatorInst(user).is_null() {
                let parent_bb_ref = LLVMGetInstructionParent(user);
                if !parent_bb_ref.is_null() && seen.insert(parent_bb_ref as usize) {
                    // SAFETY: parent_bb_ref is a valid LLVMBasicBlockRef from a well-formed module.
                    let parent_bb = BasicBlock::new(parent_bb_ref).ok_or_else(|| {
                        anyhow!("predecessors: LLVMGetInstructionParent returned invalid block")
                    })?;
                    preds.push(parent_bb);
                }
            }
            use_ref = LLVMGetNextUse(use_ref);
        }
    }
    Ok(preds)
}

fn operand_as_bb(inst: InstructionValue, idx: u32) -> Option<BasicBlock> {
    inst.get_operand(idx)?.block()
}

/// Returns `true` if there is a direct CFG edge from `from` to `to`.
fn block_has_successor(from: BasicBlock, to: BasicBlock) -> Result<bool> {
    let Some(term) = from.get_terminator() else {
        return Ok(false);
    };

    match term.get_opcode() {
        Op::Br => {
            if !term.is_conditional().unwrap() {
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

/// Returns all direct successor basic blocks of `bb`.
fn direct_successors(bb: BasicBlock) -> Result<Vec<BasicBlock>> {
    let Some(term) = bb.get_terminator() else {
        return Ok(Vec::new());
    };

    match term.get_opcode() {
        Op::Br => {
            if !term.is_conditional().unwrap() {
                Ok(vec![required_block_operand(term, 0, "direct_successors")?])
            } else {
                Ok(vec![
                    required_block_operand(term, 1, "direct_successors")?,
                    required_block_operand(term, 2, "direct_successors")?,
                ])
            }
        }
        Op::Switch => {
            let mut succs = vec![required_block_operand(term, 1, "direct_successors")?];
            let mut idx = 3;
            while idx < term.get_num_operands() {
                succs.push(required_block_operand(term, idx, "direct_successors")?);
                idx += 2;
            }
            Ok(succs)
        }
        Op::IndirectBr => {
            let mut succs = Vec::new();
            for idx in 1..term.get_num_operands() {
                succs.push(required_block_operand(term, idx, "direct_successors")?);
            }
            Ok(succs)
        }
        Op::Return | Op::Unreachable | Op::Resume => Ok(Vec::new()),
        _ => bail!(
            "Unsupported terminator when collecting direct successors: {}",
            term
        ),
    }
}

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

/// Collects all instructions from `start` to the end of the block (inclusive
/// of the terminator) into a vector.
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

/// Strips synthetic suffixes (`.sel.`, `.dup.`, `.route`, etc.) from a block
/// name to recover the base name of the original block it was derived from.
fn synthetic_block_base_name(bb: BasicBlock<'_>) -> String {
    let name = name_of_block(bb);
    let mut base = name.as_str();

    for marker in [".sel.", ".select.", ".dup", ".record", ".route"] {
        if let Some((prefix, _)) = base.split_once(marker) {
            base = prefix;
            break;
        }
    }

    normalized_synthetic_block_base_name(base)
}

fn is_purely_numeric_block_name(name: &str) -> bool {
    !name.is_empty() && name.chars().all(|ch| ch.is_ascii_digit())
}

fn normalized_synthetic_block_base_name(name: &str) -> String {
    if name.is_empty() {
        "bb".to_string()
    } else {
        name.to_string()
    }
}

/// Normalizes block names across the module: deduplicates names and assigns
/// canonical numeric suffixes. Returns `true` if any name was changed.
pub fn normalize_block_names(module: &Module) -> bool {
    let mut changed = false;

    for function in module.get_functions() {
        let blocks = function.get_basic_blocks();
        let mut used_names: HashSet<String> = blocks
            .iter()
            .map(|bb| name_of_block(*bb))
            .filter(|name| !name.is_empty() && !is_purely_numeric_block_name(name))
            .collect();
        let mut counter = 0usize;

        for block in blocks {
            let current_name = name_of_block(block);
            if !current_name.is_empty() && !is_purely_numeric_block_name(&current_name) {
                continue;
            }

            let mut candidate = if current_name.is_empty() {
                "bb".to_string()
            } else {
                format!("bb{current_name}")
            };
            while candidate.is_empty() || used_names.contains(&candidate) {
                candidate = format!("bb{counter}");
                counter += 1;
            }

            block.set_name(&candidate);
            used_names.insert(candidate);
            changed = true;
        }
    }

    changed
}

/// Returns the incoming value of `phi` from predecessor `pred`, if any.
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

/// Replaces all operand uses of `old_value` with `new_value` in `inst`.
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

/// Returns `true` if the instruction's opcode is supported by [`rebuild_inst`].
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
        | Op::FAdd
        | Op::FSub
        | Op::FMul
        | Op::FDiv
        | Op::FRem
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

/// Validates that every instruction in `slice` is rebuildable, and that the
/// slice ends with a supported terminator.
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

fn can_rebuild_terminator_opcode(inst: InstructionValue) -> bool {
    matches!(
        inst.get_opcode(),
        Op::Br | Op::Return | Op::Switch | Op::Unreachable | Op::Resume | Op::IndirectBr
    )
}

/// Looks up `v` in `vmap` and returns the mapped value, or `v` unchanged if
/// no mapping exists.
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

/// Rewrites the terminator of `from` so that an edge to `old_to` points to
/// `new_to` instead. Works for unconditional and conditional branches.
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
                if term.is_conditional().unwrap() {
                    let cond = expect_inst_operand_value(term, 0).into_int_value();
                    // inkwell operand(1) = false target, operand(2) = true target
                    let else_bb = operand_as_bb(term, 1).unwrap();
                    let then_bb = operand_as_bb(term, 2).unwrap();
                    let new_then = if then_bb == old_to { new_to } else { then_bb };
                    let new_else = if else_bb == old_to { new_to } else { else_bb };

                    builder
                        .build_conditional_branch(cond, new_then, new_else)
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

/// Rebuilds a single non-terminator instruction in `into_block`, remapping
/// its operands through `vmap`. The rebuilt instruction's result (if any) is
/// inserted into `vmap` keyed by the original instruction's `ValueKey`.
///
/// Supports arithmetic, comparison, conversion, GEP, call, store, load,
/// and select opcodes. Returns [`RebuildOutcome`] indicating whether a
/// value was produced.
pub fn rebuild_inst<'ctx>(
    builder: &Builder<'ctx>,
    into_block: BasicBlock<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<ValueKey, BasicValueEnum<'ctx>>,
) -> Result<RebuildOutcome<'ctx>> {
    let name = inst.get_name().unwrap_or(c"").to_string_lossy();
    builder.position_at_end(into_block);
    let op = |i: u32| -> BasicValueEnum<'ctx> { remap(vmap, expect_inst_operand_value(inst, i)) };

    let result: BasicValueEnum = match inst.get_opcode() {
        // ── Integer binary arithmetic & bitwise ─────────────────────────
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
            let (lhs, rhs) = (op(0).into_int_value(), op(1).into_int_value());
            match inst.get_opcode() {
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
            }?
            .as_basic_value_enum()
        }

        // ── Float binary arithmetic ─────────────────────────────────────
        Op::FAdd | Op::FSub | Op::FMul | Op::FDiv | Op::FRem => {
            let (lhs, rhs) = (op(0).into_float_value(), op(1).into_float_value());
            match inst.get_opcode() {
                Op::FAdd => builder.build_float_add(lhs, rhs, &name),
                Op::FSub => builder.build_float_sub(lhs, rhs, &name),
                Op::FMul => builder.build_float_mul(lhs, rhs, &name),
                Op::FDiv => builder.build_float_div(lhs, rhs, &name),
                Op::FRem => builder.build_float_rem(lhs, rhs, &name),
                _ => unreachable!(),
            }?
            .as_basic_value_enum()
        }

        // ── Integer ↔ integer casts ─────────────────────────────────────
        Op::Trunc | Op::ZExt | Op::SExt => {
            let (src, dst_ty) = (op(0).into_int_value(), inst.get_type().into_int_type());
            match inst.get_opcode() {
                Op::Trunc => builder.build_int_truncate(src, dst_ty, &name),
                Op::ZExt => builder.build_int_z_extend(src, dst_ty, &name),
                Op::SExt => builder.build_int_s_extend(src, dst_ty, &name),
                _ => unreachable!(),
            }?
            .as_basic_value_enum()
        }

        // ── Float ↔ float casts ─────────────────────────────────────────
        Op::FPTrunc | Op::FPExt => {
            let (src, dst_ty) = (op(0).into_float_value(), inst.get_type().into_float_type());
            match inst.get_opcode() {
                Op::FPTrunc => builder.build_float_trunc(src, dst_ty, &name),
                Op::FPExt => builder.build_float_ext(src, dst_ty, &name),
                _ => unreachable!(),
            }?
            .as_basic_value_enum()
        }

        // ── Integer → float casts ───────────────────────────────────────
        Op::UIToFP | Op::SIToFP => {
            let (src, dst_ty) = (op(0).into_int_value(), inst.get_type().into_float_type());
            match inst.get_opcode() {
                Op::UIToFP => builder.build_unsigned_int_to_float(src, dst_ty, &name),
                Op::SIToFP => builder.build_signed_int_to_float(src, dst_ty, &name),
                _ => unreachable!(),
            }?
            .as_basic_value_enum()
        }

        // ── Float → integer casts ───────────────────────────────────────
        Op::FPToUI | Op::FPToSI => {
            let (src, dst_ty) = (op(0).into_float_value(), inst.get_type().into_int_type());
            match inst.get_opcode() {
                Op::FPToUI => builder.build_float_to_unsigned_int(src, dst_ty, &name),
                Op::FPToSI => builder.build_float_to_signed_int(src, dst_ty, &name),
                _ => unreachable!(),
            }?
            .as_basic_value_enum()
        }

        // ── Pointer ↔ integer casts ─────────────────────────────────────
        Op::PtrToInt => builder
            .build_ptr_to_int(
                op(0).into_pointer_value(),
                inst.get_type().into_int_type(),
                &name,
            )?
            .as_basic_value_enum(),
        Op::IntToPtr => builder
            .build_int_to_ptr(
                op(0).into_int_value(),
                inst.get_type().into_pointer_type(),
                &name,
            )?
            .as_basic_value_enum(),

        // ── BitCast (dispatch by destination type) ───────────────────────
        Op::BitCast => {
            let src_val = op(0);
            match inst.get_type().try_into() {
                Ok(BasicTypeEnum::PointerType(dst_ty)) => {
                    let BasicValueEnum::PointerValue(src) = src_val else {
                        bail!("BitCast: source is not a pointer")
                    };
                    builder
                        .build_pointer_cast(src, dst_ty, &name)?
                        .as_basic_value_enum()
                }
                Ok(BasicTypeEnum::IntType(dst_ty)) => {
                    let BasicValueEnum::IntValue(src) = src_val else {
                        bail!("BitCast: source is not an integer")
                    };
                    if src.get_type().get_bit_width() != dst_ty.get_bit_width() {
                        bail!("BitCast: bit width mismatch");
                    }
                    builder
                        .build_int_cast(src, dst_ty, &name)?
                        .as_basic_value_enum()
                }
                Ok(BasicTypeEnum::FloatType(dst_ty)) => {
                    let BasicValueEnum::FloatValue(src) = src_val else {
                        bail!("BitCast: source is not a float")
                    };
                    if src.get_type() != dst_ty {
                        bail!("BitCast: float type mismatch");
                    }
                    builder
                        .build_float_cast(src, dst_ty, &name)?
                        .as_basic_value_enum()
                }
                _ => bail!("Unsupported BitCast destination type"),
            }
        }

        // ── Comparisons ─────────────────────────────────────────────────
        Op::ICmp => {
            let pred = inst.get_icmp_predicate().expect("ICmp missing predicate");
            builder
                .build_int_compare(pred, op(0).into_int_value(), op(1).into_int_value(), &name)?
                .as_basic_value_enum()
        }
        Op::FCmp => {
            let pred = inst
                .get_fcmp_predicate()
                .ok_or_else(|| anyhow!("FCmp missing predicate"))?;
            builder
                .build_float_compare(
                    pred,
                    op(0).into_float_value(),
                    op(1).into_float_value(),
                    &name,
                )?
                .as_basic_value_enum()
        }

        // ── Select ──────────────────────────────────────────────────────
        Op::Select => builder.build_select(op(0).into_int_value(), op(1), op(2), &name)?,

        // ── GEP ─────────────────────────────────────────────────────────
        Op::GetElementPtr => {
            let mut indices: Vec<IntValue> = Vec::new();
            for i in 1..inst.get_num_operands() {
                indices.push(op(i).into_int_value());
            }
            let gep_ty = inst.get_gep_source_element_type().unwrap();
            unsafe { builder.build_gep(gep_ty, op(0).into_pointer_value(), &indices, &name)? }
                .as_basic_value_enum()
        }

        // ── Memory ──────────────────────────────────────────────────────
        Op::Load => {
            let ty: BasicTypeEnum = inst
                .get_type()
                .try_into()
                .expect("Load result type should be a BasicType");
            builder.build_load(ty, op(0).into_pointer_value(), &name)?
        }
        Op::Store => {
            builder.build_store(op(1).into_pointer_value(), op(0))?;
            return Ok(RebuildOutcome::Void);
        }

        // ── Calls ───────────────────────────────────────────────────────
        Op::Call => {
            let orig_callsite = CallSiteValue::try_from(inst)
                .map_err(|_| anyhow!("rebuild_inst: could not convert to CallSiteValue"))?;
            let orig_callee = required_called_function(orig_callsite, "rebuild_inst")?;
            let mut args = Vec::new();
            for i in 0..orig_callsite.count_arguments() {
                if let Some(v) = inst_operand_value(inst, i) {
                    args.push(remap(vmap, v).into());
                }
            }
            let new_callsite = builder.build_call(orig_callee, &args, &name)?;
            builder.position_at_end(into_block);
            return match new_callsite.try_as_basic_value() {
                ValueKind::Basic(bv) => Ok(RebuildOutcome::Value(bv)),
                ValueKind::Instruction(_) => Ok(RebuildOutcome::Void),
            };
        }

        _ => bail!("Instruction type not yet supported for rebuild: {}", inst),
    };

    Ok(RebuildOutcome::Value(result))
}

fn operand_as_value(op: Operand) -> Option<BasicValueEnum> {
    match op {
        Operand::Value(bv) => Some(bv),
        Operand::Block(_) => None,
    }
}

fn inst_operand_value(inst: InstructionValue, i: u32) -> Option<BasicValueEnum> {
    inst.get_operand(i).and_then(operand_as_value)
}

fn expect_inst_operand_value(inst: InstructionValue, i: u32) -> BasicValueEnum {
    inst.get_operand(i)
        .and_then(operand_as_value)
        .expect("Could not get operand value")
}

fn simp_cfg(module: &Module, target: &TargetMachine) -> Result<()> {
    module
        .run_passes("simplifycfg", target, PassBuilderOptions::create())
        .map_err(|e| anyhow!("Error running simplifycfg: {e}"))
}

fn value_key_from_instruction(inst: InstructionValue) -> ValueKey {
    inst.as_value_ref() as ValueKey
}

fn value_key_from_basic_value(value: BasicValueEnum) -> Option<ValueKey> {
    value.as_instruction_value().map(value_key_from_instruction)
}

/// Attempts to interpret an arbitrary LLVM value as an instruction.
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

/// Returns all instruction users of `value` that are outside `original_block`,
/// deduplicating by [`ValueKey`].
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

fn verify_module(module: &Module) -> Result<()> {
    module
        .verify()
        .map_err(|err| anyhow!("Error verifying module: {}", err.to_string()))
}

fn required_parent_block<'ctx>(
    inst: InstructionValue<'ctx>,
    context: &str,
) -> Result<BasicBlock<'ctx>> {
    inst.get_parent()
        .ok_or_else(|| anyhow!("{context}: instruction has no parent block"))
}

fn required_parent_function<'ctx>(
    bb: BasicBlock<'ctx>,
    context: &str,
) -> Result<FunctionValue<'ctx>> {
    bb.get_parent()
        .ok_or_else(|| anyhow!("{context}: block has no parent function"))
}

fn required_block_operand<'ctx>(
    inst: InstructionValue<'ctx>,
    idx: u32,
    context: &str,
) -> Result<BasicBlock<'ctx>> {
    operand_as_bb(inst, idx).ok_or_else(|| anyhow!("{context}: missing block operand {idx}"))
}

fn required_called_function<'ctx>(
    callsite: CallSiteValue<'ctx>,
    context: &str,
) -> Result<FunctionValue<'ctx>> {
    callsite
        .get_called_fn_value()
        .ok_or_else(|| anyhow!("{context}: indirect call is not supported"))
}

fn required_instruction_value<'ctx>(
    value: BasicValueEnum<'ctx>,
    context: &str,
) -> Result<InstructionValue<'ctx>> {
    value
        .as_instruction_value()
        .ok_or_else(|| anyhow!("{context}: expected instruction-backed value"))
}

/// Rebuilds a slice of instructions (ending with a terminator) into
/// `into_block`, remapping operands through `vmap`. Optionally collects
/// produced values into `produced_values`.
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

// ═══════════════════════════════════════════════════════════════════════════
// Tests
// ═══════════════════════════════════════════════════════════════════════════

#[cfg(test)]
mod test {
    use super::*;
    use crate::inkwell::context::Context;
    use crate::inkwell::memory_buffer::MemoryBuffer;
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

    fn load_module_from_ir<'ctx>(
        context: &'ctx Context,
        name: &str,
        ir: &str,
    ) -> Result<Module<'ctx>> {
        let mut ir_bytes = ir.as_bytes().to_vec();
        if ir_bytes.last() != Some(&0) {
            ir_bytes.push(0);
        }
        let buffer = MemoryBuffer::create_from_memory_range_copy(&ir_bytes, name);
        context
            .create_module_from_ir(buffer)
            .map_err(|err| anyhow!("Failed to parse inline IR {name}: {}", err.to_string()))
    }

    fn count_lowerable_values(module: &Module) -> usize {
        module
            .get_functions()
            .map(|func| analyze_function(func).unwrap_or_default().len())
            .sum()
    }

    fn default_target_machine() -> TargetMachine {
        use crate::inkwell::targets::{InitializationConfig, Target};

        Target::initialize_all(&InitializationConfig::default());
        let triple = TargetMachine::get_default_triple();
        let target = Target::from_triple(&triple).unwrap();
        target
            .create_target_machine(
                &triple,
                "generic",
                "",
                crate::inkwell::OptimizationLevel::None,
                crate::inkwell::targets::RelocMode::Default,
                crate::inkwell::targets::CodeModel::Default,
            )
            .unwrap()
    }

    fn fixture_snapshot_suffix(fixture: &str) -> String {
        fixture
            .strip_suffix(".ll")
            .unwrap_or(fixture)
            .replace(|ch: char| !ch.is_ascii_alphanumeric(), "_")
    }

    fn normalized_module_ir_for_snapshot(module: &Module, fixture: &str) -> String {
        let normalized_module_id = format!(
            "; ModuleID = '<fixture:{}>'",
            fixture.strip_suffix(".ll").unwrap_or(fixture)
        );

        module
            .to_string()
            .lines()
            .map(|line| {
                if line.starts_with("; ModuleID = ") {
                    normalized_module_id.clone()
                } else if line.starts_with("target datalayout = ") {
                    "target datalayout = \"<normalized>\"".to_string()
                } else if line.starts_with("target triple = ") {
                    "target triple = \"<normalized>\"".to_string()
                } else {
                    line.to_string()
                }
            })
            .collect::<Vec<_>>()
            .join("\n")
    }

    fn count_record_output_calls(module: &Module) -> usize {
        module
            .get_functions()
            .flat_map(|function| function.get_basic_blocks())
            .flat_map(|block| block.get_instructions())
            .filter(|inst| inst.get_opcode() == InstructionOpcode::Call)
            .filter(|inst| {
                CallSiteValue::try_from(*inst)
                    .ok()
                    .and_then(|cs| cs.get_called_fn_value())
                    .and_then(|callee| callee.get_name().to_str().ok().map(str::to_owned))
                    .is_some_and(|name| is_record_output_runtime_call(&name))
            })
            .count()
    }

    fn prepare_module_final_block<'ctx>(
        module: &Module<'ctx>,
        function_name: &str,
    ) -> BasicBlock<'ctx> {
        let function = module
            .get_function(function_name)
            .unwrap_or_else(|| panic!("expected function {function_name}"));
        find_prepare_module_record_final_block(function)
            .unwrap()
            .unwrap_or_else(|| panic!("expected final prepare_module block in {function_name}"))
    }

    fn assert_lowering_fixture(
        fixture: &str,
        pass: impl Fn(&Module) -> Result<bool>,
        counter: impl Fn(&Module) -> usize,
        expected_kind: &str,
        snapshot_name: &str,
    ) {
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_fixture(&context, fixture).unwrap();

        let before = counter(&module);
        assert!(
            before > 0,
            "expected fixture {fixture} to contain at least one lowerable {expected_kind}"
        );

        let changed = pass(&module).unwrap();
        let after = counter(&module);

        assert!(changed, "expected pass to change fixture {fixture}");
        assert_eq!(
            after, 0,
            "expected pass to remove all lowerable {expected_kind} in fixture {fixture}"
        );
        module.verify().unwrap();

        let mut settings = insta::Settings::clone_current();
        let suffix = settings.snapshot_suffix().map_or_else(
            || fixture_snapshot_suffix(fixture),
            |existing| format!("{existing}_{}", fixture_snapshot_suffix(fixture)),
        );
        settings.set_snapshot_suffix(suffix);
        settings.bind(|| {
            assert_snapshot!(
                snapshot_name,
                normalized_module_ir_for_snapshot(&module, fixture)
            );
        });
    }

    #[rstest]
    #[case("generates-qubit-selects-1-example.ll")]
    #[case("generates-qubit-selects-2-example.ll")]
    #[case("toric_code_example.ll")]
    #[case("simple_qubit_select.ll")]
    #[case("simple_qubit_phi.ll")]
    #[case("multiple_qubit_phis_in_block.ll")]
    #[case("select_with_record_output.ll")]
    #[case("select_with_downstream_phi.ll")]
    #[case("tail_float_casts_and_cmp.ll")]
    #[case("tail_gep_bitcast_and_call.ll")]
    #[case("tail_switch_terminator.ll")]
    #[case("tail_unreachable_terminator.ll")]
    #[case("tail_record_output_and_downstream_phi.ll")]
    #[case("tail_call_result_downstream_phi.ll")]
    #[case("qubit_phi_with_constant_successor_incoming.ll")]
    #[case("simple_float_select.ll")]
    #[case("simple_float_phi.ll")]
    #[case("single_float_phi.ll")]
    #[case("float_select_with_downstream_call.ll")]
    #[case("float_phi_with_constant_successor_incoming.ll")]
    fn lowers_all_lowerable_values_from_fixture(#[case] fixture: &str) {
        let tm = default_target_machine();
        assert_lowering_fixture(
            fixture,
            |module| lower_qubit_and_float_selects_and_phis(module, &tm),
            count_lowerable_values,
            "select or phi",
            "lowered",
        );
    }

    #[test]
    fn tail_int_ptr_casts_rejected() {
        // Arithmetic on qubit pointer values (shl, or, add between ptrtoint and
        // inttoptr) is unsupported. The analysis should detect this and abort
        // with an error.
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_fixture(&context, "tail_int_ptr_casts.ll").unwrap();
        let tm = default_target_machine();
        let err = lower_qubit_and_float_selects_and_phis(&module, &tm)
            .unwrap_err()
            .to_string();
        assert!(
            err.contains("unsupported operation on qubit pointer value"),
            "expected unsupported-operation error, got: {err}"
        );
    }

    #[test]
    fn rejects_too_many_select_conditions_select_only() {
        // 5 distinct select conditions → 2^5 = 32 duplicated successor blocks, exceeding
        // MAX_LOWERED_DUP_BLOCKS. This exercises the select-only code path
        // (no leading phis).
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "too_many_selects",
            r#"
%Qubit = type opaque

define void @main(i1 %c0, i1 %c1, i1 %c2, i1 %c3, i1 %c4) {
entry:
  %q0 = select i1 %c0, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q1 = select i1 %c1, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q2 = select i1 %c2, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q3 = select i1 %c3, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q4 = select i1 %c4, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  call void @__quantum__qis__h__body(%Qubit* %q0)
  call void @__quantum__qis__h__body(%Qubit* %q1)
  call void @__quantum__qis__h__body(%Qubit* %q2)
  call void @__quantum__qis__h__body(%Qubit* %q3)
  call void @__quantum__qis__h__body(%Qubit* %q4)
  ret void
}

declare void @__quantum__qis__h__body(%Qubit*)
"#,
        )
        .unwrap();

        let tm = default_target_machine();
        let err = lower_qubit_and_float_selects_and_phis(&module, &tm)
            .unwrap_err()
            .to_string();
        assert!(
            err.contains("exceeding the limit"),
            "expected dup-block limit error, got: {err}"
        );
    }

    #[test]
    fn rejects_too_many_select_conditions_full_block() {
        // 2 predecessors × 2^4 = 32 duplicated successor blocks, exceeding
        // MAX_LOWERED_DUP_BLOCKS. This exercises the full-block code path
        // (block has leading phis).
        let _guard = crate::test::LLVM_TEST_LOCK.lock().unwrap();
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "too_many_selects_phi",
            r#"
%Qubit = type opaque

define void @main(i1 %c0, i1 %c1, i1 %c2, i1 %c3, i1 %entry_cond) {
entry:
  br i1 %entry_cond, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %phi_q = phi %Qubit* [null, %left], [inttoptr (i64 1 to %Qubit*), %right]
  %q0 = select i1 %c0, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q1 = select i1 %c1, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q2 = select i1 %c2, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  %q3 = select i1 %c3, %Qubit* null, %Qubit* inttoptr (i64 1 to %Qubit*)
  call void @__quantum__qis__h__body(%Qubit* %phi_q)
  call void @__quantum__qis__h__body(%Qubit* %q0)
  call void @__quantum__qis__h__body(%Qubit* %q1)
  call void @__quantum__qis__h__body(%Qubit* %q2)
  call void @__quantum__qis__h__body(%Qubit* %q3)
  ret void
}

declare void @__quantum__qis__h__body(%Qubit*)
"#,
        )
        .unwrap();

        let tm = default_target_machine();
        let err = lower_qubit_and_float_selects_and_phis(&module, &tm)
            .unwrap_err()
            .to_string();
        assert!(
            err.contains("exceeding the limit"),
            "expected dup-block limit error, got: {err}"
        );
    }

    #[test]
    fn rejects_invalid_input_module_before_lowering() {
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "invalid_input_module",
            r#"
; ModuleID = 'invalid_input_module'
source_filename = "invalid_input_module"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%Qubit = type opaque

define void @__hugr__.main.1(i1 %cond) {
entry:
  br i1 %cond, label %then, label %else

then:
  br label %merge

else:
  br label %merge

merge:
  %selected = phi %Qubit* [ null, %entry ], [ inttoptr (i64 1 to %Qubit*), %else ]
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
"#,
        )
        .unwrap();

        let tm = default_target_machine();
        let err = lower_qubit_and_float_selects_and_phis(&module, &tm)
            .unwrap_err()
            .to_string();
        assert!(
            err.contains(
                "Verification failed for input module to lower_qubit_and_float_selects_and_phis pass"
            ),
            "unexpected error: {err}"
        );
    }

    #[test]
    fn prepare_module_moves_record_output_calls_to_final_block_and_is_idempotent() {
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "prepare_module_idempotent",
            r#"
declare void @__quantum__rt__bool_record_output(i1, i8*)
declare void @__quantum__rt__int_record_output(i64, i8*)

define void @main(i1 %cond, i1 %flag) {
entry:
  br i1 %cond, label %left, label %right

left:
  call void @__quantum__rt__bool_record_output(i1 %flag, i8* null)
  br label %merge

right:
  call void @__quantum__rt__int_record_output(i64 7, i8* null)
  br label %merge

merge:
  ret void
}
"#,
        )
        .unwrap();

        assert_eq!(count_record_output_calls(&module), 2);

        prepare_module(&module).unwrap();
        verify_module(&module).unwrap();

        let final_block = prepare_module_final_block(&module, "main");
        assert_eq!(
            name_of_block(final_block),
            PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME
        );
        assert!(block_is_prepare_module_record_final_block(final_block).unwrap());

        let main_fn = module.get_function("main").unwrap();
        let return_blocks: Vec<_> = main_fn
            .get_basic_blocks()
            .into_iter()
            .filter(|bb| {
                bb.get_terminator()
                    .is_some_and(|term| term.get_opcode() == InstructionOpcode::Return)
            })
            .collect();
        assert_eq!(return_blocks, vec![final_block]);

        for block in main_fn.get_basic_blocks() {
            if block == final_block {
                continue;
            }
            for inst in block.get_instructions() {
                if inst.get_opcode() != InstructionOpcode::Call {
                    continue;
                }
                let cs = CallSiteValue::try_from(inst).unwrap();
                let is_record_call = cs
                    .get_called_fn_value()
                    .and_then(|callee| callee.get_name().to_str().ok().map(str::to_owned))
                    .is_some_and(|name| is_record_output_runtime_call(&name));
                assert!(
                    !is_record_call,
                    "found record_output call outside final block in {}",
                    name_of_block(block)
                );
            }
        }

        let after_first_prepare = module.to_string();
        prepare_module(&module).unwrap();
        verify_module(&module).unwrap();
        let after_second_prepare = module.to_string();

        assert_eq!(after_first_prepare, after_second_prepare);
    }

    #[test]
    fn normalize_block_names_renames_only_purely_numeric_labels() {
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "normalize_block_names",
            r#"
define void @main(i1 %cond) {
entry:
  br i1 %cond, label %0, label %_kept

0:
  br label %1

_kept:
  br label %1

1:
  ret void
}
"#,
        )
        .unwrap();

        assert!(normalize_block_names(&module));

        let main_fn = module.get_function("main").unwrap();
        for block in main_fn.get_basic_blocks() {
            let block_name = name_of_block(block);
            assert!(
                !is_purely_numeric_block_name(&block_name),
                "block name is still purely numeric: {block_name}"
            );
        }

        assert!(
            main_fn
                .get_basic_blocks()
                .into_iter()
                .any(|block| name_of_block(block) == "_kept"),
            "underscore-prefixed block name was renamed"
        );
    }

    #[test]
    fn conditional_branch_operand_order_matches_ir() {
        let context = Context::create();
        let module = load_module_from_ir(
            &context,
            "condbr_operand_order",
            r#"
define void @main(i1 %cond) {
entry:
  br i1 %cond, label %then_block, label %else_block

then_block:
  ret void

else_block:
  ret void
}
"#,
        )
        .unwrap();

        let main_fn = module.get_function("main").unwrap();
        let entry = main_fn.get_first_basic_block().unwrap();
        let term = entry.get_terminator().unwrap();
        assert!(term.is_conditional().unwrap());

        let op1 =
            required_block_operand(term, 1, "conditional_branch_operand_order_matches_ir").unwrap();
        let op2 =
            required_block_operand(term, 2, "conditional_branch_operand_order_matches_ir").unwrap();

        assert_eq!(name_of_block(op1), "else_block");
        assert_eq!(name_of_block(op2), "then_block");
    }
}
