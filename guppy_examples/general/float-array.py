"""Exercise an array element whose LLVM ABI alignment is greater than one."""

import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import measure, rz


@guppy
@no_type_check
def main() -> None:
    values = array(1.0, 2.0, 3.0, 4.0)
    q = qubit()
    rz(q, angle(values[0]))
    rz(q, angle(values[1]))
    rz(q, angle(values[2]))
    rz(q, angle(values[3]))
    output("result", measure(q).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
