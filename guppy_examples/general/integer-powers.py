from typing import no_type_check

from guppylang import array, guppy, qubit
from guppylang.std.builtins import output, panic
from guppylang.std.quantum import measure

combos = [(i, j) for i in range(11) for j in range(i, 11)]
combos.extend([(-i, j) for i in range(1, 11) for j in range(i, 11)])
test_ints = [int(i**j) for i, j in combos]


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    ints = array(i**j for i, j in combos)
    for idx in range(len(combos)):
        # llvm should be able to prove this never happens
        # and remove the panic branch
        if ints[idx] != test_ints[idx]:
            panic("int_pow messed up")
    output("ints", ints)
    output("q", measure(q).read())
