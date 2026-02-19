import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.qsystem.functional import measure
from guppylang.std.quantum import cx, discard, h
from tket_exts import tket_registry


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
    hugr_package = main.compile()
    # Can remove once extension handling fixed in guppy
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    sys.stdout.buffer.write(hugr_package.to_bytes())
