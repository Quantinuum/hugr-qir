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

The control modifier lowers through a statically-addressable array of control
qubits.

## Unsupported: barrier

Source file: `guppy_examples/guppy-features/unsupported/barrier.py`

```{literalinclude} ../../../guppy_examples/guppy-features/unsupported/barrier.py
:language: python
```

The array-typed operands can now be lowered, but the backend does not yet have
code generation for the `RuntimeBarrier` operation itself.

Expected error:

```{literalinclude} ../../../python/tests/snapshots/unsupported/barrier.error
:language: text
```

## Memory swap

Source file: `guppy_examples/guppy-features/supported/mem-swap.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/mem-swap.py
:language: python
```
