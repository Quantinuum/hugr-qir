# Arrays

These examples show the current boundary for array-like programming for H-Series compatible Guppy.

The important theme is that compile-time arrays can be useful as a structuring tool, but runtime array values and helpers that depend on borrowed array representations are not yet supported by `hugr-qir`.

## Supported: compile-time arrays

Source file: `guppy_examples/guppy-features/supported/comptime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/comptime-array.py
:language: python
```

This example works because the array manipulation happens under `@guppy.comptime`, so the loop structure and indexing can be resolved before QIR emission.

## Supported: compile-time array copy and unpacking

Source file: `guppy_examples/guppy-features/supported/comptime-array-copy-unpack.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/comptime-array-copy-unpack.py
:language: python
```

Copying and starred unpacking produce array-like values, so this pattern stays under `@guppy.comptime`.

## Unsupported: runtime arrays

Source file: `guppy_examples/guppy-features/unsupported/runtime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/runtime-array.py
:language: python
```

This version looks structurally similar to the compile-time example above, but it keeps the arrays in ordinary `@guppy` functions and therefore requires runtime array support during lowering.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/runtime-array.error
:language: text
```

## Unsupported: `measure_array`

Source file: `guppy_examples/guppy-features/unsupported/measure-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/measure-array.py
:language: python
```

This fails because `measure_array` relies on borrowed array types that are not currently emitted by the backend.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/measure-array.error
:language: text
```

## Unsupported: `discard_array`

Source file: `guppy_examples/guppy-features/unsupported/discard-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/discard-array.py
:language: python
```

Like `measure_array`, this path depends on array borrowing support that is not yet available in QIR emission.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/discard-array.error
:language: text
```

## Unsupported: array-backed collections

`Stack`, `Queue`, and `PriorityQueue` are higher-level collection APIs, but they are implemented with runtime arrays internally. That means they currently hit the same QIR lowering boundary as direct runtime arrays.

Source file: `guppy_examples/guppy-features/unsupported/collections-stack.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-stack.py
:language: python
```

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/collections-stack.error
:language: text
```

Source file: `guppy_examples/guppy-features/unsupported/collections-queue.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-queue.py
:language: python
```

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/collections-queue.error
:language: text
```

Source file: `guppy_examples/guppy-features/unsupported/collections-priority-queue.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-priority-queue.py
:language: python
```

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/collections-priority-queue.error
:language: text
```
