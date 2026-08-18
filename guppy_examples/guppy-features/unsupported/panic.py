from guppylang import guppy, qubit
from guppylang.std.platform import output, panic
from guppylang.std.quantum import h, measure, x


@guppy
def main() -> None:
    q = qubit()
    fake_ancilla = qubit()
    h(fake_ancilla)
    if measure(fake_ancilla).read():
        panic("Criteria not met")
    x(q)
    output("q", measure(q).read())
