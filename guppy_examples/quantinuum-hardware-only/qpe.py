import sys

import numpy as np
from guppylang import guppy
from guppylang.std.angles import pi
from guppylang.std.builtins import array, mem_swap, result
from guppylang.std.quantum import (
    crz,
    discard,
    h,
    measure,
    qubit,
    x,
)
from pytket import OpType
from pytket.circuit import DiagonalBox, QControlBox
from pytket.passes import AutoRebase

d_box = DiagonalBox(np.array([1, 1, np.exp(1j * np.pi / 4), np.exp(1j * np.pi / 8)]))
controlled_u_op = QControlBox(d_box, 1)
rebase = AutoRebase({OpType.CX, OpType.Rz, OpType.H, OpType.CCX})
circ = controlled_u_op.get_circuit()
rebase.apply(circ)
controlled_u = guppy.load_pytket("controlled_u_circuit", circ, use_arrays=False)


def prepare_trivial_eigenstate() -> list[qubit]:
    q0, q1 = qubit(), qubit()
    x(q0)
    x(q1)
    return [q0, q1]


def inverse_qft(qs: list[qubit]) -> None:
    # Reverse qubit order with swaps
    n = len(qs)
    for k in range(n // 2):
        mem_swap(qs[k], qs[n - k - 1])

    for i in range(n):
        h(qs[n - i - 1])
        for j in range(n - i - 1):
            crz(qs[n - i - 1], qs[n - i - j - 2], -pi / 2 ** (j + 1))


def phase_estimation(measured: list[qubit], state: list[qubit]) -> None:
    for q in measured:
        h(q)
    n = len(measured)
    # Add 2^n - 1 controlled unitaries sequentially
    for n_index in range(n):
        control_index: int = n - n_index - 1
        for _ in range(2**n_index):
            controlled_u(measured[control_index], state[0], state[1])
    inverse_qft(measured)


N = 5


@guppy.comptime
def main() -> None:
    state = prepare_trivial_eigenstate()
    measured = array(qubit() for _ in range(N))
    phase_estimation(measured, state)

    # we don't need these measurements
    # but discard doesn't work with h-series at the moment
    for state_q in state:
        discard(state_q)  # discard_array not supported

    # Create a result from the measured array
    for i in range(len(measured)):
        result(f"c_{i}", measure(measured[i]))  # measure_array not supported


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
