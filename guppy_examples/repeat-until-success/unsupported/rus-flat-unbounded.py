from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import discard, measure, qubit, s, toffoli, z
from guppylang.std.quantum.functional import h


@guppy
@no_type_check
def main() -> None:
    # This keeps the flat retry body, but leaves the retry loop truly
    # unbounded. That open-ended runtime control flow is what hugr-qir
    # rejects today. The `attempts` output counts failed attempts before
    # success, so a first-try success records 0.
    q = qubit()
    n = 0
    while True:
        a, b = h(qubit()), h(qubit())
        toffoli(a, b, q)
        s(q)
        toffoli(a, b, q)
        if not (measure(h(a)).read() | measure(h(b)).read()):
            output("attempts", n)
            output("success", True)
            discard(q)
            break
        z(q)
        n += 1
