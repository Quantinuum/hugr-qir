import sys

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, x


@guppy
def a_function(n: int) -> int:
    return n + 1


@guppy
def b_function() -> qubit:
    q1, q2 = qubit(), qubit()
    x(q1)
    if measure(q1).read():
        x(q2)
    return q2


@guppy
def main() -> None:
    # bind a variable to our function
    q_func = b_function
    my_function = a_function
    res = my_function(100)
    output("res", res)
    output("q", measure(q_func()).read())


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
