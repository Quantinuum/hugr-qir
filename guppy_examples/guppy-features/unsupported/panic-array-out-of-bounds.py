"""A constant index outside the array always panics."""

from guppylang import array, guppy, qubit
from guppylang.std.platform import output
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    values = array(10, 20, 30)
    output("value", values[3])
