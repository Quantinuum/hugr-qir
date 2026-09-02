from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.num import nat


@guppy
@no_type_check
def main() -> None:
    output("bools", array(True, False, True))
    output("ints", array(-1, 0, 1))
    output("uints", array(nat(1), nat(2), nat(3)))
