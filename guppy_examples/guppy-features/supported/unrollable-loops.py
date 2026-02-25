import sys

from guppylang import guppy
from guppylang.std.platform import result
from guppylang.std.quantum import h, measure, qubit, x


@guppy
def main() -> None:
    i = 10
    q1 = qubit()
    while True:
        if i % 2 == 0:
            h(q1)
        else:
            x(q1)
        if i == 0:
            break
        i -= 1

    for _ in range(30):
        x(q1)

    result("q", measure(q1))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
