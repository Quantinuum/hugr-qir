"""Compare the gallery's two GHZ preparations through pure-state snapshots."""

import numpy as np
from guppylang import guppy
from guppylang.emulator import EmulatorResult
from guppylang.std.builtins import array
from guppylang.std.debug import state_output
from guppylang.std.quantum import (
    cx,
    discard_array,
    h,
    qubit,
)

COMPONENT = "Full state_output snapshots from equivalent GHZ circuits"
QUBIT_BUDGET = 3
DEFAULT_SHOTS = 8
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/state_results.html"


@guppy
def ghz_state(qs: array[qubit, 3]) -> None:
    h(qs[0])
    cx(qs[0], qs[1])
    cx(qs[1], qs[2])


@guppy
def main() -> None:
    qs = array(qubit() for _ in range(3))
    ghz_state(qs)
    state_output("ghz", qs)
    discard_array(qs)
    alternative = array(qubit() for _ in range(3))
    h(alternative[0])
    cx(alternative[0], alternative[1])
    cx(alternative[0], alternative[2])
    state_output("ghz_alternative", alternative)
    discard_array(alternative)


def validate_simulation(simulation: EmulatorResult) -> dict:
    expected = np.zeros(8)
    expected[0] = expected[7] = 1 / np.sqrt(2)
    states = simulation.partial_state_dicts()
    for snapshots in states:
        for tag in ("ghz", "ghz_alternative"):
            actual = snapshots[tag].as_single_state()
            np.testing.assert_allclose(abs(np.vdot(expected, actual)), 1.0, atol=1e-8)
    return {"validated_snapshots": 2 * len(states)}
