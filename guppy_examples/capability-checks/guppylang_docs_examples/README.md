# Run the Guppy gallery checks

See [CAPABILITIES.md](CAPABILITIES.md) for notebook coverage, adaptations, and
passing/failing stages. The [shared checker README](../README.md) describes all
options and output files.

From the repository root:

```sh
python guppy_examples/capability-checks/check_examples.py --suite guppylang_docs_examples
python guppy_examples/capability-checks/check_examples.py --suite guppylang_docs_examples --emulate
python guppy_examples/capability-checks/check_examples.py --suite guppylang_docs_examples --pattern 'state_output_full.py' --emulate-only
```

Use `--output /tmp/capability-results` to select a results directory. This suite's
HUGR, QIR, per-mode JSON, logs, and shot records are written under
`/tmp/capability-results/guppylang_docs_examples/`; the combined `summary.json`
is at the results root. Pure and partial snapshots default to eight local shots,
and the intentional panic to one. `--shots` overrides these defaults.
