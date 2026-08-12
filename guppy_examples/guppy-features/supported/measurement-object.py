from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import h, measure, x


@guppy
@no_type_check
def main() -> None:
    control = qubit()
    target = qubit()
    h(control)
    measurement = measure(control)

    if measurement:
        x(target)

    result("measurement_read", measurement.read())
    result("target", measure(target).read())
