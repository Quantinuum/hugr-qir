"""Observe all phases of a two-qubit Walsh-synthesized diagonal through interference."""

import numpy as np
from guppyalgos.algorithms.state_preparation.diagonal import diagonal_unitary_walsh
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "Walsh diagonal synthesis with X-basis interference"
QUBIT_BUDGET = 2
DIAGONAL = np.exp(1j * np.array([0.1, 0.5, -0.3, 0.9]))
apply_diagonal = diagonal_unitary_walsh(DIAGONAL, truncation_threshold=0.0)


def expected_probabilities() -> dict:
    transform = (
        np.array([[(-1) ** ((i & j).bit_count()) for j in range(4)] for i in range(4)])
        / 2
    )
    return {"interference": dict(enumerate(abs(transform @ (DIAGONAL / 2)) ** 2))}


@guppy
def main() -> None:
    target = qarray(2)
    h(target[0])
    h(target[1])
    apply_diagonal(target)
    h(target[0])
    h(target[1])
    output("interference", collect_measurements(measure_array(target)))
