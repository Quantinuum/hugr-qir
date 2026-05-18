# hugr-qir

`hugr-qir` converts [HUGR](https://github.com/Quantinuum/hugr) packages into [QIR](https://github.com/qir-alliance/qir-spec), with both a Python interface and a CLI.

The primary goal of `hugr-qir` is to let users write programs in [Guppy](https://docs.quantinuum.com/guppy/), compile them through HUGR, and target backends that accept QIR as input.

In particular, this package is useful for targeting Quantinuum's older H-series systems from Guppy code.

`hugr-qir` does not yet support all Guppy features, so some programs will need to stay within the currently supported subset.

Use `hugr-qir` if you want to write guppy programs for H-series systems.

Start with [Getting Started](getting-started.md) if you are new to the project.

```{toctree}
:maxdepth: 2

getting-started
guppy-for-h-series/index
examples/index
python-api
cli
wasm
development
architecture
```
