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
