"""Apply a prefix of three callbacks to a two-qubit target."""

from guppyalgos.algorithms.select.accumulator import accumulator_unary_iteration
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import Function, array, output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    h,
    measure_array,
    qubit,
    toffoli,
)

COMPONENT = "accumulator_unary_iteration"
QUBIT_BUDGET = 6
EXPECTED = {"address": {0: 0.5, 1: 0.5}}


@guppy
def first(control: qubit, target: array[qubit, 2]) -> None:
    cx(control, target[0])


@guppy
def second(control: qubit, target: array[qubit, 2]) -> None:
    cx(control, target[1])


@guppy
def both(control: qubit, target: array[qubit, 2]) -> None:
    cx(control, target[0])
    cx(control, target[1])


@guppy.comptime
def operations() -> array[Function[[qubit, array[qubit, 2]], None], 3]:
    return [first, second, both]


@guppy
def main() -> None:
    address, target = qarray(2), qarray(2)
    h(address[0])
    accumulator_unary_iteration(operations(), toffoli, toffoli, address, target)
    output("address", collect_measurements(measure_array(address)))
    output("target", collect_measurements(measure_array(target)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    # The prefix stops before the selected index: 0->0, 1->1, 2->3.
    require_equal(
        bits_to_int(shot["target"]), [0, 1, 3, 0][bits_to_int(shot["address"])]
    )
