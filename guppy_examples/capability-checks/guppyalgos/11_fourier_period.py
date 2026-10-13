"""Fourier-analyze the periodic state (|1>+|5>+|9>+|13>)/2."""

from guppyalgos.primitives.subroutines.qft import iqft
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure_array, x

COMPONENT = "Inverse quantum Fourier transform"
QUBIT_BUDGET = 4
EXPECTED = {"frequency": dict.fromkeys([0, 4, 8, 12], 0.25)}


@guppy
def main() -> None:
    period = qarray(4)
    x(period[0])
    h(period[2])
    h(period[3])
    iqft(period)
    output("frequency", collect_measurements(measure_array(period)))
