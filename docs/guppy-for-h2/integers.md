# Integers

Most integer arithmetic is supported for both Guppy's signed `int` type and
unsigned `nat` type. Exponentiation, division, and modulo have restrictions on H2.

## Exponentiation

Integer exponentiation (`**`) uses binary exponentiation for constant and
runtime exponents that reach LLVM lowering. The compiler interprets the exponent
as unsigned and multiplication wraps at the integer width. Raising any base to
zero returns one, including `0**0`.

Guppy checks signed `int` exponents for negativity. On H2, compilation fails
if the compiler cannot eliminate the resulting panic path. For example,
`3 ** (get_current_shot() - 1)` can have a negative exponent on the first shot.
An unsigned `nat` exponent needs no negativity check.

```{warning}
HUGR can fold powers with a constant base and a constant exponent greater than
`2**32 - 1` incorrectly before LLVM lowering. Avoid such expressions. The issue
is tracked in [hugr#3370](https://github.com/Quantinuum/hugr/issues/3370).
```

For a runtime exponent, the compiler can emit arithmetic and selection
instructions for each bit of the exponent, so wider exponents can increase
the instruction count. When LLVM can determine the exponent, its optimizer
can reduce the code to a multiplication chain specialized to that value.

## Division and modulo

Integer division (`//`) and modulo (`%`) require a divisor
that the compiler can reduce to a constant. Integer literals and
compile-time expressions are supported, but values that remain dependent on
runtime information are not.

For example, division by `3` is supported, while division by a value
obtained from a measurement, random-number operation, or other runtime
computation will fail to compile. Division or modulo by zero will fail at compile time.

```{warning}
Currently, negative divisors can compile but produce incorrect results due to an
upstream Guppy bug. Avoid negative divisors in both division and modulo operations,
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
