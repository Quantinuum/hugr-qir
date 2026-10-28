from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import array, output
from guppylang.std.num import nat
from guppylang.std.quantum import measure


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    output("bools", array(True, False, True))
    output("uints", array(nat(1), nat(2), nat(3)))
