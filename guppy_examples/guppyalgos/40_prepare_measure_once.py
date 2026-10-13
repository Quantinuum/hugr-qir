"""One amplitude-estimation sample flags the |11> state with probability 1/4."""

from guppyalgos.algorithms.amplitude_amplification.qae import prepare_and_measure_once
from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import h, qubit, toffoli

COMPONENT = "Prepare-and-measure amplitude sample"
QUBIT_BUDGET = 3
EXPECTED = {"good": {0: 0.75, 1: 0.25}}


@guppy
def prepare(register: array[qubit, 2], flag: qubit) -> None:
    h(register[0])
    h(register[1])
    toffoli(register[0], register[1], flag)


@guppy
def main() -> None:
    output("good", prepare_and_measure_once(prepare))
