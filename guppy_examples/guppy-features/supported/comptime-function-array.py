"""Apply two comptime quantum functions selected from a fixed array."""

import sys

from guppylang import guppy
from guppylang.std.builtins import array
from guppylang.std.quantum import discard_array, h, qubit, x


@guppy.comptime
def apply_h(qs: array[qubit, 1]) -> None:
    h(qs[0])


@guppy.comptime
def apply_x(qs: array[qubit, 1]) -> None:
    x(qs[0])


@guppy
def main() -> None:
    functions = array(apply_h, apply_x)
    qs = array(qubit())
    functions[0](qs)
    functions[1](qs)
    discard_array(qs)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
