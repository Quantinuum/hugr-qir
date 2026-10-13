"""Run five-to-one distillation with three attempts and an Option result."""

import math

from guppylang import guppy
from guppylang.std.angles import angle, pi
from guppylang.std.builtins import array, output, owned
from guppylang.std.option import Option, nothing, some
from guppylang.std.quantum import (
    cz,
    discard,
    h,
    measure,
    qubit,
    ry,
    rz,
)

COMPONENT = (
    "Five-to-one T-state distillation with recursive retries and Option ownership"
)
QUBIT_BUDGET = 5
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/t_factory.html"
PHI = math.acos(1 / 3)


@guppy
def prepare_approx() -> qubit:
    q = qubit()
    ry(q, angle(PHI))
    rz(q, pi / 4)
    return q


@guppy
def distill(
    target: qubit @ owned, ancillas: array[qubit, 4] @ owned
) -> tuple[qubit, bool]:
    cz(ancillas[0], ancillas[1])
    cz(ancillas[2], ancillas[3])
    cz(target, ancillas[0])
    cz(ancillas[1], ancillas[2])
    cz(target, ancillas[3])
    for i in range(4):
        h(ancillas[i])
    success = True
    for q in ancillas:
        success &= not measure(q).read()
    return target, success


@guppy
def t_state(attempts: int) -> Option[qubit]:
    if attempts > 0:
        target = prepare_approx()
        ancillas = array(prepare_approx() for _ in range(4))
        q, success = distill(target, ancillas)
        if success:
            return some(q)
        discard(q)
        return t_state(attempts - 1)
    return nothing()


@guppy
def main() -> None:
    option = t_state(3)
    if option.is_some():
        q = option.unwrap()
        bit = measure(q).read()
        output("outcome", array(True, bit))
    else:
        option.unwrap_nothing()
        output("outcome", array(False, False))


def expected_probabilities() -> dict:
    from _references import distilled_probabilities  # noqa: PLC0415

    return {"outcome": distilled_probabilities()}
