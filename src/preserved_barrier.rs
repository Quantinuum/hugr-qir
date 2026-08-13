use std::str::FromStr;
use std::sync::{Arc, Weak};

use anyhow::Result;
use hugr::extension::prelude::Barrier;
use hugr::extension::simple_op::{MakeExtensionOp, MakeOpDef, MakeRegisteredOp, OpLoadError};
use hugr::extension::{
    Extension, ExtensionId, OpDef, SignatureError, SignatureFunc, Version, simple_op::try_from_name,
};
use hugr::hugr::IdentList;
use hugr::ops::{ExtensionOp, OpName};
use hugr::types::type_param::{TypeArg, TypeParam};
use hugr::types::{FuncValueType, PolyFuncTypeRV, TypeBound, TypeRow, TypeRowRV};
use hugr::{Hugr, HugrView};
use hugr_core::hugr::internal::HugrMutInternals;
use lazy_static::lazy_static;

pub const PRESERVED_BARRIER_EXTENSION_ID: ExtensionId = IdentList::new_unchecked("hqir.barrier");
pub const PRESERVED_BARRIER_EXTENSION_VERSION: Version = Version::new(0, 1, 0);
pub const PRESERVED_BARRIER_OP_ID: OpName = OpName::new_inline("PreservedBarrier");

lazy_static! {
    pub static ref PRESERVED_BARRIER_EXTENSION: Arc<Extension> = Extension::new_arc(
        PRESERVED_BARRIER_EXTENSION_ID,
        PRESERVED_BARRIER_EXTENSION_VERSION,
        |ext, ext_ref| {
            PreservedBarrierDef.add_to_extension(ext, ext_ref).unwrap();
        },
    );
}

pub struct PreservedBarrierDef;

impl FromStr for PreservedBarrierDef {
    type Err = ();

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        if s == PreservedBarrierDef.op_id() {
            Ok(Self)
        } else {
            Err(())
        }
    }
}

impl MakeOpDef for PreservedBarrierDef {
    fn opdef_id(&self) -> OpName {
        PRESERVED_BARRIER_OP_ID
    }

    fn init_signature(&self, _extension_ref: &Weak<Extension>) -> SignatureFunc {
        PolyFuncTypeRV::new(
            vec![TypeParam::new_list_kind(TypeBound::Linear)],
            FuncValueType::new_endo(TypeRowRV::new_var_use(0, TypeBound::Linear)),
        )
        .into()
    }

    fn description(&self) -> String {
        "Preserve a prelude barrier while qsystem rebasing runs".to_string()
    }

    fn from_def(op_def: &OpDef) -> std::result::Result<Self, OpLoadError> {
        try_from_name(op_def.name(), op_def.extension_id())
    }

    fn extension(&self) -> ExtensionId {
        PRESERVED_BARRIER_EXTENSION_ID
    }

    fn extension_ref(&self) -> Weak<Extension> {
        Arc::downgrade(&PRESERVED_BARRIER_EXTENSION)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PreservedBarrier {
    type_row: TypeRow,
}

impl PreservedBarrier {
    fn new(type_row: impl Into<TypeRow>) -> Self {
        Self {
            type_row: type_row.into(),
        }
    }
}

impl MakeExtensionOp for PreservedBarrier {
    fn op_id(&self) -> OpName {
        PreservedBarrierDef.op_id()
    }

    fn from_extension_op(ext_op: &ExtensionOp) -> std::result::Result<Self, OpLoadError>
    where
        Self: Sized,
    {
        let _def = PreservedBarrierDef::from_def(ext_op.def())?;

        let [TypeArg::List(elems)] = ext_op.args() else {
            return Err(SignatureError::InvalidTypeArgs.into());
        };
        let type_row = elems.clone().try_into()?;
        Ok(Self { type_row })
    }

    fn type_args(&self) -> Vec<TypeArg> {
        vec![self.type_row.clone().into()]
    }
}

impl MakeRegisteredOp for PreservedBarrier {
    fn extension_id(&self) -> ExtensionId {
        PRESERVED_BARRIER_EXTENSION_ID
    }

    fn extension_ref(&self) -> Arc<Extension> {
        PRESERVED_BARRIER_EXTENSION.clone()
    }
}

pub fn preserve_barriers_before_qsystem_pass(hugr: &mut Hugr) -> Result<()> {
    let barrier_nodes = hugr
        .nodes()
        .filter(|&node| hugr.get_optype(node).cast::<Barrier>().is_some())
        .collect::<Vec<_>>();

    if barrier_nodes.is_empty() {
        return Ok(());
    }

    hugr.extensions_mut()
        .register(PRESERVED_BARRIER_EXTENSION.clone());

    for node in barrier_nodes {
        let barrier = hugr
            .get_optype(node)
            .cast::<Barrier>()
            .expect("barrier nodes were filtered above");
        hugr.replace_op(node, PreservedBarrier::new(barrier.type_row));
    }
    Ok(())
}

pub fn restore_preserved_barriers_after_qsystem_pass(hugr: &mut Hugr) -> Result<()> {
    let preserved_nodes = hugr
        .nodes()
        .filter(|&node| hugr.get_optype(node).cast::<PreservedBarrier>().is_some())
        .collect::<Vec<_>>();

    for node in preserved_nodes {
        let barrier = hugr
            .get_optype(node)
            .cast::<PreservedBarrier>()
            .expect("preserved barrier nodes were filtered above");
        hugr.replace_op(node, Barrier::new(barrier.type_row));
    }
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    use hugr::extension::prelude::{Barrier, qb_t};
    use tket::passes::ComposablePass;
    use tket_qsystem::{QSystemPlatform, QSystemRebasePass};

    use crate::test::single_op_hugr;

    fn count_op<T>(hugr: &Hugr) -> usize
    where
        T: MakeExtensionOp,
    {
        hugr.nodes()
            .filter(|&node| hugr.get_optype(node).cast::<T>().is_some())
            .count()
    }

    #[test]
    fn preserve_and_restore_prelude_barrier() {
        let mut hugr = single_op_hugr(Barrier::new(vec![qb_t()]).into());

        assert_eq!(count_op::<Barrier>(&hugr), 1);
        assert_eq!(count_op::<PreservedBarrier>(&hugr), 0);

        preserve_barriers_before_qsystem_pass(&mut hugr).unwrap();
        assert_eq!(count_op::<Barrier>(&hugr), 0);
        assert_eq!(count_op::<PreservedBarrier>(&hugr), 1);
        hugr.validate().unwrap();

        restore_preserved_barriers_after_qsystem_pass(&mut hugr).unwrap();
        assert_eq!(count_op::<Barrier>(&hugr), 1);
        assert_eq!(count_op::<PreservedBarrier>(&hugr), 0);
        hugr.validate().unwrap();
    }

    #[test]
    fn preserved_barrier_survives_qsystem_rebase() {
        let mut hugr = single_op_hugr(Barrier::new(vec![qb_t()]).into());

        preserve_barriers_before_qsystem_pass(&mut hugr).unwrap();
        QSystemRebasePass::defaults(QSystemPlatform::Helios)
            .run(&mut hugr)
            .unwrap();
        assert_eq!(count_op::<PreservedBarrier>(&hugr), 1);

        restore_preserved_barriers_after_qsystem_pass(&mut hugr).unwrap();
        assert_eq!(count_op::<Barrier>(&hugr), 1);
        assert_eq!(count_op::<PreservedBarrier>(&hugr), 0);
        hugr.validate().unwrap();
    }
}
