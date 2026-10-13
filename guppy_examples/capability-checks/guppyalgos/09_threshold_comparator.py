"""Flag addresses below three without changing either comparison register."""

from guppyalgos.primitives.arithmetic.comparator import comparator_ripple_cuccaro
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

COMPONENT = "Reversible less-than comparator"
QUBIT_BUDGET = 10  # Seven public qubits plus comparison and carry workspace.
EXPECTED = {"address": dict.fromkeys(range(8), 1 / 8), "threshold": {3: 1.0}}


@guppy
def main() -> None:
    address = qarray(3)
    threshold = qarray(3)
    flag = qubit()
    for i in range(3):
        h(address[i])
    x(threshold[0])
    x(threshold[1])
    comparator_ripple_cuccaro(address, threshold, flag)
    output("address", collect_measurements(measure_array(address)))
    output("threshold", collect_measurements(measure_array(threshold)))
    output("below_threshold", measure(flag).read())


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bool(shot["below_threshold"]), (bits_to_int(shot["address"]) < 3))
