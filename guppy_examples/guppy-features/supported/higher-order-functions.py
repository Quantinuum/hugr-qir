import sys
from collections.abc import Callable

from guppylang import guppy
from guppylang.std.platform import result


@guppy
def my_function(f: Callable[[int], bool]) -> Callable[[int], bool]:
    # Takes a callable `f` that accepts an integer and returns a boolean.
    return f


@guppy
def main() -> None:
    def is_even(n: int) -> bool:
        return n % 2 == 0

    # # Apply our higher order function `my_function` to `is_even`
    my_function_composition = my_function(is_even)

    res = my_function_composition(42)
    result("res", res)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
