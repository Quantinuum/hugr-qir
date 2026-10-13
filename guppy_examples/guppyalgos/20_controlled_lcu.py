"""Controlled LCU with Ramsey interference; the encoded block is (Z-X)/2."""

from guppyalgos.algorithms.block_encoding.lcu import LCUCntrl
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import (
    collect_measurements,
    cz,
    h,
    measure_array,
    qubit,
    toffoli,
    x,
)

COMPONENT = "Controlled LCU with Ramsey interference"
QUBIT_BUDGET = 3


def expected_probabilities() -> dict:
    from _references import block_probabilities  # noqa: PLC0415

    return {"joint": block_probabilities("controlled_lcu")}


@guppy
def prepare(prep: array[qubit, 1]) -> None:
    h(prep[0])


@guppy
def controlled_select(
    control: qubit, prep: array[qubit, 1], target: array[qubit, 1]
) -> None:
    x(prep[0])
    h(target[0])
    toffoli(control, prep[0], target[0])
    h(target[0])
    x(prep[0])
    toffoli(control, prep[0], target[0])
    cz(control, prep[0])


@guppy
def main() -> None:
    prep = qarray(1)
    target = qarray(1)
    control = qubit()
    h(control)
    LCUCntrl(prepare, controlled_select, prepare).compose(control, prep, target)
    h(control)
    # Measure PREPARE as well: its zero projection selects the encoded block.
    joint = array(control, prep.take(0), target.take(0))
    prep.discard_all_taken()
    target.discard_all_taken()
    output("joint", collect_measurements(measure_array(joint)))
