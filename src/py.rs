use std::{ffi::OsString, iter};

use crate::CompileArgs;
use crate::cli::{Cli, CliOptimizationLevel};
use crate::target::CompileTarget;
use clap::{Parser, ValueEnum};
use hugr::llvm::inkwell;
use itertools::Itertools as _;
use pyo3::{
    Bound, PyResult, pyfunction, pymodule,
    types::{PyAnyMethods as _, PyModule, PyModuleMethods as _, PyTuple},
    wrap_pyfunction,
};

pyo3::create_exception!(
    _hugr_qir,
    CompilationError,
    pyo3::exceptions::PyRuntimeError
);

fn compilation_error_to_python(error: anyhow::Error) -> pyo3::PyErr {
    let py_error = if let Some(expected) =
        error.downcast_ref::<crate::compilation_error::CompilationError>()
    {
        CompilationError::new_err(expected.to_string())
    } else {
        pyo3::exceptions::PyRuntimeError::new_err(error.to_string())
    };
    // Preserve the complete Rust context chain for debugging, without
    // including it in the concise user-facing diagnostic.
    pyo3::Python::attach(|py| py_error.set_cause(py, Some(error.into())));
    py_error
}

#[pyfunction]
#[pyo3(signature = (*args))]
pub fn cli(args: &Bound<PyTuple>) -> PyResult<()> {
    let args = iter::once("hugr-qir".into())
        .chain(args.extract::<Vec<OsString>>()?)
        .collect_vec();
    let context = inkwell::context::Context::create();
    let mut cli = Cli::try_parse_from(args).map_err(anyhow::Error::from)?;
    let module = cli.run(&context).map_err(compilation_error_to_python)?;
    cli.write_module(&module)?;
    Ok(())
}

#[pyfunction]
pub fn opt_level_choices() -> Vec<String> {
    CliOptimizationLevel::value_variants()
        .iter()
        .filter_map(|v| v.to_possible_value().map(|pv| pv.get_name().to_string()))
        .collect()
}

#[pyfunction]
pub fn opt_level_default() -> String {
    CompileArgs::default()
        .opt_level
        .to_possible_value()
        .map(|pv| pv.get_name().to_string())
        .unwrap()
}

#[pyfunction]
pub fn max_loop_unroll_default() -> usize {
    CompileArgs::default().max_loop_unroll
}

#[pyfunction]
pub fn compile_target_choices() -> Vec<String> {
    CompileTarget::value_variants()
        .iter()
        .filter_map(|v| v.to_possible_value().map(|pv| pv.get_name().to_string()))
        .collect()
}

#[pyfunction]
pub fn compile_target_default() -> String {
    CompileArgs::default()
        .target
        .to_possible_value()
        .map(|pv| pv.get_name().to_string())
        .unwrap()
}

#[pymodule]
pub fn _hugr_qir(m: &Bound<PyModule>) -> PyResult<()> {
    m.add("CompilationError", m.py().get_type::<CompilationError>())?;
    m.add_function(wrap_pyfunction!(cli, m)?)?;
    m.add_function(wrap_pyfunction!(opt_level_choices, m)?)?;
    m.add_function(wrap_pyfunction!(opt_level_default, m)?)?;
    m.add_function(wrap_pyfunction!(max_loop_unroll_default, m)?)?;
    m.add_function(wrap_pyfunction!(compile_target_choices, m)?)?;
    m.add_function(wrap_pyfunction!(compile_target_default, m)?)?;
    Ok(())
}
