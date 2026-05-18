# Collections and Structs

The main limits in the current H-Series flow come from how Guppy collections are represented during lowering to HUGR and then to QIR.

## Arrays

- Arrays are only supported within comptime Guppy.
- Arrays cannot be used inside structs.
- Arrays cannot be used as parameters to either `@guppy` or `@guppy.comptime` decorated functions.
- Guppy builtins that rely on runtime arrays internally are not supported.

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

Counterexamples and support boundaries are summarized in [Examples](../examples/index.md) and exercised in the repository test suite.

## Tuples

- Unpacking with `*` is only supported at comptime.

## Structs

- Structs cannot contain arrays.

## Where to look next

- General example and full flow: [Getting Started](../getting-started.md)
- WASM examples: [Examples: WASM integration](../examples/wasm.md)
- Architecture overview: [Architecture](../architecture.md)
