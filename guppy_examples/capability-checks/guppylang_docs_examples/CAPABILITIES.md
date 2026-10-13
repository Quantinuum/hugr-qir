# Guppy gallery capabilities

These 16 scripts adapt all ten notebooks linked by the
[Guppy examples gallery](https://docs.quantinuum.com/guppy/examples_index.html).
Each exports a no-argument Guppy entrypoint named `main`. The
[source manifest](notebook-sources.json) records the notebook URLs, SHA-256 hashes,
and associated scripts. Notebook plotting and automatic execution are omitted;
classical outputs and state snapshots are checked by the shared runner.

Checked on 2026-10-13 with Python 3.13.13, Guppy 1.0.5, this checkout's
hugr-qir 0.3.1 native extension, and selene-sim 0.3.2. Conversion uses
`quantinuum-hardware`, aggressive optimization, an unroll limit of 800,
and HUGR/QIR validation. [Machine-readable results](capability-results.json)
include source hashes, individual stages, resource counts, and diagnostics.
See the [README](README.md) for commands and result locations.

**All 16 compile to HUGR and pass their local checks; eight produce validated QIR.**
The panic example passes locally when its expected runtime error occurs. Full and
partial state snapshots use eight shots, the panic uses one, and the other
examples use 256; all use seed 7. The maximum simulation budget is eight qubits; the maximum emitted QIR count is
seven qubits. QIR validation failures retain their emitted resource counts.
Local checks run Guppy's emulator rather than emitted QIR.

## Notebook coverage

| Notebook | Adapted scripts |
|---|---|
| [adaptive-qpe](https://docs.quantinuum.com/guppy/guppylang/examples/adaptive-qpe.html) | [adaptive-qpe.py](adaptive-qpe.py) |
| [canonical-qpe](https://docs.quantinuum.com/guppy/guppylang/examples/canonical-qpe.html) | [canonical-qpe.py](canonical-qpe.py) |
| [ghz_and_graph](https://docs.quantinuum.com/guppy/guppylang/examples/ghz_and_graph.html) | [ghz_state.py](ghz_state.py), [graph_state.py](graph_state.py) |
| [postselect](https://docs.quantinuum.com/guppy/guppylang/examples/postselect.html) | [postselection_exit.py](postselection_exit.py), [postselection_panic.py](postselection_panic.py) |
| [qaoa_maxcut_example](https://docs.quantinuum.com/guppy/guppylang/examples/qaoa_maxcut_example.html) | [qaoa_maxcut.py](qaoa_maxcut.py) |
| [random_numbers](https://docs.quantinuum.com/guppy/guppylang/examples/random_numbers.html) | [random_precomputed.py](random_precomputed.py), [random_runtime_rng.py](random_runtime_rng.py) |
| [repeat-until-success](https://docs.quantinuum.com/guppy/guppylang/examples/repeat-until-success.html) | [repeat-until-success.py](repeat-until-success.py) |
| [state_results](https://docs.quantinuum.com/guppy/guppylang/examples/state_results.html) | [state_output_branch.py](state_output_branch.py), [state_output_full.py](state_output_full.py), [state_output_partial.py](state_output_partial.py) |
| [swap_test](https://docs.quantinuum.com/guppy/guppylang/examples/swap_test.html) | [the_swap_test_and_loading_pytket_circuits.py](the_swap_test_and_loading_pytket_circuits.py) |
| [t_factory](https://docs.quantinuum.com/guppy/guppylang/examples/t_factory.html) | [optional_measurements.py](optional_measurements.py), [t_state_distillation.py](t_state_distillation.py) |

## Configuration and checks

- GHZ and graph-state scripts retain their factory-based preparation. Checks cover
  GHZ correlations and the graph state's computational-basis distribution.
- The canonical QPE script retains its comptime QFT and controlled-oracle kernel.
  A dense reference checks the output distribution of that circuit.
- QAOA fixes the gallery's seven-node graph to three layers with explicit cost and
  mixer parameters. It checks the full distribution against a dense reference and
  each reported cut score against its bitstring. The notebook's host optimizer is
  not run by these capability checks.
- Adaptive QPE retains 24 rounds and floating-point eigenvalue output. Its local
  estimate mean is checked against an independent classical sampling reference.
- Precomputed RNG uses the notebook's 100-entry seeded table, indexed cyclically
  so arbitrary shot counts are valid. Runtime RNG uses a seed derived from the shot
  index. Both verify that repeating a selected Pauli is the identity.
- RUS retains the twenty-attempt limit in the adapted script. Its attempt count
  follows the corresponding truncated geometric distribution.
- Steane postselection runs without an injected noise model and checks the returned
  state's parity. The separate panic script deliberately uses an invalid physical
  index; only that expected runtime panic satisfies its local check.
- State-output scripts separately check equivalent pure GHZ states, two-qubit mixed
  reduced states, and a state selected by a measured branch. Snapshot validators
  compare states up to global phase or compare density matrices as appropriate.
- Distillation retains five input states, three recursive attempts, and the
  notebook's numeric preparation angles. It measures the returned optional state
  instead of adding a state-debugging dependency, and checks success and output
  probabilities against dense postselection. Masked measurements separately check
  Option ownership and readout; replacement of linear optional values uses `swap`
  and consumes the previous `nothing` value.

## Results

HUGR records Guppy compilation. Conversion includes emission and QIR validation.
A dash means no emitted resource count was available. A count on a failing row
comes from emitted QIR that did not pass validation. The errors are listed below.

| Program | Capability | Simulation qubits | QIR qubits | HUGR | Conversion | Local checks |
|---|---|---:|---:|---|---|---|
| [adaptive-qpe.py](adaptive-qpe.py) | Adaptive QPE with measurement-dependent floating-point updates | 2 | — | Pass | Fail: G1 | Pass |
| [canonical-qpe.py](canonical-qpe.py) | Canonical QPE with a comptime inverse Fourier transform | 6 | 6 | Pass | Pass | Pass |
| [ghz_state.py](ghz_state.py) | Six-qubit GHZ preparation | 6 | 6 | Pass | Pass | Pass |
| [graph_state.py](graph_state.py) | Complete three-node graph state | 3 | 3 | Pass | Pass | Pass |
| [optional_measurements.py](optional_measurements.py) | Masked measurements of Option[qubit] with Option[Measurement] results | 3 | 3 | Pass | Pass | Pass |
| [postselection_exit.py](postselection_exit.py) | Steane preparation with postselection exit | 8 | — | Pass | Fail: G2 | Pass |
| [postselection_panic.py](postselection_panic.py) | Deliberate invalid-index panic | 8 | — | Pass | Fail: G3 | Pass (expected panic) |
| [qaoa_maxcut.py](qaoa_maxcut.py) | Fixed-parameter Max-Cut QAOA kernel | 7 | 7 | Pass | Pass | Pass |
| [random_precomputed.py](random_precomputed.py) | Precomputed random table indexed by shot | 1 | 1 | Pass | Fail: G4 | Pass |
| [random_runtime_rng.py](random_runtime_rng.py) | Runtime seeded RNG | 1 | 1 | Pass | Pass | Pass |
| [repeat-until-success.py](repeat-until-success.py) | Measurement-driven RUS with a twenty-attempt limit | 3 | 3 | Pass | Pass | Pass |
| [state_output_branch.py](state_output_branch.py) | state_output selected by measurement-dependent control flow | 3 | — | Pass | Fail: G5 | Pass |
| [state_output_full.py](state_output_full.py) | Full state_output snapshots from equivalent GHZ circuits | 3 | — | Pass | Fail: G5 | Pass |
| [state_output_partial.py](state_output_partial.py) | Mixed-state subset snapshots of an entangled GHZ register | 3 | — | Pass | Fail: G5 | Pass |
| [t_state_distillation.py](t_state_distillation.py) | Five-to-one T-state distillation with recursive retries and Option ownership | 5 | — | Pass | Fail: G6 | Pass |
| [the_swap_test_and_loading_pytket_circuits.py](the_swap_test_and_loading_pytket_circuits.py) | SWAP test of loaded W and S state-preparation circuits | 7 | 7 | Pass | Pass | Pass |

## Reported conversion errors

**G1 — floating-point output** (adaptive QPE):

```text
Float output is not supported on H-Series hardware
```

**G2 — possible postselection termination** (Steane exit). The converter reports
this `exit` path as a possible runtime panic:

```text
Compilation failed: Program may panic: Postselected: FT prep failed. Runtime panics are unsupported on H-Series.
```

**G3 — deliberate runtime panic** (invalid physical index):

```text
Compilation failed: Program always panics: Invalid data index in physical_h; Postselected: FT prep failed
```

**G4 — QIR validation of indexed static data** (precomputed RNG). QIR is emitted
with one qubit, but validation rejects the indexed pointer instruction:

```text
Generated QIR failed validation: Encountered Unexpected Instruction   %0 = getelementptr inbounds nuw { i64, [0 x i64] }, ptr @"sa.static_pyarray.%tmp2.c4771794.0", i64 0, i32 1, i64 %remainder.zext
```

**G5 — state debugging output** (all three state-output examples). Guppy compiles
and their numerical state checks pass, but LLVM emission fails at the
`tket.debug.StateResult` operation. The compiler reports `Failed to emit LLVM`
for the example's entrypoint; the worker logs preserve the full exception chain.

**G6 — retained functions** (recursive T-state distillation):

```text
assertion `left == right` failed
  left: 1
 right: 2
```

The converter requires one remaining function body; the recursive preparation
helper remains alongside `main`.
