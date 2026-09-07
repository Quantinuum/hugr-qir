//! QIR-specific lowering for fixed-size HUGR arrays.
//!
//! The generic `hugr-llvm` collection lowering uses `malloc` and `free`. QIR
//! programs with static resource management cannot retain those runtime
//! allocations, so use temporary stack storage instead. LLVM's loop unrolling,
//! SROA, and mem2reg passes can then scalarize statically-addressed arrays.

use anyhow::{Result, anyhow};
use hugr::{HugrView, Node};
use hugr_llvm::{
    emit::{EmitFuncContext, libc::emit_libc_abort},
    extension::collections::{
        array::{ArrayCodegen, decompose_array_fat_pointer},
        borrow_array::{
            BorrowArrayCodegen, build_none_borrowed_check, decompose_barray_fat_pointer,
        },
    },
    inkwell::{
        types::BasicTypeEnum,
        values::{BasicValue, BasicValueEnum, IntValue, PointerValue},
    },
};

/// Maximum ABI alignment required by the scalar element types supported in QIR
/// arrays (pointers, 64-bit integers, and doubles).
const ARRAY_STORAGE_ALIGNMENT: u32 = 8;

fn allocate_array_storage<'c, H: HugrView<Node = Node>>(
    ctx: &mut EmitFuncContext<'c, '_, H>,
    size: IntValue<'c>,
    name: &str,
) -> Result<PointerValue<'c>> {
    let storage = ctx
        .builder()
        .build_array_alloca(ctx.iw_context().i8_type(), size, name)?;
    storage
        .as_instruction_value()
        .ok_or_else(|| anyhow!("array storage allocation did not produce an instruction"))?
        .set_alignment(ARRAY_STORAGE_ALIGNMENT)?;
    Ok(storage)
}

/// Load every element of a statically sized array, accounting for its offset.
pub(super) fn load_array_elements<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    array: BasicValueEnum<'c>,
    elem_ty: BasicTypeEnum<'c>,
    length: u64,
) -> Result<Vec<BasicValueEnum<'c>>> {
    let (array_ptr, array_offset) = decompose_array_fat_pointer(context.builder(), array)?;
    load_elements_from_pointer(context, array_ptr, array_offset, elem_ty, length)
}

/// Load every element of a statically sized borrow array.
///
/// H-series barriers have a statically encoded arity, so a partially borrowed
/// array cannot be represented without also including elements that are absent
/// from the barrier's HUGR inputs. Reject such arrays before loading them.
pub(super) fn load_borrow_array_elements<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    array: BasicValueEnum<'c>,
    elem_ty: BasicTypeEnum<'c>,
    length: u64,
) -> Result<Vec<BasicValueEnum<'c>>> {
    let array = decompose_barray_fat_pointer(context.builder(), array)?;
    build_none_borrowed_check(
        &QirBorrowArrayCodegen,
        context,
        array.mask_ptr,
        array.offset,
        length,
    )?;
    load_elements_from_pointer(context, array.elems_ptr, array.offset, elem_ty, length)
}

fn load_elements_from_pointer<'c, H: HugrView<Node = Node>>(
    context: &mut EmitFuncContext<'c, '_, H>,
    array_ptr: PointerValue<'c>,
    array_offset: IntValue<'c>,
    elem_ty: BasicTypeEnum<'c>,
    length: u64,
) -> Result<Vec<BasicValueEnum<'c>>> {
    let index_ty = array_offset.get_type();
    (0..length)
        .map(|index| {
            let index = context.builder().build_int_add(
                array_offset,
                index_ty.const_int(index, false),
                "",
            )?;
            let elem_ptr = unsafe {
                context
                    .builder()
                    .build_in_bounds_gep(elem_ty, array_ptr, &[index], "")?
            };
            Ok(context.builder().build_load(elem_ty, elem_ptr, "")?)
        })
        .collect()
}

/// Lowers ordinary fixed-size arrays to temporary stack storage.
#[derive(Clone, Debug, Default)]
pub struct QirArrayCodegen;

impl ArrayCodegen for QirArrayCodegen {
    fn emit_allocate_array<'c, H: HugrView<Node = Node>>(
        &self,
        ctx: &mut EmitFuncContext<'c, '_, H>,
        size: IntValue<'c>,
    ) -> Result<PointerValue<'c>> {
        allocate_array_storage(ctx, size, "hugr_array_storage")
    }

    fn emit_free_array<'c, H: HugrView<Node = Node>>(
        &self,
        _ctx: &mut EmitFuncContext<'c, '_, H>,
        _ptr: PointerValue<'c>,
    ) -> Result<()> {
        Ok(())
    }
}

/// Lowers fixed-size borrow arrays to temporary stack storage.
///
/// The default borrow-array operation lowering is retained for now, including
/// its bounds and borrow checks. Both the element storage and the borrow mask
/// use stack allocations, allowing LLVM to remove them when all indexing is
/// statically resolvable.
#[derive(Clone, Debug, Default)]
pub struct QirBorrowArrayCodegen;

impl BorrowArrayCodegen for QirBorrowArrayCodegen {
    fn emit_panic<H: HugrView<Node = Node>>(
        &self,
        ctx: &mut EmitFuncContext<H>,
        _err: BasicValueEnum,
    ) -> Result<()> {
        emit_libc_abort(ctx)
    }

    fn emit_allocate_array<'c, H: HugrView<Node = Node>>(
        &self,
        ctx: &mut EmitFuncContext<'c, '_, H>,
        size: IntValue<'c>,
    ) -> Result<PointerValue<'c>> {
        allocate_array_storage(ctx, size, "hugr_borrow_array_storage")
    }

    fn emit_free_array<'c, H: HugrView<Node = Node>>(
        &self,
        _ctx: &mut EmitFuncContext<'c, '_, H>,
        _ptr: PointerValue<'c>,
    ) -> Result<()> {
        Ok(())
    }
}
