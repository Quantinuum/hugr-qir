use inkwell::basic_block::BasicBlock;
use inkwell::builder::Builder;
use inkwell::module::Module;
use inkwell::types::{AnyTypeEnum, BasicTypeEnum, PointerType};
use inkwell::values::{AnyValue, AnyValueEnum, AsValueRef, BasicValue, BasicValueEnum, CallSiteValue, FunctionValue, InstructionOpcode, InstructionValue, Operand, PhiValue, ValueKind};
use std::collections::HashMap;
use anyhow::bail;
use inkwell::passes::PassManager;
use inkwell::values::InstructionOpcode as Op;

pub fn replace_first_phi_on_qubit(module: &Module) -> bool {
    let context = module.get_context();
    let builder = context.create_builder();
    let first_func = module.get_first_function().unwrap();
    let mut changed = false;
    let mut block_opt = first_func.get_first_basic_block();
    while let Some(block) = block_opt {
        block_opt = block.get_next_basic_block();

        // 1) Get the phis of `block` and continue if none
        let phi_candidates = get_block_phis(block);
        if phi_candidates.is_empty(){
            continue;
        }

        // 2) Get the predecessors of `block`, i.e. any block that branches directy to it
        // If none, remove this block and continue
        let preds = predecessors(first_func, block);
        if preds.is_empty() {
            block.remove_from_function().expect("Block not attached to function");
            continue;
        }

        // 3) For each predecessor, duplicate tail and redirect edge
        let mut clone_map : HashMap<BasicBlock, BasicBlock> = HashMap::new();
        for pred in preds {

            // New block that will hold the duplicated tail
            let clone_block = pred
                .get_context()
                .insert_basic_block_after(pred, &format!("{}_dup", name_of_block(block)));

            clone_map.insert(pred, clone_block);

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
        // Now need to take care of any instructions that used the ssa variable
        // created by the phi, e.g. function calls on the variable or additional phis
        for phi in phi_candidates{
            let rewritten = expand_phi_uses_into_per_pred_incomings(phi, &clone_map);
            // Now it's safe to RAUW the *non-PHI* uses and erase `phi`
            //phi.replace_all_uses_with(/* something, usually not needed after duplication */);
            //phi.as_instruction().erase_from_basic_block();
            println!("phi block {:?}", block.get_name());

        }

    }
    changed
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
        if let BasicTypeEnum::PointerType(ptr_ty) = phi.as_basic_value().get_type() && is_qubit_pointer(ptr_ty) {
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
/// Inputs:
/// - `phi`:  the PHI you plan to delete (in block `B`)
/// - `clone_for_pred`: mapping P -> the block that now replaces the (P->B) edge
///                     when flowing to successors (e.g., your per-pred clone of B).
///                     This block *must* be an immediate predecessor of the user PHI's block.
///                     If you don't duplicate, you must split edges so this is true.
///
/// Returns: number of PHIs rewritten.
pub fn expand_phi_uses_into_per_pred_incomings<'ctx>(
    phi: PhiValue<'ctx>,
    clone_for_pred: &HashMap<BasicBlock<'ctx>, BasicBlock<'ctx>>,
) -> usize {
    let phi_inst = phi.as_instruction();
    let b = phi_inst.get_parent().expect("phi must be in a block");

    // 1) Build the incoming map for %phi: P -> value v_i used on edge (P -> B)
    let mut incoming_by_pred: HashMap<BasicBlock, BasicValueEnum> = HashMap::new();
    for (val, pred_bb) in phi.get_incomings() {
        incoming_by_pred.insert(pred_bb, val);
    }

    // 2) Collect *all* PHI users first (don't mutate while iterating uses)
    let mut phi_users: Vec<InstructionValue> = Vec::new();
    let mut use_opt = phi.as_basic_value().get_first_use();
    while let Some(u) = use_opt {
        let user_any = u.get_user().as_any_value_enum();
        if let AnyValueEnum::InstructionValue(user_inst) = user_any{
                phi_users.push(user_inst);
        }
        use_opt = u.get_next_use();
    }

    // 3) For each PHI user, rebuild it with expanded incomings
    let mut rewritten = 0usize;

    for u_inst in phi_users {
        if u_inst.get_opcode() == Op::Phi {
            let u_phi = unsafe { PhiValue::new(u_inst.as_value_ref()) };
            let succ_bb = u_inst.get_parent().expect("user phi must be in a block");
            let incomings = u_phi.get_incomings();

            // Build a replacement PHI before the old one
            let ty: BasicTypeEnum = u_phi.as_basic_value().get_type()
                .try_into().expect("phi value must be first-class");
            let builder = succ_bb.get_context().create_builder();
            builder.position_before(&u_inst);
            let new_phi = builder.build_phi(ty, "phi.expanded").expect("build_phi");

            // Re-add all incoming pairs, expanding (%phi, B) into per-pred pairs
            for (val, inc_bb) in incomings {
                if val != phi.as_basic_value() {
                    // copy as-is
                    new_phi.add_incoming(&[(&val, inc_bb)]);
                    continue;
                }

                // This incoming was (%phi, inc_bb). The usual case is inc_bb == B.
                // We will *replace* it by a set of per-pred pairs:
                //    for each P in preds(B):
                //       value = incoming_by_pred[P]
                //       block = clone_for_pred[P]  (must be an immediate predecessor of succ_bb)
                //
                // If you haven't duplicated/split so clone_for_pred[P] is a predecessor of succ_bb,
                // you must do that (or skip) because PHI incoming blocks must be real predecessors.  [1](https://cs6340.cc.gatech.edu/LLVM8Doxygen/TailDuplicator_8cpp_source.html)
                for (pred, edge_val) in &incoming_by_pred {
                    if let Some(&clone_block) = clone_for_pred.get(pred) {
                        // Add incoming (edge_val, clone_of_B_for_pred)
                        new_phi.add_incoming(&[(edge_val, clone_block)]);
                    } else {
                        // Fallback: if you did not duplicate/split such that `pred` (or its clone)
                        // is a predecessor of succ_bb, you cannot legally add an incoming from it.
                        // You need to split that edge first or run your B-tail duplication prior.
                        // For safety, keep the old incoming (%phi, inc_bb) (or skip adding).
                        // Here we choose to *skip* adding; the caller should ensure proper clones exist.
                    }
                }
                // NOTE: we do *not* copy the old (%phi, inc_bb); we replaced it.
            }
            // Replace and erase old PHI
            u_phi.replace_all_uses_with(&new_phi);
            u_inst.erase_from_basic_block();
        }
        if u_inst.get_opcode() == Op::Call {
            let call_bb = match u_inst.get_parent() { Some(bb) => bb, None => continue };
            let ctx = call_bb.get_context();
            let local_builder = ctx.create_builder();
            local_builder.position_before(&u_inst);

            // 1) Create the replacement PHI in the call's block with per-pred incomings
            let phi_ty: BasicTypeEnum = phi.as_basic_value().get_type()
                .try_into().expect("first-class type");
            let arg_phi = local_builder.build_phi(phi_ty, "phi.arg").expect("build_phi");

            for (pred, edge_val) in &incoming_by_pred {
                if let Some(&clone_bb) = clone_for_pred.get(pred) {
                    // clone_bb must be an immediate predecessor of call_bb (LangRef)  [1](https://deepwiki.com/TheDan64/inkwell/1-overview)
                    arg_phi.add_incoming(&[(edge_val, clone_bb)]);
                } else {
                    // If you reach here, ensure edge splitting / per-pred duplication makes clone_bb
                    // a real predecessor of `call_bb` before rewriting this call.
                    // You can skip or bail; safest is to bail for this call instance.
                    continue;
                }
            }

            // 2) Rebuild the call with `%phi` replaced by `arg_phi`
            // Read the original as a CallSite to collect callee & operands
            let cs: CallSiteValue = match u_inst.try_into() {
                Ok(cs) => cs,
                Err(_) => continue,
            };
            let callee = match cs.get_called_fn_value() {
                Some(f) => f,
                None => continue, // (indirect call via function pointer can be handled similarly)
            };
            println!("call u_inst {:?}", u_inst);

            // Gather arguments (filter out block operands; calls use only value operands)
            // Replace any operand that pointer-equals `%phi` with `arg_phi`.
            let old_val_ref = phi.as_basic_value().as_value_ref();
            let mut args: Vec<inkwell::values::BasicMetadataValueEnum> = Vec::new();
            for i in 0..cs.count_arguments() {
                if let Some(op_bv) = inst_operand_value(u_inst, i) {
                    println!("operand {} {:?}",i, op_bv);
                    let vref = op_bv.as_value_ref();
                    if vref == old_val_ref {
                        // substitute with our new PHI in this block
                        args.push(arg_phi.as_basic_value().into());
                    } else {
                        args.push(op_bv.into());
                    }
                }
            }
            println!("new args {:?}", args);

            // Build the replacement call *at the same point*
            // (LLVM 14: use build_direct_call)  [2](https://deepwiki.com/eshard/obfuscator-llvm/3.2-llvm-pass-pipeline-integration)
            let name = u_inst.get_name().map(|c| c.to_string_lossy()).unwrap_or_default();
            let new_cs = match local_builder.build_call(callee, &args, &name) {
                Ok(cs) => cs,
                Err(_) => continue,
            };

            // If call returns a value, RAUW; else just drop the old call
            if let Some(ret) = new_cs.try_as_basic_value().basic()  {
                u_inst.replace_all_uses_with(&ret.as_instruction_value().unwrap());
            }
            else {
                u_inst.erase_from_basic_block();
            }

        }
        rewritten += 1;
    }
    rewritten
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
                    if let AnyTypeEnum::PointerType(pt) = i.get_type() && is_qubit_pointer(pt) {
                            sels.push(i);
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


fn remove_dead_code_and_blocks_from_function(
    function: FunctionValue,
) {
    let pm = PassManager::create(&function);
    pm.add_cfg_simplification_pass();
    pm.add_aggressive_dce_pass();
    pm.initialize();
    pm.run_on(&function);
    pm.finalize();
}

