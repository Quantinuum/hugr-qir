import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import h, measure, x


@guppy
@no_type_check
def recursive_func(q: qubit) -> None:
    x(q)
    q_temp = qubit()
    if measure(q_temp):  # noqa: PLR2004
        return recursive_func(q)
    return None


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    h(q)
    recursive_func(q)
    result("q", measure(q))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
