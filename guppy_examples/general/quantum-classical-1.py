from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    x(q0)
    x(q1)

    b0 = measure(q0).read()
    b1 = measure(q1).read()
    b2 = b0 ^ b1

    result("0", b2)
