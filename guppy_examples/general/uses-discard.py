import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.qsystem.functional import measure
from guppylang.std.quantum import cx, discard, h


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()
    h(q0)
    h(q1)
    cx(q0, q1)
    measure(q0)
    discard(q1)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
