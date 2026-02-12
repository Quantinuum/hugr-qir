from __future__ import annotations

import sys
from typing import TYPE_CHECKING, no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, qubit, result
from guppylang.std.quantum import cx, h, measure

if TYPE_CHECKING:
    from guppylang.std.lang import owned


@no_type_check
def create_steane(name: str) -> tuple[str, array[qubit, 7]]:
    return name, [qubit() for _ in range(7)]


def steane_h(stq: list[qubit]) -> None:
    for q in stq:
        h(q)


def steane_cx(
    stq1: list[qubit],
    stq2: list[qubit],
) -> None:
    num_q = len(stq1)
    for i in range(num_q):
        cx(stq1[i], stq2[i])


@no_type_check
def steane_measure(
    stq: list[qubit] @ owned,
) -> tuple[bool, bool, bool, bool, bool, bool, bool]:
    return tuple([measure(stq[i]) for i in range(7)])


@no_type_check
def steane_measure_result(
    stq1: tuple[str, list[qubit]] @ owned,
) -> None:
    name, qbs = stq1
    res = steane_measure(qbs)
    for i in range(len(res)):
        result(f"{name}_{i}", res[i])


@guppy.comptime
@no_type_check
def main() -> None:
    steane_q1 = create_steane("q1")
    steane_q2 = create_steane("q2")
    steane_h(steane_q1[1])
    steane_h(steane_q2[1])
    steane_cx(steane_q1[1], steane_q2[1])
    steane_measure_result(steane_q1)
    steane_measure_result(steane_q2)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
