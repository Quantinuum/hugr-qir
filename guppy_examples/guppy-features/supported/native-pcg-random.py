from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result
from guppylang.std.num import nat
from guppylang.std.random import seeded_pcg32


@guppy
@no_type_check
def main() -> None:
    rng = seeded_pcg32(nat(7))
    result("pcg_bounded", rng.next_int_bounded(nat(6)))
    result("pcg_next", rng.next_int())
