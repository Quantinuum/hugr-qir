"""Three-query QSVT with nonzero reflection phases; the encoded block is (Z-X)/2."""

from guppyalgos.algorithms.block_encoding.lcu import LCU
from guppyalgos.algorithms.block_encoding.qsvt import QSVT
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, comptime, output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    cz,
    h,
    measure_array,
    qubit,
    x,
    z,
)

COMPONENT = "Three-query QSVT with nonzero reflection phases"
QUBIT_BUDGET = 3


def expected_probabilities() -> dict:
    from _references import block_probabilities  # noqa: PLC0415

    return {"joint": block_probabilities("qsvt")}


@guppy
def prepare(prep: array[qubit, 1]) -> None:
    h(prep[0])


@guppy
def select(prep: array[qubit, 1], target: array[qubit, 1]) -> None:
    # SELECT = |0><0| ⊗ Z - |1><1| ⊗ X; the minus sign belongs in SELECT.
    x(prep[0])
    cz(prep[0], target[0])
    x(prep[0])
    cx(prep[0], target[0])
    z(prep[0])


@guppy
def main() -> None:
    prep = qarray(1)
    target = qarray(1)
    signal = qubit()
    # L is Hermitian, so the same LCU supplies its inverse. Phases are half-turns.
    QSVT(
        LCU(prepare, select, prepare),
        LCU(prepare, select, prepare),
        comptime([0.125, -0.25, 0.375]),
    ).compose(signal, prep, target)
    # Measure PREPARE as well: its zero projection selects the encoded block.
    joint = array(signal, prep.take(0), target.take(0))
    prep.discard_all_taken()
    target.discard_all_taken()
    output("joint", collect_measurements(measure_array(joint)))
