from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    value = get_current_shot() - 5

    output("quotient_positive", value // 3)
    output("remainder_positive", value % 3)
    q = qubit()
    output("q", measure(q).read())
