# RNG and Shot-Dependent Examples

These examples exercise Guppy features that are specifically aimed at Quantinuum hardware-oriented workflows.

The RNG and shot-dependent functions used here are only available on Quantinuum hardware targets, so these examples are not intended as portable Guppy programs for arbitrary QIR backends. Note that not all RNG methods are currently supported; see [Support matrix](../guppy-for-h-series/support-matrix.md).

## Quantum RNG example

Source file: `guppy_examples/quantinuum-hardware-only/rng-quantum-rng-1.py`

```{literalinclude} ../../guppy_examples/quantinuum-hardware-only/rng-quantum-rng-1.py
:language: python
```

## Bounded quantum RNG example

Source file: `guppy_examples/quantinuum-hardware-only/rng-quantum-rng-2.py`

```{literalinclude} ../../guppy_examples/quantinuum-hardware-only/rng-quantum-rng-2.py
:language: python
```

## Shot-dependent example

Source file: `guppy_examples/quantinuum-hardware-only/rng-quantum-jobid-1.py`

```{literalinclude} ../../guppy_examples/quantinuum-hardware-only/rng-quantum-jobid-1.py
:language: python
```

## Native PCG RNG example

Source file: `guppy_examples/guppy-features/supported/native-pcg-random.py`

```{literalinclude} ../../guppy_examples/guppy-features/supported/native-pcg-random.py
:language: python
```

## Unsupported: `random_advance`

Source file: `guppy_examples/guppy-features/unsupported/rng-random-advance.py`

```{literalinclude} ../../guppy_examples/guppy-features/unsupported/rng-random-advance.py
:language: python
```

Expected error:

```{literalinclude} ../../python/tests/snapshots/unsupported/rng-random-advance.error
:language: text
```
