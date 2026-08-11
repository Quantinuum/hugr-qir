use crate::inkwell::{
    attributes::AttributeLoc,
    context::Context,
    types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum, FunctionType, StructType},
    values::{BasicValue, FunctionValue},
};
use hugr::types::{Signature, Type};
use hugr::{
    HugrView, Node,
    extension::simple_op::MakeExtensionOp as _,
    ops::ExtensionOp,
    std_extensions::arithmetic::int_types::INT_TYPES,
    types::{CustomType, TypeRow},
};
use hugr_llvm::{
    CodegenExtension, CodegenExtsBuilder,
    emit::{EmitFuncContext, EmitOpArgs},
    types::TypingSession,
};
use itertools::Itertools;
use std::collections::BTreeMap;
use std::fs;

use anyhow::{Result, anyhow, bail};
use hugr_core::extension::prelude::option_type;
use tket_qsystem::extension::classical_compute::wasm;
use tket_qsystem::extension::wasm::WasmType;
use wasmparser::{Export, ExternalKind, FuncType, Payload, TypeRef, ValType};

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct WasmFuncInfo {
    pub export_name: Option<String>,
    pub params: Vec<ValType>,
    pub results: Vec<ValType>,
}

pub struct WasmCodegen {
    funcs: BTreeMap<u64, WasmFuncInfo>,
    wasm_file: Option<String>,
}

impl WasmCodegen {
    pub fn new(wasm_file: &Option<String>) -> Self {
        let mut funcs = BTreeMap::new();
        if let Some(wasm_file) = wasm_file {
            // This is the only place the wasm file is actually read
            funcs = wasm_funcs_from_wasm_file(wasm_file)
                .unwrap_or_else(|err| panic!("Failed to load WASM file `{wasm_file}`: {err}"));
        }
        WasmCodegen {
            funcs,
            wasm_file: wasm_file.clone(),
        }
    }
}

// Read in the wasm functions from the wasm file
// Save signatures for later validation if a function is actually required
pub fn wasm_funcs_from_wasm_file(wasm_file_path: &String) -> Result<BTreeMap<u64, WasmFuncInfo>> {
    let bytes = fs::read(wasm_file_path)
        .map_err(|e| anyhow!("Could not read WASM file `{wasm_file_path}`: {e}"))?;
    let mut types: Vec<FuncType> = Vec::new();
    let mut imported_func_type_idxs = Vec::new();
    let mut defined_func_type_idxs = Vec::new();
    let mut function_exports = BTreeMap::new();

    for payload in wasmparser::Parser::new(0).parse_all(&bytes) {
        match payload? {
            Payload::TypeSection(reader) => {
                for ty in reader.into_iter_err_on_gc_types() {
                    types.push(ty?);
                }
            }
            Payload::ImportSection(reader) => {
                for import in reader.into_imports() {
                    let import = import?;
                    match import.ty {
                        TypeRef::Func(type_idx) | TypeRef::FuncExact(type_idx) => {
                            imported_func_type_idxs.push(type_idx);
                        }
                        _ => {}
                    }
                }
            }
            Payload::FunctionSection(reader) => {
                for type_idx in reader {
                    defined_func_type_idxs.push(type_idx?);
                }
            }
            Payload::ExportSection(exports) => {
                for (export_index, e) in exports.into_iter().enumerate() {
                    let Export { name, kind, index } = e?;
                    if kind != ExternalKind::Func {
                        continue;
                    }
                    function_exports.insert(export_index as u64, (name.to_string(), index));
                }
            }
            _ => {}
        }
    }

    let mut funcs = BTreeMap::new();
    let function_type_idxs = imported_func_type_idxs
        .into_iter()
        .chain(defined_func_type_idxs)
        .collect_vec();
    for (export_index, (name, func_index)) in function_exports {
        let Some(type_idx) = function_type_idxs.get(func_index as usize) else {
            bail!("Invalid wasm function index {func_index} for export {name}");
        };
        let Some(ty) = types.get(*type_idx as usize) else {
            bail!("Invalid wasm type index {type_idx} for function export {name}");
        };
        funcs.insert(
            export_index,
            WasmFuncInfo {
                export_name: Some(name),
                params: ty.params().to_vec(),
                results: ty.results().to_vec(),
            },
        );
    }

    Ok(funcs)
}

