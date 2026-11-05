from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.mem import mem_swap
from guppylang.std.quantum import measure


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    left = 1
    right = 2
    mem_swap(left, right)
    output("swap_left", left)
    output("swap_right", right)
