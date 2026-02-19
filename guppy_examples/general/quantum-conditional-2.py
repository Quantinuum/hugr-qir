import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from tket_exts import tket_registry


@guppy
@no_type_check
def main() -> None:
    q0, q1 = qubit(), qubit()
    h(q0)
    a = measure(q0)
    b = False
    if a:
        h(q1)
        b = measure(q1)
        if b:
            b = False
    else:
        b = measure(q1)
    result("a", a)
    result("b", b)


if __name__ == "__main__":
    hugr_package = main.compile()
    # Can remove once extension handling fixed in guppy
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    sys.stdout.buffer.write(hugr_package.to_bytes())
