//! Utilities for squashing any ssa variables to QUBIT pointers.
//!
//! For OG systems, these cannot be used as input to qis functions,
//! because dynamic addressing of qubits is not allowed

use crate::inkwell::basic_block::BasicBlock;
use crate::inkwell::builder::Builder;
use crate::inkwell::module::Module;
use crate::inkwell::passes::PassBuilderOptions;
use crate::inkwell::targets::TargetMachine;
use crate::inkwell::types::{AnyTypeEnum, BasicTypeEnum};
use crate::inkwell::values::{AnyValue, InstructionOpcode as Op};
use crate::inkwell::values::{
    AnyValueEnum, AsValueRef, BasicMetadataValueEnum, BasicValue, BasicValueEnum, CallSiteValue,
    FunctionValue, InstructionOpcode, InstructionValue, Operand, PhiValue, ValueKind,
};
use anyhow::{Result, anyhow, bail};
use std::collections::{HashMap, HashSet};

type ValueKey = usize;

#[derive(Clone, Copy)]
enum LoweredSsaKind {
    QubitPointer,
    Float,
}

/// Lowers select and phi instructions returning QUBIT* to control flow.
/// These can be introduced through llvm optimizations to reduce branching.
/// Lowers select instructions to branching + possible additional phi's,
/// then lowers any remaining phis
pub fn lower_qubit_selects_and_phis(module: &Module, target: &TargetMachine) -> Result<bool> {
    verify_module(module).map_err(|err| {
        anyhow!("Verification failed for input module to lower_qubit_selects_and_phis pass: {err}")
    })?;
    let mut qubit_values = collect_qubit_select_and_phi_values(module);
    if qubit_values.is_empty() {
        return Ok(false);
    }
    prepare_module(module)?;
    let lowered_selects = lower_qubit_selects(module, &mut qubit_values)?;
    let lowered_phis = lower_qubit_phis(module, &mut qubit_values)?;
    let changed = lowered_selects || lowered_phis;
    if changed {
        simp_cfg(module, target)?;
        // `simplifycfg` can (legally) move/duplicate the final record-output block.
        // Re-run `prepare_module` to re-canonicalize record-output calls into a single sink.
        prepare_module(module)?;
    }
    verify_module(module)?;
    Ok(changed)
}

/// Lowers select and phi instructions returning floating-point values to control flow.
///
/// This follows the same lowering strategy as the qubit-pointer pass, but does not
/// run CFG simplification afterward because that can reintroduce float phis.
pub fn lower_float_selects_and_phis(module: &Module) -> Result<bool> {
    verify_module(module).map_err(|err| {
        anyhow!("Verification failed for input module to lower_float_selects_and_phis pass: {err}")
    })?;
    if !module_has_lowerable_float_selects_or_phis(module) {
        return Ok(false);
    }
    prepare_module(module)?;
    let lowered_selects = lower_float_selects(module)?;
    let lowered_phis = lower_float_phis(module)?;
    let changed = lowered_selects || lowered_phis;
    // Don't run simp_cfg, may reintroduce float selects/phis
    verify_module(module)?;
    Ok(changed)
}

/// Returns whether the module contains at least one floating-point `select` or
/// `phi` that this pass is expected to lower.
fn module_has_lowerable_float_selects_or_phis(module: &Module) -> bool {
    module_has_lowerable_selects_or_phis_matching(
        module,
        is_lowerable_float_select_or_phi_instruction,
    )
}

/// Returns whether the module contains at least one `select` or `phi` matching
/// the provided lowering predicate.
fn module_has_lowerable_selects_or_phis_matching(
    module: &Module,
    predicate: impl Fn(InstructionValue) -> bool + Copy,
) -> bool {
    module.get_functions().any(|function| {
        function
            .get_basic_blocks()
            .iter()
            .any(|block| block.get_instructions().any(predicate))
    })
}

/// Checks whether a single instruction matches the float lowering criteria:
/// opcode `select` or `phi`, result type `FloatType`.
fn is_lowerable_float_select_or_phi_instruction(inst: InstructionValue) -> bool {
    matches!(
        inst.get_opcode(),
        InstructionOpcode::Select | InstructionOpcode::Phi
    ) && matches_lowered_any_type(inst.get_type(), LoweredSsaKind::Float)
}

/// Returns whether an LLVM type matches the lowering kind.
fn matches_lowered_any_type(ty: AnyTypeEnum, kind: LoweredSsaKind) -> bool {
    matches!(
        (ty, kind),
        (AnyTypeEnum::FloatType(_), LoweredSsaKind::Float)
    )
}

/// Returns whether a basic type matches the lowering kind.
fn matches_lowered_basic_type(ty: BasicTypeEnum, kind: LoweredSsaKind) -> bool {
    matches!(
        (ty, kind),
        (BasicTypeEnum::FloatType(_), LoweredSsaKind::Float)
    )
}

/// Human-readable description of the lowering kind for diagnostics.
fn lowered_kind_description(kind: LoweredSsaKind) -> &'static str {
    match kind {
        LoweredSsaKind::QubitPointer => "qubit pointer",
        LoweredSsaKind::Float => "floating-point",
    }
}

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

fn collect_qubit_select_and_phi_values(module: &Module) -> HashSet<ValueKey> {
    let mut qubit_values = HashSet::new();

    for function in module.get_functions() {
        for block in function.get_basic_blocks() {
            for inst in block.get_instructions() {
                if inst.get_opcode() != InstructionOpcode::Call {
                    continue;
                }
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
                    add_qubit_value_transitively(arg_inst, &mut qubit_values);
                }
            }
        }
    }

    qubit_values
}

