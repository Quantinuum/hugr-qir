from pathlib import Path
from typing import Any, no_type_check

import pytest
from guppylang import guppy, qubit
from guppylang.std.platform import result
from guppylang.std.quantum import measure
from guppylang_internals.decorator import wasm, wasm_module
from guppylang_internals.error import GuppyError
from guppylang_internals.std._internal.wasm import WasmPlatform
from hugr_qir.hugr_to_qir import hugr_to_qir


def get_h2_wasm_mod(wasm_file_path: Path) -> Any:  # noqa: ANN401, C901
    @wasm_module(str(wasm_file_path), wasm_platform=WasmPlatform.H2)
    @no_type_check
    class MyWasm:
        @wasm
        @no_type_check
        def init(self: "MyWasm") -> None: ...

        @wasm(1)
        @no_type_check
        def init_id(self: "MyWasm") -> None: ...

        @wasm
        @no_type_check
        def add_one(self: "MyWasm", x: int) -> int: ...

        @wasm(2)
        @no_type_check
        def add_one_id(self: "MyWasm", x: int) -> int: ...

        @wasm
        @no_type_check
        def multi(self: "MyWasm", x: int, y: int) -> int: ...
        @wasm(3)
        @no_type_check
        def multi_id(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm
        @no_type_check
        def no_parameters(self: "MyWasm") -> int: ...

        @wasm(8)
        @no_type_check
        def no_parameters_id(self: "MyWasm") -> int: ...

        @wasm
        @no_type_check
        def no_return(self: "MyWasm", x: int) -> None: ...

        @wasm(7)
        @no_type_check
        def no_return_id(self: "MyWasm", x: int) -> None: ...

    return MyWasm


def get_faulty_func_h2_wasm_mod(wasm_file_path: Path) -> Any:  # noqa: ANN401
    @wasm_module(str(wasm_file_path), wasm_platform=WasmPlatform.H2)
    @no_type_check
    class MyWasm:
        # add something uses i64 and will therefore fail validation
        @wasm
        @no_type_check
        def add_something(self: "MyWasm", x: int) -> int: ...

    return MyWasm


def test_h2_wasm_mod_supported_functions(h2_wasm_file: Path) -> None:
    wasm_module_class = get_h2_wasm_mod(h2_wasm_file)

    @guppy
    @no_type_check
    def main() -> None:
        q = qubit()
        mod1 = wasm_module_class(1)
        mod1.init()
        mod1.init_id()
        three = mod1.add_one(2)
        four = mod1.add_one_id(3)
        twelve = mod1.multi(three, four)
        thirty_six = mod1.multi_id(twelve, three)
        new_int = mod1.no_parameters()
        new_int2 = mod1.no_parameters_id()
        mod1.no_return(thirty_six)
        mod1.no_return_id(new_int)
        mod1.discard()
        result("q", measure(q).read())
        result("new_int2", new_int2)

    hugr = main.compile()
    hugr_to_qir(hugr, wasm_file=h2_wasm_file)


def test_h2_wasm_mod_unsupported_function(h2_wasm_file: Path) -> None:
    with pytest.raises(GuppyError):
        get_faulty_func_h2_wasm_mod(h2_wasm_file)


def get_helios_wasm_mod(wasm_file_path: Path) -> Any:  # noqa: ANN401, C901
    @wasm_module(str(wasm_file_path), wasm_platform=WasmPlatform.Helios)
    @no_type_check
    class MyWasm:
        @wasm
        @no_type_check
        def add(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm(0)
        @no_type_check
        def add_id(self: "MyWasm", x: int, y: int) -> int: ...

        @wasm
        @no_type_check
        def two(self: "MyWasm") -> int: ...

        @wasm(1)
        @no_type_check
        def two_id(self: "MyWasm") -> int: ...

        @wasm
        @no_type_check
        def fid(self: "MyWasm", x: float) -> float: ...

        @wasm(2)
        @no_type_check
        def fid_id(self: "MyWasm", x: float) -> float: ...

        @wasm
        @no_type_check
        def consume_float(self: "MyWasm", x: float) -> None: ...

        @wasm(3)
        @no_type_check
        def consume_float_id(self: "MyWasm", x: float) -> None: ...

        @wasm
        @no_type_check
        def nothing(self: "MyWasm") -> None: ...

        @wasm(4)
        @no_type_check
        def nothing_id(self: "MyWasm") -> None: ...

    return MyWasm


def compile_helios_single_call_hugr(  # noqa: C901, PLR0915
    helios_wasm_file: Path,
    func_name: str,
    lookup_by_id: bool,  # noqa: FBT001
) -> Any:  # noqa: ANN401
    wasm_module_class = get_helios_wasm_mod(helios_wasm_file)

    if func_name == "add" and lookup_by_id:

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.add_id(1, 2)
            mod1.discard()
            result("x", x)
    elif func_name == "add":

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.add(1, 2)
            mod1.discard()
            result("x", x)
    elif func_name == "two" and lookup_by_id:

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.two_id()
            mod1.discard()
            result("x", x)
    elif func_name == "two":

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.two()
            mod1.discard()
            result("x", x)
    elif func_name == "fid" and lookup_by_id:

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.fid_id(0.4)
            mod1.discard()
            result("x", x)
    elif func_name == "fid":

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            x = mod1.fid(0.4)
            mod1.discard()
            result("x", x)
    elif func_name == "consume_float" and lookup_by_id:

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            mod1.consume_float_id(0.4)
            q = qubit()
            mod1.discard()
            result("q", measure(q).read())
    elif func_name == "consume_float":

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            mod1.consume_float(0.4)
            q = qubit()
            mod1.discard()
            result("q", measure(q).read())
    elif func_name == "nothing" and lookup_by_id:

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            mod1.nothing_id()
            q = qubit()
            mod1.discard()
            result("q", measure(q).read())
    elif func_name == "nothing":

        @guppy
        @no_type_check
        def main() -> None:
            mod1 = wasm_module_class(1)
            mod1.nothing()
            q = qubit()
            mod1.discard()
            result("q", measure(q).read())
    else:
        raise ValueError

    return main.compile()


def test_loading_but_not_using_helios_wasm_mod_is_not_an_error(
    helios_wasm_file: Path,
) -> None:
    wasm_module_class = get_helios_wasm_mod(helios_wasm_file)

    @guppy
    @no_type_check
    def main() -> None:
        mod1 = wasm_module_class(1)
        q = qubit()
        mod1.discard()
        result("q", measure(q).read())

    hugr = main.compile()
    hugr_to_qir(hugr, wasm_file=helios_wasm_file)


@pytest.mark.parametrize(
    ("func_name", "lookup_by_id", "match"),
    [
        (
            "add",
            False,
            (
                r"(?=.*wasm function)(?=.*add)"
                "(?=.*unsupported parameter types)(?=.*i64)"
            ),
        ),
        (
            "add",
            True,
            (
                r"(?=.*wasm function)(?=.*add)"
                "(?=.*unsupported parameter types)(?=.*i64)"
            ),
        ),
        (
            "two",
            False,
            (
                r"(?=.*wasm function)(?=.*two)"
                "(?=.*unsupported result type)(?=.*i64)"
            ),
        ),
        (
            "two",
            True,
            (
                r"(?=.*wasm function)(?=.*two)"
                "(?=.*unsupported result type)(?=.*i64)"
            ),
        ),
        (
            "fid",
            False,
            (
                r"(?=.*wasm function)(?=.*fid)"
                "(?=.*unsupported parameter types)(?=.*f64)"
            ),
        ),
        (
            "fid",
            True,
            (
                r"(?=.*wasm function)(?=.*fid)"
                "(?=.*unsupported parameter types)(?=.*f64)"
            ),
        ),
        (
            "consume_float",
            False,
            (
                r"(?=.*wasm function)(?=.*consume_float)"
                "(?=.*unsupported parameter types)(?=.*f64)"
            ),
        ),
        (
            "consume_float",
            True,
            (
                r"(?=.*wasm function)(?=.*consume_float)"
                "(?=.*unsupported parameter types)(?=.*f64)"
            ),
        ),
    ],
    ids=[
        "add_by_name",
        "add_by_id",
        "two_by_name",
        "two_by_id",
        "fid_by_name",
        "fid_by_id",
        "consume_float_by_name",
        "consume_float_by_id",
    ],
)
def test_unsupported_helios_wasm_funcs_throw_on_lookup(
    helios_wasm_file: Path,
    func_name: str,
    lookup_by_id: bool,  # noqa: FBT001
    match: str,
) -> None:
    hugr = compile_helios_single_call_hugr(helios_wasm_file, func_name, lookup_by_id)
    with pytest.raises(ValueError, match=match):
        hugr_to_qir(hugr, wasm_file=helios_wasm_file)


@pytest.mark.parametrize(
    "lookup_by_id",
    [False, True],
    ids=["by_name", "by_id"],
)
def test_helios_wasm_func_with_no_param_or_return_succeeds(
    helios_wasm_file: Path,
    lookup_by_id: bool,  # noqa: FBT001
) -> None:
    hugr = compile_helios_single_call_hugr(helios_wasm_file, "nothing", lookup_by_id)
    hugr_to_qir(hugr, wasm_file=helios_wasm_file)
