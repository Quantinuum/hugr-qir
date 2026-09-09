import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def main() -> None:
    # A Boolean runtime selector can be lowered to two control-flow branches,
    # each of which uses a static qubit resource pointer.
    selector = qubit()
    h(selector)
    index = int(measure(selector).read())

    qbs = array(qubit() for _ in range(2))
    h(qbs[index])

    qb0, qb1 = qbs
    output("qb0", measure(qb0).read())
    output("qb1", measure(qb1).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
