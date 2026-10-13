"""Exercise the walk-power adapter at even and odd powers without QPE."""

from guppyalgos.algorithms.phase_estimation.qubitized_phase_estimation import (
    QubitizationRegs,
    qubitized_power_oracle,
)
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, cz, h, measure_array, qubit, z

COMPONENT = "Qubitized power adapter with an elementary controlled walk"
QUBIT_BUDGET = 3
EXPECTED = {
    "even": {0: 0.5, 1: 0.5},
    "odd": {0: 0.5, 3: 0.5},
    "even_prep": {0: 1.0},
    "odd_prep": {0: 1.0},
}


@guppy
def controlled_walk(
    control: qubit, prep: array[qubit, 1], target: array[qubit, 1]
) -> None:
    # W = (-Z on PREPARE) ⊗ Z on target, the walk of a one-term Z encoding.
    z(control)
    cz(control, prep[0])
    cz(control, target[0])


@guppy
def main() -> None:
    even_control = qubit()
    even = QubitizationRegs(qarray(1), qarray(1))
    h(even_control)
    h(even.target[0])
    qubitized_power_oracle(even_control, even, 2, controlled_walk)
    h(even.target[0])
    even_joint = array(even_control, even.target.take(0))
    even.target.discard_all_taken()
    output("even", collect_measurements(measure_array(even_joint)))
    output("even_prep", collect_measurements(measure_array(even.prep)))
    odd_control = qubit()
    odd = QubitizationRegs(qarray(1), qarray(1))
    h(odd_control)
    h(odd.target[0])
    qubitized_power_oracle(odd_control, odd, 3, controlled_walk)
    h(odd.target[0])
    odd_joint = array(odd_control, odd.target.take(0))
    odd.target.discard_all_taken()
    output("odd", collect_measurements(measure_array(odd_joint)))
    output("odd_prep", collect_measurements(measure_array(odd.prep)))
