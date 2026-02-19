from pathlib import Path
from typing import no_type_check

import pytest
from guppylang import guppy, qubit
from guppylang.std.platform import result
from guppylang.std.quantum import measure
from guppylang_internals.decorator import wasm, wasm_module
from tket_exts import tket_registry

from hugr_qir.hugr_to_qir import hugr_to_qir


def test_wasm_functions(wasm_file: Path) -> None:
    wasm_file_str = str(wasm_file)

    @wasm_module(wasm_file_str)
    @no_type_check
    class MyWasm:
        @wasm
        @no_type_check
        def two(self: "MyWasm") -> int: ...

        @wasm
        @no_type_check
        def add(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm
        @no_type_check
        def fid(self: "MyWasm", x: float) -> float: ...

        @wasm
        @no_type_check
        def consume_float(self: "MyWasm", x: float) -> None: ...

        @wasm
        @no_type_check
        def nothing(self: "MyWasm") -> None: ...

    @guppy
    @no_type_check
    def main() -> None:
        mod1 = MyWasm(1)
        two1 = mod1.two()
        two2 = mod1.two()
        four = mod1.add(two1, two2)
        mod1.consume_float(1.0)
        q = qubit()
        mod1.discard()
        result("six", four + two2)
        result("q", measure(q))

    hugr = main.compile()
    # TODO: Can remove once extension handling fixed in guppy
    hugr.extensions.append(tket_registry().get_extension("tket.rotation"))
    hugr_to_qir(hugr, validate_qir=False, wasm_file=wasm_file)


def test_error_on_wasm_function_that_returns_float(wasm_file: Path) -> None:
    wasm_file_str = str(wasm_file)

    @wasm_module(wasm_file_str)
    @no_type_check
    class MyWasm:
        @wasm
        @no_type_check
        def two(self: "MyWasm") -> int: ...

        @wasm
        @no_type_check
        def add(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm
        @no_type_check
        def fid(self: "MyWasm", x: float) -> float: ...

        @wasm
        @no_type_check
        def consume_float(self: "MyWasm", x: float) -> None: ...

        @wasm
        @no_type_check
        def nothing(self: "MyWasm") -> None: ...

    @guppy
    @no_type_check
    def main() -> None:
        mod1 = MyWasm(1)
        two1 = mod1.two()
        two2 = mod1.two()
        four = mod1.add(two1, two2)
        f = mod1.fid(42.0)
        mod1.consume_float(f)
        q = qubit()
        mod1.discard()
        result("six", four + two2)
        result("q", measure(q))

    hugr = main.compile()
    # TODO: Can remove once extension handling fixed in guppy
    hugr.extensions.append(tket_registry().get_extension("tket.rotation"))
    with pytest.raises(ValueError, match=r"(?=.*wasm return type error)(?=.*float64)"):
        hugr_to_qir(hugr, validate_qir=False, wasm_file=wasm_file)


def test_wasm_function_indices(wasm_file: Path) -> None:
    wasm_file_str = str(wasm_file)

    @wasm_module(wasm_file_str)
    @no_type_check
    class MyWasm:
        @wasm(1)
        @no_type_check
        def foo(self: "MyWasm") -> int: ...

        @wasm(0)
        @no_type_check
        def bar(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm(3)
        @no_type_check
        def baz(self: "MyWasm", x: float) -> None: ...

        @wasm(4)
        @no_type_check
        def side_effect(self: "MyWasm") -> None: ...

    @guppy
    @no_type_check
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
    # TODO: Can remove once extension handling fixed in guppy
    hugr.extensions.append(tket_registry().get_extension("tket.rotation"))
    hugr_to_qir(hugr, validate_qir=True, wasm_file=wasm_file)


def test_wasm_methods(wasm_file: Path) -> None:
    wasm_file_str = str(wasm_file)

    @wasm_module(wasm_file_str)
    @no_type_check
    class MyWasm:
        @wasm
        @no_type_check
        def two(self: "MyWasm") -> int: ...

        @guppy
        @no_type_check
        def bar(self: "MyWasm", x: int) -> int:
            return x + 1

    @guppy
    @no_type_check
    def main() -> None:
        mod = MyWasm(1)
        x = mod.two()
        y = mod.bar(x)
        mod.discard()
        result("bla", x + y)

    hugr = main.compile()
    # TODO: Can remove once extension handling fixed in guppy
    hugr.extensions.append(tket_registry().get_extension("tket.rotation"))
    hugr_to_qir(hugr, validate_qir=True, wasm_file=wasm_file)
