//! QIR-specific lowering for fixed-size HUGR arrays.
//!
//! The generic `hugr-llvm` collection lowering uses `malloc` and `free`. QIR
//! programs with static resource management cannot retain those runtime
//! allocations, so use temporary stack storage instead. LLVM's loop unrolling,
//! SROA, and mem2reg passes can then scalarize statically-addressed arrays.

use anyhow::Result;
use hugr::{HugrView, Node};
use hugr_llvm::{
    emit::{EmitFuncContext, libc::emit_libc_abort},
    extension::collections::{array::ArrayCodegen, borrow_array::BorrowArrayCodegen},
    inkwell::values::{BasicValueEnum, IntValue, PointerValue},
};

/// Lowers ordinary fixed-size arrays to temporary stack storage.
#[derive(Clone, Debug, Default)]
pub struct QirArrayCodegen;

impl ArrayCodegen for QirArrayCodegen {
    fn emit_allocate_array<'c, H: HugrView<Node = Node>>(
        &self,
        ctx: &mut EmitFuncContext<'c, '_, H>,
        size: IntValue<'c>,
    ) -> Result<PointerValue<'c>> {
        Ok(ctx.builder().build_array_alloca(
            ctx.iw_context().i8_type(),
            size,
            "hugr_array_storage",
        )?)
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
        Ok(ctx.builder().build_array_alloca(
            ctx.iw_context().i8_type(),
            size,
            "hugr_borrow_array_storage",
        )?)
    }

    fn emit_free_array<'c, H: HugrView<Node = Node>>(
        &self,
        _ctx: &mut EmitFuncContext<'c, '_, H>,
        _ptr: PointerValue<'c>,
    ) -> Result<()> {
        Ok(())
    }
}
