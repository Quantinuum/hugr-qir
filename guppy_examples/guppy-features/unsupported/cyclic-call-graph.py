from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def a(q: qubit) -> None:
    b(q)


@guppy
@no_type_check
def b(q: qubit) -> None:
    x(q)
    d(q)


@guppy
@no_type_check
def c(q: qubit) -> None:
    x(q)
    a(q)


@guppy
@no_type_check
def d(q: qubit) -> None:
    x(q)
    c(q)


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    d(q)
    result("0", measure(q))
