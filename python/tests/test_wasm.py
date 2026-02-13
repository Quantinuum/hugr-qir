from pathlib import Path

from guppylang import guppy
from guppylang.std.platform import result
from guppylang_internals.decorator import wasm, wasm_module
from hugr_qir.hugr_to_qir import hugr_to_qir


def test_wasm_functions(wasm_file: Path) -> None:
    @wasm_module(wasm_file)
    class MyWasm:
        @wasm
        def two(self: "MyWasm") -> int: ...

        @wasm
        def add(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm
        def fid(self: "MyWasm", x: float) -> float: ...

        @wasm
        def consume_float(self: "MyWasm", x: float) -> None: ...

        @wasm
        def nothing(self: "MyWasm") -> None: ...

    @guppy
    def main() -> None:
        mod1 = MyWasm(1)
        two1 = mod1.two()
        two2 = mod1.two()
        four = mod1.add(two1, two2)
        f = mod1.fid(42.0)
        mod1.consume_float(f)
        mod1.discard()
        result("six", four + two2)

    hugr = main.compile()
    hugr_to_qir(hugr, validate_qir=True, wasm_file=wasm_file)


def test_wasm_function_indices(wasm_file) -> None:
    @wasm_module(wasm_file)
    class MyWasm:
        @wasm(1)
        def foo(self: "MyWasm") -> int: ...

        @wasm(0)
        def bar(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm(3)
        def baz(self: "MyWasm", x: float) -> None: ...

        @wasm(4)
        def side_effect(self: "MyWasm") -> None: ...

    @guppy
    def main() -> None:
        mod = MyWasm(1)
        two1 = mod.foo()
        two2 = mod.foo()
        four = mod.bar(two1, two2)
        mod.baz(42.0)
        mod.side_effect()
        mod.discard()
        result("six", four + two2)

    hugr = main.compile()
    hugr_to_qir(hugr, validate_qir=True, wasm_file=wasm_file)


def test_wasm_methods(wasm_file):
    @wasm_module(wasm_file)
    class MyWasm:
        @wasm
        def two(self: "MyWasm") -> int: ...

        @guppy
        def bar(self: "MyWasm", x: int) -> int:
            return x + 1

    @guppy
    def main() -> None:
        mod = MyWasm(1)
        x = mod.two()
        y = mod.bar(x)
        mod.discard()
        result("bla", x + y)

    hugr = main.compile()
    hugr_to_qir(hugr, validate_qir=True, wasm_file=wasm_file)
