"""Ten nested loops with bounds that depend on the enclosing loop indices."""

import sys

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, qubit, x


@guppy
def main() -> None:
    q = qubit()
    iterations = 0
    for i0 in range(3):
        for i1 in range(i0**2):
            for i2 in range(i1 // 2):
                for i3 in range(i2 + 1):
                    for i4 in range(2**i3):
                        for i5 in range(i4 + 2):
                            for i6 in range(i5 * 2):
                                for i7 in range(i6 + 10):
                                    for i8 in range(i7 // 2):
                                        for _ in range(i8 // 2):
                                            x(q)
                                            iterations += 1

    output("iterations", iterations)
    output("q", measure(q).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
