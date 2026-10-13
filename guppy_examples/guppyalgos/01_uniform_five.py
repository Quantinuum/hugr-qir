"""Prepare five equally likely addresses using amplitude amplification."""

from guppyalgos.primitives.state_preparation import uniform_state
from guppyalgos.utils import qarray
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, measure_array

COMPONENT = "Non-power-of-two uniform state preparation"
QUBIT_BUDGET = 12  # Three address qubits plus comparator and reflection workspace.
EXPECTED = {"address": dict.fromkeys(range(5), 0.2)}
prepare = uniform_state(5)


@guppy
def main() -> None:
    address = qarray(3)
    prepare(address)
    output("address", collect_measurements(measure_array(address)))
