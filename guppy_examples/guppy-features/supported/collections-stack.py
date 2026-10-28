import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.collections.stack import empty_stack
from guppylang.std.quantum import measure


@guppy
@no_type_check
def main() -> None:
    output("q", measure(qubit()).read())
    # This fixed sequence can be fully simplified during QIR compilation.
    stack = empty_stack[int, 4]()
    stack.push(3)
    stack.push(5)
    output("stack_len", len(stack))
    output("stack_top", stack.pop())
    output("stack_next", stack.pop())
    stack.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
