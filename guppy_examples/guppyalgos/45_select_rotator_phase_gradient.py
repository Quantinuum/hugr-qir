"""Apply an indexed U-dagger Z U using the library's phase-gradient Y rotator."""

from guppyalgos.algorithms.select import SelectRotator
from guppyalgos.primitives.rotations import (
    QROMRotations,
    RotationAxisY,
    RotationPhaseGradient,
)
from guppyalgos.primitives.state_preparation import Convention, phase_gradient
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    cz,
    discard_array,
    h,
    measure_array,
    qubit,
)

COMPONENT = "SelectRotator with a phase-gradient Y rotation and elementary XOR loader"
QUBIT_BUDGET = 13
EXPECTED = {
    "address": {0: 0.5, 1: 0.5},
    "control": {0: 0.5, 1: 0.5},
    "data": {0: 1.0},
    "target": {0: 0.875, 1: 0.125},
}
prepare_resource = phase_gradient(3, convention=Convention.Standard)


@guppy
def load(address: array[qubit, 1], data: array[qubit, 3]) -> None:
    # Word 1 gives Ry(pi/4); word 0 gives identity.
    cx(address[0], data[0])


@guppy
def pauli_action(control: qubit, target: qubit) -> None:
    cz(control, target)


@guppy
def main() -> None:
    address, data, resource = qarray(1), qarray(3), qarray(3)
    control, target = qubit(), qubit()
    h(address[0])
    h(control)
    prepare_resource(resource)
    operation = SelectRotator(
        QROMRotations(load, RotationPhaseGradient(resource, RotationAxisY()), load),
        pauli_action,
    )
    operation.compose(address, data, control, target)
    discard_array(operation.qrom_rotations.rotation_box.phase_gradient)
    output("address", collect_measurements(measure_array(address)))
    output("data", collect_measurements(measure_array(data)))
    output("control", collect_measurements(measure_array(array(control))))
    output("target", collect_measurements(measure_array(array(target))))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    if not (bits_to_int(shot["control"]) and bits_to_int(shot["address"])):
        require_equal(bits_to_int(shot["target"]), 0)
