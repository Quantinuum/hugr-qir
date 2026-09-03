import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.collections.queue import empty_queue
from guppylang.std.qsystem.utils import get_current_shot


@guppy
@no_type_check
def main() -> None:
    # The queue's size depends on a runtime value, so its backing storage cannot
    # be fully removed during QIR compilation.
    queue = empty_queue[int, 4]()
    queue.push(3)
    push_second = get_current_shot() % 2 == 0
    if push_second:
        queue.push(5)

    output("queue_len", len(queue))
    if push_second:
        queue.pop()
    queue.pop()
    queue.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