impl CodegenExtension for WasmCodegen {
    fn add_extension<'a, H: HugrView<Node = Node> + 'a>(
        self,
        builder: CodegenExtsBuilder<'a, H>,
    ) -> CodegenExtsBuilder<'a, H> {
        builder
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::CONTEXT_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(empty_struct_type(session.iw_context()).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::FUNC_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| {
                    // The "storage type" (type of the in-mem representation) of a WASM
                    // function is an opaque pointer in LLVM 16+.
                    //
                    // We delay validation of the actual function signatures until op
                    // lowering, because at that point we know the function name and can
                    // give a better error message.
                    Ok(session.llvm_ptr_type().into())
                },
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::MODULE_TYPE_NAME.to_owned(),
                ),
                |session, _hugr_type| Ok(empty_struct_type(session.iw_context()).into()),
            )
            .custom_type(
                (
                    wasm::EXTENSION_ID.to_owned(),
                    wasm::RESULT_TYPE_NAME.to_owned(),
                ),
                |session, hugr_type| result_type(session, hugr_type),
            )
            .simple_extension_op(move |context, args, _: wasm::WasmOpDef| {
                emit_wasm_op(self.wasm_file.as_deref(), &self.funcs, context, args)
            })
            .custom_const({
                move |ctx, _mod: &wasm::ConstWasmModule| {
                    Ok(ctx.iw_context().const_struct(&[], false).into())
                }
            })
    }
}

fn empty_struct_type(context: &Context) -> StructType<'_> {
    context.struct_type(&[], false)
}

fn result_type<'c>(
    session: TypingSession<'c, '_>,
    hugr_type: &CustomType,
) -> Result<BasicTypeEnum<'c>> {
    let wasm::WasmType::Result { outputs } = hugr_type.clone().try_into()? else {
        anyhow::bail!("Expected WasmType::Result");
    };
    let outputs: TypeRow = outputs.try_into()?;

    if outputs.is_empty() {
        return Ok(empty_struct_type(session.iw_context()).into());
    }

    if outputs.len() > 1 {
        bail!("Result type has more than one output value")
    }
    session.llvm_type(&outputs[0].clone().try_into().unwrap())
}

fn insert_func<'c, H: HugrView<Node = Node>>(
    ctx: &EmitFuncContext<'c, '_, H>,
    name: &str,
    func_type: FunctionType<'c>,
) -> Result<FunctionValue<'c>> {
    let func = ctx.get_extern_func(name, func_type)?;
    let llvm_context = ctx.get_current_module().get_context();
    let attribute = llvm_context.create_string_attribute("wasm", "");
    func.add_attribute(AttributeLoc::Function, attribute);
    Ok(func)
}

fn validate_wasm_func_signature(name: &str, params: &[ValType], results: &[ValType]) -> Result<()> {
    let invalid_inputs = params
        .iter()
        .enumerate()
        .filter(|(_, ty)| **ty != ValType::I32)
        .map(|(idx, ty)| format!("input {idx} has type {ty}"))
        .collect_vec();
    if !invalid_inputs.is_empty() {
        bail!(
            "wasm function {name:?} has unsupported parameter types: {}; only i32 inputs are supported",
            invalid_inputs.join(", ")
        );
    }

    if results.len() > 1 {
        bail!(
            "wasm function {name:?} has {} results ({:?}); at most one i32 result is supported",
            results.len(),
            results
        );
    }

    if let Some(result) = results.first()
        && *result != ValType::I32
    {
        bail!(
            "wasm function {name:?} has unsupported result type {result}; only i32 or no result is supported"
        );
    }

    Ok(())
}

fn hugr_type_matches_wasm_i32(ty: &Type) -> bool {
    ty == &INT_TYPES[5] || ty == &INT_TYPES[6]
}

fn validate_lookup_row_against_wasm(
    func_name: &str,
    row_kind: &str,
    requested: &TypeRow,
    wasm: &[ValType],
) -> Result<()> {
    if requested.len() != wasm.len() {
        bail!(
            "wasm function {func_name:?} {row_kind} signature mismatch: requested {} {row_kind}s, but wasm function has {}",
            requested.len(),
            wasm.len()
        );
    }

    let mismatches = requested
        .iter()
        .zip(wasm.iter())
        .enumerate()
        .filter_map(|(idx, (requested_ty, wasm_ty))| match wasm_ty {
            ValType::I32 if hugr_type_matches_wasm_i32(requested_ty) => None,
            _ => Some(format!(
                "{row_kind} {idx} has requested type {} but wasm function expects {wasm_ty}",
                requested_ty
            )),
        })
        .collect_vec();

    if !mismatches.is_empty() {
        bail!(
            "wasm function {func_name:?} {row_kind} signature mismatch: {}",
            mismatches.join(", ")
        );
    }

    Ok(())
}

