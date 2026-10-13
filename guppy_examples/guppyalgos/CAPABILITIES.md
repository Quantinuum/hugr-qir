# Guppyalgos capabilities

This file records the passing and failing stages for all 45 examples. Each quantum
example has a no-argument `@guppy main`. Example 42 checks classical THC
preprocessing and allocates no qubits. See the [README](README.md) for commands
and output locations.

The examples use public `guppyalgos 0.1.0`, `guppylang 1.0.5`, `hugr-qir 0.3.1`
from this checkout's native extension, and `selene-sim 0.3.2` with Python 3.13.13.
Conversion targets `quantinuum-hardware`, with aggressive optimization, a loop
unroll limit of 800, and HUGR and QIR validation enabled.

The recorded checks for examples 01–18 are from 2026-10-09, with example 14's
QIR and numerical checks from 2026-10-12. Examples 19–45 were checked on
2026-10-13; their [machine-readable results](capability-results.json) include
source hashes, individual stages, resource counts, and diagnostics.

Of the 44 quantum examples, **43 compile to HUGR**, **26 produce validated QIR**,
and **43 pass local Guppy simulation checks**. Example 43 fails during Guppy
checking. The classical THC preprocessing check passes independently.
Local checks use 256 shots and seed 7, except THC SELECT (44), which uses eight
shots. The maximum simulation budget is 20 qubits, and the maximum emitted QIR
count is 29, below the 56-qubit limit.

Simulation checks exercise Guppy's emulator rather than emitted QIR. A simulation
pass establishes the stated outcome or invariant checks, not support in
hugr-qir. QIR counts describe emitted allocations and may exceed the simultaneous
simulation budget.

## Results

HUGR records Guppy compilation. Conversion records hugr-qir emission and QIR
validation. A dash means no emitted QIR resource count was available. A count on
a failing row comes from emitted QIR that did not pass validation. Example 42's
local result is its classical preprocessing check. Error codes refer to the
reported errors below.

