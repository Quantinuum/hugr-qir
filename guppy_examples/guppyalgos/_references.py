"""Small dense references using little-endian registers and half-turn angles."""

import numpy as np

IDENTITY = np.eye(2, dtype=complex)
X = np.array([[0, 1], [1, 0]], dtype=complex)
Z = np.diag([1, -1]).astype(complex)
H = (X + Z) / np.sqrt(2)
ZERO = np.diag([1, 0])
ONE = np.diag([0, 1])


def probabilities(state: np.ndarray) -> dict[int, float]:
    return {i: float(p) for i, p in enumerate(abs(state) ** 2) if p > 1e-12}


def signed_lcu() -> np.ndarray:
    """Full two-qubit unitary whose PREPARE-zero block is (Z-X)/2."""
    prepare = np.kron(IDENTITY, H)
    select = np.kron(Z, ZERO) - np.kron(X, ONE)
    return prepare @ select @ prepare


def controlled(unitary: np.ndarray) -> np.ndarray:
    """Add a least-significant control, active on one."""
    return np.kron(np.eye(len(unitary)), ZERO) + np.kron(unitary, ONE)


def block_probabilities(kind: str) -> dict[int, float]:
    lcu = signed_lcu()
    reflection = np.kron(IDENTITY, -Z)
    if kind == "lcu":
        unitary = np.kron(H, IDENTITY) @ lcu
        return probabilities(unitary[:, 0])
    if kind == "walk":
        return probabilities(np.linalg.matrix_power(reflection @ lcu, 2)[:, 0])
    if kind in ("controlled_lcu", "controlled_walk"):
        unitary = lcu if kind == "controlled_lcu" else reflection @ lcu
        # Ramsey interference reads the relative phase of the controlled operation.
        ramsey = np.kron(np.eye(4), H)
        return probabilities((ramsey @ controlled(unitary) @ ramsey)[:, 0])
    if kind == "qsvt":
        phases = (0.125, -0.25, 0.375)
        unitary = np.eye(8, dtype=complex)
        query = np.kron(lcu, IDENTITY)
        phase_signs = np.diag(np.kron(np.kron(IDENTITY, -Z), Z))
        for phase in phases:
            phase_op = np.diag(np.exp(-0.5j * np.pi * phase * phase_signs))
            unitary = phase_op @ query @ unitary
        ramsey = np.kron(np.eye(4), H)
        return probabilities((ramsey @ unitary @ ramsey)[:, 0])
    raise ValueError(kind)


def trotter_probabilities(
    terms: list,
    sequence: list[tuple[int, float]],
    time_step: float,
    *,
    controlled_step: bool = False,
) -> dict[int, float]:
    """Reference the finite product formula, rather than exact Hamiltonian evolution."""
    state = np.array([1, 0], dtype=complex)
    for index, factor in sequence:
        term = terms[index]
        paulis = term.string.get_dict()
        matrix = {"X": X, "Z": Z}.get(str(paulis.get(0)), IDENTITY)
        theta = np.pi * float(term.coeff) * factor * time_step / 2
        state = np.cos(theta) * state - 1j * np.sin(theta) * matrix @ state
    if not controlled_step:
        return probabilities(H @ state)
    # Control starts and ends in the X basis; the off branch stays |0>.
    joint = (
        np.kron(np.array([1, 0]), np.array([1, 0])) + np.kron(state, np.array([0, 1]))
    ) / np.sqrt(2)
    return probabilities(np.kron(IDENTITY, H) @ joint)
