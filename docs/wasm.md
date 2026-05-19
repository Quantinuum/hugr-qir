# WASM Support

`hugr-qir` supports lowering programs that use the wasm extension and refer to functions in a provided WASM module.

Currently, the only supported guppylang wasm platform is `WasmPlatform.H2`. This is not
the default and must be explicitly set as a parameter to the guppylang `@wasm_module` decorator.

Only a single WASM context is supported. `guppylang.std.qsystem.spawn_wasm_contexts` is not supported, and the context is created by constructing the decorated WASM module class with `MyWasm(nat(1))` (see [Examples: WASM integration](examples/wasm.md)).

In the compiled WASM file, the only supported function parameter type is a 32-bit integer. A WASM file may still contain unsupported functions, as long as the Guppy program does not call them.


## Providing a WASM file

Python:

```python
qir = hugr_to_qir(hugr_package, wasm_file=Path("module.wasm"))
```

CLI:

```bash
hugr-qir input.hugr --wasm-file module.wasm
```

## Signature validation

When a wasm function is referenced, the backend checks:

- the requested input arity matches the wasm signature
- the requested output arity matches the wasm signature
- wasm parameters must be `i32`
- wasm results must have length `<= 1`
- a single wasm result, if present, must be `i32`
- the requested HUGR-side integer types may use `i64` where the wasm signature uses `i32`

This validation is intentionally deferred until lookup time, so unrelated functions in the same wasm file do not cause compilation to fail.

## Missing functions

If a lookup references a function that is not present in the provided wasm file, the error message includes the lookup target and, when available, the wasm filename.
