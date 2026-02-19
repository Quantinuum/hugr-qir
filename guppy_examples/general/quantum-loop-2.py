import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from tket_exts import tket_registry


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    for _ in range(10):
        q3 = qubit()
        h(q3)
        b = measure(q3)
        if b:
            h(q0)

    result("0", measure(q0))
    result("1", measure(q1))


if __name__ == "__main__":
    hugr_package = main.compile()
    # Can remove once extension handling fixed in guppy
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    sys.stdout.buffer.write(hugr_package.to_bytes())
