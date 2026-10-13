"""XOR-load a four-word table with the address and external control in superposition."""

from guppyalgos.algorithms.select.qrom.controlled_qrom_unary_iteration import (
    cntrl_qrom_unary_iteration,
)
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, h, measure_array, qubit, toffoli

COMPONENT = "Controlled QROM with a flat two-bit payload"
QUBIT_BUDGET = 7
WORDS = [1, 2, 3, 0]
EXPECTED = {"control": {0: 0.5, 1: 0.5}, "address": dict.fromkeys(range(4), 0.25)}
lookup = cntrl_qrom_unary_iteration(
    [int_to_bits(word, 2) for word in WORDS], comp_and_op=toffoli, uncomp_and_op=toffoli
)


@guppy
def main() -> None:
    control = qubit()
    address, payload = qarray(2), qarray(2)
    h(control)
    h(address[0])
    h(address[1])
    lookup(control, address, payload)
    output("control", collect_measurements(measure_array(array(control))))
    output("address", collect_measurements(measure_array(address)))
    output("payload", collect_measurements(measure_array(payload)))


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(
        bits_to_int(shot["payload"]),
        WORDS[bits_to_int(shot["address"])] if bits_to_int(shot["control"]) else 0,
    )