fn validate_lookup_signature(
    func_name: &str,
    requested_inputs: &TypeRow,
    requested_outputs: &TypeRow,
    func_info: &WasmFuncInfo,
) -> Result<()> {
    validate_wasm_func_signature(func_name, &func_info.params, &func_info.results)?;
    validate_lookup_row_against_wasm(func_name, "input", requested_inputs, &func_info.params)?;
    validate_lookup_row_against_wasm(func_name, "output", requested_outputs, &func_info.results)?;
    Ok(())
}

fn wasm_func_by_name<'a>(
    wasm_module: &'a BTreeMap<u64, WasmFuncInfo>,
    name: &str,
) -> Option<&'a WasmFuncInfo> {
    wasm_module
        .values()
        .find(|func_info| func_info.export_name.as_deref() == Some(name))
}

fn missing_wasm_func_id_message(wasm_file: Option<&str>, id: u64) -> String {
    if let Some(wasm_file) = wasm_file {
        format!("Wasm function id {id} not found in wasm file {wasm_file}")
    } else {
        format!("Wasm function id {id} not found because no wasm file was provided")
    }
}

fn missing_wasm_func_name_message(wasm_file: Option<&str>, name: &str) -> String {
    if let Some(wasm_file) = wasm_file {
        format!("Wasm function name {name:?} not found in wasm file {wasm_file}")
    } else {
        format!("Wasm function name {name:?} not found because no wasm file was provided")
    }
}

