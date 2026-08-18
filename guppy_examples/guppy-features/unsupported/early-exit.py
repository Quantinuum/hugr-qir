from guppylang import guppy, qubit
from guppylang.std.builtins import exit, output  # noqa: A004
from guppylang.std.quantum import h, measure, x


@guppy
def main() -> None:
    q = qubit()
    fake_ancilla = qubit()
    h(fake_ancilla)
    if measure(fake_ancilla).read():
        exit("Postselected: Criteria not met", 1)
    x(q)
    output("q", measure(q).read())
