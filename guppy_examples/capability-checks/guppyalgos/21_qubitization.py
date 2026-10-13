"""Squared qubitization walk; the encoded block is (Z-X)/2."""

from guppyalgos.algorithms.block_encoding.lcu import LCU
from guppyalgos.algorithms.block_encoding.qubitization import Qubitization
from guppyalgos.primitives.gate_decompositions.cnx.cnx import cnx
from guppyalgos.primitives.subroutines.reflection import Reflection
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
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

COMPONENT = "Squared qubitization walk"
QUBIT_BUDGET = 2


def expected_probabilities() -> dict:
    from _references import block_probabilities  # noqa: PLC0415

    return {"joint": block_probabilities("walk")}


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
    Qubitization(LCU(prepare, select, prepare), Reflection[1, 0](cnx[0])).power(
        prep, target, 2
    )
    # Measure PREPARE as well: its zero projection selects the encoded block.
    joint = array(prep.take(0), target.take(0))
    prep.discard_all_taken()
    target.discard_all_taken()
    output("joint", collect_measurements(measure_array(joint)))
