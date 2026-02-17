from __future__ import annotations

import sys
from typing import TYPE_CHECKING, no_type_check

from guppylang.decorator import guppy
from guppylang.std.builtins import qubit, result
from guppylang.std.quantum import cx, cz, h, measure, x

if TYPE_CHECKING:
    from guppylang.std.lang import owned


@guppy.struct
class SteaneQubit:
    pq0: qubit
    pq1: qubit
    pq2: qubit
    pq3: qubit
    pq4: qubit
    pq5: qubit
    pq6: qubit

    @guppy
    def h_all(self) -> None:
        """Single Steane Qubit op"""
        h(self.pq0)
        h(self.pq1)
        h(self.pq2)
        h(self.pq3)
        h(self.pq4)
        h(self.pq5)
        h(self.pq6)

    @guppy
    def cx_all(self, other: SteaneQubit) -> None:
        """Binary Steane Qubit op"""
        cx(self.pq0, other.pq0)
        cx(self.pq1, other.pq1)
        cx(self.pq2, other.pq2)
        cx(self.pq3, other.pq3)
        cx(self.pq4, other.pq4)
        cx(self.pq5, other.pq5)
        cx(self.pq6, other.pq6)


@no_type_check
def steane_measure_result(steane_qb: SteaneQubit @ owned, name: str) -> None:
    """
    Measure and record results for all qubits of a SteaneQubit

    The only way to get naming to work well is to implement this method as a
    pure python function and call it within @guppy.comptime. Otherwise, the
    name string passed into the function will be a runtime guppy string, which
    cannot be printed at compile time. Also, guppy runtime doesn't have string
    operations, so strings can't be modified at runtime, which we would need to
     do here.

    :param steane_qb: The Steane Qubit to measure
    :param name: Name of Steane Qubit for result identification
    """
    result(f"{name}_0", measure(steane_qb.pq0))
    result(f"{name}_1", measure(steane_qb.pq1))
    result(f"{name}_2", measure(steane_qb.pq2))
    result(f"{name}_3", measure(steane_qb.pq3))
    result(f"{name}_4", measure(steane_qb.pq4))
    result(f"{name}_5", measure(steane_qb.pq5))
    result(f"{name}_6", measure(steane_qb.pq6))


def steane_cz(q1: SteaneQubit, q2: SteaneQubit) -> None:
    """Alternative definition of a binary Steane Qubit op"""
    cz(q1.pq0, q2.pq0)
    cz(q1.pq1, q2.pq1)
    cz(q1.pq2, q2.pq2)
    cz(q1.pq3, q2.pq3)
    cz(q1.pq4, q2.pq4)
    cz(q1.pq5, q2.pq5)
    cz(q1.pq6, q2.pq6)


@guppy.comptime
@no_type_check
def main() -> None:
    steane = SteaneQubit(*[qubit() for _ in range(7)])
    other_steane = SteaneQubit(*[qubit() for _ in range(7)])
    h(steane.pq0)
    x(steane.pq2)
    steane.h_all()
    steane.cx_all(other_steane)
    steane_cz(steane, other_steane)
    steane_measure_result(steane, "q1")
    steane_measure_result(other_steane, "q2")


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
