from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result
from guppylang.std.quantum import discard, measure, qubit, s, toffoli
from guppylang.std.quantum.functional import h


@guppy
@no_type_check
def main() -> None:
    # This keeps the flat retry body, but leaves the retry loop truly
    # unbounded. That open-ended runtime control flow is what hugr-qir
    # rejects today.
    q = qubit()
    n = 0
    while True:
        a, b = h(qubit()), h(qubit())
        toffoli(a, b, q)
        s(q)
        toffoli(a, b, q)
        if not (measure(h(a)) | measure(h(b))):
            result("attempts", n)
            result("success", True)
            discard(q)
            break
        n += 1
