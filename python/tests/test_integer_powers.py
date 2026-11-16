from typing import no_type_check

import pytest
from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure
from hugr_qir._hugr_qir import compile_target_choices, opt_level_choices
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat

from .conftest import guppy_example_dict


@guppy
@no_type_check
def large_constant_power() -> None:
    base = get_current_shot() + 2
    output("power", base**1000)
    output("q", measure(qubit()).read())


@pytest.mark.parametrize("target", compile_target_choices())
@pytest.mark.parametrize("opt_level", opt_level_choices())
@pytest.mark.parametrize("exponent_kind", ["runtime", "large-constant"])
def test_power_is_independent_of_loop_unrolling_limit(
    target: str, opt_level: str, exponent_kind: str
) -> None:
    program = (
        guppy_example_dict["runtime-integer-power"].hugr_binary
        if exponent_kind == "runtime"
        else large_constant_power.compile()
    )
    qir = hugr_to_qir(
        program,
        target=target,
        opt_level=opt_level,
        max_loop_unroll=1,
        validate_qir=True,
        output_format=OutputFormat.LLVM_IR,
    )

    assert isinstance(qir, str)
    assert "__hugr_qir_ipow" not in qir
    assert "hugr-qir.ipow" not in qir
