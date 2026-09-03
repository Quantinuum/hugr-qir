# Integers

H-Series supports non-negative integer values. Prefer Guppy's `nat` type to protect against
negative integers at compile time. Regular signed Guppy `int`s are accepted but care must be
taken that any integer values are and remain non-negative.

```{warning}
Negative integers are not supported on H-Series. A program containing them may
compile and run without an error, but calculations can silently produce
incorrect results. Avoid negative values anywhere in a calculation, including
temporary and intermediate values.
```

Integers use a 64-bit representation on H-Series, with one bit reserved by the
system. Values must therefore fit within the remaining 63 bits.

A negative integer may also be accepted by `output`, but its sign is not
preserved in the recorded result. Do not use signed output to recover negative
values.

These restrictions also apply to integer arrays and to integers stored inside
tuples, structs, or other data types.
