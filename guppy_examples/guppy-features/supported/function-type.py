from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import Function, output
from guppylang.std.quantum import measure


@guppy
@no_type_check
def increment(x: int) -> int:
    return x + 1


@guppy
@no_type_check
def apply_twice(f: Function[[int], int], value: int) -> int:
    return f(f(value))


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    output("function_type", apply_twice(increment, 3))
