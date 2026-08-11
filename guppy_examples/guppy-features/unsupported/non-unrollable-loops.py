import sys

from guppylang import guppy
from guppylang.std.quantum import h, measure, qubit


@guppy
def main() -> None:
    while True:
        q1 = qubit()
        h(q1)
        if not measure(q1).read():
            break


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
