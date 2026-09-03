from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.angles import angle
from guppylang.std.lang import owned
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.quantum import h, measure, rz


@guppy.comptime
@no_type_check
def int_from_reg(
    qs: tuple[qubit, qubit, qubit, qubit] @ owned,
) -> tuple[tuple[bool, bool, bool, bool], int]:
    res_integer_value = 0
    rs = (
        measure(qs[0]).read(),
        measure(qs[1]).read(),
        measure(qs[2]).read(),
        measure(qs[3]).read(),
    )
    for i in range(4):
        res_integer_value = (res_integer_value << 1) | int(rs[i])
    return rs, res_integer_value


@guppy
@no_type_check
def main() -> None:
    qs = qubit(), qubit(), qubit(), qubit()
    my_float = 0.4  # Constant floats may be used as gate parameters.
    rz(qs[0], angle(my_float))
    h(qs[1])
    h(qs[2])
    h(qs[3])
    h(qs[3])
    h(qs[2])
    h(qs[1])
    rs, rs_int = int_from_reg(qs)
    output("q0", rs[0])
    output("q1", rs[1])
    output("q2", rs[2])
    output("q3", rs[3])
    output("big_endian_res", rs_int)

    six = nat(6)
    four = nat(4)
    output("nat_sum", six + four)
