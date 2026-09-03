import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, qubit
from guppylang.std.quantum import h, measure


@guppy
@no_type_check
def main() -> None:
    # A fixed-size array iteration has a statically-known trip count. The array
    # is consumed by the loop, so no dynamic array cleanup is required.
    qbs = array(qubit() for _ in range(4))
    for qb in qbs:
        h(qb)
        measure(qb).read()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
