# Integers

Most integer arithmetic is supported for both Guppy's signed `int` type and
unsigned `nat` type. There are, however, restrictions on division
and modulo operations for these types.

## Division and modulo

Integer division (`//`) and modulo (`%`) require a divisor that the compiler can
reduce to a constant. Integer literals and compile-time expressions are
supported, but values that remain dependent on runtime information are not.

For example, division by `3` or `-3` is supported, while division by a value
obtained from a measurement, random-number operation, or other runtime
computation will fail to compile. Zero division or modulo will fail at compile time.

These restrictions also apply to integer arrays and to integers stored inside
tuples, structs, or other data types.

### Computational overhead

Signed division and both signed and unsigned modulo operations do not have
direct hardware support. They are lowered to unsigned division in software
and especially the signed lowerings introduce register and logic overhead.
These operations should be avoided if possible.

### Integer overflow

Signed integer division can cause overflow when the minimum integer (INT_MIN)
is divided by `-1`. The result -INT_MIN cannot be represented in the given
integer set (because -INT_MIN > INT_MAX). In this case, INT_MIN is returned.
