use inkwell::basic_block::BasicBlock;
use inkwell::builder::Builder;
use inkwell::module::Module;
use inkwell::types::{AnyTypeEnum, BasicTypeEnum};
use inkwell::values::{
    AsValueRef, BasicValue, BasicValueEnum, CallSiteValue, FunctionValue, InstructionValue,
    Operand, PhiValue, ValueKind,
};
use std::collections::HashMap;
use inkwell::values::InstructionOpcode as Op;

pub fn replace_phi_on_qubit(module: &Module) -> bool {
    let context = module.get_context();
    let builder = context.create_builder();
    let first_func = module.get_first_function().unwrap();
    let mut changed = false;
    for block in first_func.get_basic_blocks() {
        let mut inst_opt = block.get_first_instruction();
        let mut phi_candidates: Vec<PhiValue> = Vec::new();

        while let Some(inst) = inst_opt {
            use inkwell::values::InstructionOpcode;
            if inst.get_opcode() != InstructionOpcode::Phi {
                break;
            }
            // Turn the inst into PhiValue (safe since we checked opcode)
            let phi = unsafe { PhiValue::new(inst.as_value_ref()) };
            if let BasicTypeEnum::PointerType(ptr_ty) = phi.as_basic_value().get_type() {
                if ptr_ty
                    .get_element_type()
                    .into_struct_type()
                    .get_name()
                    .unwrap()
                    .eq(c"Qubit")
                {
                    phi_candidates.push(phi);
                }
            }
            inst_opt = inst.get_next_instruction();
        }
        if phi_candidates.is_empty() {
            continue;
        }

        // 2) Find predecessors of `block`
        let preds = predecessors(first_func, block);
        println!("phi block {:?}", block.get_name());
        println!(
            "phi preds {:?}",
            preds.iter().map(|b| b.get_name()).collect::<Vec<_>>()
        );
        if preds.is_empty() {
            continue;
        }

        // 3) For each predecessor, duplicate tail and redirect edge
        for pred in preds {
            // New block that will hold the duplicated tail
            let clone_block = pred
                .get_context()
                .insert_basic_block_after(pred, &format!("{}_dup", name_of_block(block)));
            // Ensure it's attached to the function (inkwell exposes append_existing_basic_block)
            //first_func.append_existing_basic_block(clone_block);

            // Seed the value map: PHI -> incoming value for this predecessor
            let mut vmap: HashMap<String, BasicValueEnum> = HashMap::new();
            for phi in &phi_candidates {
                if let Some((val, _)) = incoming_for_predecessor(*phi, pred) {
                    let key = phi
                        .as_instruction()
                        .get_name()
                        .unwrap()
                        .to_string_lossy()
                        .to_string();
                    vmap.insert(key, val);
                } else {
                    // This predecessor doesn’t contribute to this PHI; skip this pred
                    continue;
                }
            }

            // Rebuild non‑PHI instructions from bb into clone_block
            if !rebuild_tail_into(&builder, block, clone_block, &mut vmap) {
                print!("skipping");
                // if unsupported opcode appears, skip this pred
                continue;
            }

            // Redirect edge pred -> bb to pred -> clone_block
            redirect_edge(&builder, pred, block, clone_block);

            changed = true;
        }
    }
    changed
}

/// Extract BasicBlock operand i from instruction (works for Br/Switch operands).
fn operand_as_bb(inst: InstructionValue, idx: u32) -> Option<BasicBlock> {
    // In Inkwell 0.8, operands that are blocks are exposed as BasicBlock directly via the operand API.
    // We try both typed accessors that are commonly available.
    inst.get_operand(idx)?.block()
}

fn predecessors<'ctx>(func: FunctionValue<'ctx>, to: BasicBlock<'ctx>) -> Vec<BasicBlock<'ctx>> {
    let mut preds = Vec::new();

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
                _ => { /* We lowered switches and don't use indirectbr so no need to handle those cases*/
                }
            }
        }
    }
    preds
}

