"""Converting a guaranteed negative runtime integer to nat always panics."""

from guppylang import guppy
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.qsystem.utils import get_current_shot


@guppy
def main() -> None:
    # H2 shot indices are in [0, 2**32), so this cannot overflow and is negative.
    output("value", nat(-get_current_shot() - 1))
