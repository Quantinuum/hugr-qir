from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    q0, q1, q2, q3, qc0, qc1 = qubit(), qubit(), qubit(), qubit(), qubit(), qubit()
    c0, c1 = measure(qc0).read(), measure(qc1).read()
    if c0 and c1:
        x(q0)
    elif c0:
        x(q1)
    elif c1:
        x(q2)
    else:
        x(q3)

    output("c0", c0)  # -> false
    output("c1", c1)  # -> false
    output("q0", measure(q0).read())  # -> false
    output("q1", measure(q1).read())  # -> false
    output("q2", measure(q2).read())  # -> false
    output("q3", measure(q3).read())  # -> true
