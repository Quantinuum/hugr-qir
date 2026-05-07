import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def recursive_func(q: qubit, n: int) -> None:
    x(q)
    if n < 10:
        return recursive_func(q, n + 1)
    return None


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    x(q)
    recursive_func(q, 0)
    result("q", measure(q))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
