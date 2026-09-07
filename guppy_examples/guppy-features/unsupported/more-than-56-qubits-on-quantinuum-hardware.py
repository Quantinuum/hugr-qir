from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import collect_measurements, h, measure_array

NUM_QUBITS = 57


@guppy
@no_type_check
def main() -> None:
    qbs = array(qubit() for _ in range(NUM_QUBITS))
    for i in range(NUM_QUBITS):
        h(qbs[i])
    output("qbs", collect_measurements(measure_array(qbs)))
