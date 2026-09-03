import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.collections.queue import empty_queue


@guppy
@no_type_check
def main() -> None:
    # The queue's data-dependent internal loops cannot be fully unrolled for QIR.
    queue = empty_queue[int, 4]()
    queue.push(3)
    queue.push(5)
    output("queue_len", len(queue))
    output("queue_front", queue.pop())
    output("queue_next", queue.pop())
    queue.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
