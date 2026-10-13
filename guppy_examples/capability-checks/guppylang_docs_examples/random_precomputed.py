"""Choose a Pauli per shot and verify that applying it twice is the identity."""

import random

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.platform import barrier
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import (
    measure,
    qubit,
    x,
    y,
    z,
)

COMPONENT = "Precomputed random table indexed by shot"
QUBIT_BUDGET = 1
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/random_numbers.html"
EXPECTED = {"c": {0: 1.0}}
SEED = 91919
_rng = random.Random(SEED)  # noqa: S311
RANDOM_VALUES = [_rng.randint(0, 2) for _ in range(100)]


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
    choice = RANDOM_VALUES[shot % 100]
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
    from _checks import require_equal  # noqa: PLC0415

    require_equal(shot["rng"], RANDOM_VALUES[shot["shot"] % 100])
