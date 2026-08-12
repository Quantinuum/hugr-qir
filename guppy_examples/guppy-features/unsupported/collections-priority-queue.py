import sys
from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.collections.priority_queue import empty_priority_queue


@guppy
@no_type_check
def main() -> None:
    # PriorityQueue is backed by a runtime array, which is not supported by QIR
    # lowering.
    queue = empty_priority_queue[int, 4]()
    queue.push(30, 3)
    queue.push(10, 1)
    queue.push(20, 2)
    output("priority_queue_len", len(queue))
    first_priority, first_value = queue.pop()
    second_priority, second_value = queue.pop()
    output("priority_queue_first_priority", first_priority)
    output("priority_queue_first_value", first_value)
    output("priority_queue_second_priority", second_priority)
    output("priority_queue_second_value", second_value)
    _, final_value = queue.pop()
    output("priority_queue_final_value", final_value)
    queue.discard_empty()


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
