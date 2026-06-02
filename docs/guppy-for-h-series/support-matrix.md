# Support Matrix

This matrix summarizes the current Guppylang subset that can be lowered through HUGR into QIR for H-Series targets.

✅ = full support, *️⃣ = partial support, ❌ = unsupported

## Guppy features

| Features                                              | Support | Remarks                                                    |
|-------------------------------------------------------|---------|------------------------------------------------------------|
| if elif else constructs                               | ✅      |                                                            |
| function overloading                                  | ✅      |                                                            |
| Generics (`type_var`/`nat_var`)                       | ✅      | `nat_var`s are less useful without runtime array support   |
| First class or higher order functions                 | ✅      |                                                            |
| `get_current_shot`                                    | ✅      |                                                            |
| Recursive functions or loops within `@guppy.comptime` | ✅      | As long as compilation to HUGR succeeds                    |
| Recursive functions or loops within `@guppy`          | *️⃣      | Only if unrollable/serializable through chosen LLVM optimization level |
| `measure_array` or `discard_array`                    | ❌      | Use non-comptime arrays internally                         |
| `barrier`                                             | ❌      | Uses non-comptime arrays internally                        |
| `exit` and `panic`                                    | ❌      | Currently unsupported on H2 hardware                       |
| RNG: `__new__`, `discard`, `random_int/_bounded`      | ✅      | Specific to Quantinuum hardware                            |
| RNG: `random_advance`                                 | ❌      | Currently unsupported on H2 hardware                       |
| RNG: `shuffle`                                        | ❌      | Uses non-comptime arrays internally                                                    |
| RNG: `random(_clifford)_angle`, `random_float`        | ❌      | No dynamic float support planned for H2 hardware           |

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

The more detailed rules behind the partial entries are covered in [Collections and structs](collections-and-structs.md).
