# Control Flow and Recursion

H-Series programs cannot contain loops. Loops and recursion are supported when
`hugr-qir` can fully expand them during compilation.

## Supported: `if` / `elif` / `else`

Source file: `guppy_examples/guppy-features/supported/guppy-if-elif-else.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-if-elif-else.py
:language: python
```

### Known limitation: runtime branches selecting gate parameters

Some runtime-dependent branches that apply different parameterized gates can
fail QIR validation. For example, this includes branches on
`get_current_shot()` where one branch applies `y` and the others apply `x`.

During optimization, LLVM can replace the branch-selected gate parameters with
a runtime lookup table. H-Series QIR does not support the resulting dynamic
table access, and conversion fails with an error similar to:

```text
Encountered Unexpected Instruction %switch.gep = getelementptr ... @switch.table...
```

Small changes to the program can prevent this LLVM optimization and appear to
make conversion succeed, but that behavior is not stable and should not be
relied upon. Disabling QIR validation does not make the generated program
H-Series compatible.

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
