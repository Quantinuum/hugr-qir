"""Controlled order-2 Trotter step on one state qubit, checked against its finite
product formula."""

import zixy.qubit.pauli as zqp
from guppyalgos.algorithms.time_evolution.trotter import (
    cntrl_trotter_higher_order,
    suzuki_sequence,
)
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, h, measure_array, qubit

COMPONENT = "Controlled order-2 Trotter step"
QUBIT_BUDGET = 2
TIME_STEP = 0.3
HAMILTONIAN = zqp.RealTermSum.from_str("(0.7, Z0), (0.4, X0), (0.2, I0)", 1)
TERMS = list(HAMILTONIAN.to_terms())

SEQUENCE = suzuki_sequence(len(TERMS), 2)
step = cntrl_trotter_higher_order(HAMILTONIAN, 1, 2)


def expected_probabilities() -> dict:
    from _references import trotter_probabilities  # noqa: PLC0415

    return {
        "joint": trotter_probabilities(TERMS, SEQUENCE, TIME_STEP, controlled_step=True)
    }


@guppy
def main() -> None:
    state = qarray(1)
    control = qubit()
    h(control)
    step(control, state, TIME_STEP)
    h(control)
    joint = array(control, state.take(0))
    state.discard_all_taken()
    output("joint", collect_measurements(measure_array(joint)))
