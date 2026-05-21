# Arrays

These examples show the current boundary for array-like programming for H-Series compatible Guppy.

The important theme is that compile-time arrays can be useful as a structuring tool, but runtime array values and helpers that depend on borrowed array representations are not yet supported by `hugr-qir`.

## Supported: compile-time arrays

Source file: `guppy_examples/guppy-features/supported/comptime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/comptime-array.py
:language: python
```

This example works because the array manipulation happens under `@guppy.comptime`, so the loop structure and indexing can be resolved before QIR emission.

## Unsupported: runtime arrays

Source file: `guppy_examples/guppy-features/unsupported/runtime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/runtime-array.py
:language: python
```

This version looks structurally similar to the compile-time example above, but it keeps the arrays in ordinary `@guppy` functions and therefore requires runtime array support during lowering.

Expected error:

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/runtime-array.error
:language: text
```

## Unsupported: `measure_array`

Source file: `guppy_examples/guppy-features/unsupported/measure-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/measure-array.py
:language: python
```

This fails because `measure_array` relies on borrowed array types that are not currently emitted by the backend.

Expected error:

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/measure-array.error
:language: text
```

## Unsupported: `discard_array`

Source file: `guppy_examples/guppy-features/unsupported/discard-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/discard-array.py
:language: python
```

Like `measure_array`, this path depends on array borrowing support that is not yet available in QIR emission.

Expected error:

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/discard-array.error
:language: text
```