| Program | Capability and result | Simulation qubits | QIR qubits | HUGR | Conversion | Local checks |
|---|---|---:|---:|---|---|---|
| [01_uniform_five.py](01_uniform_five.py) | Amplitude amplification prepares five equally likely addresses. | 12 | — | Pass | Panic rejection: E5 | Pass |
| [02_complex_amplitudes.py](02_complex_amplitudes.py) | Multiplexor loads complex amplitudes; Hadamard interference reveals their phases. | 3 | 3 | Pass | Pass | Pass |
| [03_alias_sampling.py](03_alias_sampling.py) | Alias-table preparation samples probabilities 1/8, 2/8, 3/8, 2/8. | 16 | — | Pass | Loop unrolling: E1 | Pass |
| [04_qrom_lookup.py](04_qrom_lookup.py) | Unary-iteration QROM correlates eight addresses with three-bit words. | 8 | — | Pass | Loop unrolling: E1 | Pass |
| [05_qrom_measurement_uncompute.py](05_qrom_measurement_uncompute.py) | Measurement-based QROM erasure recovers a coherent address superposition. | 12 | — | Pass | Loop unrolling: E1 | Pass |
| [06_pauli_select.py](06_pauli_select.py) | Pauli SELECT applies one of four two-qubit strings. | 5 | — | Pass | Loop unrolling: E1 | Pass |
| [07_ripple_carry.py](07_ripple_carry.py) | Cuccaro addition computes 9+a and its overflow for superposed a. | 10 | 11 | Pass | Pass | Pass |
| [08_gidney_addition.py](08_gidney_addition.py) | Gidney addition computes 11+a modulo 16 with measured carry cleanup. | 11 | 14 | Pass | Pass | Pass |
| [09_threshold_comparator.py](09_threshold_comparator.py) | Reversible comparison flags addresses below three and preserves both inputs. | 10 | 9 | Pass | Pass | Pass |
| [10_hamming_weight.py](10_hamming_weight.py) | A tree of adders counts six superposed bits; a reference verifies every sampled count. | 18 | 18 | Pass | Pass | Pass |
| [11_fourier_period.py](11_fourier_period.py) | IQFT extracts the Fourier peaks of a period-four state. | 4 | — | Pass | Loop unrolling: E1 | Pass |
| [12_phase_estimation.py](12_phase_estimation.py) | QPE resolves phases 0 and 5/16, correlated with the system eigenstate. | 5 | — | Pass | Loop unrolling: E1 | Pass |
| [13_hadamard_overlap.py](13_hadamard_overlap.py) | Hadamard test estimates the real overlap of a controlled XX evolution. | 3 | 3 | Pass | Pass | Pass |
| [14_ising_trotter.py](14_ising_trotter.py) | Six Trotter steps evolve a four-site Ising chain; dense product-formula probabilities check the result. | 4 | 4 | Pass | Pass | Pass |
| [15_grover_reflection.py](15_grover_reflection.py) | Householder reflections amplify the marked value five in two Grover iterations. | 3 | — | Pass | Loop unrolling: E1 | Pass |
| [16_phase_gradient_rotation.py](16_phase_gradient_rotation.py) | Controlled addition into a Fourier resource implements a binary-encoded Y rotation. | 13 | 23 | Pass | Pass | Pass |
| [17_teleport_entanglement.py](17_teleport_entanglement.py) | Teleportation transfers half a Bell pair; decoding verifies the recovered entanglement. | 4 | 4 | Pass | Pass | Pass |
| [18_pauli_exponential.py](18_pauli_exponential.py) | An XYZ Pauli exponential produces correlated three-qubit amplitudes. | 3 | 3 | Pass | Pass | Pass |
| [19_lcu.py](19_lcu.py) | LCU composition with a signed two-term SELECT | 2 | 2 | Pass | Pass | Pass |
| [20_controlled_lcu.py](20_controlled_lcu.py) | Controlled LCU with Ramsey interference | 3 | 3 | Pass | Pass | Pass |
| [21_qubitization.py](21_qubitization.py) | Squared qubitization walk | 2 | 2 | Pass | Pass | Pass |
| [22_controlled_qubitization.py](22_controlled_qubitization.py) | Controlled qubitization walk with Ramsey interference | 3 | 3 | Pass | Pass | Pass |
| [23_qsvt.py](23_qsvt.py) | Three-query QSVT with nonzero reflection phases | 3 | 3 | Pass | Pass | Pass |
| [24_inverse_phase_estimation.py](24_inverse_phase_estimation.py) | Inverse QPE independently initialized with a known phase | 4 | — | Pass | Loop unrolling: E1 | Pass |
| [25_qubitized_power_oracle.py](25_qubitized_power_oracle.py) | Qubitized power adapter with an elementary controlled walk | 3 | 6 | Pass | Pass | Pass |
| [26_controlled_select.py](26_controlled_select.py) | Controlled unary SELECT with plain gate callbacks | 7 | — | Pass | Loop unrolling: E1 | Pass |
| [27_controlled_qrom.py](27_controlled_qrom.py) | Controlled QROM with a flat two-bit payload | 7 | — | Pass | Loop unrolling: E1 | Pass |
| [28_selectswap_lookup.py](28_selectswap_lookup.py) | SELECTSWAP forward with two payload banks | 8 | — | Pass | Loop unrolling: E1 | Pass |
| [29_selectswap_uncompute.py](29_selectswap_uncompute.py) | SELECTSWAP inverse with two payload banks | 8 | — | Pass | Loop unrolling: E1 | Pass |
| [30_accumulator.py](30_accumulator.py) | accumulator_unary_iteration | 6 | — | Pass | Loop unrolling: E1 | Pass |
| [31_guarded_accumulator.py](31_guarded_accumulator.py) | guarded_accumulator_unary_iteration | 6 | — | Pass | Loop unrolling: E1 | Pass |
| [32_select_rotator.py](32_select_rotator.py) | SelectRotator wrapper with elementary compute/rotate/uncompute | 4 | 4 | Pass | Pass | Pass |
| [33_walsh_diagonal.py](33_walsh_diagonal.py) | Walsh diagonal synthesis with X-basis interference | 2 | 2 | Pass | Pass | Pass |
| [34_trotter_second_order.py](34_trotter_second_order.py) | order-2 Trotter step | 1 | 1 | Pass | Pass | Pass |
| [35_trotter_fourth_order.py](35_trotter_fourth_order.py) | order-4 Trotter step | 1 | 1 | Pass | Pass | Pass |
| [36_controlled_trotter_first.py](36_controlled_trotter_first.py) | Controlled order-1 Trotter step | 2 | 2 | Pass | Pass | Pass |
| [37_controlled_trotter_higher.py](37_controlled_trotter_higher.py) | Controlled order-2 Trotter step | 2 | 2 | Pass | Pass | Pass |
| [38_custom_trotter_sequence.py](38_custom_trotter_sequence.py) | custom signed sequence | 1 | 1 | Pass | Pass | Pass |
| [39_controlled_trotter_sequence.py](39_controlled_trotter_sequence.py) | Controlled custom signed sequence | 2 | 2 | Pass | Pass | Pass |
| [40_prepare_measure_once.py](40_prepare_measure_once.py) | Prepare-and-measure amplitude sample | 3 | 3 | Pass | Pass | Pass |
| [41_prepare_measure_estimation.py](41_prepare_measure_estimation.py) | Repeated prepare-and-measure amplitude estimation | 3 | 24 | Pass | QIR validation: E2 | Pass |
| [42_thc_preprocessing.py](42_thc_preprocessing.py) | THC classical preprocessing; no quantum circuit | 0 | — | Not applicable | Not applicable | Classical pass |
| [43_thc_record_loader.py](43_thc_record_loader.py) | THC record-loader wrapper with a six-bit record QROM | 10 | — | Blocked by E3 | Guppy check: E3 | Blocked by E3 |
| [44_thc_controlled_select.py](44_thc_controlled_select.py) | THC controlled SELECT with decoded fields and a phase-gradient cascade | 20 | — | Pass | Panic rejection: E4 | Pass (8 shots) |
| [45_select_rotator_phase_gradient.py](45_select_rotator_phase_gradient.py) | SelectRotator with a phase-gradient Y rotation and elementary XOR loader | 13 | 29 | Pass | Pass | Pass |

