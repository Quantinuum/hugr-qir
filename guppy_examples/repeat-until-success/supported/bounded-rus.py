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
    if measure(h(a)):
        discard(b)
        return False
    t(q)
    z(q)
    cx(q, b)
    t(b)
    if measure(h(b)):
        z(q)
        return False
    return True


@guppy
@no_type_check
def rus_step(q: qubit, ok: bool, n: int) -> tuple[bool, int]:
    # The dynamic stop-or-retry decision lives in a regular Guppy function
    # because the outer retry structure below is expanded at comptime.
    if ok:
        return True, n
    return rus_attempt(q), n + 1


@guppy.comptime
@no_type_check
def main() -> None:
    # This version differs from an unbounded retry loop in three ways:
    # 1. The retry budget is finite (N attempts) rather than unbounded.
    # 2. The loop is unrolled at comptime so hugr-qir sees static control flow.
    # 3. Results expose both whether we succeeded and how many tries were used.
    # This two-stage retry body also materializes fresh ancillas per attempt in
    # QIR, unlike rus-flat-bounded.py which reuses 3 qubits.
    q = qubit()
    q = h(q)
    n = 0
    ok = False
    for _ in range(N):
        ok, n = rus_step(q, ok, n)
    result("attempts", n)
    result("success", ok)
    result("q", measure(q))
