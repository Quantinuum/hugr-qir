import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import cx, h, measure, x
from tket_exts import tket_registry


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    h(q0)
    cx(q0, q1)

    b0 = measure(q0)

    if b0:
        x(q1)

    result("0", measure(q1))


if __name__ == "__main__":
    hugr_package = main.compile()
    # Can remove once extension handling fixed in guppy
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    sys.stdout.buffer.write(hugr_package.to_bytes())
