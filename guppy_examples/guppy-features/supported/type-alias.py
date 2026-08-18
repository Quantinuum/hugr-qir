from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output

Row = guppy.type_alias("Row", "tuple[int, int, int, int]")

T = guppy.type_var("T")
Pair = guppy.type_alias("Pair", "tuple[T, T]", params=[T])


@guppy
@no_type_check
def row_sum(row: Row) -> int:
    return row[0] + row[1] + row[2] + row[3]


@guppy
@no_type_check
def pair_first(pair: Pair[int]) -> int:
    return pair[0]


@guppy.comptime
@no_type_check
def main() -> None:
    output("row_sum", row_sum((1, 2, 3, 4)))
    output("pair_first", pair_first((8, 13)))
