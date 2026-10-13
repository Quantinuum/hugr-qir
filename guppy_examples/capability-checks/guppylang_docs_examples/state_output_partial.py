"""Inspect each two-qubit reduced state of a three-qubit GHZ state."""

import numpy as np
from guppylang import guppy
from guppylang.emulator import EmulatorResult
from guppylang.std.builtins import array
from guppylang.std.debug import state_output
from guppylang.std.platform import barrier
from guppylang.std.quantum import (
    cx,
    discard_array,
    h,
    qubit,
)

COMPONENT = "Mixed-state subset snapshots of an entangled GHZ register"
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
    barrier(qs)
    state_output("subset01", qs[0], qs[1])
    state_output("subset02", qs[0], qs[2])
    state_output("subset12", qs[1], qs[2])
    barrier(qs)
    discard_array(qs)


def validate_simulation(simulation: EmulatorResult) -> dict:
    states = simulation.partial_state_dicts()
    for snapshots in states:
        for tag in ("subset01", "subset02", "subset12"):
            density = np.zeros((4, 4), dtype=complex)
            for component in snapshots[tag].state_distribution():
                density += component.probability * np.outer(
                    component.state, component.state.conj()
                )
            np.testing.assert_allclose(density, np.diag([0.5, 0, 0, 0.5]), atol=1e-8)
    return {"validated_snapshots": 3 * len(states)}
