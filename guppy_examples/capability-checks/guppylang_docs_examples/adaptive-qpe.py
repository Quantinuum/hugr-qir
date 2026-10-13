"""Estimate a one-qubit eigenphase through twenty-four adaptive measurements."""

import math

import numpy as np
from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import output
from guppylang.std.quantum import (
    crz,
    discard,
    h,
    measure,
    qubit,
    rz,
    x,
)

COMPONENT = "Adaptive QPE with measurement-dependent floating-point updates"
QUBIT_BUDGET = 2
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/adaptive-qpe.html"
SQRT_E = math.sqrt(math.e)
SHRINK = math.sqrt((math.e - 1) / math.e)


@guppy
def oracle(control: qubit, target: qubit, time: float) -> None:
    crz(control, target, angle(0.5 * time))


@guppy
def main() -> None:
    mu, sigma = SHRINK, 1 / SQRT_E
    target = qubit()
    x(target)
    for _ in range(24):
        time = 1 / sigma
        aux = qubit()
        h(aux)
        rz(aux, angle((sigma - mu) * time))
        oracle(aux, target, time)
        h(aux)
        if measure(aux).read():
            mu += sigma / SQRT_E
        else:
            mu -= sigma / SQRT_E
        sigma *= SHRINK
    discard(target)
    output("eigenvalue", 2 * mu)


def validate_records(records: list[dict]) -> None:
    from _references import adaptive_reference  # noqa: PLC0415

    expected_mean, expected_std = adaptive_reference()
    values = np.array([record["eigenvalue"] for record in records])
    if (
        not np.isfinite(values).all()
        or abs(values.mean() - expected_mean)
        > 6 * expected_std / np.sqrt(len(values)) + 0.02
    ):
        message = (
            "Adaptive estimates disagree with the sampling reference: "
            f"{values.mean()} versus {expected_mean}"
        )
        raise AssertionError(message)
