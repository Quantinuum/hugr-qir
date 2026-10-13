"""Evolve a four-site transverse-field Ising chain with six Trotter steps."""

import numpy as np
import zixy.qubit.pauli as zqp
from guppyalgos.algorithms.time_evolution.trotter import (
    ham_sim_trotter,
    trotter_first_order,
)
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, measure_array, x

COMPONENT = "First-order Trotter Hamiltonian simulation"
QUBIT_BUDGET = 4
HAMILTONIAN = zqp.RealTermSum.from_str(
    "(-0.7, Z0 Z1), (-0.7, Z1 Z2), (-0.7, Z2 Z3), "
    "(-0.4, X0), (-0.4, X1), (-0.4, X2), (-0.4, X3)",
    4,
)
step = trotter_first_order(HAMILTONIAN, 4)
# The step angle is coefficient*step_parameter in half-turns. Physical dt=pi/20.
evolve = ham_sim_trotter(step, n_steps=6, time_step=0.1, n_state_qubits=4)


def expected_probabilities() -> dict:
    """Calculate the same finite-step product formula with dense Pauli matrices."""
    state = np.zeros(16, dtype=complex)
    state[5] = 1  # |q3 q2 q1 q0> = |0101>.
    identity = np.eye(2)
    matrices = {"X": np.array([[0, 1], [1, 0]]), "Z": np.diag([1, -1])}
    terms = list(HAMILTONIAN.to_terms())
    for _ in range(6):
        for term in terms:
            paulis = term.string.get_dict()
            matrix = np.array([[1]])
            for i in range(3, -1, -1):
                matrix = np.kron(
                    matrix, matrices[str(paulis[i])] if i in paulis else identity
                )
            theta = np.pi * float(term.coeff) * 0.1 / 2
            state = np.cos(theta) * state - 1j * np.sin(theta) * matrix @ state
    return {"spins": dict(enumerate((abs(state) ** 2).tolist()))}


@guppy
def main() -> None:
    spins = qarray(4)
    x(spins[0])
    x(spins[2])
    evolve(spins)
    output("spins", collect_measurements(measure_array(spins)))
