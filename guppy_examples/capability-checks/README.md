# Capability checks

The shared checker runs two suites:

- [guppyalgos](guppyalgos/CAPABILITIES.md): isolated public-library algorithms.
- [guppylang_docs_examples](guppylang_docs_examples/CAPABILITIES.md): script adaptations
  of the [Guppy examples gallery](https://docs.quantinuum.com/guppy/examples_index.html).

Each suite's `CAPABILITIES.md` records its examples, results, and conversion errors.

## Run the checks

Install the project's development dependencies with `uv sync --group dev`, activate
its Python environment, and run these commands from the repository root:

```sh
python guppy_examples/capability-checks/check_examples.py
python guppy_examples/capability-checks/check_examples.py --emulate
python guppy_examples/capability-checks/check_examples.py --emulate-only
```

The default command checks and compiles each Guppy entrypoint, emits QIR, and
validates both HUGR and QIR. `--emulate` also checks the programs in Guppy's local
statevector emulator. `--emulate-only` runs just local simulations. Classical
THC preprocessing runs its Python checks in either mode.

Select a suite or filename pattern; both options can be repeated:

```sh
python guppy_examples/capability-checks/check_examples.py --suite guppylang_docs_examples
python guppy_examples/capability-checks/check_examples.py --suite guppyalgos --pattern '23_*.py' --emulate
python guppy_examples/capability-checks/check_examples.py --pattern 'ghz_state.py' --pattern '19_*.py' --emulate
```

Both suites are selected when `--suite` is omitted. Patterns match filenames
inside the selected suites; helper files beginning with `_` are excluded.

Each example runs in its own process with a 90-second timeout per mode. Use
`--timeout 180` for longer checks. Simulations use seed 7 and normally 256 shots.
Full and partial state snapshots, and THC SELECT, default to eight shots; the
intentional panic defaults to one. `--shots` overrides the per-example default.

The checker continues after failures and exits with a nonzero status if a
requested check fails. The panic example's local check passes only when it
raises the expected runtime error; compilation or emulator-build errors do not
satisfy that check. Simulations run locally and do not execute emitted QIR or
submit cloud jobs.

## Output locations

The checker prints its output directory. By default it creates a temporary
`capability-checks-*` directory; choose a persistent location with `--output`:

```sh
python guppy_examples/capability-checks/check_examples.py --output /tmp/capability-results
```

Results are separated by suite:

```text
capability-results/
  summary.json
  guppyalgos/
    19_lcu.hugr
    19_lcu.ll
    19_lcu.compile.json
    19_lcu.compile.log
  guppylang_docs_examples/
    ghz_state.hugr
    ghz_state.ll
    ghz_state.compile.json
    ghz_state.compile.log
    ghz_state.emulate.json
    ghz_state.emulate.log
    ghz_state.shots.json
```

Each suite directory can contain:

- `<example>.hugr`: compiled Guppy HUGR, when compilation succeeds.
- `<example>.ll`: emitted QIR, saved before validation so rejected QIR can be inspected.
- `<example>.compile.json` and `<example>.emulate.json`: stages, source hash,
  resource counts, and diagnostics.
- `<example>.compile.log` and `<example>.emulate.log`: complete worker output and tracebacks.
- `<example>.shots.json`: classical simulation outputs. Raw simulator state entries
  are identified by type; their numerical checks are recorded in `validation_details`.

`summary.json` records versions, selected suites, and all selected examples.
The `qir` stage includes emission and validation; `qir_emitted` distinguishes
emission from validation failures, and `qir_qubits` records emitted allocations.
Classical examples report `preprocess` instead of HUGR or QIR stages.

The [machine-readable results](guppylang_docs_examples/capability-results.json) and
[notebook sources](guppylang_docs_examples/notebook-sources.json) alongside the
suite document its verified scripts and their upstream notebook URLs and hashes.

## Check the shared machinery

```sh
uv run pytest guppy_examples/capability-checks/test_check_examples.py
```

These tests cover discovery, separate artifacts for same-named examples in
different suites, and expected runtime-error handling.
They run only when explicitly selected; plain `uv run pytest` collects
the tests under `python/tests`.
