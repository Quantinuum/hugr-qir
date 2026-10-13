"""Load complex amplitudes and reveal their phases with Hadamard interference."""

import numpy as np
from guppyalgos.algorithms.state_preparation import multiplexor_prep
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "Multiplexor state preparation"
QUBIT_BUDGET = 3
AMPLITUDES = np.array([1, 1j, -2, 2j, 1 - 1j, 0, 1, -1j], dtype=complex)
AMPLITUDES /= np.linalg.norm(AMPLITUDES)
prepare = multiplexor_prep(AMPLITUDES)

# The Walsh transform gives the independent distribution after H on each qubit.
WALSH = np.array([[(-1) ** ((i & j).bit_count()) for j in range(8)] for i in range(8)])
PROBABILITIES = abs(WALSH @ AMPLITUDES / np.sqrt(8)) ** 2
EXPECTED = {"interference": dict(enumerate(PROBABILITIES.tolist()))}


@guppy
def main() -> None:
    state = qarray(3)
    prepare(state)
    for i in range(3):
        h(state[i])
    output("interference", collect_measurements(measure_array(state)))
