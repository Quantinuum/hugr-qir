"""Create a three-qubit correlated state with exp(-i*pi*X0*Y1*Z2/4)."""

import zixy.qubit.pauli as zqp
from guppyalgos.primitives.pauli.pauli_exp import pauli_exp
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, measure_array

COMPONENT = "Pauli exponential gadget"
QUBIT_BUDGET = 3
EXPECTED = {"correlated": {0: 0.5, 3: 0.5}}
evolve = pauli_exp(zqp.String.from_str("X0 Y1 Z2", 3), 3)


@guppy
def main() -> None:
    state = qarray(3)
    evolve(state, angle(0.5))
    output("correlated", collect_measurements(measure_array(state)))
