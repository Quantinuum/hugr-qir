from collections.abc import Generator
from contextlib import contextmanager
from typing import no_type_check

import guppylang_internals
import wasmtime as wt
from guppylang import guppy, qubit
from guppylang.std.num import nat
from guppylang.std.platform import result
from guppylang.std.qsystem.functional import measure
from guppylang_internals.decorator import wasm, wasm_module
from guppylang_internals.wasm_util import WasmPlatform
from guppylang_internals.tys.ty import (
    NumericType,
    Type,
)


@wasm_module("wasm-quantum-1.wasm", wasm_platform=WasmPlatform.H2)
@no_type_check
class MyWasm:
    @wasm
    @no_type_check
    def add_one(self: "MyWasm", x: int) -> int: ...

    @wasm
    @no_type_check
    def multi(self: "MyWasm", x: int, y: int) -> int: ...

    @wasm
    @no_type_check
    def init(self: "MyWasm") -> None: ...


@guppy.comptime
@no_type_check
def main() -> None:
    qub = qubit()
    mod = MyWasm(nat(1))
    two = mod.add_one(1)
    six = mod.multi(2, 3)
    mod.discard()
    result("qub", measure(qub))
    result("2 + 6", two + six)
