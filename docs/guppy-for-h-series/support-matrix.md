# Support Matrix

This matrix summarizes the current Guppylang subset that can be lowered through HUGR into QIR for H-Series targets.

✅ = full support, *️⃣ = partial support, ❌ = unsupported

## Guppy features

| Features                                              | Support | Remarks                                                                |
|-------------------------------------------------------|---------|:-----------------------------------------------------------------------|
| if elif else constructs                               | ✅       |                                                                        |
| Measurement objects from `measure(q)`                 | ✅       | Read the classical value with `.read()`                                |
| Angle values and arithmetic                           | ✅       | Supported for gate parameters such as `rz`                             |
| function overloading                                  | ✅       |                                                                        |
| Generics (`type_var`/`nat_var`)                       | ✅       | `nat_var`s are less useful without runtime array support               |
| Function type annotations                             | ✅       |                                                                        |
| First class or higher order functions                 | ✅       |                                                                        |
| Protocols                                             | ✅       |                                                                        |
| Type aliases                                          | ✅       | Avoid aliases that expand to runtime arrays                            |
| `Option`, `Result`, and `Either`                      | ✅       | Supported when payload types are supported                             |
| `mem_swap`                                            | ✅       |                                                                        |
| Dagger modifier                                       | ✅       |                                                                        |
| Control modifier                                      | ❌       | Lowers to an array of control qubits                                   |
| `get_current_shot`                                    | ✅       |                                                                        |
| Recursive functions or loops within `@guppy.comptime` | ✅       | As long as compilation to HUGR succeeds                                |
| Recursive functions or loops within `@guppy`          | *️⃣     | Only if unrollable/serializable through chosen LLVM optimization level |
| `Stack`, `Queue`, and `PriorityQueue`                 | ❌       | Backed by runtime arrays                                               |
| `measure_array` or `discard_array`                    | ❌       | Use non-comptime arrays internally                                     |
| `barrier`                                             | ❌       | Uses non-comptime arrays internally                                    |
| `output`                                              | *️⃣     | Only available for recording bools and ints; see [Result recording](result_recording.md) |
| `exit` and `panic`                                    | ❌       | Currently unsupported on H2 hardware                                   |
| RNG: `__new__`, `discard`, `random_int/_bounded`      | ✅       | Specific to Quantinuum hardware                                        |
| RNG: `random_advance`                                 | ❌       | Currently unsupported on H2 hardware                                   |
| RNG: `shuffle`                                        | ❌       | Uses non-comptime arrays internally                                    |
| RNG: `random(_clifford)_angle`, `random_float`        | ❌       | No dynamic float support planned for H2 hardware                       |

## Data types

| Data Types | Support | Caveats                                            |
|------------|---------|----------------------------------------------------|
| int        | ✅      |                                                    |
| bool       | ✅      |                                                    |
| nat        | ✅      |                                                    |
| struct     | ✅      | Cannot contain arrays                              |
| float      | *️⃣      | Must be runtime constant, arithmetic comptime only |
| array      | *️⃣      | Comptime only                                      |
| tuple      | *️⃣      | Unpacking with `*` returns an array, so only at comptime |
| enum       | ✅      | Supported when variant payloads are supported      |
| `Option`   | ✅      | Supported when payload type is supported           |
| `Result`   | ✅      | Supported when payload types are supported         |
| `Either`   | ✅      | Supported when payload types are supported         |

The more detailed rules behind the partial entries are covered in [Collections and structs](collections-and-structs.md).
