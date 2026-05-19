# Architecture

At a high level, `hugr-qir` takes a HUGR package, runs a Rust lowering pipeline, and emits QIR as LLVM IR or bitcode.

## Main flow

1. Input HUGR is loaded through the CLI or the Python wrapper.
2. The Rust backend validates and transforms the package.
3. The backend lowers the result into an LLVM module.
4. The module is emitted as LLVM IR or bitcode.
5. The Python wrapper can optionally validate the generated QIR.

## Main entrypoints

- Native executable entry: `src/main.rs`
- CLI argument handling: `src/cli.rs`
- Python wrapper: `python/hugr_qir/cli.py`

## Wasm integration

Wasm metadata is parsed once when a Wasm file is provided, then validated at lookup time when a specific Wasm function is actually referenced. This keeps unrelated functions in the module from causing spurious failures.

The Wasm implementation lives in `src/qir/wasm_ext.rs`.
