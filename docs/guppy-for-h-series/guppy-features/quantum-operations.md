# Quantum Operations

These examples cover Guppy features around measurement values, gate parameters, modifiers, and nearby helper operations.

## Measurement objects

Source file: `guppy_examples/guppy-features/supported/measurement-object.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/measurement-object.py
:language: python
```

In Guppy v1, `measure(q)` returns a measurement object. It can be used as a conditional value, and the classical result should be passed to `output` by calling `.read()`.

## Angles

Source file: `guppy_examples/guppy-features/supported/angles.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/angles.py
:language: python
```

## Dagger modifier

Source file: `guppy_examples/guppy-features/supported/modifier-dagger.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/modifier-dagger.py
:language: python
```

## Unsupported: control modifier

Source file: `guppy_examples/guppy-features/unsupported/modifier-control.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/modifier-control.py
:language: python
```

The control modifier lowers to an array of control qubits, which is not currently supported by QIR lowering.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/modifier-control.error
:language: text
```

## Unsupported: barrier

Source file: `guppy_examples/guppy-features/unsupported/barrier.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/barrier.py
:language: python
```

The current lowering path for barriers also introduces array-typed values, so barriers are not currently supported in the H-Series QIR subset.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/barrier.error
:language: text
```

## Memory swap

Source file: `guppy_examples/guppy-features/supported/mem-swap.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/mem-swap.py
:language: python
```
