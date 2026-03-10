from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import cx, discard, measure, t, tdg, z
from guppylang.std.quantum.functional import h


@guppy
@no_type_check
def main() -> None:
    # This matches the original RUS control structure more closely than the
    # supported example: retry until success using a measurement-controlled loop.
    q = qubit()
    q = h(q)

    n = 0
    while True:
        n += 1

        a, b = h(qubit()), h(qubit())
        tdg(a)
        cx(b, a)
        t(a)
        a = h(a)
        if measure(a):
            discard(b)
            continue

        t(q)
        z(q)
        cx(q, b)
        t(b)
        b = h(b)
        if measure(b):
            z(q)
            continue

        result("attempts", n)
        result("success", True)
        result("q", measure(q))
        break
