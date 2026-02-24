from typing import no_type_check, Generator

import guppylang_internals
from guppylang import guppy, qubit
from guppylang.std.num import nat
from guppylang.std.platform import result
from guppylang.std.qsystem.functional import measure
from guppylang_internals.decorator import wasm, wasm_module


from contextlib import contextmanager
import wasmtime as wt
from guppylang_internals.tys.ty import (
    NumericType,
    Type,
)

def h2_decode_type(ty: wt.ValType) -> Type | None:
    if ty == wt.ValType.i32():
        return NumericType(NumericType.Kind.Int)
    elif ty == wt.ValType.f64():
        return NumericType(NumericType.Kind.Float)
    else:
        return None

@contextmanager
def h_series(yes: bool) -> Generator:
    if yes:
        original = guppylang_internals.wasm_util.decode_type
        guppylang_internals.wasm_util.decode_type = h2_decode_type
        try:
            yield
        finally:
            guppylang_internals.wasm_util.decode_type = original
    else:
        yield


with h_series(True):
    @wasm_module("wasm-quantum-1.wasm")
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
