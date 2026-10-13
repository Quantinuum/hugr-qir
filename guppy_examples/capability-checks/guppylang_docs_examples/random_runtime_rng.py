"""Choose a Pauli per shot and verify that applying it twice is the identity."""

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.platform import barrier
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure, qubit, x, y, z

COMPONENT = "Runtime seeded RNG"
QUBIT_BUDGET = 1
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/random_numbers.html"
EXPECTED = {"c": {0: 1.0}}
SEED = 91919


@guppy
def rand_pauli(q: qubit, choice: int) -> None:
    if choice == 0:
        x(q)
    elif choice == 1:
        y(q)
    else:
        z(q)


@guppy
def main() -> None:
    q = qubit()
    shot = get_current_shot()
    rng = RNG(SEED + shot)
    choice = rng.random_int_bounded(3)
    rng.discard()
    rand_pauli(q, choice)
    barrier(q)
    rand_pauli(q, choice)
    output("shot", shot)
    output("rng", choice)
    output("c", measure(q).read())


def validate_shot(shot: dict) -> None:
    if not 0 <= shot["rng"] < 3:
        message = f"Pauli index out of range: {shot}"
        raise AssertionError(message)
