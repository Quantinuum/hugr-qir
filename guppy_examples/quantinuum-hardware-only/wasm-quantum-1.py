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
from guppylang_internals.tys.ty import (
    NumericType,
    Type,
)


def h2_decode_type(ty: wt.ValType) -> Type | None:
    if ty == wt.ValType.i32():
        return NumericType(NumericType.Kind.Int)
    return None


# This context manager is a workaround to make H2 wasm files
# work with current guppy. We are working on adding a parameter
# to the wasm_module decorator to fix this guppy-side and this
# can be removed once that is released
@contextmanager
def h_series() -> Generator:
    original = guppylang_internals.wasm_util.decode_type
    guppylang_internals.wasm_util.decode_type = h2_decode_type
    try:
        yield
    finally:
        guppylang_internals.wasm_util.decode_type = original


with h_series():

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
