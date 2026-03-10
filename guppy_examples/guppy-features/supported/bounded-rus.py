from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import cx, discard, measure, t, tdg, z
from guppylang.std.quantum.functional import h

N = 10


@guppy
@no_type_check
def rus_attempt(q: qubit) -> bool:
    # Same single-shot RUS body as the original example.
    a, b = h(qubit()), h(qubit())
    tdg(a)
    cx(b, a)
    t(a)
    a = h(a)
    if measure(a):
        discard(b)
        return False
    t(q)
    z(q)
    cx(q, b)
    t(b)
    b = h(b)
    if measure(b):
        z(q)
        return False
    return True


@guppy
@no_type_check
def rus_step(q: qubit, ok: bool, n: int) -> tuple[bool, int]:
    # In the original notebook, this dynamic branch lives directly in a
    # measurement-controlled while loop. Here it is isolated in a regular
    # Guppy function because the retry structure below is expanded at comptime.
    if ok:
        return True, n
    return rus_attempt(q), n + 1


@guppy.comptime
@no_type_check
def main() -> None:
    # This differs from the original RUS example in three ways:
    # 1. The retry budget is finite (N attempts) rather than unbounded.
    # 2. The loop is unrolled at comptime so hugr-qir sees static control flow.
    # 3. Results expose both whether we succeeded and how many tries were used.
    q = qubit()
    q = h(q)
    n = 0
    ok = False
    for _ in range(N):
        ok, n = rus_step(q, ok, n)
    result("attempts", n)
    result("success", ok)
    result("q", measure(q))
