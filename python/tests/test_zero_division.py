from typing import no_type_check

import pytest
from guppylang import array, guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, x
from hugr_qir.guppy_to_qir import guppy_to_qir_str


@guppy
@no_type_check
def main() -> None:
    q = qubit()
    dividends = array(i for i in range(3))
    divisors = array(i for i in range(3))
    for i in range(3):
        for j in range(3):
            div = dividends[i] // divisors[j]
            rem = dividends[i] % divisors[j]
            if div == 0:
                x(q)
            if rem == 0:
                x(q)
    output("q", measure(q).read())


@pytest.mark.parametrize("validate_qir", [False, True])
def test_zero_div(validate_qir: bool) -> None:  # noqa: FBT001
    with pytest.raises(
        Exception,
        match=("Program always panics: Attempted division by 0"),
    ):
        guppy_to_qir_str(main, validate_qir=validate_qir)
