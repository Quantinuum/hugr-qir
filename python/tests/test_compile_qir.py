from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from hugr_qir.guppy_to_qir import guppy_to_qir_str
from hugr_qir.hugr_to_qir import to_qir_str


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


def test_hugr_package_to_qir() -> None:
    qir = to_qir_str(hugr_package)
    assert len(qir) > 10  # noqa: PLR2004


def test_guppy_entrypoint_to_qir() -> None:
    qir = guppy_to_qir_str(main)
    assert len(qir) > 10  # noqa: PLR2004


def test_generated_qir_uses_qir_1_runtime_contracts() -> None:
    qir = guppy_to_qir_str(main, validate_qir=True)

    assert "__quantum__rt__read_result" in qir
    assert "__quantum__qis__read_result__body" not in qir
    assert 'qir_profiles"="adaptive_profile"' in qir
    assert "call void @__quantum__rt__initialize(ptr null)" in qir
    assert "declare void @__quantum__qis__mz__body(ptr, ptr writeonly)" in qir
    assert "declare i1 @__quantum__rt__read_result(ptr readonly)" in qir
    assert '"irreversible"' in qir
