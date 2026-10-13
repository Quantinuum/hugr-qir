"""Prepare a Steane zero state and postselect on a fault-detection flag."""

from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.builtins import exit as end_shot
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    h,
    measure,
    measure_array,
    qubit,
)

COMPONENT = "Steane preparation with postselection exit"
QUBIT_BUDGET = 8
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/postselect.html"
EXPECTED = {"parity": {0: 1.0}}


@guppy.struct
class SteaneQubit:
    data_qs: array[qubit, 7]


@guppy
def non_ft_zero() -> SteaneQubit:
    data = array(qubit() for _ in range(7))
    for index in array(0, 4, 6):
        h(data[index])
    for control, target in array(
        (0, 1), (4, 5), (6, 3), (6, 5), (4, 2), (0, 3), (4, 1), (3, 2)
    ):
        cx(data[control], data[target])
    return SteaneQubit(data)


@guppy
def ft_zero() -> SteaneQubit:
    state = non_ft_zero()
    flag = qubit()
    for index in array(1, 3, 5):
        cx(state.data_qs[index], flag)
    if measure(flag).read():
        end_shot("Postselected: FT prep failed", 1)
    return state


@guppy
def main() -> None:
    state = ft_zero()
    bits = collect_measurements(measure_array(state.data_qs))
    parity = False
    for bit in bits:
        parity ^= bit
    output("parity", parity)
