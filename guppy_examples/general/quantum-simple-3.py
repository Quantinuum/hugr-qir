from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem import measure_and_reset
from guppylang.std.quantum import Measurement, measure, x


@guppy
@no_type_check
def get_measurement_result(m: Measurement) -> bool:
    return m.read()


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    x(q)
    meas = measure_and_reset(q)
    meas2 = measure(q)
    res = get_measurement_result(meas)
    res2 = get_measurement_result(meas2)
    output("expect_one", res)
    output("expect_zero", res2)
