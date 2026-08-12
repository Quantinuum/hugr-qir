from typing import no_type_check

from guppylang import guppy
from guppylang.std.angles import angle, pi
from guppylang.std.builtins import output, qubit
from guppylang.std.quantum import measure, rz


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    theta = (pi / 2.0) + angle(0.25)
    rz(q, theta)
    output("angle", measure(q).read())
