"""Sample a four-outcome weighted distribution with an alias table."""

import numpy as np
from guppyalgos.algorithms.state_preparation.alias_sampling.alias_prep import (
    alias_samp_prep,
)
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import (
    collect_measurements,
    discard,
    discard_array,
    measure_array,
    qubit,
)

COMPONENT = "Alias sampling state preparation"
QUBIT_BUDGET = 16  # 2+2+3+3+1 public qubits, with unary-iteration/comparator workspace.
PROBABILITIES = np.array([1, 2, 3, 2], dtype=float) / 8
EXPECTED = {"sample": dict(enumerate(PROBABILITIES.tolist()))}
prepare = alias_samp_prep(PROBABILITIES, precision=1 / 8)


@guppy
def main() -> None:
    index = qarray(2)
    alternative = qarray(2)
    keep = qarray(3)
    random_threshold = qarray(3)
    comparison = qubit()
    prepare(index, alternative, keep, random_threshold, comparison, False)
    output("sample", collect_measurements(measure_array(index)))
    # Sampling consumes the state; these registers retain alias-table workspace.
    discard_array(alternative)
    discard_array(keep)
    discard_array(random_threshold)
    discard(comparison)
