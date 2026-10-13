"""Load eight words through two payload banks and coherent row/column addresses."""

from guppyalgos.algorithms.select.selectswap import selectswap
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    h,
    measure_array,
    toffoli,
)

WORDS = [0, 1, 2, 3, 3, 2, 1, 0]
COMPONENT = "SELECTSWAP forward with two payload banks"
QUBIT_BUDGET = 8
EXPECTED = {"row": dict.fromkeys(range(4), 0.25), "column": {0: 0.5, 1: 0.5}}
lookup = selectswap(
    [int_to_bits(word, 2) for word in WORDS],
    2,
    comp_and_op=toffoli,
    uncomp_and_op=toffoli,
    uncompute=False,
)


@guppy
def main() -> None:
    row, column = qarray(2), qarray(1)
    banks = array(qarray(2), qarray(2))
    h(row[0])
    h(row[1])
    h(column[0])
    lookup(row, column, banks)
    bank0, bank1 = banks
    output("bank0", collect_measurements(measure_array(bank0)))
    output("bank1", collect_measurements(measure_array(bank1)))
    output("row", collect_measurements(measure_array(row)))
    output("column", collect_measurements(measure_array(column)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    row, column = bits_to_int(shot["row"]), bits_to_int(shot["column"])
    require_equal(bits_to_int(shot["bank0"]), WORDS[2 * row + column])
    require_equal(bits_to_int(shot["bank1"]), WORDS[2 * row + 1 - column])
