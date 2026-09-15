"""Probe runtime unsigned division with the high bit of an i64 set.

Hardware regression probe: an H2 run of 30 shots matched LLVM's unsigned
semantics for every reported quotient and remainder. This contradicts the earlier
hypothesis that a runtime dividend with its high bit set is interpreted as signed.
It verifies this example, not every possible unsigned dividend or divisor.

For shot s, the unsigned dividend is 2**63 + s and the constant divisor is 3.
The shot counter keeps the dividend runtime-dependent, preventing constant folding.

Expected outputs under LLVM's unsigned semantics:
  quotient = (2**63 + s) // 3
  remainder = (2**63 + s) % 3

Use the output "shot" to calculate expectations: get_current_shot() returned
1 through 30 in that run, even though the result records were indexed 0 through 29.

Representative expected AND observed outputs:
  shot          quotient          remainder
    1     3074457345618258603          0
    2     3074457345618258603          1
    3     3074457345618258603          2
    4     3074457345618258604          0
   30     3074457345618258612          2

For comparison, signed-register floor division would give quotient
-3074457345618258603 and remainder 2 at shot 1. That was NOT observed.

The program also measures exactly one qubit, initially |0>, and outputs "q".
Ideally q is false; this measurement is independent of the arithmetic probe.
All 30 measurements in the reported run were false.
"""

from guppylang import guppy, qubit
from guppylang.std.num import nat
from guppylang.std.platform import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    shot = get_current_shot()
    # Construct 2**63 in nat arithmetic: an int literal of 2**63 is rejected.
    high_bit = nat(4611686018427387904) * nat(2)
    dividend = high_bit + nat(shot)

    output("shot", shot)
    output("quotient", dividend // nat(3))
    output("remainder", dividend % nat(3))

    q = qubit()
    output("q", measure(q).read())
