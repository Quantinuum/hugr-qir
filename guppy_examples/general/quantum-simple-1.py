from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    x(q)
    result("0", measure(q).read())
