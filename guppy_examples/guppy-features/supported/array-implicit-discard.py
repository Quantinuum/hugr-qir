import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import array, output
from guppylang.std.quantum import measure


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    # Copyable, droppable elements allow the remaining array to be discarded
    # implicitly after a statically-indexed access.
    values = array(i + 10 for i in range(4))
    output("value", values[2])


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
