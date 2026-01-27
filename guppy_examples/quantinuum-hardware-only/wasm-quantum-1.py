import sys

from guppylang import guppy
from guppylang.std.qsystem.wasm import spawn_wasm_contexts
from guppylang_internals.decorator import wasm, wasm_module


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
