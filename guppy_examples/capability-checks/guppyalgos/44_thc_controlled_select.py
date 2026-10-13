"""Apply THC SELECT to a decoded two-body record with two-bit Givens angles."""

from guppyalgos.algorithms.block_encoding.thc import (
    SelectTHCCntrl,
    SelectTHCCntrlRegs,
    THCWalkTargetRegs,
)
from guppyalgos.primitives.gate_decompositions.cnx.cnx import cnx
from guppyalgos.primitives.rotations import GivensCascadePhaseGradient
from guppyalgos.primitives.state_preparation import Convention, phase_gradient
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    discard_array,
    measure_array,
    qubit,
    x,
)

COMPONENT = "THC controlled SELECT with decoded fields and a phase-gradient cascade"
QUBIT_BUDGET = 20
DEFAULT_SHOTS = 8
EXPECTED = {"control": {1: 1.0}, "mu": {0: 1.0}, "nu": {1: 1.0}, "flags": {0: 1.0}}


# Elementary XOR loaders keep unary QROM and coefficient preprocessing separate.
@guppy
def combined_qrom(address: array[qubit, 2], data: array[array[qubit, 2], 1]) -> None:
    cx(address[0], data[0][0])
    cx(address[1], data[0][1])


@guppy
def two_body_qrom(address: array[qubit, 1], data: array[array[qubit, 2], 1]) -> None:
    cx(address[0], data[0][1])


prepare_resource = phase_gradient(2, convention=Convention.Standard)


@guppy
def main() -> None:
    # Prepare the record directly; alias preparation and record loading have
    # their own examples.
    registers = SelectTHCCntrlRegs(qubit(), qubit(), qarray(1), qarray(1))
    x(registers.second_index_qreg[0])
    targets = THCWalkTargetRegs(qarray(2), qarray(2))
    x(targets.spin_up[0])
    resource = qarray(2)
    prepare_resource(resource)
    operation = SelectTHCCntrl[1, 2, 2, 1, 2, GivensCascadePhaseGradient[2, 1, 2]](
        combined_qrom,
        two_body_qrom,
        GivensCascadePhaseGradient[2, 1, 2](resource),
        cnx[1],
    )
    control = qubit()
    x(control)
    operation.compose(control, registers, targets)
    # The cascade is the final owner of the preserved resource state.
    discard_array(operation.cascade.phase_gradient)
    output("control", collect_measurements(measure_array(array(control))))
    output("mu", collect_measurements(measure_array(registers.first_index_qreg)))
    output("nu", collect_measurements(measure_array(registers.second_index_qreg)))
    output(
        "flags",
        collect_measurements(
            measure_array(array(registers.one_body_flag, registers.coefficient_sign))
        ),
    )
    output("spin_up", collect_measurements(measure_array(targets.spin_up)))
    output("spin_down", collect_measurements(measure_array(targets.spin_down)))


def validate_shot(shot: dict) -> None:
    from _checks import require_equal  # noqa: PLC0415

    # Check register flow and particle number; no full THC block is constructed.
    require_equal(sum(shot["spin_up"]) + sum(shot["spin_down"]), 1)
