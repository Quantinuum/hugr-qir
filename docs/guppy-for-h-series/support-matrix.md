# Support Matrix

This matrix summarizes the current Guppylang subset that can be lowered through HUGR into QIR for H-Series targets.

✅ = full support, *️⃣ = partial support, ❌ = unsupported

## Guppy features

| Features                              | Support | Remarks                                                  |
|---------------------------------------|---------|----------------------------------------------------------|
| if elif else constructs               | ✅      |                                                          |
| function overloading                  | ✅      |                                                          |
| Generics (`type_var`/`nat_var`)       | ✅      | `nat_var`s are less useful without runtime array support |
| First class or higher order functions | ✅      |                                                          |
| Recursive functions or loops          | *️⃣      | Only if unrollable or serializable                       |
| `measure_array` or `discard_array`    | ❌      | Use non-comptime arrays internally                       |

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