fn emit_wasm_op<'c, H: HugrView<Node = Node>>(
    wasm_file: Option<&str>,
    wasm_module: &BTreeMap<u64, WasmFuncInfo>,
    ctx: &EmitFuncContext<'c, '_, H>,
    args: EmitOpArgs<'c, '_, ExtensionOp, H>,
) -> Result<()> {
    match wasm::WasmOp::from_extension_op(&args.node())? {
        wasm::WasmOp::GetContext => {
            let r = ctx.iw_context().struct_type(&[], false).get_undef().into();
            let builder = ctx.builder();
            let result_t = ctx.llvm_sum_type(option_type(vec![Type::new_extension(
                WasmType::Context.into(),
            )]))?;
            // Although the result is an option type, we always return true
            // in this lowering: failure is already handled.
            let pair = result_t.build_tag(builder, 1, vec![r])?;
            args.outputs
                .finish(ctx.builder(), [pair.as_basic_value_enum()])
        }
        wasm::WasmOp::DisposeContext => {
            let builder = ctx.builder();
            args.outputs.finish(builder, [])
        }
        wasm::WasmOp::LookupById {
            id,
            inputs,
            outputs,
        } => {
            let Some(func_info) = wasm_module.get(&id) else {
                bail!("{}", missing_wasm_func_id_message(wasm_file, id))
            };
            let Some(name) = func_info.export_name.as_deref() else {
                bail!("Wasm module id {id} is defined but not exported");
            };
            let inputs: TypeRow = inputs.try_into()?;
            let outputs: TypeRow = outputs.try_into()?;
            validate_lookup_signature(name, &inputs, &outputs, func_info)?;
            let llvm_func_ty = ctx.llvm_func_type(&Signature::new(inputs, outputs))?;
            let func = insert_func(ctx, name, llvm_func_ty)?;
            let builder = ctx.builder();
            args.outputs
                .finish(builder, [func.as_global_value().as_pointer_value().into()])
        }
        wasm::WasmOp::LookupByName {
            name,
            inputs,
            outputs,
        } => {
            let inputs: TypeRow = inputs.try_into()?;
            let outputs: TypeRow = outputs.try_into()?;
            let Some(func_info) = wasm_func_by_name(wasm_module, &name) else {
                bail!("{}", missing_wasm_func_name_message(wasm_file, &name))
            };
            validate_lookup_signature(&name, &inputs, &outputs, func_info)?;
            let llvm_func_ty = ctx.llvm_func_type(&Signature::new(inputs, outputs))?;
            let func = insert_func(ctx, &name, llvm_func_ty)?;
            let builder = ctx.builder();
            args.outputs
                .finish(builder, [func.as_global_value().as_pointer_value().into()])
        }
        wasm::WasmOp::Call { outputs, .. } => {
            let func_ptr = args.inputs[1].into_pointer_value();
            let call_args = args.inputs[2..]
                .iter()
                .copied()
                .map(|x| x.into())
                .collect::<Vec<_>>();
            let arg_tys: Vec<BasicMetadataTypeEnum> = args.inputs[2..]
                .iter()
                .map(|value| value.get_type().into())
                .collect();
            let llvm_func_ty = if outputs.is_empty() {
                ctx.iw_context().void_type().fn_type(&arg_tys, false)
            } else if outputs.len() == 1 {
                ctx.llvm_type(&outputs[0])?.fn_type(&arg_tys, false)
            } else {
                bail!("WasmOp::Call must have zero or one outputs; got {outputs}");
            };

            let builder = ctx.builder();
            let r = builder.build_indirect_call(llvm_func_ty, func_ptr, &call_args, "")?;

            // if no outputs, return a placeholder empty struct.
            // if one output, return that output directly.
            let r = if outputs.is_empty() {
                empty_struct_type(ctx.iw_context()).get_undef().into()
            } else {
                r.try_as_basic_value().basic().unwrap()
            };
            args.outputs.finish(builder, [r])
        }
        wasm::WasmOp::ReadResult { outputs } => {
            let [r] = args.inputs.as_slice() else {
                bail!("expected 1 input")
            };
            let builder = ctx.builder();
            let ctx_out = empty_struct_type(ctx.iw_context()).get_undef().into();
            if outputs.is_empty() {
                args.outputs.finish(builder, [ctx_out])
            } else {
                args.outputs.finish(builder, [ctx_out, *r])
            }
        }
        op => bail!("Unknown op: {op:?}"),
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::WasmCodegen;
    use crate::qir::utils_ext::UtilsCodegenExtension;
    use anyhow::Error;
    use hugr::llvm::check_emission;
    use hugr::llvm::test::{TestContext, llvm_ctx, single_op_hugr};
    use rstest::Context;
    use tket::circuit::TypeRow;
    use tket::hugr::std_extensions::arithmetic::int_types::INT_TYPES;
    use tket::hugr::type_row;
    use tket_qsystem::extension::wasm::WasmOp;

    #[rstest::rstest]
    #[case::get_context(WasmOp::GetContext)]
    #[case::dispose_context(WasmOp::DisposeContext)]
    #[case::lookup_by_id(WasmOp::LookupById {
        id: 42,
        inputs: type_row![].into(),
        outputs: type_row![].into(),
        })]
    #[case::lookup_by_name(WasmOp::LookupByName {
        name: "example_function".into(),
        inputs: type_row![].into(),
        outputs: type_row![].into(),
        })]
    #[case::call_args(WasmOp::Call {
        inputs: TypeRow::from(vec![
            INT_TYPES[5].clone(),
        ]),
        outputs: TypeRow::from(vec![]),
        })]
    #[case::call_ret_int(WasmOp::Call {
        inputs: type_row![],
        outputs: TypeRow::from(vec![INT_TYPES[5].clone()]),
        })]
    #[case::read_result_int(WasmOp::ReadResult {
        outputs: TypeRow::from(vec![INT_TYPES[5].clone()]),
        })]
    fn wasm_codegen(#[context] ctx: Context, mut llvm_ctx: TestContext, #[case] op: WasmOp) {
        let _g = {
            let desc = ctx.description.unwrap();
            let mut settings = insta::Settings::clone_current();
            let suffix = settings
                .snapshot_suffix()
                .map_or_else(|| desc.to_string(), |s| format!("{s}_{desc}"));
            settings.set_snapshot_suffix(suffix);
            settings
        }
        .bind_to_scope();

        llvm_ctx.add_extensions(move |cge| {
            cge.add_extension(UtilsCodegenExtension)
                .add_default_prelude_extensions()
                .add_default_int_extensions()
                .add_extension(WasmCodegen {
                    funcs: BTreeMap::from([
                        (
                            42,
                            WasmFuncInfo {
                                export_name: Some("wasm_func_42".into()),
                                params: vec![],
                                results: vec![],
                            },
                        ),
                        (
                            43,
                            WasmFuncInfo {
                                export_name: Some("example_function".into()),
                                params: vec![],
                                results: vec![],
                            },
                        ),
                    ]),
                    wasm_file: Some("example.wasm".into()),
                })
        });
        let hugr = single_op_hugr(op.into());
        check_emission!(hugr, llvm_ctx);
    }

    fn err_text(err: Error) -> String {
        format!("{err:#}")
    }

    #[test]
    fn validate_wasm_func_signature_accepts_i32_params_and_optional_i32_result() {
        validate_wasm_func_signature("example", &[ValType::I32, ValType::I32], &[ValType::I32])
            .unwrap();
        validate_wasm_func_signature("example", &[ValType::I32], &[]).unwrap();
    }

    #[test]
    fn validate_wasm_func_signature_rejects_non_i32_params() {
        let err = validate_wasm_func_signature(
            "example",
            &[ValType::I32, ValType::F32, ValType::I64],
            &[],
        )
        .unwrap_err();
        let err = err_text(err);
        assert!(err.contains("\"example\""));
        assert!(err.contains("input 1 has type f32"));
        assert!(err.contains("input 2 has type i64"));
    }

    #[test]
    fn validate_wasm_func_signature_rejects_multiple_results() {
        let err =
            validate_wasm_func_signature("example", &[ValType::I32], &[ValType::I32, ValType::I32])
                .unwrap_err();
        let err = err_text(err);
        assert!(err.contains("\"example\""));
        assert!(err.contains("has 2 results"));
    }

    #[test]
    fn validate_wasm_func_signature_rejects_non_i32_result() {
        let err =
            validate_wasm_func_signature("example", &[ValType::I32], &[ValType::F64]).unwrap_err();
        let err = err_text(err);
        assert!(err.contains("\"example\""));
        assert!(err.contains("unsupported result type f64"));
    }

    #[test]
    fn missing_wasm_func_id_message_mentions_file_when_present() {
        assert_eq!(
            missing_wasm_func_id_message(Some("example.wasm"), 42),
            "Wasm function id 42 not found in wasm file example.wasm"
        );
    }

    #[test]
    fn missing_wasm_func_id_message_mentions_missing_file() {
        assert_eq!(
            missing_wasm_func_id_message(None, 42),
            "Wasm function id 42 not found because no wasm file was provided"
        );
    }

    #[test]
    fn missing_wasm_func_name_message_mentions_file_when_present() {
        assert_eq!(
            missing_wasm_func_name_message(Some("example.wasm"), "foo"),
            "Wasm function name \"foo\" not found in wasm file example.wasm"
        );
    }

    #[test]
    fn missing_wasm_func_name_message_mentions_missing_file() {
        assert_eq!(
            missing_wasm_func_name_message(None, "foo"),
            "Wasm function name \"foo\" not found because no wasm file was provided"
        );
    }

    #[test]
    fn validate_lookup_signature_accepts_i64_for_wasm_i32() {
        let func_info = WasmFuncInfo {
            export_name: Some("example".into()),
            params: vec![ValType::I32],
            results: vec![ValType::I32],
        };
        validate_lookup_signature(
            "example",
            &TypeRow::from(vec![INT_TYPES[6].clone()]),
            &TypeRow::from(vec![INT_TYPES[6].clone()]),
            &func_info,
        )
        .unwrap();
    }

    #[test]
    fn validate_lookup_signature_rejects_input_length_mismatch() {
        let func_info = WasmFuncInfo {
            export_name: Some("example".into()),
            params: vec![ValType::I32],
            results: vec![],
        };
        let err = validate_lookup_signature(
            "example",
            &TypeRow::from(vec![INT_TYPES[5].clone(), INT_TYPES[5].clone()]),
            &TypeRow::new(),
            &func_info,
        )
        .unwrap_err();
        let err = err_text(err);
        assert!(err.contains("input signature mismatch"));
        assert!(err.contains("requested 2 inputs"));
        assert!(err.contains("wasm function has 1"));
    }

    #[test]
    fn validate_lookup_signature_rejects_incompatible_input_type() {
        let func_info = WasmFuncInfo {
            export_name: Some("example".into()),
            params: vec![ValType::I32],
            results: vec![],
        };
        let err = validate_lookup_signature(
            "example",
            &TypeRow::from(vec![INT_TYPES[4].clone()]),
            &TypeRow::new(),
            &func_info,
        )
        .unwrap_err();
        let err = err_text(err);
        assert!(err.contains("input signature mismatch"));
        assert!(err.contains("input 0"));
        assert!(err.contains("expects i32"));
    }

    #[test]
    fn validate_lookup_signature_rejects_output_presence_mismatch() {
        let func_info = WasmFuncInfo {
            export_name: Some("example".into()),
            params: vec![],
            results: vec![ValType::I32],
        };
        let err =
            validate_lookup_signature("example", &TypeRow::new(), &TypeRow::new(), &func_info)
                .unwrap_err();
        let err = err_text(err);
        assert!(err.contains("output signature mismatch"));
        assert!(err.contains("requested 0 outputs"));
        assert!(err.contains("wasm function has 1"));
    }
}
