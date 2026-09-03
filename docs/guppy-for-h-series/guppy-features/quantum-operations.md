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

## Control modifier

Source file: `guppy_examples/guppy-features/supported/modifier-control.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/modifier-control.py
:language: python
```

Control modifiers are supported for gates whose control qubits can be determined
during compilation.

## Barrier

Source file: `guppy_examples/guppy-features/supported/barrier.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/barrier.py
:language: python
```

Barriers accept individual qubits and fixed-size qubit arrays. Non-qubit values
passed to a barrier are ignored. A barrier containing no qubits has no effect.

## Memory swap

Source file: `guppy_examples/guppy-features/supported/mem-swap.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/mem-swap.py
:language: python
```
