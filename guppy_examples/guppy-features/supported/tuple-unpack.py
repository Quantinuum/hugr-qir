from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result


@guppy
@no_type_check
def split_pair(pair: tuple[int, int]) -> int:
    left, right = pair
    return left * 10 + right


@guppy
@no_type_check
def main() -> None:
    result("split_pair", split_pair((4, 7)))
