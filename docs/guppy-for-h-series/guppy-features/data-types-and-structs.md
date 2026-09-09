# Data Types and Structs

These examples show the data-shape patterns that are currently practical for H-Series targets.

## Numeric types

Source file: `guppy_examples/guppy-features/supported/num-types.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/num-types.py
:language: python
```

Non-negative integers are supported. Negative values can silently produce
incorrect results on H-Series, even when they occur only during a calculation.
See [Integers](../integers.md) for details.

Floating-point values may be used as constant gate parameters. Floating-point
calculations and output are unsupported on H-Series.

## Tuples

Source file: `guppy_examples/guppy-features/supported/guppy-tuple.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-tuple.py
:language: python
```

This example stays within the supported subset by doing tuple-oriented bulk operations under `@guppy.comptime`.

## Tuple unpacking

Source file: `guppy_examples/guppy-features/supported/tuple-unpack.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/tuple-unpack.py
:language: python
```

Fixed-shape tuple unpacking is supported. Starred unpacking creates an array for
the starred portion, so that value follows the normal [array rules](arrays.md).

## Structs

Source file: `guppy_examples/guppy-features/supported/guppy-struct.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-struct.py
:language: python
```

Structs are supported when their field types are supported. Array fields are
allowed, but accesses through them retain the static-addressing requirements
described in [Arrays](arrays.md).

## Enums

Source file: `guppy_examples/guppy-features/supported/enum-method.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/enum-method.py
:language: python
```

## Type aliases

Source file: `guppy_examples/guppy-features/supported/type-alias.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/type-alias.py
:language: python
```

Type aliases are supported when the expanded type is supported. Aliases that
expand to arrays inherit the usual array lowering constraints.

## `Option`, `Result`, and `Either`

Source file: `guppy_examples/guppy-features/supported/option-result-either.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/option-result-either.py
:language: python
```

These sum types are supported when their payload types are supported.
