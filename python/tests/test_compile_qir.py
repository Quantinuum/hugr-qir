from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import h, measure
from hugr_qir.hugr_to_qir import hugr_to_qir  # noqa: F401


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


def test_compile_and_convert():
    qir = main.compile().to_qir_str()
    assert len(qir) > 10
