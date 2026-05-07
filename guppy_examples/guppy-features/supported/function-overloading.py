import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.platform import result
from guppylang.std.quantum import measure, x


@guppy
def one_state() -> qubit:
    q = qubit()
    x(q)
    return q


@guppy
def apply_x(q: qubit) -> None:
    x(q)


@guppy.overload(one_state, apply_x)
@no_type_check
def apply_x_to_something(): ...  # noqa: ANN201


@guppy
@no_type_check
def main() -> None:
    q = qubit()

    # compiler dispatches apply_x() to be used here
    apply_x_to_something(q)

    # compiler dispatches one_state() to be used here
    other_q = apply_x_to_something()

    result("q", measure(q))
    result("other_q", measure(other_q))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
