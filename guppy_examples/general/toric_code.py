r"""Even-distanced [[16, 2, 4]] code"""

from guppylang import guppy
from guppylang.std.builtins import comptime, result
from guppylang.std.quantum import cx, h, measure, qubit, z

stabilizer_indices_z = [
    [0, 1, 4, 5],
    [2, 3, 6, 7],
    [5, 6, 9, 10],
    [7, 4, 11, 8],
    [8, 9, 12, 13],
    [10, 11, 14, 15],
    [13, 14, 1, 2],
    [15, 12, 3, 0],
]

stabilizer_indices_x = [
    [1, 2, 5, 6],  # round 2
    [3, 0, 7, 4],  # round 2
    [4, 5, 8, 9],  # round 1
    [6, 7, 10, 11],  # round 1
    [9, 10, 13, 14],  # round 2
    [11, 8, 15, 12],  # round 2
    [12, 13, 0, 1],  # round 1
    [14, 15, 2, 3],  # round 1
]

index_0 = [2, 3, 6, 7]
index_1 = [0, 1, 4, 5]

NULL_VALUE = -1


@guppy.comptime
def main() -> None:
    data_qubits = [qubit() for _ in range(16)]
    stab_indices_x = stabilizer_indices_x

    index_0_guppy = index_0
    syndromes_0 = [False for _ in range(4)]

    for i in range(4):
        syndromes_0[i] = syndrome_extraction(
            data_qubits, stab_indices_x[index_0_guppy[i]]
        )
    result("s0", bool_array_as_int(syndromes_0))

    indices = decoder_0(syndromes_0)
    correction(indices, data_qubits)
    index_1_guppy = index_1
    syndromes_1 = [False for _ in range(4)]
    for i in range(4):
        syndromes_1[i] = syndrome_extraction(
            data_qubits, stab_indices_x[index_1_guppy[i]]
        )
    result("s1", bool_array_as_int(syndromes_1))
    indices = decoder_1(syndromes_1)
    correction(indices, data_qubits)
    result("c", bool_array_as_int([measure(q) for q in data_qubits]))


def syndrome_extraction(q: list[qubit], indices: list[int]) -> bool:
    ancilla = qubit()
    for i in indices:
        h(q[i])
        cx(q[i], ancilla)
        h(q[i])
    return measure(ancilla)


@guppy
def dynamic_branching(condition: bool, value: int) -> int:
    if condition:
        return value
    return comptime(NULL_VALUE)


def decoder_0(syndromes: list[bool]) -> list[int]:
    null = NULL_VALUE
    stabilizers = stabilizer_indices_x
    indices = [null, null, null, null]
    stab = index_0
    for j in range(4):
        syn = syndromes[j]
        indices[j] = dynamic_branching(syn, stabilizers[stab[j]][2])
    return indices


@guppy
def dynamic_branching2(syndrome_result: int) -> tuple[int, int, int, int]:
    null = comptime(NULL_VALUE)
    idx0 = null
    idx1 = null
    idx2 = null
    idx3 = null
    if syndrome_result == 12:  # 2^2 + 2^3 = (0, 0, 1, 1)
        idx0 = 10
        idx1 = 11
    elif syndrome_result == 10:  # 2^1 + 2^3 = (0, 1, 0, 1)
        idx0 = 4
        idx1 = 8
    elif syndrome_result == 6:  # 2^1 + 2^2 = (0, 1, 1, 0)
        idx0 = 0
        idx1 = 13
    elif syndrome_result == 9:  # 2^0 + 2^3 = (1, 0, 0, 1)
        idx0 = 2
        idx1 = 15
    elif syndrome_result == 5:  # 2^0 + 2^2 = (1, 0, 1, 0)
        idx0 = 5
        idx1 = 9
    elif syndrome_result == 3:  # 2^0 + 2^1 = (1, 1, 0, 0)
        idx0 = 6
        idx1 = 7
    elif syndrome_result == 15:  # 2^0 + 2^1 + 2^2 + 2^3 = (1, 1, 1, 1)
        idx0 = 2
        idx1 = 3
        idx2 = 14
        idx3 = 15
    return idx0, idx1, idx2, idx3


def decoder_1(syndromes: list[bool]) -> list[int]:
    syndrome_result = 0
    for i in range(4):
        syndrome_result += dynamic_branching(syndromes[i], 2**i)
    return list(dynamic_branching2(syndrome_result))


def correction(indices: list[int], data_qubits: list[qubit]) -> None:
    for i, _ in enumerate(data_qubits):
        data_q = data_qubits[i]
        for idx in indices:
            correct_qubit = need_to_correct(i, idx)
            correct_if(correct_qubit, data_q)


@guppy
def need_to_correct(idx: int, to_correct_idx: int) -> bool:
    return idx == to_correct_idx


@guppy
def correct_if(needed: bool, to_correct_q: qubit) -> None:
    if needed:
        z(to_correct_q)


def bool_array_as_int(bool_arr: list[bool], big_endian: bool = True) -> int:
    """Convert a comptime bool array to integer"""
    integer_value = 0
    if big_endian:
        for b in bool_arr:
            integer_value = (integer_value << 1) | int(b)
    else:
        for i, b in enumerate(bool_arr):
            integer_value = int(b) << i
    return integer_value
