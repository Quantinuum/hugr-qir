from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import comptime, result
from guppylang.std.qsystem import measure_and_reset
from guppylang.std.quantum import discard, h, qubit, s, toffoli

N = 10


@guppy
@no_type_check
def branch(a: bool, b: bool, i: int) -> bool:
    if not (a | b):
        result("attempts", i)
        return True
    return False


@no_type_check
def repeat_until_success(q: qubit, attempts: int @ comptime) -> bool:
    # This differs from rus-flat-unbounded.py in three ways:
    # 1. The retry budget is finite (`attempts`) rather than unbounded.
    # 2. The loop bound is comptime-known so hugr-qir sees static control flow.
    # 3. Ancillas are allocated once and reused with measure_and_reset, so the
    #    lowered QIR only needs 3 qubits.
    ok = False
    a = qubit()
    b = qubit()
    for i in range(attempts):
        h(a)
        h(b)
        toffoli(a, b, q)
        s(q)
        toffoli(a, b, q)
        h(a)
        h(b)
        ok = branch(measure_and_reset(a), measure_and_reset(b), i)
    discard(a)
    discard(b)
    return ok


@guppy.comptime
@no_type_check
def main() -> None:
    q = qubit()
    success = repeat_until_success(q, comptime(N))
    result("success", success)
    discard(q)
