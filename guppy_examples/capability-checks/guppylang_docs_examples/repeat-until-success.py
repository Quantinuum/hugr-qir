"""Measurement-driven RUS with a twenty-attempt limit."""

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.qsystem.sol.functional import measure_and_reset
from guppylang.std.quantum import cx, discard, h, qubit, reset, t, tdg, z


@guppy
def repeat_until_success(q: qubit) -> int:
    attempts = 0
    a, b = qubit(), qubit()
    while attempts < 20:
        attempts += 1

        # Prepare ancilla qubits
        h(a)
        h(b)

        tdg(a)
        cx(b, a)
        t(a)
        h(a)
        a, ma = measure_and_reset(a)
        if ma.read():
            # First ancilla failed, consume all ancillas, try again
            reset(b)
            continue

        t(q)
        z(q)
        cx(q, b)
        t(b)
        h(b)
        b, mb = measure_and_reset(b)
        if mb.read():
            # Second ancilla failed, apply correction and try again
            z(q)
            continue

        break
    discard(a)
    discard(b)
    return attempts


@guppy
def main() -> None:
    q = qubit()
    attempts = repeat_until_success(q)
    output("attempts", attempts)
    discard(q)


COMPONENT = "Measurement-driven RUS with a twenty-attempt limit"
QUBIT_BUDGET = 3
SOURCE_URL = (
    "https://docs.quantinuum.com/guppy/guppylang/examples/repeat-until-success.html"
)

EXPECTED = {"attempts": {k: (3 / 8) ** (k - 1) * (5 / 8) for k in range(1, 20)}}
EXPECTED["attempts"][20] = (3 / 8) ** 19
