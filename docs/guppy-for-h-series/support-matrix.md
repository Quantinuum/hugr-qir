# Support Matrix

This matrix summarizes the Guppy features supported when targeting H-Series
systems with `hugr-qir`.

✅ = full support, *️⃣ = partial support, ❌ = unsupported

## Guppy features

| Feature | Support | Remarks |
|---------|---------|---------|
| `if` / `elif` / `else` | ✅ | |
| Measurement objects from `measure(q)` | ✅ | Read the classical value with `.read()` |
| Scalar and array `output` | *️⃣ | Supports booleans and unsigned integers; see [Result recording](result-recording.md) |
| Angle values and arithmetic | ✅ | Supported for gate parameters such as `rz` |
| `measure_array` and `discard_array` | ✅ | Boolean measurement arrays are limited to 63 results when recorded |
| `barrier` | ✅ | Accepts individual qubits and fixed-size qubit arrays |
| Function overloading | ✅ | |
| Generics (`type_var` / `nat_var`) | ✅ | Fixed-size generic arrays follow the normal array rules |
| Function type annotations | ✅ | |
| First-class and higher-order functions | ✅ | |
| Protocols | ✅ | |
| Type aliases | ✅ | The expanded type must be supported |
| `Option`, `Result`, and `Either` | ✅ | Payload types must be supported |
| `mem_swap` | ✅ | |
| Dagger modifier | ✅ | |
| Control modifier | ✅ | |
| `get_current_shot` | ✅ | |
| RNG: `__new__`, `discard`, `random_int/_bounded` | ✅ | |
| Recursive functions or loops within `@guppy.comptime` | ✅ | As long as Guppy compilation succeeds |
| Recursive functions or loops within `@guppy` | *️⃣ | Loops must have a fixed upper bound and be fully unrolled; the default limit is 800 iterations |
| `Stack` and `Queue` | *️⃣ | Fixed operation sequences are supported when their internal storage and control flow can be fully simplified |
| `PriorityQueue` | ❌ | Its internal storage cannot currently be removed completely |
| `exit` and `panic` | ❌ | Early exit is unsupported on H-Series |
| RNG: `random_advance` | ❌ | Unsupported on H-Series |
| RNG: `shuffle` | ❌ | Its array accesses cannot be made static |
| RNG: `random(_clifford)_angle`, `random_float` | ❌ | Dynamic floating-point values are unsupported on H-Series |

## Data types

| Data type | Support | Caveats                                                                             |
|-----------|---------|-------------------------------------------------------------------------------------|
| int | *️⃣ | Negative values can silently produce incorrect results; see [Integers](integers.md) |
| float | *️⃣ | May be used as a constant gate parameter; calculations and output are unsupported   |
| array | *️⃣ | Fixed-size arrays are supported when all qubit accesses can be made static          |
| bool | ✅ |                                                                                     |
| nat | ✅ |                                                                                     |
| struct | ✅ |                                                                                     |
| tuple | ✅ |                                                                                     |
| enum | ✅ |                                                                                     |
| `Option` | ✅ |                                                                                     |
| `Result` | ✅ |                                                                                     |
| `Either` | ✅ |                                                                                     |

See [Integers](integers.md), [Collections and structs](collections-and-structs.md),
and [Arrays](guppy-features/arrays.md) for the rules behind the partial entries.
