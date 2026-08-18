from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, x


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    x(q)
    output("0", measure(q).read())
