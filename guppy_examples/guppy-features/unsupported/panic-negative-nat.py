"""Converting a guaranteed negative runtime integer to nat always panics."""

from guppylang import guppy, qubit
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    # H2 shot indices are in [0, 2**32), so this cannot overflow and is negative.
    output("value", nat(-get_current_shot() - 1))
