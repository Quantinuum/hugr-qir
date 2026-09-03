import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output, qubit
from guppylang.std.collections.stack import empty_stack
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import discard, measure, x


@guppy
@no_type_check
def main() -> None:
    # The stack's top qubit depends on a runtime value, so the qubit used by the
    # x gate cannot be reduced to a single static address.
    stack = empty_stack[qubit, 2]()
    stack.push(qubit())
    second = qubit()
    push_second = get_current_shot() % 2 == 0
    if push_second:
        stack.push(second)
    else:
        discard(second)

    top = stack.pop()
    x(top)
    output("stack_top", measure(top).read())
    if push_second:
        discard(stack.pop())
    stack.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
