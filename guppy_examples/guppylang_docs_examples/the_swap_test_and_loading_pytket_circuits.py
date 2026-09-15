from guppylang import guppy
from guppylang.std.quantum import qubit, h, cx, toffoli, measure, discard_array
from guppylang.emulator import EmulatorResult
from guppylang.std.builtins import output, array


from pytket import Circuit
from pytket.circuit import StatePreparationBox
from pytket.passes import DecomposeBoxes

import numpy as np


@guppy
def cswap(control: qubit, q1: qubit, q2: qubit) -> None:
    cx(q1, q2)
    toffoli(control, q2, q1)
    cx(q1, q2)


@guppy
def cswap_layer(ancilla: qubit, arr0: array[qubit, 3], arr1: array[qubit, 3]) -> None:
    for i in range(3):
        cswap(ancilla, arr0[i], arr1[i])


# Define two StatePreparationBox(es) by passing the amplitudes for |S> and |W> as numpy arrays
w_state = 1 / np.sqrt(3) * np.array([0, 1, 1, 0, 1, 0, 0, 0])
s_state = 1 / np.sqrt(7) * np.array([0] + [1] * 7)

w_state_box = StatePreparationBox(w_state)
s_state_box = StatePreparationBox(s_state)


# Build a pytket Circuit with 7 qubits
pytket_circ = Circuit()
ancilla = pytket_circ.add_q_register("a", 1)
w_qubits = pytket_circ.add_q_register("w", 3)
s_qubits = pytket_circ.add_q_register("s", 3)


# Append the state preparation subroutines to the empty circuit
pytket_circ.add_gate(w_state_box, list(w_qubits))
pytket_circ.add_gate(s_state_box, list(s_qubits))

DecomposeBoxes().apply(pytket_circ)


pytket_state_prep = guppy.load_pytket("pytket_state_prep", pytket_circ)


@guppy
def main() -> None:
    w_qubits = array(qubit() for _ in range(3))
    s_qubits = array(qubit() for _ in range(3))
    ancilla_reg = array(qubit())
    # The pytket function only acts on arrays
    pytket_state_prep(ancilla_reg, s_qubits, w_qubits)

    (ancilla,) = ancilla_reg

    h(ancilla)
    cswap_layer(ancilla, w_qubits, s_qubits)
    h(ancilla)

    output("c", measure(ancilla).read())

    # We are only interested in measuring the first qubit
    # Discard all the of |W> and |S> qubits to avoid linearity violation.
    discard_array(w_qubits)
    discard_array(s_qubits)
