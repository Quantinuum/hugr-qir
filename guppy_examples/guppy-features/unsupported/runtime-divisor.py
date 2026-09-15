from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    rng = RNG(11)
    random = rng.random_int()
    rng.discard()
    shot = get_current_shot()

    output("random_divisor", shot // random)
    q = qubit()
    output("q", measure(q).read())
