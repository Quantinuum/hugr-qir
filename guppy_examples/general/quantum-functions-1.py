from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def fun_func(q: qubit) -> None:
    x(q)


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    fun_func(q0)
    fun_func(q1)

    result("0", measure(q0).read())
    result("1", measure(q1).read())
