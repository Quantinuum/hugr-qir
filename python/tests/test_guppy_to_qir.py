from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import h, measure
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    h(q0)
    h(q1)

    b0 = measure(q0).read()
    b1 = measure(q1).read()
    b2 = b0 ^ b1

    output("0", b2)


hugr_package = main.compile()
qir = hugr_to_qir(hugr_package, output_format=OutputFormat.LLVM_IR)

assert len(qir) > 10  # noqa: PLR2004
