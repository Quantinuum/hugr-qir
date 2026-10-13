"""order-4 Trotter step on one state qubit, checked against its finite product
formula."""

import zixy.qubit.pauli as zqp
from guppyalgos.algorithms.time_evolution.trotter import (
    suzuki_sequence,
    trotter_higher_order,
)
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "order-4 Trotter step"
QUBIT_BUDGET = 1
TIME_STEP = 0.3
HAMILTONIAN = zqp.RealTermSum.from_str("(0.7, Z0), (0.4, X0)", 1)
TERMS = list(HAMILTONIAN.to_terms())

SEQUENCE = suzuki_sequence(len(TERMS), 4)
step = trotter_higher_order(HAMILTONIAN, 1, 4)


def expected_probabilities() -> dict:
    from _references import trotter_probabilities  # noqa: PLC0415

    return {
        "joint": trotter_probabilities(
            TERMS, SEQUENCE, TIME_STEP, controlled_step=False
        )
    }


@guppy
def main() -> None:
    state = qarray(1)
    step(state, TIME_STEP)
    h(state[0])
    output("joint", collect_measurements(measure_array(state)))
