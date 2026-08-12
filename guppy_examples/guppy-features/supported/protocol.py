from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result


@guppy.protocol
class HasWeight:
    @guppy.require
    def weight(self: "HasWeight") -> int: ...


@guppy.struct
class WeightedInt:
    value: int

    @guppy
    @no_type_check
    def weight(self: "WeightedInt") -> int:
        return self.value


@guppy
@no_type_check
def read_weight(x: HasWeight) -> int:
    return x.weight()


@guppy
@no_type_check
def main() -> None:
    result("protocol_weight", read_weight(WeightedInt(3)))
