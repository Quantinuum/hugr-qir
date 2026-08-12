from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.random import RNG
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()
    h(q1)
    h(q1)
    r = RNG(11)
    if r.random_int() == 5:
        h(q1)
    r.discard()
    output("0", measure(q0).read())
    output("1", measure(q1).read())
