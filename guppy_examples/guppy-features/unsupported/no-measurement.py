from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output


@guppy
@no_type_check
def main() -> None:
    output("test", 0)
