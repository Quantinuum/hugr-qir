# Result Recording

Guppy's `output` function supports booleans, signed and unsigned integers (`int`
and `nat`), and fixed-size arrays of these values on H-Series. Floating-point
output is unsupported. See [Integers](integers.md) for restrictions on integer
values and arithmetic.

## Output rules

- A program must record at least one scalar value or array element. Outputting
  only empty arrays does not record any values.
- A program must contain at least one quantum measurement in the optimized QIR.
  Programs containing only classical computations are unsupported.
- Tags must be nonempty, compile-time strings. Each tag must be unique across the
  program, including calls in helper functions and outputs with different types.
- Each tag must be output exactly once on every run (shot). Output calls that can be
  skipped by a branch or repeated by a loop are unsupported.

H-Series reports a fixed set of result registers for every shot. Skipping an
output call would leave its register at the default zero value, rather than
omit the tag from the results. `hugr-qir` rejects conditional outputs to avoid
this ambiguity.

You can compute values using branches and loops, then record the results with
unconditional output calls. The values themselves can depend on measurements
and other runtime computations.

## Scalar outputs and conditional values

This example records a boolean, a signed integer chosen by a branch, and an
unsigned integer. Every output call executes once, regardless of the measurement
result.

```python
from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.num import nat
from guppylang.std.quantum import h, measure


@guppy
def main() -> None:
    q = qubit()
    h(q)
    bit = measure(q).read()
    if bit:
        value = 1
    else:
        value = -1
    output("bit", bit)
    output("value", value)
    output("count", nat(3))
```

## Array outputs

Use one `output` call to record an entire fixed-size array. Each array has one
user tag; its elements do not require separate output calls.

Source file: `guppy_examples/guppy-features/supported/result-arrays.py`

```{literalinclude} ../../guppy_examples/guppy-features/supported/result-arrays.py
:language: python
```

## Unsupported: conditional outputs

In this example, `"r"` is unconditional, but `"true"` and `"false"` are only
written in their respective branches. The program is rejected even though the
two branches use different tags.

```{literalinclude} ../../guppy_examples/guppy-features/unsupported/branched-output.py
:language: python
:lines: 1-18
```

Expected compilation error:

```{literalinclude} ../../python/tests/snapshots/unsupported/branched-output.error
:language: text
```

Move the output after the branch, as in the scalar example above. Giving two
branch-local calls the same tag is also unsupported: tags must be unique.

## Outputs in loops

An output repeated by a loop is unsupported even when the loop has a fixed
iteration count and can be fully unrolled. For example:

```python
from guppylang import guppy
from guppylang.std.builtins import output


@guppy
def main() -> None:
    for i in range(3):
        output("value", i)
```

To record every value, either expand the loop at compile time with a distinct
tag for each value, or collect the values into a fixed-size array and output it
once. This example demonstrates both approaches:

```python
from guppylang import guppy, qubit
from guppylang.std.builtins import array, output
from guppylang.std.quantum import measure

@guppy.comptime
def comptime_output_loop() -> None:
  for i in range(3):
    output(f"value_{i}", i)

@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    array_output = array(i for i in range(3))
    comptime_output_loop() # okay, because comptime tags include index
    output("value", array_output) # okay, unrepeated array output
```

The compile-time loop produces three scalar outputs tagged `"value_0"`,
`"value_1"`, and `"value_2"`. The array output records the same values,
`[0, 1, 2]`, under the single tag `"value"`. Each tag is written exactly once on
every run.

These restrictions are checked after optimization. A constant branch or a
single-iteration loop that simplifies to one unconditional output can be
accepted. Compile-time expansion can also produce multiple outputs with
distinct tags, provided each output is unconditional and unrepeated. See
[Control flow and recursion](guppy-features/control-flow-and-recursion.md) for
the general restrictions on loops.
