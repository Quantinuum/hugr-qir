"""Find the marked three-bit value five using two Grover iterations."""

from math import asin, sin, sqrt

from guppyalgos.primitives.gate_decompositions.cnx.cnx import cnx
from guppyalgos.primitives.subroutines.reflection.reflection_box import reflection_box
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array, x

COMPONENT = "Householder reflection and multi-controlled X"
QUBIT_BUDGET = 3  # Two controls use a Toffoli without extra workspace.
SUCCESS = sin(5 * asin(1 / sqrt(8))) ** 2
EXPECTED = {
    "candidate": {i: SUCCESS if i == 5 else (1 - SUCCESS) / 7 for i in range(8)}
}


@guppy
def main() -> None:
    search = qarray(3)
    for i in range(3):
        h(search[i])
    for _ in range(2):
        # Conjugating the zero-state reflection marks |101> (little endian).
        x(search[0])
        x(search[2])
        reflection_box(search, cnx[2])
        x(search[0])
        x(search[2])
        for i in range(3):
            h(search[i])
        reflection_box(search, cnx[2])
        for i in range(3):
            h(search[i])
    output("candidate", collect_measurements(measure_array(search)))
