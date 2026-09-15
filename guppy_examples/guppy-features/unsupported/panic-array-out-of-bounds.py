"""A constant index outside the array always panics."""

from guppylang import array, guppy
from guppylang.std.platform import output


@guppy
def main() -> None:
    values = array(10, 20, 30)
    output("value", values[3])
