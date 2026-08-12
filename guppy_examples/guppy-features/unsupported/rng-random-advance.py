from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.random import RNG
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    h(q0)
    r = RNG(11)
    r.random_advance(1)
    r.discard()
    output("0", measure(q0).read())
