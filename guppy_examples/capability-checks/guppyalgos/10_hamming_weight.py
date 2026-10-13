"""Compute the population count of six superposed bits and preserve a reference."""

from math import comb

from guppyalgos.primitives.arithmetic.hamming_weight import hamming_weight_func
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    discard_array,
    h,
    measure_array,
)

COMPONENT = "Tree-based Hamming weight"
QUBIT_BUDGET = 18  # Six input bits, six reference bits, six internal ancillas.
EXPECTED = {"weight": {i: comb(6, i) / 64 for i in range(7)}}
population_count = hamming_weight_func(6)


@guppy
def main() -> None:
    data = qarray(6)
    reference = qarray(6)
    for i in range(6):
        h(data[i])
        cx(data[i], reference[i])
    weight, workspace = population_count(data)
    data.discard_all_taken()
    output("reference", collect_measurements(measure_array(reference)))
    output("weight", collect_measurements(measure_array(weight)))
    discard_array(workspace)


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bits_to_int(shot["weight"]), sum(shot["reference"]))
