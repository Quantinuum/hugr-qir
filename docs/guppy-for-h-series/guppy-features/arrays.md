# Arrays

These examples show the current boundary for array-like programming for H-Series compatible Guppy.

Compile-time arrays and statically addressable runtime qubit arrays can both be
lowered to QIR. Runtime indexing must become static during LLVM optimization.

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

## Supported: statically-addressable runtime qubit arrays

Source file: `guppy_examples/guppy-features/supported/runtime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/runtime-array.py
:language: python
```

This version keeps qubit arrays in ordinary `@guppy` functions. The backend
lowers them to temporary stack storage, then relies on LLVM loop unrolling and
scalar replacement to turn every quantum operation into a statically-addressed
QIR call. If normal optimization leaves array storage behind, the backend
forces full unrolling of natural loops with statically-known trip counts up to
the configured limit (800 by default). Programs are rejected if any dynamic
qubit address remains afterward.

## Unsupported: `measure_array`

Source file: `guppy_examples/guppy-features/unsupported/measure-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/measure-array.py
:language: python
```

Array storage is lowered successfully, but the backend does not yet implement
the `result_array_bool` operation produced by `measure_array`.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/measure-array.error
:language: text
```

## Supported: `discard_array`

Source file: `guppy_examples/guppy-features/supported/discard-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/discard-array.py
:language: python
```

`discard_array` is supported when its qubit array can be statically resolved.

## Unsupported: array-backed collections

`Stack`, `Queue`, and `PriorityQueue` are higher-level collection APIs built on
runtime arrays. Their generated bounds and borrow-check failure paths retain
`unreachable` instructions, which are outside the supported QIR profile.

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
