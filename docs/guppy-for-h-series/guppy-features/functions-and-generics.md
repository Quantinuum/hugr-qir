# Functions and Generics

These examples cover higher-level function features that are already usable in the H-Series subset.

## Function overloading

Source file: `guppy_examples/guppy-features/supported/function-overloading.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/function-overloading.py
:language: python
```

## First-class functions

Source file: `guppy_examples/guppy-features/supported/first-class-functions.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/first-class-functions.py
:language: python
```

## Higher-order functions

Source file: `guppy_examples/guppy-features/supported/higher-order-functions.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/higher-order-functions.py
:language: python
```

## Generics

Source file: `guppy_examples/guppy-features/supported/generics.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/generics.py
:language: python
```

The generic array example is still constrained by the same array rules described in [Arrays](arrays.md): it works here because the array manipulation happens from Python under `@guppy.comptime`.
