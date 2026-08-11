from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.angles import angle
from guppylang.std.builtins import result
from guppylang.std.qsystem.functional import measure_and_reset
from guppylang.std.quantum import measure, rx, x


@guppy
@no_type_check
def main() -> None:  # noqa: PLR0915
    q0, q1, q2, q3 = qubit(), qubit(), qubit(), qubit()
    qc0, qc1 = qubit(), qubit()
    x(qc1)
    c0, c1 = measure(qc0).read(), measure(qc1).read()
    result("c0", c0)  # -> false
    result("c1", c1)  # -> true

    int_res = 0
    my_float = 0.3

    if c0:
        int_res += 1
    if c1:
        int_res += 1
        my_float = 0.6

    if c0 and c1:
        x(q0)
    elif c0:
        x(q1)
    elif c1:
        x(q2)
        my_float = 0.9
    else:
        x(q3)

    q0, q0m1 = measure_and_reset(q0)
    q1, q1m1 = measure_and_reset(q1)
    q2, q2m1 = measure_and_reset(q2)
    q3, q3m1 = measure_and_reset(q3)

    result("q0", q0m1.read())  # -> false
    result("q1", q1m1.read())  # -> false
    result("q2", q2m1.read())  # -> true
    result("q3", q3m1.read())  # -> false
    result("c0 + c1", int_res)  # -> 1

    if c0:
        x(q0)
    if c1:
        my_float = 0.2
        x(q1)

    mtup = (
        measure(q0).read(),  # -> false
        measure(q1).read(),  # -> true
        measure(q2).read(),  # -> false
        measure(q3).read(),  # -> false
    )
    integer_value = to_int(mtup)
    result("2nd result as int", integer_value)  # -> [0100] = 4

    q4 = qubit()
    q5 = qubit()

    int_res += int(mtup[2])

    if int_res == 0:
        x(q4)
    elif int_res == 1:
        x(q5)
    elif int_res == 2:
        x(q4)
        x(q5)

    result("q4", measure(q4).read())  # -> false
    result("q5", measure(q5).read())  # -> true

    q6 = qubit()
    rx(q6, angle(my_float))
    result("q6", measure(q6).read())  # -> not-deterministic


@guppy.comptime
@no_type_check
def to_int(mtup: tuple[bool, bool, bool, bool]) -> int:
    integer_value = 0
    for i in range(4):
        b = mtup[i]
        integer_value = (integer_value << 1) | int(b)  # for big-endian
    return integer_value
