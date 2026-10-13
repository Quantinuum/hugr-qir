"""Estimate P(good)=1/4 from eight independent preparations in each shot."""

from math import comb

from guppyalgos.algorithms.amplitude_amplification.qae import prepare_and_measure
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import h, qubit, toffoli

COMPONENT = "Repeated prepare-and-measure amplitude estimation"
QUBIT_BUDGET = 3
# A count k is recorded as k low set bits.
EXPECTED = {
    "success_thermometer": {
        (1 << k) - 1: comb(8, k) * 0.25**k * 0.75 ** (8 - k) for k in range(9)
    }
}


@guppy
def prepare(register: array[qubit, 2], flag: qubit) -> None:
    h(register[0])
    h(register[1])
    toffoli(register[0], register[1], flag)


@guppy
def main() -> None:
    frequency = prepare_and_measure(prepare, 8)
    output(
        "success_thermometer",
        array(
            frequency >= 0.125,
            frequency >= 0.25,
            frequency >= 0.375,
            frequency >= 0.5,
            frequency >= 0.625,
            frequency >= 0.75,
            frequency >= 0.875,
            frequency >= 1.0,
        ),
    )
