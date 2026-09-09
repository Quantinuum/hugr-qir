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

## Division and modulo

Integer division (`//`) and modulo (`%`) require a divisor that the compiler can
reduce to a constant. Integer literals and compile-time expressions are
supported, but values that remain dependent on runtime information are not.

For example, division by `3` is supported, while division by a value obtained
from a measurement, random-number operation, or other runtime computation will
fail to compile. This remains true even when a runtime divisor is known to be a
`nat` or can otherwise be proven positive: the divisor itself must be static.

Signed `int` divisors have an additional restriction. If the compiler cannot
prove that a runtime integer is positive, Guppy may retain a failure path for a
negative or zero divisor. Failure paths are not currently supported on H-Series, so the
program will fail to compile. Prefer a positive constant divisor and use `nat`
for non-negative integer values, but note that converting a runtime value to
`nat` does not make it static.

These restrictions also apply to integer arrays and to integers stored inside
tuples, structs, or other data types.
