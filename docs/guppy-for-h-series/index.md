# Guppy for H-Series

The current focus of `hugr-qir` is to let Guppy programs target Quantinuum's H-Series systems.

Due to hardware restrictions, not all Guppy code can be run on H-Series, but support for most features is available. This section summarizes the current limitations to keep in mind when writing programs for H-Series targets.

- Start with the [Support matrix](support-matrix.md) for a quick feature-level overview.
- Read [Integers](integers.md) before using signed values or large integers.
- Use [Collections and structs](collections-and-structs.md) when you need the current rules around arrays, tuples, and structs.
- See [Result recording](result-recording.md) for scalar and array result encodings.
- Browse [Guppy feature examples](guppy-features/index.md) for paired supported examples and unsupported counterexamples from the repository.

```{toctree}
:maxdepth: 1

support-matrix
integers
collections-and-structs
result-recording
guppy-features/index
```
