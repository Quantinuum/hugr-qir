# Control Flow and Recursion

These examples show the distinction between control flow that can be made static for QIR generation and control flow that still implies dynamic or cyclic structure in the lowered program.

## Supported: `if` / `elif` / `else`

Source file: `guppy_examples/guppy-features/supported/guppy-if-elif-else.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-if-elif-else.py
:language: python
```

## Supported: unrollable loops

Source file: `guppy_examples/guppy-features/supported/unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/unrollable-loops.py
:language: python
```

This pattern works because the loop structure can be serialized into static control flow during lowering.

## Unsupported: non-unrollable loops

Source file: `guppy_examples/guppy-features/unsupported/non-unrollable-loops.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/non-unrollable-loops.py
:language: python
```

This loop depends on measurement results and therefore remains genuinely dynamic in the generated control-flow graph.

Expected error:

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/non-unrollable-loops.error
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

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/complex-recursion.error
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

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/cyclic-call-graph.error
:language: text
```
