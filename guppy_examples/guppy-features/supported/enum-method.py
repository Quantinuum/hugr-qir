from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure


@guppy.enum
class Flag:
    On = {"value": int}  # noqa: RUF012
    Off = {}  # noqa: RUF012

    @guppy
    @no_type_check
    def score(self: "Flag") -> int:
        return 1


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    flag = Flag.On(4)
    output("enum_score", flag.score())
