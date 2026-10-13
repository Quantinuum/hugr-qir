"""Independent dense and sampling references for the documentation examples."""

import math

import numpy as np

H = np.array([[1, 1], [1, -1]]) / np.sqrt(2)


def single(state: np.ndarray, gate: np.ndarray, target: int) -> np.ndarray:
    result = state.copy()
    for basis in range(len(state)):
        if not (basis >> target) & 1:
            other = basis | (1 << target)
            result[[basis, other]] = gate @ state[[basis, other]]
    return result


def canonical_probabilities() -> dict[int, float]:
    # The two-qubit oracle has eigenphase pi/8 on |11>. Control order is MSB first.
    state = np.array(
        [
            np.exp(
                1j * np.pi / 8 * sum(((b >> j) & 1) * 2 ** (3 - j) for j in range(4))
            )
            / 4
            for b in range(16)
        ]
    )
    reversed_indices = [int(f"{b:04b}"[::-1], 2) for b in range(16)]
    state = state[reversed_indices]
    for target in reversed(range(4)):
        for control in reversed(range(target + 1, 4)):
            theta = -np.pi / 2 ** (control - target)
            state *= np.array(
                [
                    np.exp(-0.5j * theta * (1 - 2 * ((b >> target) & 1)))
                    if (b >> control) & 1
                    else 1
                    for b in range(16)
                ]
            )
        state = single(state, H, target)
    return dict(enumerate(abs(state) ** 2))


def qaoa_probabilities(
    edges: list[tuple[int, int]], cost: list[float], mixer: list[float]
) -> dict[int, float]:
    state = np.ones(128, dtype=complex) / np.sqrt(128)
    x = np.array([[0, 1], [1, 0]])
    for gamma, beta in zip(cost, mixer, strict=True):
        for a, b in edges:
            signs = np.array(
                [
                    (-1) ** (((basis >> a) & 1) + ((basis >> b) & 1))
                    for basis in range(128)
                ]
            )
            state *= np.exp(0.25j * np.pi * gamma * signs)
        rotation = (
            np.cos(np.pi * beta / 2) * np.eye(2) - 1j * np.sin(np.pi * beta / 2) * x
        )
        for target in range(7):
            state = single(state, rotation, target)
    return dict(enumerate(abs(state) ** 2))


def adaptive_reference() -> tuple[float, float]:
    rng = np.random.default_rng(771)
    mu = np.full(100_000, math.sqrt((math.e - 1) / math.e))
    sigma = 1 / math.sqrt(math.e)
    for _ in range(24):
        phase = np.pi * (sigma - mu + 0.25) / sigma
        outcomes = rng.random(len(mu)) < (1 - np.cos(phase)) / 2
        mu += np.where(outcomes, 1, -1) * sigma / math.sqrt(math.e)
        sigma *= math.sqrt((math.e - 1) / math.e)
    values = 2 * mu
    return float(values.mean()), float(values.std())


def distilled_probabilities() -> dict[int, float]:
    phi = math.acos(1 / 3)
    # Match the notebook's angle(phi), whose numeric argument is in half-turns.
    q = np.array(
        [np.cos(np.pi * phi / 2), np.exp(0.25j * np.pi) * np.sin(np.pi * phi / 2)]
    )
    state = q.copy()
    for _ in range(4):
        state = np.kron(q, state)
    for a, b in [(1, 2), (3, 4), (0, 1), (2, 3), (0, 4)]:
        state *= np.array(
            [(-1) ** (((basis >> a) & 1) * ((basis >> b) & 1)) for basis in range(32)]
        )
    # Postselect the four ancillas in the X basis on zero, without renormalizing.
    projected = np.array([state[bit::2].sum() / 4 for bit in range(2)])
    success = float(sum(abs(projected) ** 2))
    acceptance = 1 - (1 - success) ** 3
    target = abs(projected) ** 2 / success
    return {
        0: 1 - acceptance,
        1: acceptance * float(target[0]),
        3: acceptance * float(target[1]),
    }
