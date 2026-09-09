from typing import no_type_check

from guppylang import array, guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.platform import barrier
from guppylang.std.quantum import discard_array, h, measure


@guppy
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(4))
    h(qbs[0])
    barrier(qbs[0])
    h(qbs[0])
    barrier(qbs)
    q0, q1, *qbs = qbs
    b = False
    a = measure(q0).read()
    if a:
        h(q1)
        b = measure(q1).read()
        if b:
            b = False
    else:
        b = measure(q1).read()

    output("a", a)
    output("b", b)
    discard_array(qbs)
