"""Teleport half a Bell pair and verify its recovered entanglement by decoding."""

from guppyalgos.primitives.subroutines.teleport import quantum_teleportation
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import (
    collect_measurements,
    cx,
    h,
    measure,
    measure_array,
    qubit,
)

COMPONENT = "Teleportation with measurement-dependent Pauli corrections"
QUBIT_BUDGET = 4  # Reference, source, destination, internal Bell-pair ancilla.
EXPECTED = {"reference": {0: 1.0}, "destination": {0: 1.0}}


@guppy
def main() -> None:
    reference = qubit()
    source = qarray(1)
    destination = qarray(1)
    h(reference)
    cx(reference, source[0])
    quantum_teleportation(source, destination)
    cx(reference, destination[0])
    h(reference)
    output("reference", measure(reference).read())
    output("destination", collect_measurements(measure_array(destination)))
