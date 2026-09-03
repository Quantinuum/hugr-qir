# Collections and Structs

## Arrays

Fixed-size Guppy arrays are supported, including arrays created in ordinary
`@guppy` functions, passed to other Guppy functions, or created from Python
lists.

H-Series requires the qubit used by each quantum operation to be known during
compilation. `hugr-qir` tries to make array indexing static by expanding loops
and simplifying indices. Compilation fails if it cannot determine the qubit
used by an operation.

An index does not have to be written as a literal. Some runtime choices can be
expanded into a small number of branches with a known qubit in each branch.
See [Arrays](guppy-features/arrays.md) for supported and unsupported examples.

Using `@guppy.comptime` is a useful alternative when array indices and loops can
be decided while the program is compiled.

## Array-backed collections

`Stack` and `Queue` from `guppylang.std.collections` can be used when their
operations can be completely simplified during compilation. Fixed sequences of
pushes and pops are a typical supported case.

Collection state that depends on runtime values is not generally supported. It
can leave internal storage, loops, or dynamic qubit addressing in the program,
which H-Series QIR cannot represent. Compilation fails when that state cannot be
removed. Calling `discard_empty()` is still required for ownership checking, but
does not by itself make a collection suitable for QIR.

`PriorityQueue` is currently unsupported, including for simple fixed sequences.
Use a direct fixed-size array, tuple, struct, or individual variables when a
collection cannot be simplified.

## Tuples

Fixed-shape tuple operations are supported. Starred unpacking creates an array
for the starred portion, which follows the usual array rules.

## Structs

Structs are supported when their field types are supported. Array fields follow
the usual array rules.

## Where to look next

- Detailed array examples: [Arrays](guppy-features/arrays.md)
- Feature overview: [Support matrix](support-matrix.md)
- General workflow: [Getting Started](../getting-started.md)
