import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.mem import mem_swap
from guppylang.std.quantum import measure, x


@guppy.comptime
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()
    x(q1)
    mem_swap(q0, q1)
    b0 = measure(q0)
    b1 = measure(q1)

    result("0", b0)
    result("1", b1)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
