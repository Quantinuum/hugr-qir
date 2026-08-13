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

## Barrier

Source file: `guppy_examples/guppy-features/supported/barrier.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/barrier.py
:language: python
```

Any non-qubit arguments are ignored for the emitted QIR barrier call.

## Memory swap

Source file: `guppy_examples/guppy-features/supported/mem-swap.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/mem-swap.py
:language: python
```
