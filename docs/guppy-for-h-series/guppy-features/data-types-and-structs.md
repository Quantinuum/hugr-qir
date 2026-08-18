# Data Types and Structs

These examples show the data-shape patterns that are currently practical for H-Series targets.

## Numeric types

Source file: `guppy_examples/guppy-features/supported/num-types.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/num-types.py
:language: python
```

This page is especially useful for the current float caveat: constant float values are fine, but runtime float arithmetic is not supported on H-Series.

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

Fixed-shape tuple unpacking is supported. Starred unpacking is more constrained because the starred part is array-like; see [Arrays](arrays.md).

## Structs

Source file: `guppy_examples/guppy-features/supported/guppy-struct.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/guppy-struct.py
:language: python
```

This example is a good pattern to prefer over runtime arrays when you want a fixed-size register-like object in supported H-Series code.

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

Type aliases are supported when the expanded type is supported. Aliases that expand to runtime arrays still inherit the runtime-array limitation.

## `Option`, `Result`, and `Either`

Source file: `guppy_examples/guppy-features/supported/option-result-either.py`

```{literalinclude} ../../../guppy_examples/guppy-features/supported/option-result-either.py
:language: python
```

These sum types are supported when their payload types are supported.
