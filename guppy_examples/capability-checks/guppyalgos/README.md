# Run the guppyalgos checks

See [CAPABILITIES.md](CAPABILITIES.md) for all examples and their passing/failing stages.
The [shared checker README](../README.md) describes options and output files.

From the repository root:

```sh
python guppy_examples/capability-checks/check_examples.py --suite guppyalgos
python guppy_examples/capability-checks/check_examples.py --suite guppyalgos --emulate
python guppy_examples/capability-checks/check_examples.py --suite guppyalgos --pattern '23_*.py' --emulate
```

Use `--output /tmp/capability-results` to select a results directory. This suite's
HUGR, QIR, per-mode JSON, logs, and shot records are written under
`/tmp/capability-results/guppyalgos/`; the combined `summary.json` is at the results
root. THC SELECT defaults to eight local shots; `--shots` can override that count.

The single-file generator writes QIR in the current working directory:

```sh
python guppy_examples/generate_qir guppy_examples/capability-checks/guppyalgos/08_gidney_addition.py
```

This produces `08_gidney_addition.ll`.
