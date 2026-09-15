"""The nat conversion panics on shots 0 through 4, but not later shots."""

from guppylang import guppy
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.qsystem.utils import get_current_shot


@guppy
def main() -> None:
    output("value", nat(get_current_shot() - 5))
