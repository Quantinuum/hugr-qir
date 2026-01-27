import sys
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import h, measure
from guppylang_internals.decorator import wasm, wasm_module
from guppylang.std.qsystem.wasm import spawn_wasm_contexts


@wasm_module("testfile.wasm")
class MyWasm:
    @wasm
    def add_one(self: "MyWasm", x: int) -> int: ...

    @wasm
    def multi(self: "MyWasm", x: int, y: int) -> int: ...

    @wasm
    def init(self: "MyWasm") -> None: ...


@guppy
def main() -> int:
    [mod] = spawn_wasm_contexts(1, MyWasm)
    two = mod.add_one(1)
    mod.discard()
    return two

if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
