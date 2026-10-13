"""Look up an eight-row, three-bit table on a superposition of addresses."""

from guppyalgos.algorithms.select.qrom import qrom_unary_iteration
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "Unary-iteration QROM lookup"
QUBIT_BUDGET = 8  # Three address bits, three word bits, two unary-iteration ancillas.
TABLE = [6, 1, 4, 7, 0, 3, 5, 2]
EXPECTED = {"address": dict.fromkeys(range(8), 1 / 8)}
lookup = qrom_unary_iteration([int_to_bits(word, 3) for word in TABLE])


@guppy
def main() -> None:
    address = qarray(3)
    word = qarray(3)
    for i in range(3):
        h(address[i])
    lookup(address, word)
    output("address", collect_measurements(measure_array(address)))
    output("word", collect_measurements(measure_array(word)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bits_to_int(shot["word"]), TABLE[bits_to_int(shot["address"])])
