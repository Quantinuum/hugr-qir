# Arrays

Fixed-size arrays are supported in both `@guppy` and `@guppy.comptime` code.
This includes arrays created from Python lists.

H-Series requires the exact qubit used by every quantum operation to be known
when the program is compiled. `hugr-qir` makes a best effort to simplify array
indices and fully expand loops. Compilation fails if a qubit index cannot be
made static or if a loop cannot be fully expanded.

This means runtime indexing sometimes works, but is not guaranteed to work just
because the array has a fixed size.

## Supported: runtime arrays and array parameters

Source file: `guppy_examples/guppy-features/supported/runtime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/runtime-array.py
:language: python
```

This example creates qubit arrays in an ordinary `@guppy` function, passes them
to other Guppy functions, and accesses them in fixed-size loops.

## Supported: fixed-size iteration

Source file: `guppy_examples/guppy-features/supported/array-static-full-iteration.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/array-static-full-iteration.py
:language: python
```

Iterating over an entire fixed-size array can be fully expanded during
compilation.

## Supported: finite runtime selection

Source file: `guppy_examples/guppy-features/supported/array-branch-selected-borrow.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/array-branch-selected-borrow.py
:language: python
```

The index in this example depends on a measurement, but can only be zero or
one. It can therefore be compiled into two branches, each using a known qubit.

## Supported: bounded data-dependent exit

Source file: `guppy_examples/guppy-features/supported/array-data-dependent-early-exit.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/array-data-dependent-early-exit.py
:language: python
```

Although a measurement determines when this loop exits, its maximum number of
iterations is fixed. The loop can be fully expanded into conditional steps.

## Supported: implicit discard

Source file: `guppy_examples/guppy-features/supported/array-implicit-discard.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/array-implicit-discard.py
:language: python
```

Arrays of copyable, droppable values can be discarded after use.

## Supported: compile-time arrays

Source file: `guppy_examples/guppy-features/supported/comptime-array.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/comptime-array.py
:language: python
```

`@guppy.comptime` is useful when all array indices and loop bounds can be
decided during compilation. Copying and starred unpacking at compile time are
demonstrated separately:

```{literalinclude} ../../../guppy_examples/guppy-features/supported/comptime-array-copy-unpack.py
:language: python
```

## Supported: measurement and discard helpers

`measure_array` and `discard_array` follow the same array rules.

```{literalinclude} ../../../guppy_examples/guppy-features/supported/measure-array.py
:language: python
```

The boolean array passed to `output` is packed into one integer. At most 63
boolean values can be recorded under one tag; split larger arrays into multiple
outputs. See [Result recording](../result-recording.md) for the result encoding.

```{literalinclude} ../../../guppy_examples/guppy-features/supported/discard-array.py
:language: python
```

## Unsupported: unresolved runtime index

Source file: `guppy_examples/guppy-features/unsupported/array-runtime-index.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/array-runtime-index.py
:language: python
```

Here an RNG selects the qubit. The compiler cannot determine a fixed qubit for
the `x` operation, so compilation fails.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/array-runtime-index.error
:language: text
```

## Unsupported: array-backed collections

`Stack`, `Queue`, and `PriorityQueue` contain internal loops that cannot be
fully expanded for H-Series.

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-stack.py
:language: python
```

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-queue.py
:language: python
```

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/collections-priority-queue.py
:language: python
```

Example error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/collections-stack.error
:language: text
```
