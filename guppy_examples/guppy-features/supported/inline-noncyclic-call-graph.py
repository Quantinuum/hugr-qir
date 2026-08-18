from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output, qubit
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def a(q: qubit) -> None:
    x(q)


@guppy
@no_type_check
def b(q: qubit) -> None:
    x(q)
    a(q)


@guppy
@no_type_check
def c(q: qubit) -> None:
    x(q)
    b(q)


@guppy
@no_type_check
def d(q: qubit) -> None:
    x(q)
    b(q)


@guppy
@no_type_check
def e(q: qubit) -> None:
    x(q)
    d(q)
    c(q)


@guppy
@no_type_check
def f(q: qubit) -> None:
    x(q)
    d(q)
    e(q)


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    d(q)
    f(q)

    output("0", measure(q).read())
