"""Measure a mask of optional qubits and consume every remaining linear value."""

from guppylang import guppy
from guppylang.std.builtins import array, nat, output, owned
from guppylang.std.option import Option, nothing, some
from guppylang.std.quantum import (
    Measurement,
    discard,
    measure,
    qubit,
    x,
)

COMPONENT = "Masked measurements of Option[qubit] with Option[Measurement] results"
QUBIT_BUDGET = 3
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/t_factory.html"
EXPECTED = {"present": {5: 1.0}, "values": {4: 1.0}}


@guppy
def measure_mask[n: nat](
    qs: array[Option[qubit], n], mask: array[bool, n] @ owned
) -> array[Option[Measurement], n]:
    results = array(nothing[Measurement]() for _ in range(n))
    index = 0
    for selected in mask:
        if selected and qs[index].is_some():
            q = qs[index].take()
            previous = results[index].swap(some(measure(q.unwrap())))
            previous.unwrap_nothing()
        index += 1  # noqa: SIM113
    return results


@guppy
def main() -> None:
    q0, q1, q2 = qubit(), qubit(), qubit()
    x(q2)
    qs = array(some(q0), some(q1), some(q2))
    present = array(False, False, False)
    values = array(False, False, False)
    index = 0
    for optional in measure_mask(qs, array(True, False, True)):
        if optional.is_some():
            values[index] = optional.unwrap().read()
            present[index] = True
        else:
            optional.unwrap_nothing()
        index += 1  # noqa: SIM113
    for optional_q in qs:
        if optional_q.is_some():
            discard(optional_q.unwrap())
        else:
            optional_q.unwrap_nothing()
    output("present", present)
    output("values", values)
