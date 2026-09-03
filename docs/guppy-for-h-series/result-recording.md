# Result Recording

Guppy's `output` function supports booleans, unsigned integers (`nat`), and
arrays of these values on H-Series. Signed integers (`int`) and their arrays
are also accepted but errors can occur when their values become negative.
See [Integers](integers.md) for the restrictions on integer values.

## Array results

Source file: `guppy_examples/guppy-features/supported/result-arrays.py`

```{literalinclude} ../../guppy_examples/guppy-features/supported/result-arrays.py
:language: python
```

A boolean array is packed into one integer under the supplied tag. Elements are
packed in array order, so `[True, False, True]` is recorded as `5` (`0b101`).

At most 63 booleans can be recorded under one tag. Split a larger array across
multiple `output` calls.

```{literalinclude} ../../guppy_examples/guppy-features/unsupported/result-bool-array-too-large.py
:language: python
```

Expected error:

```{literalinclude} ../../python/tests/snapshots/unsupported/result-bool-array-too-large.error
:language: text
```

Integer arrays have no array-length limit imposed by `hugr-qir`. Each element
is recorded separately with its index appended to the tag. For example,
`output("values", array(nat(4), nat(7)))` produces the tags `values:0` and
`values:1`.
