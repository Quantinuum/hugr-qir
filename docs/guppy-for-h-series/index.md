# Guppy for H-Series

`hugr-qir` is aimed at Guppy programs that compile through HUGR and then target Quantinuum's H-Series systems via QIR.

That workflow is already usable today, but it supports only a subset of Guppy. This section summarizes the current limitations to keep in mind when writing programs for H-Series targets.

- Start with the [Support matrix](support-matrix.md) for a quick feature-level overview.
- Use [Collections and structs](collections-and-structs.md) when you need the current rules around arrays, tuples, and structs.
- See [Result recording](result_recording.md) for caveats around recorded results and retrieval through H-Series submission workflows.
- Browse [Guppy feature examples](guppy-features/index.md) for paired supported examples and unsupported counterexamples from the repository.

## Nexus Submission Example

The following example shows the full procedure for compilation of guppy to a QIR program and submission to Nexus.

Source file: `examples/qnexus-test.py`

```{literalinclude} ../../examples/qnexus-test.py
:language: python
```

Example output from the final print loop:

```text
Shot 0:  11101010   234
Shot 1:  10001101   141
Shot 2:  01111111   127
Shot 3:  11001011   203
Shot 4:  00111000   56
Shot 5:  00110101   53
Shot 6:  10010110   150
Shot 7:  10011000   152
Shot 8:  10010011   147
Shot 9:  00100110   38
```

```{toctree}
:maxdepth: 1

support-matrix
collections-and-structs
result_recording
guppy-features/index
```
