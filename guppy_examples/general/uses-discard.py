from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.qsystem.functional import measure
from guppylang.std.quantum import cx, discard, x


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()
    x(q0)
    x(q1)
    cx(q0, q1)
    measure(q0).read()
    discard(q1)
