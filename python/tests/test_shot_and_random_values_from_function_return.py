from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure, x
from hugr_qir.guppy_to_qir import guppy_to_qir_str


@guppy
@no_type_check
def call_get_current_shot() -> int:
    return get_current_shot()


@guppy
@no_type_check
def call_random_int() -> int:
    r = RNG(4)
    res = r.random_int()
    r.discard()
    return res


@guppy
@no_type_check
def call_random_int_bounded() -> int:
    r = RNG(4)
    res = r.random_int_bounded(4)
    r.discard()
    return res


@guppy
@no_type_check
def main() -> None:
    current = call_get_current_shot()
    random_int = call_random_int()
    random_int_bounded = call_random_int_bounded()

    q = qubit()

    if current // 2 > 4:  # noqa: PLR2004
        x(q)
    if random_int % 3 == 2:  # noqa: PLR2004
        x(q)
    if random_int_bounded // 2 == 0:
        x(q)

    output("q", measure(q).read())
    output("shot", current)
    output("r0", random_int)
    output("r1", random_int_bounded)


def test_int_to_nat_within_call() -> None:
    guppy_to_qir_str(main, validate_qir=True)
