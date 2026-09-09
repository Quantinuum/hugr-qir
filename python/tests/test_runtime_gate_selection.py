from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure, x, y
from hugr_qir.guppy_to_qir import guppy_to_qir_str


@guppy
@no_type_check
def runtime_gate_selection() -> None:
    q0, q1, q2, q3, q4, q5 = (
        qubit(),
        qubit(),
        qubit(),
        qubit(),
        qubit(),
        qubit(),
    )
    control0, control1 = qubit(), qubit()
    condition0 = measure(control0).read()
    condition1 = measure(control1).read()

    # This conditional produces qubit selects or phis that require the later
    # simplifycfg cleanup in lower_qubit_selects_and_phis.
    if condition0 and condition1:
        x(q2)
    elif condition0:
        x(q3)
    elif condition1:
        x(q4)
    else:
        x(q5)

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
    output("2", measure(q2).read())
    output("3", measure(q3).read())
    output("4", measure(q4).read())
    output("5", measure(q5).read())


def test_runtime_gate_and_qubit_selection_do_not_generate_lookup_table() -> None:
    qir = guppy_to_qir_str(runtime_gate_selection, validate_qir=True)

    assert "switch.table" not in qir