Example 14's 320 emitted QIR gates reproduce its dense Trotter reference with
maximum probability error below 4e-15. Its
[one-qubit comptime function-array example](../guppy-features/supported/comptime-function-array.py)
also converts to validated QIR.

## Isolation and interpreting results

- LCU and the walk/QSVT examples use elementary PREPARE and SELECT gate oracles.
  Their encoded block is `(Z-X)/2`; QROM and alias preparation are not dependencies.
  PREPARE is measured along with the system: only its zero projection selects the
  encoded block. The controlled examples use Ramsey interference to check relative
  phases. QSVT uses three nonzero reflection phases and a Hermitian LCU whose
  inverse is the same LCU. It tests composition rather than phase synthesis.
- Inverse QPE starts from a known phase word instead of running forward QPE.
  The power-adapter example uses an elementary one-term walk at even and odd
  powers instead of depending on the full QPE algorithm.
- Controlled SELECT uses plain gate callbacks; controlled QROM uses a flat word
  table. Both supply self-inverse Toffoli compute/uncompute operations. SELECTSWAP
  forward and inverse operations have separate examples; the inverse starts from
  an independently initialized bank. Accumulators have separate valid-index and
  coherent out-of-range guard examples.
- Example 32 checks the SELECT-rotation wrapper with elementary loaders and a
  self-inverse bit-flip rotator. Example 45 uses the library's phase-gradient Y
  rotator with an elementary loader. Both check that the data register is cleared.
- Walsh phases are checked by X-basis interference. Trotter programs use one
  system qubit, noncommuting terms, and independent dense references to their
  finite product formulas. Controlled formulas retain an identity term so its
  relative phase is tested. Custom schedules include negative time weights.
- The amplitude samplers mark a good subspace of probability 1/4. Example 41
  estimates it with eight samples and records a count of `k` as `k` low set bits
  in `success_thermometer`. The readout can be decoded by counting its true bits.
- THC preprocessing, record loading, and SELECT are separate programs. SELECT
  starts from a decoded two-body record and uses elementary XOR angle loaders,
  keeping alias preparation and unary QROM separate. Its local checks verify
  register restoration and particle number. These examples do not construct or
  validate a complete THC block encoding of a molecular Hamiltonian.

## Reported errors

**E1 — loop unrolling** (03, 04, 05, 06, 11, 12, 15, 24, 26, 27, 28, 29, 30, 31). These programs check and
compile in Guppy and pass local simulations, but hugr-qir reports:

```text
Compilation failed: Loop cannot be unrolled: its iteration count is not known at compile time or exceeds the limit of 800.
```

**E2 — QIR validation** (41). QIR is emitted with 24 qubits, then validation
rejects the integer-to-floating-point conversion used by the estimator:

```text
Generated QIR failed validation: Encountered Unexpected Instruction   %15 = uitofp nneg i64 %14 to double
```

**E3 — public-library signature** (43). Guppy fails while parsing
`load_select_registers`, before HUGR or QIR compilation. The failing annotation
is `array[qubit, comptime((2 * n_index_q) + 2)]` in
`guppyalgos/algorithms/block_encoding/thc/thc_lcu.py:64`:

```text
NameError: name 'n_index_q' is not defined
```

**E4 — possible runtime panic** (44). Guppy compiles the circuit and its local
checks pass. hugr-qir reports:

```text
Compilation failed: Program may panic: Array element is already borrowed; Option.unwrap: value is `Nothing`. Runtime panics are unsupported on H-Series.
```

**E5 — checked zero-state disposal** (01). Guppy compiles the circuit and
its local outcome checks pass. The converter rejects the possible runtime panic
in uniform-state preparation's workspace cleanup:

```text
Compilation failed: Program may panic: Qubit promised to be in 0 is non-zero. Runtime panics are unsupported on H-Series.
```
