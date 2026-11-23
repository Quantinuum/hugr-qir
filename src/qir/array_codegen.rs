//! QIR-specific lowering for fixed-size HUGR arrays.
//!
//! The generic `hugr-llvm` collection lowering uses `malloc` and `free`. QIR
//! programs with static resource management cannot retain those runtime
//! allocations, so use temporary stack storage instead. LLVM's loop unrolling,
//! SROA, and mem2reg passes can then scalarize statically-addressed arrays.

use anyhow::{Result, anyhow, ensure};
use hugr::{HugrView, Node, std_extensions::collections::static_array::StaticArrayValue};
use hugr_llvm::{
    emit::EmitFuncContext,
    extension::PreludeCodegen,
    extension::collections::{
        array::{ArrayCodegen, decompose_array_fat_pointer},
        borrow_array::{
            BorrowArrayCodegen, build_none_borrowed_check, decompose_barray_fat_pointer,
        },
        static_array::{DefaultStaticArrayCodegen, StaticArrayCodegen},
    },
    inkwell::{
        llvm_sys::core::LLVMIsAGlobalVariable,
        module::Linkage,
        types::BasicTypeEnum,
        values::{AsValueRef, BasicValue, BasicValueEnum, GlobalValue, IntValue, PointerValue},
    },
};

/// Maximum ABI alignment required by the scalar element types supported in QIR
/// arrays (pointers, 64-bit integers, and doubles).
const ARRAY_STORAGE_ALIGNMENT: u32 = 8;

/// Emits static-array constants as private storage owned by the QIR module.
#[derive(Clone, Debug, Default)]
pub struct QirStaticArrayCodegen;

impl StaticArrayCodegen for QirStaticArrayCodegen {
    fn static_array_value<'c, H: HugrView<Node = Node>>(
        &self,
        context: &mut EmitFuncContext<'c, '_, H>,
        value: &StaticArrayValue,
    ) -> Result<BasicValueEnum<'c>> {
        let array = DefaultStaticArrayCodegen.static_array_value(context, value)?;
        // SAFETY: `LLVMIsAGlobalVariable` returns either null or its argument,
        // which is a valid value reference owned by the current module.
        let global = unsafe { LLVMIsAGlobalVariable(array.as_value_ref()) };
        ensure!(
            !global.is_null(),
            "Static-array constant did not produce a global"
        );
        // SAFETY: The value was checked to be a global variable above.
        unsafe { GlobalValue::new(global) }.set_linkage(Linkage::Private);
        Ok(array)
    }
}

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
/// H2 barriers have a statically encoded arity, so a partially borrowed
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
        err: BasicValueEnum,
    ) -> Result<()> {
        super::QirPreludeCodegen.emit_panic(ctx, err)
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::inkwell::context::Context;
    use crate::test::{LLVM_TEST_LOCK, native_target_machine};
    use hugr::builder::{Dataflow, DataflowHugr};
    use hugr::extension::prelude::{ConstUsize, usize_t};
    use hugr::llvm::{
        emit::{EmitDebugInfo, EmitHugr, Namer, test::SimpleHugrConfig},
        utils::fat::FatExt,
    };
    use hugr::ops::constant::CustomConst;

    #[test]
    fn static_array_storage_is_private_and_preserved_while_live() {
        let _guard = LLVM_TEST_LOCK.lock().unwrap();
        let value = StaticArrayValue::try_new(
            "values",
            usize_t(),
            [3, 5, 8].map(|x| ConstUsize::new(x).into()),
        )
        .unwrap();
        let hugr = SimpleHugrConfig::new()
            .with_outs([value.get_type()])
            .finish(|mut builder| {
                let array = builder.add_load_value(value);
                builder.finish_hugr_with_outputs([array]).unwrap()
            });
        let context = Context::create();
        let module = EmitHugr::new(
            &context,
            context.create_module("static_array_storage"),
            std::rc::Rc::new(Namer::default()),
            crate::CompileArgs::default().codegen_extensions().into(),
        )
        .emit_module(hugr.fat_root().unwrap(), EmitDebugInfo::Exclude)
        .unwrap()
        .finish()
        .0;
        let function = module
            .get_functions()
            .find(|function| function.count_basic_blocks() > 0)
            .unwrap();
        function.set_linkage(Linkage::External);
        let globals = module.get_globals().collect::<Vec<_>>();
        assert_eq!(globals.len(), 1);
        let global = globals[0];
        assert_eq!(global.get_linkage(), Linkage::Private);
        let name = global.get_name().to_str().unwrap().to_owned();
        let i64_type = context.i64_type();
        let expected = context.const_struct(
            &[
                i64_type.const_int(3, false).into(),
                i64_type
                    .const_array(&[3, 5, 8].map(|x| i64_type.const_int(x, false)))
                    .into(),
            ],
            false,
        );
        assert_eq!(global.get_initializer(), Some(expected.into()));
        let target = native_target_machine();

        crate::cleanup_module_llvm(&module, &target).unwrap();

        assert_eq!(
            module.get_global(&name).unwrap().get_initializer(),
            Some(expected.into())
        );
        module.verify().unwrap();

        function.set_linkage(Linkage::Private);
        crate::cleanup_module_llvm(&module, &target).unwrap();
        assert!(module.get_global(&name).is_none());
        module.verify().unwrap();
    }
}
