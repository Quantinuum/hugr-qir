import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import cx, h, measure


@guppy
@no_type_check
def create_steane() -> array[qubit, 7]:
    return array(qubit() for _ in range(7))


@guppy
@no_type_check
def steane_h(stq: array[qubit, 7]) -> None:
    for i in range(7):
        h(stq[i])


@guppy
@no_type_check
def steane_cx(
    stq1: array[qubit, 7],
    stq2: array[qubit, 7],
) -> None:
    for i in range(7):
        cx(stq1[i], stq2[i])


@guppy
@no_type_check
def main() -> None:
    steane_q1 = create_steane()
    steane_q2 = create_steane()
    steane_h(steane_q1)
    steane_h(steane_q2)
    steane_cx(steane_q1, steane_q2)
    q1_0, q1_1, q1_2, q1_3, q1_4, q1_5, q1_6 = steane_q1
    q2_0, q2_1, q2_2, q2_3, q2_4, q2_5, q2_6 = steane_q2
    output("st1_0", measure(q1_0).read())
    output("st1_1", measure(q1_1).read())
    output("st1_2", measure(q1_2).read())
    output("st1_3", measure(q1_3).read())
    output("st1_4", measure(q1_4).read())
    output("st1_5", measure(q1_5).read())
    output("st1_6", measure(q1_6).read())
    output("st2_0", measure(q2_0).read())
    output("st2_1", measure(q2_1).read())
    output("st2_2", measure(q2_2).read())
    output("st2_3", measure(q2_3).read())
    output("st2_4", measure(q2_4).read())
    output("st2_5", measure(q2_5).read())
    output("st2_6", measure(q2_6).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
