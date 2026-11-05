"""An explicit panic with no successful runtime path."""

from guppylang import guppy, qubit
from guppylang.std.platform import output, panic
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    panic("Required input is missing")
