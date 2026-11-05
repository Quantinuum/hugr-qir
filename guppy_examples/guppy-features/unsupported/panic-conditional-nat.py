"""The nat conversion panics on shots 0 through 4, but not later shots."""

from guppylang import guppy, qubit
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    output("value", nat(get_current_shot() - 5))
