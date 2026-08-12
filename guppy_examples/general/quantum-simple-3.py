from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import Measurement, measure, x


@guppy
def get_measurement_result(m: Measurement) -> bool:
    return m.read()


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    x(q)
    meas = measure(q)
    res = get_measurement_result(meas)
    result("0", res)
