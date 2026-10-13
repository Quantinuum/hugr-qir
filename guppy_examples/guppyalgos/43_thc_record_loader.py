"""Load decoded THC fields from four independent records using the public loader."""

from guppyalgos.algorithms.block_encoding.thc import (
    SelectTHCCntrlRegs,
    load_select_registers,
)
from guppyalgos.algorithms.select.qrom import qrom_unary_iteration
from guppyalgos.utils import int_to_bits, qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    h,
    measure_array,
    qubit,
    toffoli,
)

COMPONENT = "THC record-loader wrapper with a six-bit record QROM"
QUBIT_BUDGET = 10
WORDS = [0, 17, 38, 63]
EXPECTED = {"address": dict.fromkeys(range(4), 0.25)}
loader = qrom_unary_iteration(
    [int_to_bits(word, 6) for word in WORDS], comp_and_op=toffoli, uncomp_and_op=toffoli
)


@guppy
def main() -> None:
    address = qarray(2)
    h(address[0])
    h(address[1])
    registers = SelectTHCCntrlRegs(qubit(), qubit(), qarray(2), qarray(2))
    load_select_registers[2, 2](loader, address, registers)
    output("address", collect_measurements(measure_array(address)))
    output("mu", collect_measurements(measure_array(registers.first_index_qreg)))
    output("nu", collect_measurements(measure_array(registers.second_index_qreg)))
    output(
        "flags",
        collect_measurements(
            measure_array(array(registers.one_body_flag, registers.coefficient_sign))
        ),
    )


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    word = (
        bits_to_int(shot["mu"])
        + (bits_to_int(shot["nu"]) << 2)
        + (bits_to_int(shot["flags"]) << 4)
    )
    require_equal(word, WORDS[bits_to_int(shot["address"])])
