"""Add eleven modulo sixteen using temporary ANDs and measured uncomputation."""

from guppyalgos.primitives.arithmetic import adder_ripple_gidney_mod
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array, x

COMPONENT = "Gidney addition with measurement-based cleanup"
QUBIT_BUDGET = 11  # Two four-bit registers and three carry ancillas.
EXPECTED = {"addend": dict.fromkeys(range(16), 1 / 16)}


@guppy
def main() -> None:
    addend = qarray(4)
    total = qarray(4)
    for i in range(4):
        h(addend[i])
    x(total[0])
    x(total[1])
    x(total[3])
    adder_ripple_gidney_mod(addend, total)
    output("addend", collect_measurements(measure_array(addend)))
    output("sum", collect_measurements(measure_array(total)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bits_to_int(shot["sum"]), (bits_to_int(shot["addend"]) + 11) % 16)
