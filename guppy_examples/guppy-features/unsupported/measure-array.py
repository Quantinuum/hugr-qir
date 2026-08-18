import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import collect_measurements, cx, h, measure_array


@guppy.comptime
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(8))  # comptime array is ok
    for i in range(8):
        if i % 2 == 0:
            h(qbs[i])
        else:
            cx(qbs[i - 1], qbs[i])

    results = collect_measurements(measure_array(qbs))
    output("qbs", results)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
