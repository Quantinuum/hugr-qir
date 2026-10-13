"""Resolve both eigenphases of U=diag(1, exp(2*pi*i*5/16))."""

from guppyalgos.algorithms.phase_estimation import qpe
from guppyalgos.utils import cphase, qarray
from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import output
from guppylang.std.quantum import collect_measurements, h, measure, measure_array, qubit

COMPONENT = "Canonical QPE with a powered controlled oracle"
QUBIT_BUDGET = 5
EXPECTED = {"phase": {0: 0.5, 5: 0.5}}


@guppy
def powered_oracle(control: qubit, system: qubit, power: int) -> None:
    cphase(control, system, angle(5.0 * power / 8.0))


@guppy
def main() -> None:
    phase = qarray(4)
    system = qubit()
    h(system)
    # qpe expects its phase register to have already been prepared in |+>.
    for i in range(4):
        h(phase[i])
    qpe(phase, system, powered_oracle)
    output("phase", collect_measurements(measure_array(phase)))
    output("eigenstate", measure(system).read())


def validate_shot(shot: dict) -> None:
    from _checks import bits_to_int, require_equal  # noqa: PLC0415

    require_equal(bits_to_int(shot["phase"]), (5 if shot["eigenstate"] else 0))
