"""Add nine to a coherent four-bit integer, retaining the overflow bit."""

from guppyalgos.primitives.arithmetic import adder_ripple_cuccaro_carry_out
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import (
    collect_measurements,
    h,
    measure,
    measure_array,
    qubit,
    x,
)

COMPONENT = "Cuccaro ripple-carry addition"
QUBIT_BUDGET = 10  # Two four-bit registers, carry-out, internal carry ancilla.
EXPECTED = {"addend": dict.fromkeys(range(16), 1 / 16)}


@guppy
def main() -> None:
    addend = qarray(4)
    total = qarray(4)
    carry = qubit()
    for i in range(4):
        h(addend[i])
    x(total[0])
    x(total[3])
    adder_ripple_cuccaro_carry_out(addend, total, carry)
    output("addend", collect_measurements(measure_array(addend)))
    output("sum", collect_measurements(measure_array(total)))
    output("carry", measure(carry).read())


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    value = bits_to_int(shot["addend"]) + 9
    require_equal(bits_to_int(shot["sum"]), value % 16)
    require_equal(bool(shot["carry"]), (value >= 16))
