from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import array, output
from guppylang.std.quantum import measure


@guppy.comptime
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    values = array(1, 2, 3, 4)
    copied = values.copy()
    first, *tail = copied
    values[0] = 10

    output("array_first", first)
    output("array_tail_1", tail[1])
    output("array_mutated", values[0])
