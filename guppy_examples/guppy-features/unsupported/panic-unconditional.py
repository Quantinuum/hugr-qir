"""An explicit panic with no successful runtime path."""

from guppylang import guppy
from guppylang.std.platform import panic


@guppy
def main() -> None:
    panic("Required input is missing")
