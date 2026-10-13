"""Estimate Re(<00|exp(-i*pi*X0*X1/6)|00>) with a Hadamard test."""

from math import cos, pi

import zixy.qubit.pauli as zqp
from guppyalgos.algorithms.phase_estimation import hadamard_test
from guppyalgos.primitives.pauli.pauli_exp import cntrl_pauli_exp
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import array, output
from guppylang.std.quantum import discard_array, measure, qubit

COMPONENT = "Hadamard test of a controlled Pauli exponential"
QUBIT_BUDGET = 3
EXPECTED = {"overlap": {0: (1 + cos(pi / 6)) / 2, 1: (1 - cos(pi / 6)) / 2}}
evolve = cntrl_pauli_exp(zqp.String.from_str("X0 X1", 2), 2)


@guppy
def oracle(control: qubit, state: array[qubit, 2]) -> None:
    evolve(control, state, angle(1.0 / 3.0))


@guppy
def main() -> None:
    state = qarray(2)
    ancilla = qubit()
    hadamard_test(ancilla, state, oracle)
    output("overlap", measure(ancilla).read())
    discard_array(state)
