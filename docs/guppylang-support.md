# Guppylang Support

✅ = full support, *️⃣ = partial support, ❌ = unsupported

## Guppy features

| Features                            | Support | Remarks                                                  |
|-------------------------------------|---------|----------------------------------------------------------|
| if elif else constructs             | ✅      |                                                          |
| function overloading                | ✅      |                                                          |
| Generics (`type_var`/`nat_var`)     | ✅      | `nat_var`s are less useful without runtime array support |
| First class or higher order functions | ✅    |                                                          |
| Recursive functions or loops        | *️⃣      | Only if unrollable or serializable                       |
| `measure_array` or `discard_array`  | ❌      | Use non-comptime arrays internally                       |

## Data types

| Data Types | Support | Caveats                                             |
|------------|---------|-----------------------------------------------------|
| int        | ✅      |                                                     |
| bool       | ✅      |                                                     |
| nat        | ✅      |                                                     |
| struct     | ✅      | Cannot contain arrays                               |
| float      | *️⃣      | Must be runtime constant, arithmetic comptime only  |
| array      | *️⃣      | Comptime only                                       |
| tuple      | *️⃣      | Unpacking with `*` returns an array, so only at comptime |

## Arrays

- Only supported within comptime Guppy
- Cannot use Guppy builtins that use runtime arrays internally
- Cannot be used within structs
- Cannot be used as a parameter to either `@guppy` or `@guppy.comptime` decorated functions

Example:

```python
def py_function(arr: array[qubit]) -> None:
    for q in arr:
        h(q)

@guppy.comptime
def main() -> None:
    comptime_array = array(qubit() for _ in range(4))
    py_function(comptime_array)
```

Counterexamples and support boundaries are summarized in [Examples](examples/index.md) and exercised in the repository test suite.

## Tuples

- Unpacking with `*` is only supported at comptime

## Structs

- Structs cannot contain arrays

## Where to look next

- General example and full flow: [Getting Started](getting-started.md)
- WASM examples: [Examples: WASM integration](examples/wasm.md)
- Architecture overview: [Architecture](architecture.md)
