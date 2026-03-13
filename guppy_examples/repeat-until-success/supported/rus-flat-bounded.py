from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import comptime, result
from guppylang.std.qsystem import measure_and_reset
from guppylang.std.quantum import discard, h, qubit, s, toffoli, z

N = 10


@guppy
@no_type_check
def branch(
    q: qubit,
    success: bool,
    retry: bool,
    i: int,
    attempts: int,
) -> tuple[bool, int]:
    # Unlike the unbounded version, the retry loop itself is fixed at comptime.
    # This helper keeps the measurement-dependent branch in regular Guppy code.
    if success:
        return True, attempts
    if not retry:
        return True, i
    z(q)
    return False, attempts


@no_type_check
def repeat_until_success(q: qubit, max_attempts: int @ comptime) -> tuple[bool, int]:
    # This differs from rus-flat-unbounded.py in three ways:
    # 1. The retry budget is finite (`max_attempts`) rather than unbounded.
    # 2. The loop bound is comptime-known, so hugr-qir sees static control flow.
    # 3. Ancillas are allocated once and reused with measure_and_reset, so the
    #    lowered QIR only needs 3 qubits.
    success = False
    attempts = max_attempts
    a = qubit()
    b = qubit()
    for i in range(max_attempts):
        h(a)
        h(b)
        toffoli(a, b, q)
        s(q)
        toffoli(a, b, q)
        h(a)
        h(b)
        c0 = measure_and_reset(a)
        c1 = measure_and_reset(b)
        success, attempts = branch(
            q,
            success,
            c0 | c1,
            i,
            attempts,
        )
    discard(a)
    discard(b)
    return success, attempts


@guppy.comptime
@no_type_check
def main() -> None:
    # The unbounded version retries with `while True`. Here the bound is fixed
    # at compile time and the final outputs are emitted once after the loop.
    # The recorded `attempts` value is the zero-based success index, i.e. the
    # number of failed attempts before success, or `N` if all attempts fail.
    q = qubit()
    success, attempts = repeat_until_success(q, comptime(N))
    result("attempts", attempts)
    result("success", success)
    discard(q)
