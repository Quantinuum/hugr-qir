import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result
from guppylang.std.collections.stack import empty_stack


@guppy
@no_type_check
def main() -> None:
    # Stack is backed by a runtime array, which is not supported by QIR lowering.
    stack = empty_stack[int, 4]()
    stack.push(3)
    stack.push(5)
    result("stack_len", len(stack))
    result("stack_top", stack.pop())
    result("stack_next", stack.pop())
    stack.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
