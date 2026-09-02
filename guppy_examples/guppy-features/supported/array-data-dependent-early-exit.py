import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import array, output, qubit
from guppylang.std.quantum import h, measure, x


@guppy
@no_type_check
def main() -> None:
    selector = qubit()
    h(selector)
    stop_early = measure(selector).read()
    target = qubit()

    # Although the exact exit iteration depends on a measurement, the fixed
    # array size gives LLVM a finite upper bound that it can expand into
    # guarded, acyclic control flow.
    values = array(i + 10 for i in range(4))
    for _ in values:
        x(target)
        if stop_early:
            break

    output("target", measure(target).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
