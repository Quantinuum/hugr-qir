import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import cx, discard_array, h, measure


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(8))
    for i in range(8):
        if i % 2 == 0:
            h(qbs[i])
        else:
            cx(qbs[i - 1], qbs[i])

    measure_q, *discard_qs = qbs

    output("qb0", measure(measure_q).read())
    discard_array(discard_qs)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
