# Guppy Feature Examples

This subsection documents some smaller Guppy examples under `guppy_examples/guppy-features` that highlight some supported features of Guppy for targeting H-series compatible QIR along with counterexamples.

Where possible, each page pairs a supported example with one or more nearby
counterexamples that fail during compilation. For unsupported cases, the
expected error output is documented.

Integer restrictions are documented separately on the [Integers](../integers.md)
page because some unsupported values are accepted by the system but produce
incorrect results rather than a compilation error.

```{toctree}
:maxdepth: 1

arrays
quantum-operations
control-flow-and-recursion
functions-and-generics
data-types-and-structs
```
