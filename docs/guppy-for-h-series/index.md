# Guppy for H-Series

The current main target of `hugr-qir` is to allow running Guppy programs to target Quantinuum's H-Series systems via QIR. The [example](#nexus-submission-example) below shows a full compilation and submission workflow for running Guppy on H-Series through Quantinuum Nexus.

That workflow is already usable today, but it does not support the full Guppy feature set, in part because of the H-series hardware limitations. The documents here summarize the current limitations and workarounds to keep in mind when writing Guppy programs for H-Series targets.

- Start with the [Nexus submission example](#nexus-submission-example) for a simple overview of the full submission pipeline.
- See the [Support matrix](support-matrix.md) for a feature support overview.
- Use [Collections and structs](collections-and-structs.md) when you need the current rules around arrays, tuples, and structs.
- See [Result recording](result_recording.md) for information on result recording and retrieval through H-Series submission workflows.
- Browse [Guppy feature examples](guppy-features/index.md) for paired supported examples and unsupported counterexamples from the repository.

```{toctree}
:maxdepth: 1

support-matrix
collections-and-structs
result_recording
guppy-features/index
```

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
