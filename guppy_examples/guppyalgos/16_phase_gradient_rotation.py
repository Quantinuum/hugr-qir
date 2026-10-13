"""Kick back a binary angle from a phase-gradient resource onto a target qubit."""

from math import pi, sin

from guppyalgos.primitives.rotations import RotationAxisY, RotationPhaseGradient
from guppyalgos.primitives.state_preparation import Convention, phase_gradient
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import discard_array, measure, qubit, x

COMPONENT = "Phase-gradient rotation using controlled Gidney addition"
QUBIT_BUDGET = 13  # Two four-bit registers, target, controlled-adder workspace.
prepare_resource = phase_gradient(4, convention=Convention.Standard)
# Binary angle 3/16 turns gives Ry(3*pi/8), P(1)=sin(3*pi/16)^2.
P_ONE = sin(3 * pi / 16) ** 2
EXPECTED = {"rotated": {0: 1 - P_ONE, 1: P_ONE}}


@guppy
def main() -> None:
    binary_angle = qarray(4)
    resource = qarray(4)
    target = qubit()
    x(binary_angle[0])
    x(binary_angle[1])
    prepare_resource(resource)
    rotator = RotationPhaseGradient(resource, RotationAxisY())
    rotator.compose(binary_angle, target)
    output("rotated", measure(target).read())
    discard_array(binary_angle)
    discard_array(rotator.phase_gradient)
