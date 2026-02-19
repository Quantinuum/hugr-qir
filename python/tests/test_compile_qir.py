from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from tket_exts import tket_registry

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
# TODO: Can remove once extension handling fixed in guppy
hugr_package.extensions.append(tket_registry().get_extension("tket.rotation"))
def test_hugr_package_to_qir() -> None:
    qir = to_qir_str(hugr_package)
    assert len(qir) > 10  # noqa: PLR2004


def test_guppy_entrypoint_to_qir() -> None:
    qir = guppy_to_qir_str(main)
    assert len(qir) > 10  # noqa: PLR2004
