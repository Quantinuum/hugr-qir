from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def fun_func(q: qubit) -> None:
    h(q)


@guppy
@no_type_check
def fun_func_2(q0: qubit, q1: qubit, i: int) -> None:
    for _ in range(i):
        fun_func(q0)

    fun_func(q1)


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    fun_func_2(q0, q1, 3)
    fun_func_2(q0, q1, 7)

    output("0", measure(q0).read())
    output("1", measure(q1).read())
