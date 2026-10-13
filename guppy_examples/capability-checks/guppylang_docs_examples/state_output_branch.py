"""Snapshot the qubit selected by a measured branch, including its classical choice."""

import numpy as np
from guppylang import guppy
from guppylang.emulator import EmulatorResult
from guppylang.std.builtins import output
from guppylang.std.debug import state_output
from guppylang.std.quantum import (
    discard,
    h,
    measure,
    qubit,
    x,
)

COMPONENT = "state_output selected by measurement-dependent control flow"
QUBIT_BUDGET = 3
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/state_results.html"
EXPECTED = {"choice": {0: 0.5, 1: 0.5}}


@guppy
def main() -> None:
    selector, zero, one = qubit(), qubit(), qubit()
    h(selector)
    x(one)
    choice = measure(selector).read()
    if choice:
        state_output("state", one)
    else:
        state_output("state", zero)
    output("choice", choice)
    discard(zero)
    discard(one)


def validate_simulation(simulation: EmulatorResult) -> dict:
    states = simulation.partial_state_dicts()
    for shot, snapshots in zip(simulation.results, states, strict=True):
        choice = int(shot.as_dict()["choice"])
        expected = np.eye(2)[choice]
        np.testing.assert_allclose(
            abs(np.vdot(expected, snapshots["state"].as_single_state())), 1.0, atol=1e-8
        )
    return {"validated_snapshots": len(states)}
