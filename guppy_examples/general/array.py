import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.lang import owned
from guppylang.std.quantum import h, measure

N = 80


@guppy.comptime
def arr_res(qbs: array[qubit, N] @ owned) -> None:
    for i, q in enumerate(qbs):
        output(f"arr_res_{i}", measure(q).read())


@guppy
@no_type_check
def main() -> None:
    qubits = array(qubit() for _ in range(N))
    for i in range(N):
        h(qubits[i])
    arr_res(qubits)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
