"""Select a comptime function using a measured bit from a fixed function table."""

import sys

from guppylang import guppy
from guppylang.std.builtins import array, output
from guppylang.std.quantum import h, measure, qubit, x


@guppy.comptime
def leave(qs: array[qubit, 1]) -> None:
    pass


@guppy.comptime
def flip(qs: array[qubit, 1]) -> None:
    x(qs[0])


@guppy
def main() -> None:
    control = qubit()
    h(control)
    choice = measure(control).read()
    index = 0
    if choice:
        index = 1
    functions = array(leave, flip)
    target = array(qubit())
    functions[index](target)
    (q,) = target
    output("choice", choice)
    output("target", measure(q).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
