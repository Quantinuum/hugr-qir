import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.collections.stack import empty_stack


@guppy
@no_type_check
def main() -> None:
    # The stack's data-dependent internal loops cannot be fully unrolled for QIR.
    stack = empty_stack[int, 4]()
    stack.push(3)
    stack.push(5)
    output("stack_len", len(stack))
    output("stack_top", stack.pop())
    output("stack_next", stack.pop())
    stack.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
