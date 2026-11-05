from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure


@guppy
@no_type_check
def split_pair(pair: tuple[int, int]) -> int:
    left, right = pair
    return left * 10 + right


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    output("split_pair", split_pair((4, 7)))
