import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.lang import comptime, owned
from guppylang.std.quantum import h, measure

n = guppy.nat_var("n")


@guppy.comptime
def arr_res(qbs: array[qubit, n] @ owned) -> None:
    for i, q in enumerate(qbs):
        output(f"arr_res_{i}", measure(q).read())


@guppy.comptime
def iarr_res(label: str @ comptime, qbs: array[int, n]) -> None:
    for i, q in enumerate(qbs):
        output(f"{label}_{i}", q)


py_array = [3, 4, 5, 6]

N = 80


@guppy
@no_type_check
def main() -> None:
    qubits = array(qubit() for _ in range(N))
    ints = array(i for i in range(N))
    static_array = array(i for i in py_array)
    for i in range(N):
        h(qubits[i])
    arr_res(qubits)
    iarr_res("iar", ints)
    iarr_res("siar", static_array)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
