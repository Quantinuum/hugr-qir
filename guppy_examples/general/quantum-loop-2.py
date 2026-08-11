from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    for _ in range(10):
        q3 = qubit()
        x(q3)
        b = measure(q3).read()
        if b:
            x(q0)

    result("0", measure(q0).read())
    result("1", measure(q1).read())
