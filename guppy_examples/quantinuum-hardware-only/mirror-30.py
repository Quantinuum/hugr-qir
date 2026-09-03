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
def runtime_forward(  # noqa: PLR0913, PLR0917
    q1: qubit,
    q2: qubit,
    q4: qubit,
    q7: qubit,
    q13: qubit,
    q19: qubit,
    q21: qubit,
    q25: qubit,
    random_choice: bool,
    shot_choice: bool,
) -> None:
    # Exercise Guppy's dagger modifier on an array element.
    with dagger():
        quantum_rz(q2, pi / 2)
        x(q2)

    # Quantinuum-only runtime values choose additional reversible work. Both
    # choices are undone after the barrier, so they cannot affect the result.
    if random_choice:
        rz(q1, pi / 2)
        rz(q7, pi / 2)
        rz(q13, pi / 2)
        rz(q19, pi / 2)
        rz(q25, pi / 2)
    if shot_choice:
        x(q4)
        x(q21)


@guppy
@no_type_check
def runtime_reverse(  # noqa: PLR0913, PLR0917
    q1: qubit,
    q2: qubit,
    q4: qubit,
    q7: qubit,
    q13: qubit,
    q19: qubit,
    q21: qubit,
    q25: qubit,
    random_choice: bool,
    shot_choice: bool,
) -> None:
    if shot_choice:
        x(q21)
        x(q4)
    if random_choice:
        rz(q25, -pi / 2)
        rz(q19, -pi / 2)
        rz(q13, -pi / 2)
        rz(q7, -pi / 2)
        rz(q1, -pi / 2)

    # Invert the daggered block.
    quantum_rz(q2, pi / 2)
    x(q2)


@guppy
@no_type_check
def controlled_x(ctl: qubit, target: qubit) -> None:
    with control(ctl):
        x(target)


@guppy
@no_type_check
def mirror_barrier(  # noqa: PLR0913, PLR0917
    q0: qubit,
    q1: qubit,
    q2: qubit,
    q3: qubit,
    q4: qubit,
    q5: qubit,
    q6: qubit,
    q7: qubit,
    q8: qubit,
    q9: qubit,
    q10: qubit,
    q11: qubit,
    q12: qubit,
    q13: qubit,
    q14: qubit,
    q15: qubit,
    q16: qubit,
    q17: qubit,
    q18: qubit,
    q19: qubit,
    q20: qubit,
    q21: qubit,
    q22: qubit,
    q23: qubit,
    q24: qubit,
    q25: qubit,
    q26: qubit,
    q27: qubit,
    q28: qubit,
    q29: qubit,
) -> None:
    barrier(
        q0,
        q1,
        q2,
        q3,
        q4,
        q5,
        q6,
        q7,
        q8,
        q9,
        q10,
        q11,
        q12,
        q13,
        q14,
        q15,
        q16,
        q17,
        q18,
        q19,
        q20,
        q21,
        q22,
        q23,
        q24,
        q25,
        q26,
        q27,
        q28,
        q29,
    )


@guppy
@no_type_check
def record_result(qbs: array[qubit, N_QUBITS] @ owned) -> None:
    # Exercise array barriers and deferred array measurement.
    barrier(qbs)
    output("mirror", collect_measurements(measure_array(qbs)))


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = [qubit() for _ in range(N_QUBITS)]

    rng = RNG(2026)
    random_choice = rng.random_int_bounded(2) == 1
    rng.discard()
    shot_choice = get_current_shot() % 2 == 1

    forward_mirror(qbs)
    runtime_forward(
        qbs[1],
        qbs[2],
        qbs[4],
        qbs[7],
        qbs[13],
        qbs[19],
        qbs[21],
        qbs[25],
        random_choice,
        shot_choice,
    )
    controlled_x(qbs[0], qbs[29])
    mirror_barrier(
        qbs[0],
        qbs[1],
        qbs[2],
        qbs[3],
        qbs[4],
        qbs[5],
        qbs[6],
        qbs[7],
        qbs[8],
        qbs[9],
        qbs[10],
        qbs[11],
        qbs[12],
        qbs[13],
        qbs[14],
        qbs[15],
        qbs[16],
        qbs[17],
        qbs[18],
        qbs[19],
        qbs[20],
        qbs[21],
        qbs[22],
        qbs[23],
        qbs[24],
        qbs[25],
        qbs[26],
        qbs[27],
        qbs[28],
        qbs[29],
    )
    controlled_x(qbs[0], qbs[29])
    runtime_reverse(
        qbs[1],
        qbs[2],
        qbs[4],
        qbs[7],
        qbs[13],
        qbs[19],
        qbs[21],
        qbs[25],
        random_choice,
        shot_choice,
    )
    reverse_mirror(qbs)

    record_result(qbs)


# Expected output for every shot: {"mirror": 0} (all 30 measured bits are zero).
