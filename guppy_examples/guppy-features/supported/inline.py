import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import h, measure, x


@guppy
@no_type_check
def one(q: qubit) -> None:
    x(q)


@guppy
@no_type_check
def two(q: qubit) -> None:
    x(q)
    one(q)


@guppy
@no_type_check
def three(q: qubit) -> None:
    x(q)
    two(q)


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    h(q)
    three(q)

    result("0", measure(q))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
