from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.num import nat
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    divisor = nat(get_current_shot())
    output("quotient", nat(100) // divisor)
