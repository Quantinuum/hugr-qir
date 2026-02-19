import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.angles import angle
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure, rz
from tket_exts import tket_registry


@guppy
@no_type_check
def rx(q: qubit, x: angle) -> None:
    # Implement Rx via Rz rotation
    h(q)
    rz(q, x)
    h(q)


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    rx(q, angle(1.5))
    result("1", measure(q))


if __name__ == "__main__":
    hugr_package = main.compile()
    # Can remove once extension handling fixed in guppy
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    sys.stdout.buffer.write(hugr_package.to_bytes())
