from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result
from guppylang.std.mem import mem_swap


@guppy
@no_type_check
def main() -> None:
    left = 1
    right = 2
    mem_swap(left, right)
    result("swap_left", left)
    result("swap_right", right)
