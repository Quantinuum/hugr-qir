"""Decode the known phase 3/8 with inverse QPE and an inverse power oracle."""

from guppyalgos.algorithms.phase_estimation import iqpe
from guppyalgos.utils import cphase, qarray
from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, h, measure_array, qubit, x

COMPONENT = "Inverse QPE independently initialized with a known phase"
QUBIT_BUDGET = 4
EXPECTED = {"restored": {0: 1.0}, "system": {1: 1.0}}


@guppy
def inverse_oracle(control: qubit, target: qubit, power: int) -> None:
    cphase(control, target, angle(-3.0 * power / 4.0))


@guppy
def main() -> None:
    phase = qarray(3)
    system = qubit()
    x(phase[0])
    x(phase[1])  # Little-endian phase word 3, representing 3/8.
    x(system)
    iqpe(phase, system, inverse_oracle)
    for i in range(3):
        h(phase[i])
    output("restored", collect_measurements(measure_array(phase)))
    output("system", collect_measurements(measure_array(array(system))))
