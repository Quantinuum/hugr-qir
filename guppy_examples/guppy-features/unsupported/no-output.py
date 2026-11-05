from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.qsystem import measure


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    measure(q).read()
