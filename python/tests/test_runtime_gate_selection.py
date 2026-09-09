from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure, x, y
from hugr_qir.guppy_to_qir import guppy_to_qir_str


@guppy
@no_type_check
def runtime_gate_selection() -> None:
    q0 = qubit()
    q1 = qubit()
    shot = get_current_shot()
    if shot == 0:
        y(q0)
        x(q1)
    if shot == 1:
        x(q0)
        x(q1)
    if shot == 2:  # noqa: PLR2004
        x(q0)
        x(q1)
    output("0", measure(q0).read())
    output("1", measure(q1).read())


def test_runtime_gate_selection_does_not_generate_lookup_table() -> None:
    qir = guppy_to_qir_str(runtime_gate_selection, validate_qir=True)

    assert "switch.table" not in qir
