import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.lang import owned
from guppylang.std.quantum import cx, h, measure


@guppy
def create_steane() -> tuple[qubit, qubit, qubit, qubit, qubit, qubit, qubit]:
    return qubit(), qubit(), qubit(), qubit(), qubit(), qubit(), qubit()


@guppy.comptime
def steane_h(stq: tuple[qubit, qubit, qubit, qubit, qubit, qubit, qubit]) -> None:
    for i in range(7):
        h(stq[i])


@guppy.comptime
def steane_cx(
    stq1: tuple[qubit, qubit, qubit, qubit, qubit, qubit, qubit],
    stq2: tuple[qubit, qubit, qubit, qubit, qubit, qubit, qubit],
) -> None:
    for i in range(7):
        cx(stq1[i], stq2[i])


@no_type_check
def steane_measure(
    stq: list[qubit] @ owned,
) -> tuple[bool, bool, bool, bool, bool, bool, bool]:
    return tuple([measure(stq[i]) for i in range(7)])


@no_type_check
def steane_measure_result(
    stq1: tuple[str, tuple[qubit, qubit, qubit, qubit, qubit, qubit, qubit]] @ owned,
) -> None:
    name, qbs = stq1
    qblist = list(qbs)
    res = steane_measure(qblist)
    for i in range(7):
        result(f"{name}_{i}", res[i])


@guppy.comptime
@no_type_check
def main() -> None:
    steane_q1 = (
        "q1",
        create_steane(),
    )  # this is a python tuple of a python str and guppy tuple
    steane_q2 = "q2", create_steane()
    steane_h(steane_q1[1])
    steane_h(steane_q2[1])
    steane_cx(steane_q1[1], steane_q2[1])
    steane_measure_result(steane_q1)
    steane_measure_result(steane_q2)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
