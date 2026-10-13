"""Unload an independently initialized SELECTSWAP bank."""

from guppyalgos.algorithms.select.selectswap import selectswap
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    measure_array,
    toffoli,
    x,
)

WORDS = [0, 1, 2, 3, 3, 2, 1, 0]
COMPONENT = "SELECTSWAP inverse with two payload banks"
QUBIT_BUDGET = 8
EXPECTED = {"row": {1: 1.0}, "column": {1: 1.0}, "bank0": {0: 1.0}, "bank1": {0: 1.0}}
lookup = selectswap(
    [int_to_bits(word, 2) for word in WORDS],
    2,
    comp_and_op=toffoli,
    uncomp_and_op=toffoli,
    uncompute=True,
)


@guppy
def main() -> None:
    row, column = qarray(2), qarray(1)
    banks = array(qarray(2), qarray(2))
    x(row[0])
    x(column[0])
    # Row 1, column 1 means the forward bank would contain [3, 2].
    x(banks[0][0])
    x(banks[0][1])
    x(banks[1][1])
    lookup(row, column, banks)
    bank0, bank1 = banks
    output("bank0", collect_measurements(measure_array(bank0)))
    output("bank1", collect_measurements(measure_array(bank1)))
    output("row", collect_measurements(measure_array(row)))
    output("column", collect_measurements(measure_array(column)))
