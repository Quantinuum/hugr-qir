r"""Even-distanced [[16, 2, 4]] code using fixed-size runtime arrays."""

import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import cx, h, measure, z

NDQ = 16


@guppy
def syndrome_extraction(q: array[qubit, NDQ], idxs: array[int, 4]) -> bool:
    ancilla = qubit()
    h(q[idxs[0]])
    cx(q[idxs[0]], ancilla)
    h(q[idxs[0]])
    h(q[idxs[1]])
    cx(q[idxs[1]], ancilla)
    h(q[idxs[1]])
    h(q[idxs[2]])
    cx(q[idxs[2]], ancilla)
    h(q[idxs[2]])
    h(q[idxs[3]])
    cx(q[idxs[3]], ancilla)
    h(q[idxs[3]])
    return measure(ancilla).read()


@guppy
def correct_if(needed: bool, data_qubit: qubit) -> None:
    if needed:
        z(data_qubit)


@guppy
@no_type_check
def apply_first_round_correction(
    syndromes: array[bool, 4],
    q: array[qubit, NDQ],
    idxs: array[int, 4],
) -> None:
    correct_if(syndromes[0], q[idxs[0]])
    correct_if(syndromes[1], q[idxs[1]])
    correct_if(syndromes[2], q[idxs[2]])
    correct_if(syndromes[3], q[idxs[3]])


@guppy
@no_type_check
def apply_second_round_correction(
    syndrome: int,
    q: array[qubit, NDQ],
) -> None:
    if syndrome == 3:
        z(q[10])
        z(q[11])
    elif syndrome == 5:
        z(q[4])
        z(q[8])
    elif syndrome == 6:
        z(q[0])
        z(q[13])
    elif syndrome == 9:
        z(q[2])
        z(q[15])
    elif syndrome == 10:
        z(q[5])
        z(q[9])
    elif syndrome == 12:
        z(q[6])
        z(q[7])
    elif syndrome == 15:
        z(q[2])
        z(q[3])
        z(q[14])
        z(q[15])


@guppy
@no_type_check
def bool_array_as_int(values: array[bool, 4]) -> int:
    return (
        (int(values[0]) << 3)
        | (int(values[1]) << 2)
        | (int(values[2]) << 1)
        | int(values[3])
    )


stabilizer_indices_x = {
    "round_1": [
        [4, 5, 8, 9],
        [6, 7, 10, 11],
        [12, 13, 0, 1],
        [14, 15, 2, 3],
    ],
    "round_2": [
        [1, 2, 5, 6],
        [3, 0, 7, 4],
        [9, 10, 13, 14],
        [11, 8, 15, 12],
    ],
}

first_round_correction_indices = [8, 10, 0, 2]


@guppy.comptime
@no_type_check
def main() -> None:
    data_qubits = array(qubit() for _ in range(NDQ))
    first_syndromes = array(
        syndrome_extraction(data_qubits, st_idxs)
        for st_idxs in stabilizer_indices_x["round_1"]
    )
    output("s0", bool_array_as_int(first_syndromes))
    apply_first_round_correction(
        first_syndromes,
        data_qubits,
        first_round_correction_indices,
    )
    second_syndromes = array(
        syndrome_extraction(data_qubits, st_idxs)
        for st_idxs in stabilizer_indices_x["round_2"]
    )
    second_syndrome = bool_array_as_int(second_syndromes)
    output("s1", second_syndrome)

    apply_second_round_correction(
        second_syndrome,
        data_qubits,
    )
    codeword = 0
    for data_qubit in data_qubits:
        codeword = (codeword << 1) | int(measure(data_qubit).read())
    output("c", codeword)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
