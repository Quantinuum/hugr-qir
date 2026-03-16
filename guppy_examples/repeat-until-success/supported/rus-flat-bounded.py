from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import comptime, result
from guppylang.std.qsystem import measure_and_reset
from guppylang.std.quantum import discard, h, qubit, s, toffoli, z

N = 10


@no_type_check
def repeat_until_success(q: qubit, attempts: int @ comptime) -> tuple[bool, int]:
    # This differs from rus-flat-unbounded.py in three ways:
    # 1. The retry budget is finite (`attempts`) rather than unbounded.
    # 2. The loop bound is comptime-known so hugr-qir sees static control flow.
    # 3. Ancillas are allocated once and reused with measure_and_reset, so the
    #    lowered QIR only needs 3 qubits.
    ok = False
    n = 0
    a = qubit()
    b = qubit()
    for _ in range(attempts):
        ok, n = rus_step(q, a, b, ok, n)
    discard(a)
    discard(b)
    return ok, n


@guppy
@no_type_check
def rus_attempt(q: qubit, a: qubit, b: qubit) -> bool:
    h(a)
    h(b)
    toffoli(a, b, q)
    s(q)
    toffoli(a, b, q)
    h(a)
    h(b)
    c0 = measure_and_reset(a)
    c1 = measure_and_reset(b)
    if not (c0 | c1):
        return True
    z(q)
    return False


@guppy
@no_type_check
def rus_step(q: qubit, a: qubit, b: qubit, ok: bool, n: int) -> tuple[bool, int]:
    # The dynamic stop-or-retry decision lives in a regular Guppy function
    # because the outer retry structure below is expanded at comptime.
    if ok:
        return True, n
    return rus_attempt(q, a, b), n + 1


@guppy.comptime
@no_type_check
def main() -> None:
    q = qubit()
    success, n = repeat_until_success(q, comptime(N))
    result("success", success)
    result("attempts", n)
    discard(q)
