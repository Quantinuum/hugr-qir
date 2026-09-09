# Control Flow and Recursion

H-Series programs cannot contain loops. Loops and recursion are supported when
`hugr-qir` can fully expand them during compilation.

## Supported: `if` / `elif` / `else`

Source file: `guppy_examples/guppy-features/supported/guppy-if-elif-else.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-if-elif-else.py
:language: python
```

## Unsupported: `exit` / `panic`

Source file: `guppy_examples/guppy-features/unsupported/early-exit.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/early-exit.py
:language: python
```

Source file: `guppy_examples/guppy-features/unsupported/panic.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/panic.py
:language: python
```

Early exit using either `exit` or `panic` is unsupported on H-Series.

Expected error (for both examples):

```{literalinclude} ../../../python/tests/snapshots/unsupported/early-exit.error
:language: text
```

## Supported: unrollable loops

Source file: `guppy_examples/guppy-features/supported/unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/unrollable-loops.py
:language: python
```

This loop has a fixed number of iterations, so `hugr-qir` can fully expand it.
The default maximum is 800 iterations and can be configured using
`max_loop_unroll` in Python or `--max-loop-unroll` on the command line.

For larger static loops, consider using `@guppy.comptime` so Guppy expands the
loop during compilation. This cannot be used when the loop itself depends on a
runtime value such as a measurement result.

## Unsupported: non-unrollable loops

Source file: `guppy_examples/guppy-features/unsupported/non-unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/non-unrollable-loops.py
:language: python
```

The number of iterations depends on measurement results, so the loop cannot be
fully expanded during compilation.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/non-unrollable-loops.error
:language: text
```

## Supported: simple recursion

Source file: `guppy_examples/guppy-features/supported/simple-recursion.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/simple-recursion.py
:language: python
```

This recursive form has a fixed depth and can be fully expanded.

## Unsupported: complex recursion

Source file: `guppy_examples/guppy-features/unsupported/complex-recursion.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/complex-recursion.py
:language: python
```

Here the recursive path depends on a measurement result, so it cannot be fully
expanded.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/complex-recursion.error
:language: text
```

## Supported: non-cyclic call graphs

Source file: `guppy_examples/guppy-features/supported/inline-noncyclic-call-graph.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/inline-noncyclic-call-graph.py
:language: python
```

## Unsupported: cyclic call graphs

Source file: `guppy_examples/guppy-features/unsupported/cyclic-call-graph.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/cyclic-call-graph.py
:language: python
```

This example creates recursion across multiple Guppy functions that cannot be
fully expanded.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/cyclic-call-graph.error
:language: text
```