/// Adds `inst` to `qubit_values` if it is a `select` or `phi`, then recursively
/// adds any upstream `select`/`phi` instructions reachable through its value operands.
///
/// `inttoptr` and `ptrtoint` casts are transparent: the chain is followed through
/// them without adding the cast itself to `qubit_values`.
///
/// For `select`, operand 0 is the i1 condition and is skipped; operands 1 and 2 are
/// the value arms.  For `phi`, `inst_operand_value` returns `None` for the
/// interleaved basic-block operands, so only the value slots are followed.
fn add_qubit_value_transitively(inst: InstructionValue, qubit_values: &mut HashSet<ValueKey>) {
    match inst.get_opcode() {
        InstructionOpcode::IntToPtr | InstructionOpcode::PtrToInt => {
            // Transparent: follow through the cast to find upstream selects/phis.
            if let Some(operand) = inst_operand_value(inst, 0)
                && let Some(operand_inst) = operand.as_instruction_value()
            {
                add_qubit_value_transitively(operand_inst, qubit_values);
            }
        }
        InstructionOpcode::Select | InstructionOpcode::Phi => {
            let key = value_key_from_instruction(inst);
            if !qubit_values.insert(key) {
                return; // already visited — prevents loops
            }
            let n = inst.get_num_operands();
            // Skip the i1 condition (operand 0) for select.
            let start = if inst.get_opcode() == InstructionOpcode::Select {
                1
            } else {
                0
            };
            for i in start..n {
                if let Some(operand) = inst_operand_value(inst, i)
                    && let Some(operand_inst) = operand.as_instruction_value()
                {
                    add_qubit_value_transitively(operand_inst, qubit_values);
                }
            }
        }
        _ => {}
    }
}

/// Returns whether an instruction is a lowerable floating-point `select`.
fn is_lowerable_float_select(inst: InstructionValue) -> bool {
    inst.get_opcode() == InstructionOpcode::Select
        && matches_lowered_any_type(inst.get_type(), LoweredSsaKind::Float)
}

/// Returns whether a phi is a lowerable floating-point phi.
fn is_lowerable_float_phi(phi: PhiValue) -> bool {
    matches_lowered_basic_type(phi.as_basic_value().get_type(), LoweredSsaKind::Float)
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
            let is_cond = term.is_conditional().unwrap();
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

/// Returns true for runtime record-output functions such as
/// `__quantum__rt__bool_record_output` and `__quantum__rt__int_record_output`.
fn is_record_output_runtime_call(name: &str) -> bool {
    name.starts_with("__quantum__rt__") && name.ends_with("_record_output")
}

const PREPARE_MODULE_RECORD_FINAL_BLOCK_NAME: &str = "__prepare_module_record_output_final";

/// Normalizes the module before select/phi lowering.
///
/// At present this moves runtime `*_record_output` calls to a single sink at
/// the end of each function so later tail duplication cannot duplicate them.
fn prepare_module(module: &Module) -> Result<()> {
    for func in module.get_functions() {
        move_record_output_calls_to_function_end(func)?;
    }
    Ok(())
}

/// Moves all movable `*_record_output` calls in a function into a single final
/// block at the end of the function.
///
/// The final block is named so it can be recognized on later runs of
/// `prepare_module`. Its shape is:
/// - optional leading phis
/// - direct `*_record_output` calls only
/// - a return terminator
///
/// If such a block already exists and is the only return point in the function,
/// newly discovered record-output calls are appended to the start of that block
/// rather than creating another sink.
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

/// Lower all pointer-typed `select` on qubits to explicit control flow by introducing
/// a then/else diamond and a merge PHI, then using phi elimination to remove phi.
/// May introduce new phis downstream
pub fn lower_qubit_selects(module: &Module, qubit_values: &mut HashSet<ValueKey>) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;

    for func in module.get_functions() {
        let mut block_opt = func.get_last_basic_block();
        while let Some(bb) = block_opt {
            let last_sel = get_last_qubit_select_in_block(bb, qubit_values);
            if let Some(sel) = last_sel {
                lower_one_select_to_control_flow(
                    module,
                    &builder,
                    sel,
                    LoweredSsaKind::QubitPointer,
                    qubit_values,
                )?;
                changed = true;
            } else {
                block_opt = bb.get_previous_basic_block();
            }
        }
    }
    Ok(changed)
}

/// Lower all floating-point `select` instructions to explicit control flow.
pub fn lower_float_selects(module: &Module) -> Result<bool> {
    lower_matching_selects(
        module,
        is_lowerable_float_select,
        LoweredSsaKind::Float,
        &mut HashSet::new(),
    )
}

/// Lowers all `select` instructions matched by `matches_select` using reverse
/// block and instruction order.
fn lower_matching_selects(
    module: &Module,
    matches_select: impl Fn(InstructionValue) -> bool + Copy,
    kind: LoweredSsaKind,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;

    for func in module.get_functions() {
        let mut block_opt = func.get_last_basic_block();
        while let Some(bb) = block_opt {
            if let Some(last_sel) = get_last_matching_select_in_block(bb, matches_select) {
                lower_one_select_to_control_flow(module, &builder, last_sel, kind, qubit_values)?;
                changed = true;
            } else {
                block_opt = bb.get_previous_basic_block();
            }
        }
    }
    Ok(changed)
}

