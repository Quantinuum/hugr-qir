from guppylang import guppy, qubit
from guppylang.std.platform import panic, result
from guppylang.std.quantum import h, measure, x


@guppy
def main() -> None:
    q = qubit()
    fake_ancilla = qubit()
    h(fake_ancilla)
    if measure(fake_ancilla).read():
        panic("Criteria not met")
    x(q)
    result("q", measure(q).read())
