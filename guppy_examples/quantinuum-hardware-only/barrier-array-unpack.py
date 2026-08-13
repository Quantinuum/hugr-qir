from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.platform import barrier, output
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def barrier8(  # noqa: PLR0913 PLR0917
    q0: qubit,
    q1: qubit,
    q2: qubit,
    q3: qubit,
    q4: qubit,
    q5: qubit,
    q6: qubit,
    q7: qubit,
) -> None:
    barrier(q0, q1, q2, q3, q4, q5, q6, q7)


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = [qubit() for _ in range(8)]

    for q in qbs:
        h(q)

    barrier(qbs[0])

    for q in qbs:
        h(q)

    for i, q in enumerate(qbs):
        output(f"q_{i}", measure(q).read())
