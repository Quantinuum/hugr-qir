# Integers

Most integer arithmetic is supported for both Guppy's signed `int` type and
unsigned `nat` type. There are, however, restrictions on division
and modulo operations for these types.

## Division and modulo

Integer division (`//`) and modulo (`%`) currently require a positive divisor
that the compiler can reduce to a constant. Positive integer literals and
compile-time expressions are supported, but values that remain dependent on
runtime information are not. Negative dividends are supported.

For example, division by `3` is supported, while division by a value
obtained from a measurement, random-number operation, or other runtime
computation will fail to compile. Division or modulo by zero will fail at compile time.

```{warning}
Negative divisors can compile but produce incorrect results due to an upstream
Guppy bug. Avoid negative divisors in both division and modulo operations,
even when they are compile-time constants. This issue is tracked in
[guppylang#2316](https://github.com/Quantinuum/guppylang/issues/2316).
```

These restrictions also apply to integer arrays and to integers stored inside
tuples, structs, or other data types.

### Computational overhead

Signed division and both signed and unsigned modulo operations do not have
direct hardware support. They are lowered to unsigned division in software
and especially the signed lowerings introduce register and logic overhead.
These operations should be avoided if possible.

### Integer overflow

Signed integer division overflows when the minimum integer (`INT_MIN`) is
divided by `-1`, because the mathematical result cannot be represented in the
signed integer type. This case follows LLVM's undefined behavior: programs
must avoid it. No runtime overflow check is performed and the compiler
optimizes code assuming that this case never occurs.