/// First non‑PHI in a block
fn first_non_phi(bb: BasicBlock) -> Option<InstructionValue> {
    let mut it = bb.get_first_instruction();
    while let Some(i) = it {
        if i.get_opcode() != inkwell::values::InstructionOpcode::Phi {
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

/// Rebuild all non‑PHI instructions from `from_bb` into `into_bb`.
fn rebuild_tail_into<'ctx>(
    builder: &Builder<'ctx>,
    from_bb: BasicBlock<'ctx>,
    into_bb: BasicBlock<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> bool {
    builder.position_at_end(into_bb);
    let mut it = first_non_phi(from_bb);
    while let Some(inst) = it {
        if inst.is_terminator() {
            if !rebuild_terminator(builder, inst, vmap) {
                return false;
            }
            break;
        }
        match rebuild_inst(builder, inst, vmap) {
            Ok(RebuildOutcome::Value(bv)) => {
                // only value-producing instructions enter vmap
                vmap.insert(inst.get_name().unwrap().to_string_lossy().to_string(), bv);
            }
            Ok(RebuildOutcome::Void) => {
                // built successfully, but nothing to map → keep going
            }
            Err(()) => {
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
    vmap: &HashMap<String, BasicValueEnum<'ctx>>,
    v: BasicValueEnum<'ctx>,
) -> BasicValueEnum<'ctx> {
    if let Some(orig) = v
        .as_instruction_value()
        .map(|iv| iv.get_name().unwrap().to_string_lossy().to_string()) &&
        let Some(mapped) = vmap.get(&orig)
    {
            return *mapped;
    }
    v
}

fn rebuild_terminator<'ctx>(
    builder: &Builder<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> bool {
    match inst.get_opcode() {
        Op::Br => {
            if inst.is_conditional() {
                let cond = remap(vmap, inst_operand_value(inst, 0).unwrap()).into_int_value();

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
                    let cond = inst_operand_value(term, 0).unwrap().into_int_value();
                    let then_bb = operand_as_bb(term, 1).unwrap();
                    let else_bb = operand_as_bb(term, 2).unwrap();
                    let new_then = if then_bb == old_to { new_to } else { then_bb };
                    let new_else = if else_bb == old_to { new_to } else { else_bb };

                    // This order of fbb and tbb is not what I would expect but
                    // if you do it the other way the branches get switched...
                    builder
                        .build_conditional_branch(cond, new_else, new_then)
                        .ok();
                    println!("erasing conditional");
                    term.erase_from_basic_block();
                } else {
                    builder.build_unconditional_branch(new_to).ok();
                    println!("erasing unconditional");
                    term.erase_from_basic_block();
                }
            }
            _ => { /* extend for switch if needed */ }
        }
    }
}

pub fn rebuild_inst<'ctx>(
    builder: &Builder<'ctx>,
    inst: InstructionValue<'ctx>,
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> Result<RebuildOutcome<'ctx>, ()> {

    let name = inst.get_name().unwrap_or(c"").to_string_lossy();

    match inst.get_opcode() {
        // ---------------- Pointer / aggregate ops ----------------
        Op::GetElementPtr => unsafe {
            let base = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let num_ops = inst.get_num_operands();
            let mut indices = Vec::new();
            for i in 1..num_ops {
                let idx = inst_operand_value(inst, i).ok_or(())?;
                indices.push(remap(vmap, idx).into_int_value());
            }
            let built = builder
                .build_gep(base.into_pointer_value(), &indices, &name)
                .ok()
                .ok_or(())?;
            Ok(RebuildOutcome::Value(built.as_basic_value_enum()))
        },

        // ---------------- Casts (no `build_bitcast` fallback) ----------------
        Op::BitCast => {
            // We implement bitcast via specialized casts. See comments in our previous message.
            let src_val = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let dst_any = inst.get_type(); // LLVM 14: typed pointers still exist

            match dst_any.try_into() {
                Ok(BasicTypeEnum::PointerType(dst_ptr_ty)) => {
                    let src_ptr = match src_val {
                        BasicValueEnum::PointerValue(p) => p,
                        _ => return Err(()),
                    };
                    let cast = builder
                        .build_pointer_cast(src_ptr, dst_ptr_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::IntType(dst_int_ty)) => {
                    let src_int = match src_val {
                        BasicValueEnum::IntValue(i) => i,
                        _ => return Err(()),
                    };
                    if src_int.get_type().get_bit_width() != dst_int_ty.get_bit_width() {
                        return Err(());
                    }
                    let cast = builder
                        .build_int_cast(src_int, dst_int_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                Ok(BasicTypeEnum::FloatType(dst_fp_ty)) => {
                    let src_fp = match src_val {
                        BasicValueEnum::FloatValue(f) => f,
                        _ => return Err(()),
                    };
                    if src_fp.get_type() != dst_fp_ty {
                        return Err(());
                    }
                    let cast = builder
                        .build_float_cast(src_fp, dst_fp_ty, &name)
                        .ok()
                        .ok_or(())?;
                    Ok(RebuildOutcome::Value(cast.as_basic_value_enum()))
                }
                _ => Err(()),
            }
        }

        // ---------------- Memory ops ----------------
        Op::Load => {
            let addr = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_pointer_value();
            //let ty   = inst.get_type();
            let load = builder.build_load(addr, &name).ok().ok_or(())?;
            Ok(RebuildOutcome::Value(load))
        }

        Op::Store => {
            let val = remap(vmap, inst_operand_value(inst, 0).ok_or(())?);
            let addr = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_pointer_value();
            builder.build_store(addr, val).ok().ok_or(())?;
            Ok(RebuildOutcome::Void)
        }

        // ---------------- Comparisons / select ----------------
        Op::ICmp => {
            let pred = inst.get_icmp_predicate().ok_or(())?;
            let lhs = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let rhs = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_int_value();
            let cmp = builder
                .build_int_compare(pred, lhs, rhs, &name)
                .ok()
                .ok_or(())?;
            Ok(RebuildOutcome::Value(cmp.as_basic_value_enum()))
        }

        Op::Select => {
            let cond = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let tval = remap(vmap, inst_operand_value(inst, 1).ok_or(())?);
            let fval = remap(vmap, inst_operand_value(inst, 2).ok_or(())?);
            let sel = builder
                .build_select(cond, tval, fval, &name)
                .ok()
                .ok_or(())?;
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
            let lhs = remap(vmap, inst_operand_value(inst, 0).ok_or(())?).into_int_value();
            let rhs = remap(vmap, inst_operand_value(inst, 1).ok_or(())?).into_int_value();
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
            }
            .ok()
            .ok_or(())?;
            Ok(RebuildOutcome::Value(res.as_basic_value_enum()))
        }

        // ---------------- Calls (LLVM 14: use build_direct_call) ----------------
        Op::Call => {
            let cs = CallSiteValue::try_from(inst)?;
            let callee = cs.get_called_fn_value().ok_or(())?;

            // Collect value operands as args (calls don't have block operands).
            let mut args = Vec::new();
            for i in 0..cs.count_arguments() {
                if let Some(v) = inst_operand_value(inst, i) {
                    args.push(remap(vmap, v).into());
                }
            }

            // NOTE: In Inkwell, build_call is available only for LLVM>=15 and aliases build_direct_call.
            // On LLVM 14, use build_direct_call.
            let callsite = builder.build_call(callee, &args, &name).ok().ok_or(())?; // [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/classllvm_1_1ValueMapper.html)

            // If return type is void → Void; else produce the resulting SSA value
            let value = callsite.try_as_basic_value();
            match value {
                ValueKind::Basic(bv) => Ok(RebuildOutcome::Value(bv)),
                ValueKind::Instruction(_) => Ok(RebuildOutcome::Void),
            }
        }

        // Add more opcodes as needed (sext/zext/trunc, ptrtoint/inttoptr, FP ops, vectors, etc.)
        _ => Err(()),
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


/// Lower all pointer-typed `select` to explicit control flow by introducing
/// a then/else diamond and a merge PHI. Works even if %sel has non-local uses.
pub fn lower_pointer_selects_with_phi_merge(
    module: &Module
) -> bool {
    let context = module.get_context();
    let builder = context.create_builder();
    let mut changed = false;

    for func in module.get_functions() {
        for bb in func.get_basic_blocks() {
            // Collect selects first to avoid invalidating iteration
            let mut sels = Vec::new();
            let mut it = bb.get_first_instruction();
            while let Some(i) = it {
                it = i.get_next_instruction();
                if i.get_opcode() == inkwell::values::InstructionOpcode::Select {
                    if let AnyTypeEnum::PointerType(pt) = i.get_type() {
                        if pt
                            .get_element_type()
                            .into_struct_type()
                            .get_name()
                            .unwrap()
                            .eq(c"Qubit")
                        {
                            sels.push(i);
                        }
                    }
                }
            }
            for sel in sels {
                println!("select: {:?}", sel);
                if lower_one_select_to_cf_with_phi(&builder, sel) {
                    changed = true;
                }
            }
        }
    }
    changed
}

fn lower_one_select_to_cf_with_phi<'ctx>(
    builder: &Builder<'ctx>,
    sel: InstructionValue<'ctx>,
) -> bool {
    let bb = match sel.get_parent() { Some(b) => b, None => return false };
    let func = match bb.get_parent() { Some(f) => f, None => return false };

    // Extract select operands (per LangRef: 0=cond,1=true,2=false)
    let cond = match inst_operand_value(sel, 0) { Some(v) => v.into_int_value(), None => return false };
    let tval = match inst_operand_value(sel, 1) { Some(v) => v, None => return false };
    let fval = match inst_operand_value(sel, 2) { Some(v) => v, None => return false };
    println!("tval: {:?}", tval);
    println!("fval: {:?}", fval);

    // Gather the tail (all instructions after `sel`, including the original terminator)
    let mut tail: Vec<InstructionValue> = Vec::new();
    let mut it = sel.get_next_instruction();
    while let Some(i) = it {
        tail.push(i);
        it = i.get_next_instruction();
    }
    let tail2 = tail.clone();
    println!("orig br of select bb: {:?}", tail.last());

    // Create THEN, ELSE, MERGE blocks and append to function
    let ctx = bb.get_context();

    let then_bb = ctx.insert_basic_block_after(bb, &format!("{}.select.then", name_of_block(bb)));
    let else_bb = ctx.insert_basic_block_after(then_bb, &format!("{}select.else", name_of_block(bb)));
    let merge_bb = ctx.insert_basic_block_after(else_bb, &format!("{}select.merge", name_of_block(bb)));
    //func.append_existing_basic_block(then_bb);
    //func.append_existing_basic_block(else_bb);
    //func.append_existing_basic_block(merge_bb);

    // Build PHI in merge (must be first in the block)  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
    builder.position_at_end(merge_bb);
    let phi_ty: BasicTypeEnum = match sel.get_type().try_into() {
        Ok(bt) => bt,
        Err(_) => return false, // select must have a first-class (basic) type
    };
    let phi = builder.build_phi(phi_ty, "select.merge.val").ok().unwrap();
    phi.add_incoming(&[(&tval, then_bb), (&fval, else_bb)]);

    // Rebuild the original tail into merge, remapping %sel -> %phi
    let mut vmap: HashMap<String, BasicValueEnum> = HashMap::new();
    vmap.insert(sel.get_name().unwrap().to_string_lossy().to_string(), phi.as_basic_value());
    if !rebuild_tail_slice(builder, &tail, &mut vmap) {
        return false;
    }

    // Now that merge has a full copy of the tail (including the original terminator),
    // erase the original tail from `bb` and replace it with br i1 %cond, %then, %else.
    builder.position_at_end(bb);
    for &i in tail.iter().rev() {
        i.erase_from_basic_block();
    }
    // Build: br i1 %cond, label %then_bb, label %else_bb  (0=cond,1=true,2=false)  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
    builder.build_conditional_branch(cond, then_bb, else_bb).ok();
    builder.position_at_end(then_bb);
    builder.build_unconditional_branch(merge_bb).ok();
    builder.position_at_end(else_bb);
    builder.build_unconditional_branch(merge_bb).ok();

    // PHI fixups: any successor that previously had incoming from `bb`
    // must now have incoming from `merge_bb`.
    if let Some(merge_term) = merge_bb.get_terminator() {
        fix_successor_phis_block_rename(merge_term, bb, merge_bb, phi);
    }

    // Finally, drop the original %sel itself (all uses now read %phi)
    sel.erase_from_basic_block();

    true
}


/// Rebuild an instruction slice (the "tail") into the current insertion block,
/// using the same `rebuild_inst` / `rebuild_terminator` strategy you already have.
/// `slice` comes from the original block; it’s safe to iterate because we erased them from `bb`.
fn rebuild_tail_slice<'ctx>(
    builder: &inkwell::builder::Builder<'ctx>,
    slice: &[InstructionValue<'ctx>],
    vmap: &mut HashMap<String, BasicValueEnum<'ctx>>,
) -> bool {
    for &orig_inst in slice {
        if orig_inst.is_terminator() {
            println!("rebuild_tail_slice: orig_inst: {:?}", orig_inst);
            return rebuild_terminator(builder, orig_inst, vmap);
        } else {
            match rebuild_inst(builder, orig_inst, vmap) {
                Ok(RebuildOutcome::Value(bv)) => {
                    vmap.insert(orig_inst.get_name().unwrap().to_string_lossy().to_string(), bv);
                }
                Ok(RebuildOutcome::Void) => { /* fine */ }
                Err(()) => return false,
            }
        }
    }
    true
}


/// Replace PHI incoming `(…, old_bb)` → `(…, new_bb)` for *all* PHIs in each successor
/// of `term` (supports unconditional/conditional br). Extend for `switch` if needed.
fn fix_successor_phis_block_rename<'ctx>(
    term: InstructionValue<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    merge_phi: PhiValue,
) {
    match term.get_opcode() {
        Op::Br => unsafe {
            let is_cond = term.is_conditional();
            let succs: Vec<BasicBlock> = if is_cond {
                // br i1 %cond, %then, %else  → operands 1/2 are the successors  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
                [inst_operand_block(term, 1).unwrap(), inst_operand_block(term, 2).unwrap()].to_vec()
            } else {
                // br %dest  → operand 0 is the successor  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
                [inst_operand_block(term, 0).unwrap()].to_vec()
            };
            for s in succs {
                rename_incoming_block_in_phis(s, old_bb, new_bb, merge_phi);
            }
        }
        // TODO: handle Op::Switch similarly, if your IR uses switches.
        _ => {}
    }
}

/// For every PHI at the start of `succ_bb`, if it has an incoming from `old_bb`,
/// rebuild that PHI with the incoming block replaced by `new_bb`.
unsafe fn rename_incoming_block_in_phis<'ctx>(
    succ_bb: BasicBlock<'ctx>,
    old_bb: BasicBlock<'ctx>,
    new_bb: BasicBlock<'ctx>,
    merge_phi: PhiValue,
) {
    // Iterate PHIs at block start
    let mut it = succ_bb.get_first_instruction();
    while let Some(inst) = it {
        if inst.get_opcode() != Op::Phi { break; }
        // Defensive: clone the incoming list
        let phi = PhiValue::new(inst.as_value_ref()); // safe: opcode checked
        let incomings = phi.get_incomings();

        // If no incoming from old_bb, skip
        if !incomings.into_iter().any(|(_, b)| b == old_bb) {
            it = inst.get_next_instruction();
            continue;
        }

        let incomings = phi.get_incomings();

        // Build a replacement PHI with the same type, before the old PHI
        let ty: BasicTypeEnum = phi.as_basic_value().get_type().try_into().unwrap();
        let builder = succ_bb.get_context().create_builder();
        builder.position_before(&inst);
        let new_phi = builder.build_phi(ty, "phi.fix").unwrap();

        for (val, inc_bb) in incomings {
            println!("   -> phi incoming val {:?}", val);
            println!("   -> phi incoming bb {:?}", inc_bb);
            let mapped_bb = if inc_bb == old_bb { new_bb } else { inc_bb };
            let mapped_val = if inc_bb == old_bb { merge_phi.as_basic_value() } else { val };
            new_phi.add_incoming(&[(&mapped_val, mapped_bb)]);
        }

        // Replace all uses and erase old phi
        phi.replace_all_uses_with(&new_phi);
        inst.erase_from_basic_block();

        // Move iterator to the *next* instruction after the newly inserted PHI
        it = new_phi.as_instruction().get_next_instruction();
    }
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
