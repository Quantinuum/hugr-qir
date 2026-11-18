"""Integer power with a shot-dependent runtime exponent."""

from guppylang import guppy, qubit
from guppylang.std.builtins import nat, output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    q = qubit()
    exponent = nat(get_current_shot())
    output("power", 3**exponent)
    output("q", measure(q).read())
