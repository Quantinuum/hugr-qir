import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import result
from guppylang.std.collections.queue import empty_queue


@guppy
@no_type_check
def main() -> None:
    # Queue is backed by a runtime array, which is not supported by QIR lowering.
    queue = empty_queue[int, 4]()
    queue.push(3)
    queue.push(5)
    result("queue_len", len(queue))
    result("queue_front", queue.pop())
    result("queue_next", queue.pop())
    queue.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
