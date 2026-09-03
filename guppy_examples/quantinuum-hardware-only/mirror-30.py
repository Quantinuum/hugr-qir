from typing import no_type_check

from guppylang import guppy
from guppylang.std.angles import pi
from guppylang.std.builtins import array, control, dagger, output, qubit
from guppylang.std.lang import owned
from guppylang.std.platform import barrier
from guppylang.std.qsystem.helios import (
    collect_measurements,
    measure_array,
    phased_x,
    rz,
    zz_max,
    zz_phase,
)
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import rz as quantum_rz
from guppylang.std.quantum import x

N_QUBITS = 30


@no_type_check
def forward_mirror(qbs: list[qubit]) -> None:
    # Native single-qubit gates create a non-trivial product state.
    for i in range(N_QUBITS):
        phased_x(qbs[i], pi / 2, (i % 2) * pi / 2)

    # Two staggered layers entangle the whole register.
    for i in range(N_QUBITS // 2):
        zz_max(qbs[2 * i], qbs[2 * i + 1])
    for i in range((N_QUBITS - 2) // 2):
        zz_phase(qbs[2 * i + 1], qbs[2 * i + 2], pi / 2)


@no_type_check
def reverse_mirror(qbs: list[qubit]) -> None:
    for i in range((N_QUBITS - 2) // 2):
        j = (N_QUBITS - 4) // 2 - i
        zz_phase(qbs[2 * j + 1], qbs[2 * j + 2], -pi / 2)
    for i in range(N_QUBITS // 2):
        j = N_QUBITS // 2 - 1 - i
        zz_phase(qbs[2 * j], qbs[2 * j + 1], -pi / 2)

    for i in range(N_QUBITS):
        j = N_QUBITS - 1 - i
        phased_x(qbs[j], -pi / 2, (j % 2) * pi / 2)


@guppy
@no_type_check
def runtime_forward(
    q: array[qubit, N_QUBITS],
    random_choice: bool,
    shot_choice: bool,
) -> None:
    # Exercise Guppy's dagger modifier on an array element.
    with dagger():
        quantum_rz(q[2], pi / 2)
        x(q[2])

    # Quantinuum-only runtime values choose additional reversible work. Both
    # choices are undone after the barrier, so they cannot affect the result.
    if random_choice:
        rz(q[1], pi / 2)
        rz(q[7], pi / 2)
        rz(q[13], pi / 2)
        rz(q[19], pi / 2)
        rz(q[25], pi / 2)
    if shot_choice:
        x(q[4])
        x(q[21])


@guppy
@no_type_check
def runtime_reverse(
    q: array[qubit, N_QUBITS],
    random_choice: bool,
    shot_choice: bool,
) -> None:
    if shot_choice:
        x(q[21])
        x(q[4])
    if random_choice:
        rz(q[25], -pi / 2)
        rz(q[19], -pi / 2)
        rz(q[13], -pi / 2)
        rz(q[7], -pi / 2)
        rz(q[1], -pi / 2)

    # Invert the daggered block.
    quantum_rz(q[2], pi / 2)
    x(q[2])


@guppy
@no_type_check
def controlled_x(ctl: qubit, target: qubit) -> None:
    with control(ctl):
        x(target)


@guppy
@no_type_check
def mirror_barrier(qbs: array[qubit, N_QUBITS]) -> None:
    barrier(qbs)


@guppy
@no_type_check
def record_result(qbs: array[qubit, N_QUBITS] @ owned) -> None:
    # Exercise array barriers and deferred array measurement.
    barrier(qbs)
    output("mirror", collect_measurements(measure_array(qbs)))


# hqscompiler doesn't like llvm `srem` which would arise
# from get_current_shot() % 2 == 0
# so choosing like this for now
even_numbers_less_than_10 = [0, 2, 4, 6, 8]


@guppy
@no_type_check
def get_shot_choice() -> bool:
    cshot = get_current_shot()
    for even in array(i for i in even_numbers_less_than_10):  # noqa: SIM110
        if cshot == even:
            return True
    return False


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = [qubit() for _ in range(N_QUBITS)]

    rng = RNG(2026)
    random_choice = rng.random_int_bounded(2) == 1
    rng.discard()
    shot_choice = get_shot_choice()

    forward_mirror(qbs)
    runtime_forward(qbs, random_choice, shot_choice)
    controlled_x(qbs[0], qbs[29])
    mirror_barrier(qbs)
    controlled_x(qbs[0], qbs[29])
    runtime_reverse(qbs, random_choice, shot_choice)
    reverse_mirror(qbs)

    record_result(qbs)


# Expected output for every shot: {"mirror": 0} (all 30 measured bits are zero).
