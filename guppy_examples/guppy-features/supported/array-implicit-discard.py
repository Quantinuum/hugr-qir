import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output


@guppy
@no_type_check
def main() -> None:
    # Copyable, droppable elements allow the remaining array to be discarded
    # implicitly after a statically-indexed access.
    values = array(i + 10 for i in range(4))
    output("value", values[2])


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
