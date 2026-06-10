from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.platform import barrier
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def main() -> None:
    q0, q1 = qubit(), qubit()
    h(q0)
    barrier(q0)
    h(q0)
    a = measure(q0)
    b = False
    if a:
        h(q1)
        b = measure(q1)
        if b:
            b = False
    else:
        b = measure(q1)
    result("a", a)
    result("b", b)