/// Returns the last matching `select` in `bb`, if any.
fn get_last_matching_select_in_block(
    bb: BasicBlock,
    matches_select: impl Fn(InstructionValue) -> bool,
) -> Option<InstructionValue> {
    let mut it = bb.get_last_instruction();
    while let Some(i) = it {
        it = i.get_previous_instruction();
        if matches_select(i) {
            return Some(i);
        }
    }
    None
}

/// Returns the last qubit select in `bb` according to the current `qubit_values` set.
fn get_last_qubit_select_in_block<'ctx>(
    bb: BasicBlock<'ctx>,
    qubit_values: &HashSet<ValueKey>,
) -> Option<InstructionValue<'ctx>> {
    get_last_matching_select_in_block(bb, |inst| {
        inst.get_opcode() == InstructionOpcode::Select
            && qubit_values.contains(&value_key_from_instruction(inst))
    })
}

/// Lowers one qubit-pointer `select` into an explicit then/else/merge diamond and then duplicates
/// the merge block using tail duplication
///
/// The original tail after the select is rebuilt into the merge block. Afterward, this introduces
/// a phi instruction in the merge block which is immediately lowered. This will introduce new qubit
/// typed phis downstream if there were downstream users of the select and these phis
/// are not lowered here. They can be removed using the dedicated phi lowering pass.
fn lower_one_select_to_control_flow<'ctx>(
    module: &'ctx Module,
    builder: &Builder<'ctx>,
    sel: InstructionValue<'ctx>,
    kind: LoweredSsaKind,
    qubit_values: &mut HashSet<ValueKey>,
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

    validate_select_lowering(sel, &tail, kind)?;

    // Create THEN, ELSE, MERGE blocks and append to function
    let ctx = bb.get_context();

    let block_base_name = synthetic_block_base_name(bb);
    let then_bb = ctx.insert_basic_block_after(bb, &format!("{block_base_name}.sel.then"));
    let else_bb = ctx.insert_basic_block_after(then_bb, &format!("{block_base_name}.sel.else"));
    let merge_bb = ctx.insert_basic_block_after(else_bb, &format!("{block_base_name}.sel.merge"));

    // Build PHI in merge (must be first in the block)
    builder.position_at_end(merge_bb);
    let phi = builder.build_phi(phi_ty, "select.merge.val")?;
    phi.add_incoming(&[(&tval, then_bb), (&fval, else_bb)]);
    if matches!(kind, LoweredSsaKind::QubitPointer) {
        qubit_values.insert(value_key_from_instruction(phi.as_instruction()));
    }

    // Rebuild the original tail into merge, remapping %sel -> %phi
    let mut vmap: HashMap<ValueKey, BasicValueEnum> = HashMap::new();
    vmap.insert(value_key_from_instruction(sel), phi.as_basic_value());

    rebuild_tail(
        builder,
        merge_bb,
        &tail,
        &mut vmap,
        None,
        &format!("{} select block tail", lowered_kind_description(kind)),
    )?;
    rewrite_external_uses_to_vmap(bb, &vmap)?;

    // Now that merge has a full copy of the tail (including the original terminator),
    // erase the original tail from `bb` and replace it with br i1 %cond, %then, %else.
    builder.position_at_end(bb);
    for &i in tail.iter().rev() {
        forget_qubit_value(i, qubit_values);
        i.erase_from_basic_block();
    }
    builder.build_conditional_branch(cond, then_bb, else_bb)?;
    builder.position_at_end(then_bb);
    builder.build_unconditional_branch(merge_bb)?;
    builder.position_at_end(else_bb);
    builder.build_unconditional_branch(merge_bb)?;

    if let Some(merge_term) = merge_bb.get_terminator() {
        fix_successor_phis_block_rename(merge_term, bb, merge_bb, &vmap, qubit_values)?;
    }
    forget_qubit_value(sel, qubit_values);
    sel.erase_from_basic_block();
    lower_successive_phis_in_block(module, builder, merge_bb, vec![phi], qubit_values)?;
    collapse_trivial_select_dispatch_blocks(builder, bb, then_bb, else_bb, qubit_values)?;
    Ok(())
}

