from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output, qubit
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
@no_type_check
def main() -> None:
    cs = get_current_shot()
    output("cs", cs)
    q = qubit()
    output("result", measure(q).read())
