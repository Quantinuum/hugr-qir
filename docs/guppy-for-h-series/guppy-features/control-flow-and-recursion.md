# Control Flow and Recursion

These examples show the distinction between control flow that can be made static for QIR generation and control flow that still implies dynamic or cyclic structure in the lowered program. They also detail some Guppy features that are not currently supported by H-Series hardware.

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

Early exit using either `exit` or `panic` is not currently supported on H-Series hardware and will not pass the QIR validation step.

Expected error (for both examples):

```{literalinclude} ../../../python/tests/snapshots/unsupported/early-exit.error
:language: text
```

## Supported: unrollable loops

Source file: `guppy_examples/guppy-features/supported/unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/unrollable-loops.py
:language: python
```

This pattern works because the loop structure can be serialized into static
control flow during lowering. After normal optimization, the backend marks all
remaining natural loops for full unrolling with a maximum static trip count of
800 by default. The limit is configurable, and no loop is permitted to remain
in emitted QIR.

Writing loops within `@guppy.comptime` remains useful for loops larger than this
limit or whose structure is difficult for LLVM to analyze. Such loops execute
during Guppy compilation rather than becoming LLVM control flow. This is not
possible if the loop branches on runtime values such as measurement results.

## Unsupported: non-unrollable loops

Source file: `guppy_examples/guppy-features/unsupported/non-unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/non-unrollable-loops.py
:language: python
```

This loop depends on measurement results and therefore remains genuinely dynamic in the generated control-flow graph.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/non-unrollable-loops.error
:language: text
```

## Supported: simple recursion

Source file: `guppy_examples/guppy-features/supported/simple-recursion.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/simple-recursion.py
:language: python
```

This recursive form works because it can be turned into static control flow for QIR generation.

## Unsupported: complex recursion

Source file: `guppy_examples/guppy-features/unsupported/complex-recursion.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/complex-recursion.py
:language: python
```

Here the recursive path depends on a measurement result, so the generated CFG contains a loop that the current backend rejects during validation.

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

This example creates a cycle across multiple Guppy functions, which eventually lowers to an unsupported loop in the control-flow graph.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/cyclic-call-graph.error
:language: text
```