/// Collapses the trivial `sel.then` / `sel.else` forwarding blocks left behind
/// after select-lowering-induced phi elimination.
///
/// After the merge phi has been lowered, these blocks normally contain only an
/// unconditional branch to the duplicated tails. In that case we retarget the
/// original conditional branch to those real tail blocks directly and delete the
/// forwarding blocks.
fn collapse_trivial_select_dispatch_blocks<'ctx>(
    builder: &Builder<'ctx>,
    source_bb: BasicBlock<'ctx>,
    then_bb: BasicBlock<'ctx>,
    else_bb: BasicBlock<'ctx>,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    let Some(source_term) = source_bb.get_terminator() else {
        return Ok(());
    };
    if source_term.get_opcode() != InstructionOpcode::Br || !source_term.is_conditional().unwrap() {
        return Ok(());
    }

    if !block_is_trivial_unconditional_branch(then_bb)
        || !block_is_trivial_unconditional_branch(else_bb)
    {
        return Ok(());
    }

    let cond = expect_inst_operand_value(source_term, 0).into_int_value();
    let direct_then = required_block_operand(
        then_bb.get_terminator().ok_or_else(|| {
            anyhow!("collapse_trivial_select_dispatch_blocks: missing then terminator")
        })?,
        0,
        "collapse_trivial_select_dispatch_blocks",
    )?;
    let direct_else = required_block_operand(
        else_bb.get_terminator().ok_or_else(|| {
            anyhow!("collapse_trivial_select_dispatch_blocks: missing else terminator")
        })?,
        0,
        "collapse_trivial_select_dispatch_blocks",
    )?;

    // If both forwarding blocks jump to the same destination, then they may be
    // deliberately distinguishing control-flow for PHIs in that destination. Don't
    // collapse in that case.
    if direct_then == direct_else {
        return Ok(());
    }

    builder.position_at_end(source_bb);
    source_term.erase_from_basic_block();
    builder.build_conditional_branch(cond, direct_then, direct_else)?;

    // The branch now targets `direct_then`/`direct_else` from `source_bb`, so any PHIs
    // in those destination blocks must update their incoming blocks accordingly.
    rewrite_successor_phis_for_edge_change(direct_then, then_bb, Some(source_bb), qubit_values)?;
    rewrite_successor_phis_for_edge_change(direct_else, else_bb, Some(source_bb), qubit_values)?;

    erase_all_instructions_in_block(then_bb, qubit_values);
    erase_all_instructions_in_block(else_bb, qubit_values);
    then_bb
        .remove_from_function()
        .expect("collapse_trivial_select_dispatch_blocks: failed to remove then block");
    else_bb
        .remove_from_function()
        .expect("collapse_trivial_select_dispatch_blocks: failed to remove else block");
    let _ = then_bb;
    let _ = else_bb;

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
fn validate_select_lowering(
    sel: InstructionValue,
    tail: &[InstructionValue],
    kind: LoweredSsaKind,
) -> Result<()> {
    validate_rebuildable_tail_slice(tail).map_err(|err| {
        anyhow!(
            "{} select block tail cannot be lowered: {err}",
            lowered_kind_description(kind)
        )
    })?;
    match kind {
        LoweredSsaKind::QubitPointer => Ok(()),
        LoweredSsaKind::Float => {
            if matches_lowered_any_type(sel.get_type(), kind) {
                Ok(())
            } else {
                bail!(
                    "Select lowering only supports {} results",
                    lowered_kind_description(kind)
                )
            }
        }
    }
}

/// Replace PHI incoming `(…, old_bb)` → `(…, new_bb)` for *all* PHIs in each successor
/// of `term` (supports unconditional/conditional br). Extend for `switch` if needed.
fn fix_successor_phis_block_rename<'ctx>(
    term: InstructionValue<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    vmap: &HashMap<ValueKey, BasicValueEnum<'ctx>>,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    match term.get_opcode() {
        Op::Br => {
            let is_cond = term.is_conditional().unwrap();
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
                rename_incoming_block_in_phis(s, old_bb, new_bb, vmap, qubit_values)?;
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
                rename_incoming_block_in_phis(succ, old_bb, new_bb, vmap, qubit_values)?;
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
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    let mut it = succ_bb.get_first_instruction();
    while let Some(inst) = it {
        if inst.get_opcode() != Op::Phi {
            break;
        }
        let phi: PhiValue = inst.try_into().unwrap();
        let incomings = phi.get_incomings();

        if !incomings.into_iter().any(|(_, b)| b == old_bb) {
            it = inst.get_next_instruction();
            continue;
        }

        let incomings = phi.get_incomings();
        let ty: BasicTypeEnum = phi.as_basic_value().get_type();
        let old_phi_key = value_key_from_instruction(inst);
        let builder = succ_bb.get_context().create_builder();
        builder.position_before(&inst);
        let new_phi = builder.build_phi(ty, "phi.fix")?;
        if qubit_values.contains(&old_phi_key) {
            qubit_values.insert(value_key_from_instruction(new_phi.as_instruction()));
        }

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
        forget_qubit_value(inst, qubit_values);
        inst.erase_from_basic_block();
        it = new_phi.as_instruction().get_next_instruction();
    }
    Ok(())
}

/// Rewrites leading PHIs in `succ_bb` so that any incoming edge from `old_bb`
/// is rewritten to come from `new_bb` (or dropped when `new_bb` is `None`).
///
/// This is used when we retarget branches and then remove now-dead forwarding
/// blocks from the function.
fn rewrite_successor_phis_for_edge_change<'ctx>(
    succ_bb: BasicBlock<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: Option<BasicBlock<'ctx>>,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    let mut it = succ_bb.get_first_instruction();
    while let Some(inst) = it {
        if inst.get_opcode() != Op::Phi {
            break;
        }

        let phi: PhiValue = inst.try_into().unwrap();
        let incomings: Vec<_> = phi.get_incomings().collect();

        if !incomings.iter().any(|(_, b)| *b == old_bb) {
            it = inst.get_next_instruction();
            continue;
        }

        let ty: BasicTypeEnum = phi.as_basic_value().get_type();
        let old_phi_key = value_key_from_instruction(inst);
        let builder = succ_bb.get_context().create_builder();
        builder.position_before(&inst);
        let new_phi = builder.build_phi(ty, "phi.edge")?;
        if qubit_values.contains(&old_phi_key) {
            qubit_values.insert(value_key_from_instruction(new_phi.as_instruction()));
        }

        let mut incoming_by_block: HashMap<usize, BasicValueEnum<'ctx>> = HashMap::new();
        for (val, inc_bb) in incomings {
            let mapped_bb = if inc_bb == old_bb {
                new_bb
            } else {
                Some(inc_bb)
            };
            let Some(mapped_bb) = mapped_bb else {
                continue;
            };
            let key = mapped_bb.as_mut_ptr() as usize;
            match incoming_by_block.entry(key) {
                std::collections::hash_map::Entry::Vacant(e) => {
                    e.insert(val);
                    new_phi.add_incoming(&[(&val, mapped_bb)]);
                }
                std::collections::hash_map::Entry::Occupied(e) => {
                    if e.get().as_value_ref() != val.as_value_ref() {
                        bail!(
                            "rewrite_successor_phis_for_edge_change: multiple distinct incoming values for the same predecessor block"
                        );
                    }
                }
            }
        }

        phi.replace_all_uses_with(&new_phi);
        forget_qubit_value(inst, qubit_values);
        inst.erase_from_basic_block();
        it = new_phi.as_instruction().get_next_instruction();
    }

    Ok(())
}

