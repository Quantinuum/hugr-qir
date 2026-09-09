from guppylang import guppy, qubit
from guppylang.std.builtins import array
from guppylang.std.platform import output
from guppylang.std.quantum import collect_measurements, cx, measure_array


@guppy
def apply_subscript(qs: array[qubit, 10], i: int) -> None:
    cx(qs[0], qs[i])


@guppy
def main() -> None:
    qbs = array(qubit() for _ in range(10))
    apply_subscript(qbs, 0)
    output("qbs", collect_measurements(measure_array(qbs)))
