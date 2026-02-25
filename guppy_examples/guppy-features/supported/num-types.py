from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.angles import angle
from guppylang.std.lang import owned
from guppylang.std.num import nat
from guppylang.std.platform import result
from guppylang.std.quantum import h, measure, rz


@guppy
def plus_or_minus(res: bool) -> int:  # noqa: FBT001
    if res:
        return 1
    return -1


@guppy.comptime
@no_type_check
def int_from_reg(
    qs: tuple[qubit, qubit, qubit, qubit] @ owned,
) -> tuple[tuple[bool, bool, bool, bool], int]:
    res_integer_value = 0
    rs = measure(qs[0]), measure(qs[1]), measure(qs[2]), measure(qs[3])
    for i in range(4):
        res_integer_value = (res_integer_value << 1) | int(rs[i])
    return rs, res_integer_value


@guppy
@no_type_check
def main() -> None:
    qs = qubit(), qubit(), qubit(), qubit()
    my_float = 0.4  # constant float is ok, any arithmetic or round(),
    rz(qs[0], angle(my_float))
    h(qs[1])
    h(qs[2])
    h(qs[3])
    rs, rs_int = int_from_reg(qs)
    result("q0", rs[0])
    result("q1", rs[1])
    result("q2", rs[2])
    result("q3", rs[3])
    result("big_endian_res", rs_int)

    random_sum = 0
    random_sum += plus_or_minus(rs[0])
    random_sum += plus_or_minus(rs[1])
    random_sum += plus_or_minus(rs[2])
    random_sum += plus_or_minus(rs[3])
    result("random_sum", random_sum)

    rsum2 = random_sum * random_sum
    six = nat(6)
    four = nat(4)
    example_result = six + four - rsum2
    result("int_res", example_result)
