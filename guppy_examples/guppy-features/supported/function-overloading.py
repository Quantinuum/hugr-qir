import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.platform import result
from guppylang.std.quantum import h, measure


@guppy
def plus_state() -> qubit:
    q = qubit()
    h(q)
    return q


@guppy
def apply_h(q: qubit) -> None:
    h(q)


@guppy.overload(plus_state, apply_h)
@no_type_check
def apply_h_to_something(): ...  # noqa: ANN201


@guppy
@no_type_check
def main() -> None:
    q = qubit()

    # compiler dispatches apply_h() to be used here
    apply_h_to_something(q)

    # compiler dispatches plus_state() to be used here
    other_q = apply_h_to_something()

    result("q", measure(q))
    result("other_q", measure(other_q))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
