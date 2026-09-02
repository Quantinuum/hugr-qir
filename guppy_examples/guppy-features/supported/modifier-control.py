import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import control, output, qubit
from guppylang.std.quantum import h, measure, x


@guppy
@no_type_check
def main() -> None:
    ctl = qubit()
    target = qubit()
    h(ctl)

    with control(ctl):
        x(target)

    output("control_target", measure(target).read())
    output("control_ctl", measure(ctl).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
