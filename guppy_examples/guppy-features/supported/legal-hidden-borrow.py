"""Hidden borrow

Guppy functions such as apply_subscript here could potentially perform on operation that
violates linearity, but the borrow checker cannot catch it at guppy->hugr compile time.
In such cases a runtime check is added and the code will panic at runtime if a violation
 occurs.

For hugr to qir, the array indices must be made static at hugr->qir compilation time.
 If they can be made static, and no violations actually occur, the panic branch will
  also be optimized away and the code compiles.

If not, the panic branch will survive and qircheck will fail, see corresponding
 example under "unsupported"
"""

from guppylang import guppy, qubit
from guppylang.std.builtins import array
from guppylang.std.platform import output
from guppylang.std.quantum import collect_measurements, cx, measure_array


@guppy
def apply_subscript(qs: array[qubit, 10], i: int) -> None:
    cx(qs[0], qs[i])


@guppy
def main() -> None:
    qbs = array(qubit() for _ in range(10))
    apply_subscript(qbs, 1)
    apply_subscript(qbs, 4)
    output("qbs", collect_measurements(measure_array(qbs)))