/// Lowers all phi instructions returning QUBIT* to control flow.
pub fn lower_qubit_phis(module: &Module, qubit_values: &mut HashSet<ValueKey>) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;
    for func in module.get_functions() {
        let mut block_opt = func.get_first_basic_block();
        while let Some(block) = block_opt {
            block_opt = block.get_next_basic_block();
            let phi_candidates = get_block_qubit_phis(block, qubit_values);
            if phi_candidates.is_empty() {
                continue;
            }
            if lower_successive_phis_in_block(
                module,
                &builder,
                block,
                phi_candidates,
                qubit_values,
            )? {
                verify_module(module).map_err(|err| {
                    anyhow!(
                        "Module verification failed after lowering {} phis in block {}: {err}",
                        lowered_kind_description(LoweredSsaKind::QubitPointer),
                        name_of_block(block)
                    )
                })?;
                changed = true;
            }
        }
    }
    Ok(changed)
}

/// Lowers all phi instructions returning floating-point values to control flow.
pub fn lower_float_phis(module: &Module) -> Result<bool> {
    lower_matching_phis(
        module,
        is_lowerable_float_phi,
        LoweredSsaKind::Float,
        &mut HashSet::new(),
    )
}

/// Lowers all leading block phis matched by `matches_phi`.
fn lower_matching_phis(
    module: &Module,
    matches_phi: impl Fn(PhiValue) -> bool + Copy,
    kind: LoweredSsaKind,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<bool> {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;
    for func in module.get_functions() {
        let mut block_opt = func.get_first_basic_block();
        while let Some(block) = block_opt {
            block_opt = block.get_next_basic_block();
            let phi_candidates = get_block_matching_phis(block, matches_phi);
            if phi_candidates.is_empty() {
                continue;
            }
            if lower_successive_phis_in_block(
                module,
                &builder,
                block,
                phi_candidates,
                qubit_values,
            )? {
                verify_module(module).map_err(|err| {
                    anyhow!(
                        "Module verification failed after lowering {} phis in block {}: {err}",
                        lowered_kind_description(kind),
                        name_of_block(block)
                    )
                })?;
                changed = true;
            }
        }
    }
    Ok(changed)
}

pub fn lower_successive_phis_in_block(
    _module: &Module,
    builder: &Builder,
    block: BasicBlock,
    phis: Vec<PhiValue>,
    qubit_values: &mut HashSet<ValueKey>,
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
        // Remove any incoming-from-`block` entries in successor PHIs before detaching.
        for succ in direct_successors(block)? {
            rewrite_successor_phis_for_edge_change(succ, block, None, qubit_values)?;
        }

        erase_all_instructions_in_block(block, qubit_values);
        block
            .remove_from_function()
            .expect("Tried to remove block without parent");
        let _ = block;
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
    reconcile_successor_phi_incoming_blocks_after_duplication(
        block,
        &clone_map,
        &clone_value_maps,
        qubit_values,
    )?;
    reconcile_external_uses_after_duplication(
        block,
        &clone_map,
        &clone_value_maps,
        &lowered_phi_keys,
        qubit_values,
    )?;

    // Now need to take care of any instructions that used the phi ssa variable
    // , e.g. function calls on the variable or additional phis
    for phi in phis {
        handle_phi_users(phi, block, &clone_map, qubit_values)?;
        let inst = phi.as_instruction();
        forget_qubit_value(inst, qubit_values);
        inst.erase_from_basic_block();
    }

    // Delete no longer needed block
    erase_all_instructions_in_block(block, qubit_values);
    block
        .remove_from_function()
        .expect("Tried to remove block without parent");
    let _ = block;
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
fn get_block_matching_phis(
    block: BasicBlock,
    matches_phi: impl Fn(PhiValue) -> bool,
) -> Vec<PhiValue> {
    let mut inst_opt = block.get_first_instruction();
    let mut phi_candidates: Vec<PhiValue> = Vec::new();
    while let Some(inst) = inst_opt {
        if inst.get_opcode() != InstructionOpcode::Phi {
            break;
        }
        let phi: PhiValue = inst.try_into().unwrap();
        if matches_phi(phi) {
            phi_candidates.push(phi);
        }
        inst_opt = inst.get_next_instruction();
    }
    phi_candidates
}

/// Collects leading phis in `block` that are tracked in `qubit_values`.
fn get_block_qubit_phis<'ctx>(
    block: BasicBlock<'ctx>,
    qubit_values: &HashSet<ValueKey>,
) -> Vec<PhiValue<'ctx>> {
    get_block_matching_phis(block, |phi| {
        qubit_values.contains(&value_key_from_instruction(phi.as_instruction()))
    })
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
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<usize> {
    let phi_users = plan_phi_user_rewrites(phi, phi_block, clone_for_pred)?;
    apply_phi_user_rewrites(phi, phi_block, clone_for_pred, &phi_users, qubit_values)
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
    qubit_values: &mut HashSet<ValueKey>,
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
                qubit_values,
            )?,
            InstructionOpcode::Call => rewrite_phi_user_as_call(
                phi,
                phi_block,
                u_inst,
                clone_for_pred,
                &sorted_incoming_by_pred,
                &mut available_value_cache,
                qubit_values,
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
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    let user_phi: PhiValue = user_inst.try_into().unwrap();
    let succ_bb = required_parent_block(user_inst, "rewrite_phi_user_as_phi")?;
    let incomings = user_phi.get_incomings();

    let ty: BasicTypeEnum = user_phi.as_basic_value().get_type();
    let old_phi_key = value_key_from_instruction(phi.as_instruction());
    let builder = succ_bb.get_context().create_builder();
    builder.position_before(&user_inst);
    let new_phi = builder.build_phi(ty, "phi.expanded")?;
    if qubit_values.contains(&old_phi_key) {
        qubit_values.insert(value_key_from_instruction(new_phi.as_instruction()));
    }

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
                qubit_values,
            )?;
            new_phi.add_incoming(&[(&available_value, inc_bb)]);
        }
    }

    user_phi.replace_all_uses_with(&new_phi);
    forget_qubit_value(user_inst, qubit_values);
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
    qubit_values: &mut HashSet<ValueKey>,
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
            qubit_values,
        )?
    };

    let cs: CallSiteValue = user_inst
        .try_into()
        .map_err(|_| anyhow!("rewrite_phi_user_as_call: planned call rewrite is not a call"))?;
    let callee = required_called_function(cs, "rewrite_phi_user_as_call")?;

    let old_val_ref = phi.as_basic_value().as_value_ref();
    let mut args: Vec<BasicMetadataValueEnum> = Vec::new();
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
    forget_qubit_value(user_inst, qubit_values);
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
    qubit_values: &mut HashSet<ValueKey>,
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
    let phi_key = value_key_from_instruction(phi.as_instruction());
    let helper_phi = builder.build_phi(phi.as_basic_value().get_type(), "phi.available")?;
    if qubit_values.contains(&phi_key) {
        qubit_values.insert(value_key_from_instruction(helper_phi.as_instruction()));
    }
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
                qubit_values,
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
                    if !term.is_conditional().unwrap() {
                        if operand_as_bb(term, 0) == Some(to) {
                            preds.push(b);
                        }
                    } else {
                        // Conditional: operand 1 = false-dest BB, operand 2 = true-dest BB
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

/// Remove a just-erased instruction's key from `qubit_values` to avoid
/// pointer-address reuse causing nondeterministic misclassification.
fn forget_qubit_value(inst: InstructionValue, qubit_values: &mut HashSet<ValueKey>) {
    qubit_values.remove(&value_key_from_instruction(inst));
}

/// Erases all instructions in `block` (including its terminator) in reverse order.
///
/// This is required before detaching a block from its parent function: otherwise the
/// now-parentless instructions can continue to reference globals and/or successor
/// blocks, breaking verification and potentially leading to LLVM crashes.
fn erase_all_instructions_in_block(block: BasicBlock, qubit_values: &mut HashSet<ValueKey>) {
    let mut inst_opt = block.get_last_instruction();
    while let Some(inst) = inst_opt {
        inst_opt = inst.get_previous_instruction();
        forget_qubit_value(inst, qubit_values);
        inst.erase_from_basic_block();
    }
}

/// Returns whether `from` has `to` as a direct successor through a supported terminator.
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

/// Returns the direct CFG successors of `bb` for the terminator kinds this pass
/// reasons about explicitly.
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

/// Returns whether a block contains *only* an unconditional branch terminator.
///
/// Important: we must not remove forwarding blocks that still contain PHIs,
/// because those PHI results can be used by downstream blocks. Deleting the block
/// would then leave dangling (`<badref>`) values.
fn block_is_trivial_unconditional_branch(bb: BasicBlock) -> bool {
    let Some(term) = bb.get_terminator() else {
        return false;
    };
    if term.get_opcode() != Op::Br || term.is_conditional().unwrap() {
        return false;
    }

    bb.get_first_instruction() == Some(term)
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

/// Returns a short stable base name for synthetic blocks created by this pass.
///
/// This prevents names from growing recursively as we duplicate/select-lower
/// blocks that were themselves created by earlier rounds of the pass.
fn synthetic_block_base_name(bb: BasicBlock<'_>) -> String {
    let name = name_of_block(bb);
    let mut base = name.as_str();

    for marker in [".sel.", ".select.", ".dup", ".record"] {
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
/// values for *all* leading PHIs in `block` on that edge.
///
/// We may be lowering only a subset of those PHIs (e.g. float-only), but we still
/// delete the entire block after tail duplication. Any remaining PHI values that
/// are referenced in the duplicated tail must therefore be remapped too.
fn phi_incoming_vmap_for_block_predecessor<'ctx>(
    block: BasicBlock<'ctx>,
    pred: BasicBlock<'ctx>,
) -> Result<HashMap<ValueKey, BasicValueEnum<'ctx>>> {
    let mut vmap = HashMap::new();

    for inst in block
        .get_instructions()
        .take_while(|inst| inst.get_opcode() == InstructionOpcode::Phi)
    {
        let phi: PhiValue<'ctx> = inst.try_into().unwrap();
        let (val, _) = incoming_for_predecessor(phi, pred)
            .ok_or_else(|| anyhow!("Missing phi incoming for predecessor during lowering"))?;
        let key = value_key_from_instruction(inst);
        vmap.insert(key, val);
    }

    Ok(vmap)
}

/// Builds one predecessor-specific clone block for a phi-only block lowering.
fn duplicate_phi_tail_for_predecessor<'ctx>(
    builder: &Builder<'ctx>,
    original_block: BasicBlock<'ctx>,
    pred: BasicBlock<'ctx>,
    _phis: &[PhiValue<'ctx>],
    duplicated_tail: &[InstructionValue<'ctx>],
) -> Result<(BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>)> {
    let mut vmap = phi_incoming_vmap_for_block_predecessor(original_block, pred)?;
    let mut cloned_values: HashMap<ValueKey, BasicValueEnum<'ctx>> = HashMap::new();

    let clone_block = pred.get_context().insert_basic_block_after(
        pred,
        &format!("{}.dup", synthetic_block_base_name(original_block)),
    );

    if let Err(err) = rebuild_tail(
        builder,
        clone_block,
        duplicated_tail,
        &mut vmap,
        Some(&mut cloned_values),
        "duplicated phi tail",
    ) {
        erase_all_instructions_in_block(clone_block, &mut HashSet::new());
        clone_block
            .remove_from_function()
            .expect("Tried to delete failed clone block without parent");
        let _ = clone_block;
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

/// Rewrites phi incomings in direct successors of `original_block` before that
/// block is deleted.
///
/// This covers downstream phis that mention `original_block` only as an incoming
/// block, even when the incoming value is a constant or some other value not
/// defined in `original_block`. Those edges are not discoverable through use-def
/// walking, but they still need to be expanded to the duplicated clone blocks.
fn reconcile_successor_phi_incoming_blocks_after_duplication<'ctx>(
    original_block: BasicBlock<'ctx>,
    clone_map: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
    clone_value_maps: &HashMap<BasicBlock<'ctx>, HashMap<ValueKey, BasicValueEnum<'ctx>>>,
    qubit_values: &mut HashSet<ValueKey>,
) -> Result<()> {
    let resolver = DuplicationValueResolver::new(original_block, clone_map, clone_value_maps);
    let sorted_clone_entries = sorted_clone_entries(clone_map);

    for succ_bb in direct_successors(original_block)? {
        let phi_insts: Vec<_> = succ_bb
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

            let builder = succ_bb.get_context().create_builder();
            builder.position_before(&phi_inst);
            let old_phi_key = value_key_from_instruction(phi_inst);
            let replacement_phi = builder.build_phi(phi.as_basic_value().get_type(), "phi.edge")?;
            if qubit_values.contains(&old_phi_key) {
                qubit_values.insert(value_key_from_instruction(replacement_phi.as_instruction()));
            }

            for (incoming_val, incoming_bb) in incomings {
                if incoming_bb != original_block {
                    replacement_phi.add_incoming(&[(&incoming_val, incoming_bb)]);
                    continue;
                }

                for (orig_pred, clone_block) in &sorted_clone_entries {
                    if !block_has_successor(*clone_block, succ_bb)? {
                        continue;
                    }
                    let replacement_val = resolver
                        .value_for_duplicated_original_predecessor(*orig_pred, incoming_val)?;
                    replacement_phi.add_incoming(&[(&replacement_val, *clone_block)]);
                }
            }

            phi.replace_all_uses_with(&replacement_phi);
            forget_qubit_value(phi_inst, qubit_values);
            phi_inst.erase_from_basic_block();
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
    qubit_values: &mut HashSet<ValueKey>,
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
                let user_phi: PhiValue = user.try_into().unwrap();
                let user_block =
                    required_parent_block(user, "reconcile_external_uses_after_duplication")?;
                let incomings = user_phi.get_incomings();
                let builder = user_block.get_context().create_builder();
                builder.position_before(&user);
                let old_user_phi_key = value_key_from_instruction(user);
                let replacement_phi =
                    builder.build_phi(user_phi.as_basic_value().get_type(), "phi.calluser")?;
                if qubit_values.contains(&old_user_phi_key) {
                    qubit_values
                        .insert(value_key_from_instruction(replacement_phi.as_instruction()));
                }
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
                            qubit_values,
                        )?
                    } else {
                        incoming_val
                    };
                    replacement_phi.add_incoming(&[(&replacement_val, incoming_bb)]);
                }

                user_phi.replace_all_uses_with(&replacement_phi);
                forget_qubit_value(user, qubit_values);
                user.erase_from_basic_block();
                continue;
            }

            // If not phi

            let user_block =
                required_parent_block(user, "reconcile_external_uses_after_duplication")?;
            let replacement_value = resolver.value_available_in_block(
                inst,
                user_block,
                value_key,
                old_value,
                qubit_values,
            )?;
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
                    let phi: PhiValue = original_inst.try_into().unwrap();
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
        qubit_values: &mut HashSet<ValueKey>,
    ) -> Result<BasicValueEnum<'ctx>> {
        if let Some(&cached) = self.available_value_cache.get(&(block, value_key)) {
            return Ok(cached);
        }

        if let Some(original_pred) = self.reverse_clone_map.get(&block) {
            let direct_value = self.resolve_original_instruction_for_predecessor(
                *original_pred,
                original_inst,
                value_key,
                "value_available_in_block_after_duplication",
            )?;
            self.available_value_cache
                .insert((block, value_key), direct_value);
            return Ok(direct_value);
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
        if qubit_values.contains(&value_key) {
            qubit_values.insert(value_key_from_instruction(helper_phi.as_instruction()));
        }
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
                    qubit_values,
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
                if term.is_conditional().unwrap() {
                    let cond = expect_inst_operand_value(term, 0).into_int_value();
                    let then_bb = operand_as_bb(term, 1).unwrap();
                    let else_bb = operand_as_bb(term, 2).unwrap();
                    let new_then = if then_bb == old_to { new_to } else { then_bb };
                    let new_else = if else_bb == old_to { new_to } else { else_bb };

                    // In this LLVM/in-inkwell setup, operand(1) is the *false* target and
                    // operand(2) is the *true* target. Keep the same ordering here so we don't
                    // invert the branch when rebuilding.
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
            let gep_ty = inst.get_gep_source_element_type().unwrap();
            let built = builder.build_gep(gep_ty, base.into_pointer_value(), &indices, &name)?;
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
            let ty: BasicTypeEnum = inst
                .get_type()
                .try_into()
                .expect("the result type of a load should be a BasicType");
            let load = builder.build_load(ty, addr, &name)?;
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

        // ---------------- Floating-point arithmetic ----------------
        Op::FAdd | Op::FSub | Op::FMul | Op::FDiv | Op::FRem => {
            let lhs = remap(vmap, expect_inst_operand_value(inst, 0)).into_float_value();
            let rhs = remap(vmap, expect_inst_operand_value(inst, 1)).into_float_value();
            let res = match inst.get_opcode() {
                Op::FAdd => builder.build_float_add(lhs, rhs, &name),
                Op::FSub => builder.build_float_sub(lhs, rhs, &name),
                Op::FMul => builder.build_float_mul(lhs, rhs, &name),
                Op::FDiv => builder.build_float_div(lhs, rhs, &name),
                Op::FRem => builder.build_float_rem(lhs, rhs, &name),
                _ => unreachable!(),
            }?;
            Ok(RebuildOutcome::Value(res.as_basic_value_enum()))
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
fn simp_cfg(module: &Module, target: &TargetMachine) -> Result<()> {
    module
        .run_passes("simplifycfg", target, PassBuilderOptions::create())
        .map_err(|e| anyhow!("Error running simplifycfg: {e}"))
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
) -> Result<FunctionValue<'ctx>> {
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
) -> Result<FunctionValue<'ctx>> {
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

    fn count_lowerable_qubit_selects_and_phis(module: &Module) -> usize {
        collect_qubit_select_and_phi_values(module).len()
    }

    fn count_lowerable_float_selects_and_phis(module: &Module) -> usize {
        count_matching_selects_and_phis(module, is_lowerable_float_select_or_phi_instruction)
    }

    fn count_matching_selects_and_phis(
        module: &Module,
        predicate: impl Fn(InstructionValue) -> bool + Copy,
    ) -> usize {
        module
            .get_functions()
            .flat_map(|function| function.get_basic_blocks())
            .flat_map(|block| block.get_instructions())
            .filter(|inst| predicate(*inst))
            .count()
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
    // tail_int_ptr_casts.ll omitted: arithmetic on qubit pointer values is not supported
    #[case("tail_float_casts_and_cmp.ll")]
    #[case("tail_gep_bitcast_and_call.ll")]
    #[case("tail_switch_terminator.ll")]
    #[case("tail_unreachable_terminator.ll")]
    #[case("tail_record_output_and_downstream_phi.ll")]
    #[case("tail_call_result_downstream_phi.ll")]
    #[case("qubit_phi_with_constant_successor_incoming.ll")]
    fn lowers_all_lowerable_qubit_selects_and_phis_from_fixture(#[case] fixture: &str) {
        let tm = default_target_machine();
        assert_lowering_fixture(
            fixture,
            |module| lower_qubit_selects_and_phis(module, &tm),
            count_lowerable_qubit_selects_and_phis,
            "qubit select or phi",
            "lowered_qubit_selects_and_phis",
        );
    }

    #[rstest]
    #[case("simple_float_select.ll")]
    #[case("simple_float_phi.ll")]
    #[case("single_float_phi.ll")]
    #[case("float_select_with_downstream_call.ll")]
    #[case("float_phi_with_constant_successor_incoming.ll")]
    fn lowers_all_lowerable_float_selects_and_phis_from_fixture(#[case] fixture: &str) {
        assert_lowering_fixture(
            fixture,
            lower_float_selects_and_phis,
            count_lowerable_float_selects_and_phis,
            "float select or phi",
            "lowered_float_selects_and_phis",
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
  ; first incoming is invalid because `entry` is not a predecessor of `merge`
  %selected = phi %Qubit* [ null, %entry ], [ inttoptr (i64 1 to %Qubit*), %else ]
  tail call void @__quantum__qis__reset__body(%Qubit* %selected)
  ret void
}

declare void @__quantum__qis__reset__body(%Qubit*)
"#,
        )
        .unwrap();

        let tm = default_target_machine();
        let err = lower_qubit_selects_and_phis(&module, &tm)
            .unwrap_err()
            .to_string();
        assert!(
            err.contains(
                "Verification failed for input module to lower_qubit_selects_and_phis pass"
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

        // NOTE: In this build of LLVM/inkwell, conditional `br` operands are ordered
        // as (cond, false_dest, true_dest).
        assert_eq!(name_of_block(op1), "else_block");
        assert_eq!(name_of_block(op2), "then_block");
    }
}
