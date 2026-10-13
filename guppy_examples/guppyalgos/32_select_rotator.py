"""Isolate SelectRotator using a two-gate QROM and a self-inverse rotator."""

from guppyalgos.algorithms.select import SelectRotator
from guppyalgos.primitives.rotations import QROMRotations
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, cx, cz, h, measure_array, qubit

COMPONENT = "SelectRotator wrapper with elementary compute/rotate/uncompute"
QUBIT_BUDGET = 4
EXPECTED = {"address": {0: 0.5, 1: 0.5}, "data": {0: 1.0}, "joint": {0: 0.5, 3: 0.5}}


@guppy
def load(index: array[qubit, 1], data: array[qubit, 1]) -> None:
    cx(index[0], data[0])


@guppy.struct
class BitFlipRotator:
    @guppy
    def compose(self, data: array[qubit, 1], target: qubit) -> None:
        cx(data[0], target)

    @guppy
    def daggered(self, data: array[qubit, 1], target: qubit) -> None:
        cx(data[0], target)


@guppy
def pauli_action(control: qubit, target: qubit) -> None:
    cz(control, target)


@guppy
def main() -> None:
    address, data = qarray(1), qarray(1)
    control, target = qubit(), qubit()
    h(address[0])
    h(control)
    h(target)
    operation = SelectRotator(QROMRotations(load, BitFlipRotator(), load), pauli_action)
    operation.compose(address, data, control, target)
    # Conjugating Z by X gives an address-dependent control phase.
    h(address[0])
    h(target)
    output("address", collect_measurements(measure_array(address)))
    output("data", collect_measurements(measure_array(data)))
    output("joint", collect_measurements(measure_array(array(control, target))))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bits_to_int(shot["address"]), bits_to_int(shot["joint"]) & 1)
