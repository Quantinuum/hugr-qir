"""Classical checks for little-endian example outputs."""

from collections import Counter
from math import isclose, sqrt

SUPPORT_EPSILON = 1e-12


def bits_to_int(bits: list[bool] | bool | int) -> int:
    if isinstance(bits, (bool, int)):
        return int(bits)
    return sum(int(bit) << i for i, bit in enumerate(bits))


def require_equal(actual: object, expected: object) -> None:
    if actual != expected:
        message = f"Got {actual!r}, expected {expected!r}"
        raise AssertionError(message)


def check_distribution(
    shots: list[dict], label: str, expected: dict[int, float]
) -> None:
    """Check support and frequencies against a six-standard-error tolerance."""
    if not shots or not isclose(sum(expected.values()), 1.0, abs_tol=1e-10):
        message = "Need shots and a normalized expected distribution"
        raise AssertionError(message)
    counts = Counter(bits_to_int(shot[label]) for shot in shots)
    for value, count in counts.items():
        if expected.get(value, 0.0) < SUPPORT_EPSILON:
            message = f"{label}: unexpected outcome {value} ({count} shots)"
            raise AssertionError(message)
    for value, probability in expected.items():
        observed = counts[value] / len(shots)
        tolerance = 6 * sqrt(probability * (1 - probability) / len(shots)) + 1 / len(
            shots
        )
        if abs(observed - probability) > tolerance:
            message = (
                f"{label}={value}: observed {observed:.4f}, expected {probability:.4f}"
            )
            raise AssertionError(message)
