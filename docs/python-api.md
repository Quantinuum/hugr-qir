# Python API

## Main functions

The Python layer centers on `python/hugr_qir/hugr_to_qir.py`.

### `hugr_to_qir`

```python
hugr_to_qir(
    hugr,
    *,
    validate_qir=True,
    validate_hugr=False,
    target="native",
    opt_level="default",
    output_format=OutputFormat.BASE64,
    wasm_file=None,
)
```

Key parameters:

- `hugr`: either a `hugr.package.Package` or serialized HUGR bytes
- `validate_qir`: run QIR validation after code generation
- `validate_hugr`: validate the input HUGR before and during compilation
- `target`: compilation target passed through to the Rust backend
- `opt_level`: LLVM optimization level
- `output_format`: `LLVM_IR`, `BITCODE`, or `BASE64`
- `wasm_file`: optional path to a WASM module used by the wasm extension

### Convenience helpers

- `to_qir_str(...)`: returns LLVM IR as `str`
- `to_qir_bytes(...)`: returns bitcode as `bytes`

## Output formats

The output enum lives in `python/hugr_qir/output.py`.

- `OutputFormat.LLVM_IR`
- `OutputFormat.BITCODE`
- `OutputFormat.BASE64`

Example:

```python
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat

bitcode = hugr_to_qir(hugr_package, output_format=OutputFormat.BITCODE)
```

## Error behavior

The Python wrapper raises `ValueError` when code generation or validation fails. For wasm-related failures, the backend attempts to produce function-specific errors that mention the wasm function being looked up.
