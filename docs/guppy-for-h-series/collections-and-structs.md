# Collections and Structs

The main limits in the current H-Series flow come from how Guppy collections are represented during lowering to HUGR and then to QIR.

## Arrays

Guppy qubit arrays are generally allowed to be indexed into using a runtime integer, but this is incompatible with H-Series hardware, where any addressing of qubits must be static. The workaround here is to use "comptime" arrays, ones that are generated within `@guppy.comptime` and are interchangeable with python lists. These arrays can be passed into pure python functions, but not other guppy functions.

- Arrays are only supported within comptime Guppy.
- Arrays cannot be used inside structs.
- Arrays cannot be used as parameters to either `@guppy` or `@guppy.comptime` decorated functions.
- Guppy builtins that rely on runtime arrays internally are not supported.

## Array-backed collections

`Stack`, `Queue`, and `PriorityQueue` from `guppylang.std.collections` are currently unsupported for H-Series. Although they provide a higher-level API than direct array manipulation, their implementations store values in fixed-size Guppy arrays:

- `Stack` stores its elements in an `array[Option[T], MAX_SIZE]`.
- `Queue` stores its circular buffer in an `array[Option[T], MAX_SIZE]`.
- `PriorityQueue` stores its heap in an `array[Option[tuple[int, T]], MAX_SIZE]`.

That means using these collections still introduces runtime array values into the lowered program. Prefer tuples, structs, individual variables, or comptime arrays for H-Series-compatible code.

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
- Wasm examples: [Examples: Wasm integration](../examples/wasm.md)
- Architecture overview: [Architecture](../architecture.md)
