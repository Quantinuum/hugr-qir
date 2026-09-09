import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import collect_measurements, cx, h, measure_array


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
    output("steane_q1", collect_measurements(measure_array(steane_q1)))
    output("steane_q2", collect_measurements(measure_array(steane_q2)))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
