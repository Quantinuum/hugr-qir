from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result


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
    flag = Flag.On(4)
    result("enum_score", flag.score())
