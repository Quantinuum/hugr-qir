from guppylang import guppy, qubit
from guppylang.std.platform import output
from guppylang.std.quantum import h, measure


@guppy
def main() -> None:
    ip = qubit()
    h(ip)
    r = measure(ip)
    output("r", r.read())

    if r:
        output("true", True)
    else:
        output("false", True)
