# Python API

## Main functions

The Python layer centers on `python/hugr_qir/hugr_to_qir.py`.


### `hugr_to_qir`

```{eval-rst}
.. currentmodule:: hugr_qir.hugr_to_qir
.. autofunction:: hugr_to_qir
```

Example:

```python
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat

bitcode = hugr_to_qir(hugr_package, output_format=OutputFormat.BITCODE)
```

Key parameters:

- `hugr`: either a `hugr.package.Package` or serialized HUGR bytes
- `validate_qir`: run QIR validation after code generation
- `validate_hugr`: validate the input HUGR before and during compilation
- `target`: compilation target passed through to the Rust backend
- `opt_level`: LLVM optimization level
- `output_format`: `LLVM_IR`, `BITCODE`, or `BASE64`
- `wasm_file`: optional path to a Wasm module used by the Wasm extension


### Convenience helpers

```{eval-rst}
.. currentmodule:: hugr_qir.hugr_to_qir
.. autofunction:: to_qir_str
.. autofunction:: to_qir_bytes
```

## Output formats

The output format enum lives in `python/hugr_qir/output.py`.

- `OutputFormat.LLVM_IR`
- `OutputFormat.BITCODE`
- `OutputFormat.BASE64`

## H-Series Result Helper

```{eval-rst}
.. automodule:: hugr_qir.h_series_helpers.results
   :members:
```
