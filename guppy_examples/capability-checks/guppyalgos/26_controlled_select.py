"""Choose one of four simple callbacks under a coherent external control."""

from guppyalgos.algorithms.select.select_unary_iteration import (
    cntrl_select_unary_iteration,
)
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

COMPONENT = "Controlled unary SELECT with plain gate callbacks"
QUBIT_BUDGET = 7
EXPECTED = {"control": {0: 0.5, 1: 0.5}, "address": dict.fromkeys(range(4), 0.25)}


@guppy
def nothing(control: qubit, target: array[qubit, 2]) -> None:
    pass


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
def operations() -> array[Function[[qubit, array[qubit, 2]], None], 4]:
    return [nothing, first, second, both]


@guppy
def main() -> None:
    control = qubit()
    address = qarray(2)
    target = qarray(2)
    h(control)
    h(address[0])
    h(address[1])
    # Toffoli is self-inverse; it avoids a separate measurement-based AND dependency.
    cntrl_select_unary_iteration(
        operations(), toffoli, toffoli, control, address, target
    )
    output("control", collect_measurements(measure_array(array(control))))
    output("address", collect_measurements(measure_array(address)))
    output("target", collect_measurements(measure_array(target)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(
        bits_to_int(shot["target"]),
        bits_to_int(shot["address"]) if bits_to_int(shot["control"]) else 0,
    )
