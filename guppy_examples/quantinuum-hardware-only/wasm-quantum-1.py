import sys

from guppylang import guppy
from guppylang.std.num import nat
from guppylang.std.platform import result
from guppylang.std.qsystem.wasm import spawn_wasm_contexts, spawn_wasm_context
from guppylang_internals.decorator import wasm, wasm_module


@wasm_module("wasm-quantum-1.wasm")
class MyWasm:
    @wasm
    def add_one(self: "MyWasm", x: int) -> int: ...

    @wasm
    def multi(self: "MyWasm", x: int, y: int) -> int: ...

    @wasm
    def init(self: "MyWasm") -> None: ...




@guppy.comptime
def main() -> None:
    mod = MyWasm(nat(1))
    two = mod.add_one(1)
    six = mod.multi(2,3)
    mod.discard()
    result("2 + 6", two + six)


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
