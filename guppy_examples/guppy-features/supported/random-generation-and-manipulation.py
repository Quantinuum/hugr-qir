from typing import no_type_check

from guppylang import enable_experimental_features, guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.num import nat
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import h, measure, x

enable_experimental_features()


@guppy
@no_type_check
def main() -> None:
    shot = get_current_shot()
    q0 = qubit()
    h(q0)
    r = RNG(11)
    random_nr = r.random_int_bounded(10)
    random_nr2 = r.random_int()
    r.discard()
    output("0", measure(q0).read())

    output("shot", shot)
    output("random_nr", random_nr)
    output("random_nr2", random_nr2)

    shot_ = nat(shot)
    random_nr_ = nat(random_nr)
    random_nr2_ = nat(random_nr2)

    output("shot_", shot_)
    output("random_nr_", random_nr_)
    output("random_nr2_", random_nr2_)

    q = qubit()
    mod3 = random_nr_ % 3
    if mod3 == 0:
        h(q)
    elif mod3 == 1:
        x(q)
    elif mod3 == 2:
        h(q)
        x(q)

    output("q", measure(q).read())

    q2 = qubit()
    div3 = random_nr_ // 3
    if div3 == 0:
        h(q2)
    elif div3 == 1:
        x(q2)
    elif div3 == 2:
        h(q2)
        x(q2)

    output("q2", measure(q2).read())
