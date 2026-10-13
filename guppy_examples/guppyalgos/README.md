# Running guppyalgos example checks

[CAPABILITIES.md](CAPABILITIES.md) records the capabilities and passing/failing
stages of all examples.

## Run the checks

Install the development dependencies with `uv sync --group dev` and activate the
project's Python environment. From the repository root, run:

```sh
python guppy_examples/guppyalgos/check_examples.py
python guppy_examples/guppyalgos/check_examples.py --emulate
python guppy_examples/guppyalgos/check_examples.py --emulate-only
```

The default command checks each example, compiles its HUGR, and converts it with
hugr-qir, including HUGR and QIR validation. `--emulate` also runs Guppy's local
statevector emulator; `--emulate-only` runs just the local checks. Classical
example 42 runs its preprocessing check in either mode.

Select an example with `--pattern`, or repeat it to combine selections:

```sh
python guppy_examples/guppyalgos/check_examples.py --pattern '23_*.py' --emulate
python guppy_examples/guppyalgos/check_examples.py --pattern '19_*.py' --pattern '[2-4][0-9]_*.py'
python guppy_examples/guppyalgos/check_examples.py --pattern '44_*.py' --emulate-only --shots 8
```

Each example runs in a separate process. The default timeout is 90 seconds per
example per mode; `--timeout 180` allows longer checks. Simulations default to
256 shots and seed 7; `--shots` changes the shot count. THC SELECT (44) has a
larger statevector budget; its documented local check uses eight shots.

The runner continues after failures and returns a nonzero exit status if any
requested check fails. Simulation checks run Guppy programs locally; they do not
execute the emitted QIR or submit cloud jobs.

## Output locations

The runner prints its output directory. By default it creates a temporary
`guppyalgos-*` directory. Choose a persistent location with `--output`:

```sh
python guppy_examples/guppyalgos/check_examples.py --output /tmp/guppyalgos-checks
```

The directory contains:

- `<example>.hugr`: the compiled Guppy HUGR, when compilation succeeds.
- `<example>.ll`: emitted QIR, saved before validation so rejected QIR can be inspected.
- `<example>.compile.json` and `<example>.emulate.json`: per-mode results and diagnostics.
- `<example>.compile.log` and `<example>.emulate.log`: complete worker output and tracebacks.
- `<example>.shots.json`: simulation shot records, when available.
- `summary.json`: versions and results for the selected examples.

The `qir` result includes emission and validation; `qir_emitted` identifies when
emission succeeded, and `qir_qubits` records the emitted resource count.
Classical examples report `preprocess` instead of HUGR or QIR stages.

The single-file generator writes QIR in the current working directory:

```sh
python guppy_examples/generate_qir guppy_examples/guppyalgos/08_gidney_addition.py
```

This produces `08_gidney_addition.ll`.
