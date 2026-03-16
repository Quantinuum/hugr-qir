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
    success = False
    tries = 0
    a = qubit()
    b = qubit()
    for _ in range(attempts):
        success, tries = rus_step(q, a, b, success, tries)
    discard(a)
    discard(b)
    return success, tries


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
def rus_step(
    q: qubit, a: qubit, b: qubit, success: bool, tries: int
) -> tuple[bool, int]:
    # The dynamic stop-or-retry decision lives in regular Guppy code because
    # the outer retry structure below is expanded at comptime. Returning early
    # on success keeps later unrolled attempts out of the runtime path.
    if success:
        return True, tries
    if rus_attempt(q, a, b):
        return True, tries
    return False, tries + 1


@guppy.comptime
@no_type_check
def main() -> None:
    # The unbounded version retries with `while True`. Here the retry budget is
    # fixed at compile time and the final outputs are emitted once after the
    # loop. `attempts` is the number of failed attempts before success, or `N`
    # if all attempts fail.
    q = qubit()
    success, attempts = repeat_until_success(q, comptime(N))
    result("success", success)
    result("attempts", attempts)
    discard(q)
