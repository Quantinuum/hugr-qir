from guppylang import guppy, comptime
from guppylang.std.angles import pi
from guppylang.std.quantum import (
    qubit,
    h,
    crz,
    x,
    measure_array,
    discard_array,
    cx,
    rz,
    collect_measurements,
)
from guppylang.std.builtins import array, output, control, dagger, nat


@guppy
def prepare_trivial_eigenstate() -> array[qubit, 2]:
    q0, q1 = qubit(), qubit()
    x(q0)
    x(q1)
    return array(q0, q1)


@guppy(controllable=True)
def u(q0: qubit, q1: qubit) -> None:
    cx(q0, q1)
    rz(q1, -pi / 4)
    cx(q0, q1)


@guppy(daggerable=True)
def swap(q0: qubit, q1: qubit) -> None:
    cx(q0, q1)
    cx(q1, q0)
    cx(q0, q1)


@guppy.comptime(daggerable=True)
def qft[n: nat](qs: array[qubit, n]) -> None:
    for i in range(n):
        h(qs[i])
        for j in range(i + 1, n):
            crz(qs[j], qs[i], pi / 2.0 ** (j - i))

    # Reverse qubit order with swaps
    for k in range(n // 2):
        swap(qs[k], qs[n - k - 1])


@guppy
def phase_estimation[n: nat](
    estimation_qubits: array[qubit, n], state_qubits: array[qubit, 2]
) -> None:
    for i in range(n):
        h(estimation_qubits[i])

    # Add 2^n - 1 controlled unitaries sequentially
    for n_index in range(n):
        control_index: int = n - n_index - 1
        for _ in range(2**n_index):
            with control(estimation_qubits[control_index]):
                u(state_qubits[0], state_qubits[1])
    with dagger:
        qft(estimation_qubits)


@guppy
def main() -> None:
    # Allocate qubits for state prep and measurement.
    state = prepare_trivial_eigenstate()
    qubits_to_measure = array(qubit() for _ in range(4))

    # Apply phase estimation subroutine.
    phase_estimation(qubits_to_measure, state)

    # Measure the qubits encoding the phase.
    measurements = measure_array(qubits_to_measure)

    # State prep qubits are not measured so have to be explicitly discarded.
    discard_array(state)

    # Create an output from the measured array.
    output("c", collect_measurements(measurements))
