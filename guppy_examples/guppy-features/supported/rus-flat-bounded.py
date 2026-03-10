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
    # This uses a flat bounded loop body with measure-and-reset ancillas, so
    # the same three qubits can be reused.
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
