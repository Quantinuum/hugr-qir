from guppylang import array, guppy, qubit
from guppylang.std.platform import output
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("duplicated", 1)
    output("duplicated", measure(qubit()).read())
    output("duplicated", array(4, 5, 6))
    output("duplicated", array(True, False, True))
