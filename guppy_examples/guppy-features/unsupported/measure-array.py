import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, qubit, result
from guppylang.std.quantum import cx, h, measure_array


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(8))  # comptime array is ok
    for i in range(8):
        if i % 2 == 0:
            h(qbs[i])
        else:
            cx(qbs[i - 1], qbs[i])

    result("qbs", measure_array(qbs))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
