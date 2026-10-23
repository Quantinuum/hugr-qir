import sys

from guppylang import guppy
from guppylang.std.platform import output
from guppylang.std.quantum import h, measure, qubit


@guppy
def main() -> None:
    while True:
        q1 = qubit()
        h(q1)
        if not measure(q1).read():
            break
    output("completed", 1)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
