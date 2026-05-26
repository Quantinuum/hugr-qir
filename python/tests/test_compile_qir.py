import re
from importlib.metadata import version
from typing import no_type_check

import pytest
from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from hugr_qir.guppy_to_qir import guppy_to_qir_str
from hugr_qir.hugr_to_qir import to_qir_str
from hugr_qir.output import GENERATOR_SECTION


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    h(q0)
    h(q1)

    b0 = measure(q0)
    b1 = measure(q1)
    b2 = b0 ^ b1

    result("0", b2)


hugr_package = main.compile()


def rustify_version(version_str: str) -> str:
    return re.sub(r"^(\d+\.\d+\.\d+)rc(\d+)$", r"\1-rc.\2", version_str)


def test_hugr_package_to_qir() -> None:
    qir = to_qir_str(hugr_package)
    assert len(qir) > 10  # noqa: PLR2004


def test_guppy_entrypoint_to_qir() -> None:
    qir = guppy_to_qir_str(main)
    assert len(qir) > 10  # noqa: PLR2004


def test_generated_qir_uses_qir_1_runtime_contracts(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    # remove version override for this test only
    monkeypatch.delenv("HUGR_QIR_VERSION_TEST_OVERRIDE", raising=False)
    qir = guppy_to_qir_str(main, validate_qir=True)
    package_version = rustify_version(version("hugr-qir"))

    assert "__quantum__rt__read_result" in qir
    assert "__quantum__qis__read_result__body" not in qir
    assert 'qir_profiles"="adaptive_profile"' in qir
    gen_name_pattern = (
        rf"@gen_name = private unnamed_addr constant "
        rf'\[8 x i8\] c"hugr-qir", section "{re.escape(GENERATOR_SECTION)}"'
    )
    assert re.search(
        gen_name_pattern,
        qir,
    )

    gen_version_pattern = (
        rf"@gen_version = private unnamed_addr constant "
        rf'\[{len(package_version)} x i8\] c"{re.escape(package_version)}", '
        rf'section "{re.escape(GENERATOR_SECTION)}"'
    )
    assert re.search(
        gen_version_pattern,
        qir,
    )
    assert "call void @__quantum__rt__initialize(ptr null)" in qir
    assert "declare void @__quantum__qis__mz__body(ptr, ptr writeonly)" in qir
    assert "declare i1 @__quantum__rt__read_result(ptr readonly)" in qir
    assert '"irreversible"' in qir
