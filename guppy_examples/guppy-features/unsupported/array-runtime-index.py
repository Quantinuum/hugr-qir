import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.qsystem.random import RNG
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    # Unlike a Boolean selector, this runtime integer cannot be expanded into
    # a small set of statically addressed QIR qubit operations.
    rng = RNG(11)
    index = rng.random_int_bounded(4)
    rng.discard()

    qbs = array(qubit() for _ in range(4))
    x(qbs[index])

    qb0, qb1, qb2, qb3 = qbs
    output("qb0", measure(qb0).read())
    output("qb1", measure(qb1).read())
    output("qb2", measure(qb2).read())
    output("qb3", measure(qb3).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
