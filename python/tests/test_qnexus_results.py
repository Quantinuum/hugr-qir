import json
from pathlib import Path

import pytest
from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.platform import _output_nat as output_nat
from hugr_qir.h_series_helpers.results import (
    HugrQirResultHelper,
    ResultRep,
    ResultSpec,
    hugr_to_result_spec,
)
from pytket import Bit
from pytket.backends.backendresult import BackendResult
from pytket.utils.outcomearray import OutcomeArray

from tests.conftest import TEST_DIR

BACKEND_RESULT = TEST_DIR / Path("resources/backend_results/backend_result.json")
EXPECTED_SHOTS = 10
INTEGER_VALUE = 3


@guppy
def result_spec_program() -> None:
    output("flag", True)  # noqa: FBT003
    output("count", 42)


@guppy
def unsigned_result_spec_program() -> None:
    output_nat("unsigned_count", 42)


@guppy
def unsupported_result_spec_program() -> None:
    output("value", 1.0)


@guppy
def conflicting_result_spec_program() -> None:
    output("value", True)  # noqa: FBT003
    output("value", 42)


def load_backend_result(
    result_representations: dict[str, ResultRep] | None = None,
) -> HugrQirResultHelper:
    with BACKEND_RESULT.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    return HugrQirResultHelper(
        backend_result,
        ResultSpec(result_representations or {}),
    )


def test_hugr_to_result_spec() -> None:
    result_spec = hugr_to_result_spec(result_spec_program.compile())

    assert result_spec == ResultSpec(
        {
            "flag": ResultRep.BOOL,
            "count": ResultRep.INT,
        }
    )


def test_hugr_to_result_spec_rejects_unsigned_result_operation() -> None:
    with pytest.raises(
        ValueError, match="Unsupported HUGR result operation 'result_uint'"
    ):
        hugr_to_result_spec(unsigned_result_spec_program.compile())


def test_hugr_to_result_spec_rejects_unsupported_result_operation() -> None:
    with pytest.raises(
        ValueError, match="Unsupported HUGR result operation 'result_f64'"
    ):
        hugr_to_result_spec(unsupported_result_spec_program.compile())


def test_hugr_to_result_spec_rejects_conflicting_tag_representations() -> None:
    with pytest.raises(
        ValueError, match="Conflicting result representations for tag 'value'"
    ):
        hugr_to_result_spec(conflicting_result_spec_program.compile())


def test_backend_result_resource_get_shots_all_bitstring_first_shot() -> None:
    results = load_backend_result()

    assert results.get_shots_all_bitstring()[0] == {
        "two": "0" * 62 + "10",
        "true2": "0" * 63 + "1",
        "true0": "0" * 63 + "1",
        "three": "0" * 62 + "11",
        "ten": "0" * 60 + "1010",
        "qubit0": "0" * 63 + "1",
        "one": "0" * 63 + "1",
        "integer_value": "0" * 62 + "11",
        "false": "0" * 64,
        "2pow32": "0" * 31 + "1" + "0" * 32,
    }


def test_backend_result_resource_get_shots_all_bitstring() -> None:
    results = load_backend_result()

    assert len(results.get_shots_all_bitstring()) == EXPECTED_SHOTS
    assert all(
        shot == results.get_shots_all_bitstring()[0]
        for shot in results.get_shots_all_bitstring()
    )


def test_backend_result_resource_get_shots_all_integer_first_shot() -> None:
    results = load_backend_result()

    assert results.get_shots_all_integer()[0] == {
        "two": 2,
        "true2": 1,
        "true0": 1,
        "three": 3,
        "ten": 10,
        "qubit0": 1,
        "one": 1,
        "integer_value": 3,
        "false": 0,
        "2pow32": 2**32,
    }


def test_backend_result_resource_get_shots_all_integer() -> None:
    results = load_backend_result()

    assert len(results.get_shots_all_integer()) == EXPECTED_SHOTS
    assert all(
        shot == results.get_shots_all_integer()[0]
        for shot in results.get_shots_all_integer()
    )


def test_backend_result_resource_shots_uses_default_bitstring_representation() -> None:
    results = load_backend_result()

    assert results.get_shots() == results.get_shots_all_bitstring()


def test_backend_result_resource_shots_uses_tag_representations() -> None:
    results = load_backend_result(
        {
            "false": ResultRep.BOOL,
            "true0": ResultRep.BOOL,
            "true2": ResultRep.BIT,
            "integer_value": ResultRep.INT,
        }
    )

    first_shot = results.get_shots()[0]

    assert first_shot["false"] is False
    assert first_shot["true0"] is True
    assert first_shot["true2"] == "1"
    assert first_shot["integer_value"] == INTEGER_VALUE
    assert first_shot["two"] == "0" * 62 + "10"


def test_backend_result_resource_shots_uses_default_int_representation() -> None:
    results = load_backend_result()

    assert results.get_shots(default_representation=ResultRep.INT) == (
        results.get_shots_all_integer()
    )


def test_backend_result_resource_decodes_signed_integers() -> None:
    bits = [Bit("signed", i) for i in reversed(range(64))]
    backend_result = BackendResult(
        c_bits=bits,
        shots=OutcomeArray.from_readouts([[1] * 64]),
    )
    results = HugrQirResultHelper(
        backend_result,
        ResultSpec({"signed": ResultRep.INT}),
    )

    assert results.get_shots() == [{"signed": -1}]
    assert results.get_shots_all_integer() == [{"signed": -1}]


def test_backend_result_resource_rejects_bool_representation_for_int_tag() -> None:
    with pytest.raises(
        ValueError, match="Result 'two' cannot be represented as a bool"
    ):
        load_backend_result({"two": ResultRep.BOOL})


def test_backend_result_resource_rejects_bit_representation_for_int_tag() -> None:
    with pytest.raises(
        ValueError, match="Result 'two' cannot be represented as a bool"
    ):
        load_backend_result({"two": ResultRep.BIT})


def test_backend_result_resource_rejects_default_bool_for_int_tags() -> None:
    results = load_backend_result()

    with pytest.raises(
        ValueError, match="Result 'two' cannot be represented as a bool"
    ):
        results.get_shots(default_representation=ResultRep.BOOL)
