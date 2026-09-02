from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output


@guppy
@no_type_check
def main() -> None:
    output("bools", array(False for _ in range(64)))
