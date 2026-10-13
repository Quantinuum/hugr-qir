"""Erase a QROM word by measurement while preserving address coherence."""

from guppyalgos.algorithms.select.qrom import (
    qrom_measure_uncompute,
    qrom_unary_iteration,
)
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "QROM measurement-based uncomputation"
QUBIT_BUDGET = 12  # Includes both unary-iteration workspaces and the correction qubit.
EXPECTED = {"coherence": {0: 1.0}}
WORDS = [int_to_bits(word, 3) for word in [6, 1, 4, 7, 0, 3, 5, 2]]
lookup = qrom_unary_iteration(WORDS)
uncompute = qrom_measure_uncompute(WORDS)


@guppy
def main() -> None:
    address = qarray(3)
    word = qarray(3)
    for i in range(3):
        h(address[i])
    lookup(address, word)
    uncompute(address, word)
    for i in range(3):
        h(address[i])
    output("coherence", collect_measurements(measure_array(address)))
