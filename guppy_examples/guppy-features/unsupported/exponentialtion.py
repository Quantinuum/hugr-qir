import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit


@guppy
@no_type_check
def main() -> None:
    kng = 1
    for i in range(3):
        for j in range(3):
            kng += 3 ** (i + j)
    output("kng", kng)
