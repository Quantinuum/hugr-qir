from typing import no_type_check

from guppylang import guppy
from guppylang.std.angles import pi
from guppylang.std.builtins import dagger, qubit, result
from guppylang.std.quantum import measure, rz, x


@guppy
@no_type_check
def main() -> None:
    target = qubit()

    with dagger():
        rz(target, pi / 4.0)
        x(target)

    result("dagger_target", measure(target).read())
