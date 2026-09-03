from typing import no_type_check

from guppylang import guppy
from guppylang.std.angles import pi
from guppylang.std.builtins import array, control, output, qubit
from guppylang.std.lang import owned
from guppylang.std.quantum import collect_measurements, cx, h, measure_array, rz, x

N_QUBITS = 10


@guppy
@no_type_check
def forward_mirror(qbs: array[qubit, N_QUBITS]) -> None:
    # Single-qubit gates create a non-trivial product state.
    for i in range(N_QUBITS):
        h(qbs[i])
        rz(qbs[i], (i % 2) * pi / 2)

    # Two staggered layers entangle the whole register.
    for i in range(N_QUBITS // 2):
        cx(qbs[2 * i], qbs[2 * i + 1])
    for i in range((N_QUBITS - 2) // 2):
        cx(qbs[2 * i + 1], qbs[2 * i + 2])


@guppy
@no_type_check
def reverse_mirror(qbs: array[qubit, N_QUBITS]) -> None:
    for i in range((N_QUBITS - 2) // 2):
        j = (N_QUBITS - 4) // 2 - i
        cx(qbs[2 * j + 1], qbs[2 * j + 2])
    for i in range(N_QUBITS // 2):
        j = N_QUBITS // 2 - 1 - i
        cx(qbs[2 * j], qbs[2 * j + 1])

    for i in range(N_QUBITS):
        j = N_QUBITS - 1 - i
        rz(qbs[j], -((j % 2) * pi / 2))
        h(qbs[j])


@guppy
@no_type_check
def controlled_x(ctl: qubit, target: qubit) -> None:
    with control(ctl):
        x(target)


@guppy
@no_type_check
def record_result(qbs: array[qubit, N_QUBITS] @ owned) -> None:
    output("mirror", collect_measurements(measure_array(qbs)))


@guppy
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(N_QUBITS))

    forward_mirror(qbs)
    controlled_x(qbs[0], qbs[N_QUBITS - 1])
    controlled_x(qbs[0], qbs[N_QUBITS - 1])
    reverse_mirror(qbs)

    record_result(qbs)


# Expected output for every shot: {"mirror": 0} (all 10 measured bits are zero).
