from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.num import nat
from guppylang.std.qsystem.utils import get_current_shot


@guppy
def main() -> None:
    divisor = nat(get_current_shot())
    output("quotient", nat(100) // divisor)
