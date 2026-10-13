"""Apply one of four two-qubit Pauli strings selected coherently by an address."""

import zixy.qubit.pauli as zqp
from guppyalgos.algorithms.select.pauli_select import pauli_select_unary_iteration
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array

COMPONENT = "Unary-iteration Pauli SELECT"
QUBIT_BUDGET = 5  # Two address bits, two system bits, one temporary AND.
EXPECTED = {"address": dict.fromkeys(range(4), 0.25)}
select = pauli_select_unary_iteration(
    zqp.Strings.from_str("Z0 Z1, X0 Y1, Y0 Z1, Z0 X1", 2), 2
)


@guppy
def main() -> None:
    address = qarray(2)
    state = qarray(2)
    h(address[0])
    h(address[1])
    select(address, state)
    output("address", collect_measurements(measure_array(address)))
    output("state", collect_measurements(measure_array(state)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(
        bits_to_int(shot["state"]), [0, 3, 1, 2][bits_to_int(shot["address"])]
    )
