import json
import logging
from pathlib import Path

import pytest
from hugr.qsystem.result import QsysResult
from hugr_qir.h_series_helpers.results import (
    EXPECTED_REGISTER_SIZE,
    ResultConversionError,
    backendresult_to_qsysresult,
)
from pytest_snapshot.plugin import Snapshot
from pytket import Bit
from pytket.backends.backendresult import BackendResult
from pytket.utils.outcomearray import OutcomeArray

from tests.conftest import TEST_DIR, skip_snapshot_checks

QSYS_SNAPSHOT_DIR = Path(__file__).parent / "snapshots" / "qsysresult"

BACKEND_RESULT = TEST_DIR / Path("resources/backend_results/backend_result.json")
BACKEND_RESULT_ARRAY = TEST_DIR / Path(
    "resources/backend_results/backend_result_array.json"
)
BACKEND_RESULT_UARRAY = TEST_DIR / Path(
    "resources/backend_results/backend_result_uarray.json"
)
BACKEND_RESULT_IARRAY = TEST_DIR / Path(
    "resources/backend_results/backend_result_iarray.json"
)

EXPECTED_SHOTS = 10
EXPECTED_VALUES = 10
EXPECTED_VALUES_ARRAY = 3
U64MAX = 18446744073709551615
EMPTY_RESULT_SHOTS = 2


def _make_backend_result(
    registers: dict[str, list[int]], readouts: list[list[int]] | None = None
) -> BackendResult:
    bits = [
        Bit(register_name, index)
        for register_name, indices in registers.items()
        for index in indices
    ]
    if readouts is None:
        readouts = [[0] * len(bits)]
    return BackendResult(
        c_bits=bits,
        shots=OutcomeArray.from_readouts(readouts),
    )


def _qs_to_str(qs: QsysResult) -> str:
    "convert q sys results to string"

    qs_str = ""

    for shot in qs:
        result_list = list(shot)
        result_list.sort()
        qs_str += str(result_list)
        qs_str += "\n"

    return qs_str


def test_backend(snapshot: Snapshot) -> None:

    with BACKEND_RESULT.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    assert len(qs) == EXPECTED_SHOTS

    for i in range(EXPECTED_SHOTS):
        assert len(qs[i]) == EXPECTED_VALUES

        set_reg = set()

        for x in qs[i]:  # check if reg names are in new qsys result
            set_reg.add(x[0])

        assert set_reg == {
            "one",
            "true0",
            "three",
            "two",
            "ten",
            "false",
            "qubit0",
            "integer_value",
            "true2",
            "2pow32",
        }

        for x in qs[i]:
            assert type(x[1]) is int
            if x[0] == "one":
                assert x[1] == 1
            elif x[0] == "ten":
                assert x[1] == 10  # noqa: PLR2004
            elif x[0] == "false":
                assert x[1] == 0
            elif x[0] == "integer_value":
                assert x[1] == 3  # noqa: PLR2004
            elif x[0] == "2pow32":
                assert x[1] == 4294967296  # noqa: PLR2004

    if not skip_snapshot_checks:
        snapshot.assert_match(
            _qs_to_str(qs),
            "test_backend.txt",
        )


def test_backend_array(snapshot: Snapshot) -> None:
    with BACKEND_RESULT_ARRAY.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    assert len(qs) == EXPECTED_SHOTS

    for i in range(EXPECTED_SHOTS):
        assert len(qs[i]) == EXPECTED_VALUES_ARRAY

        set_reg = set()

        for x in qs[i]:  # check if reg names are in new qsys result
            set_reg.add(x[0])

        assert set_reg == {"000", "qbs", "ires"}

        for x in qs[i]:
            if x[0] == "000":
                assert type(x[1]) is bool
            elif x[0] == "qbs":
                assert type(x[1]) is list
                for y in x[1]:
                    assert type(y) is bool
            elif x[0] == "ires":
                assert type(x[1]) is list
                assert x[1] == list(range(8))
                for y in x[1]:
                    assert type(y) is int

    if not skip_snapshot_checks:
        snapshot.assert_match(
            _qs_to_str(qs),
            "test_backend_array.txt",
        )


def test_backend_uarray(snapshot: Snapshot) -> None:
    with BACKEND_RESULT_UARRAY.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    assert len(qs) == 1

    for i in range(1):
        assert len(qs[i]) == 2  # noqa: PLR2004

        set_reg = set()

        for x in qs[i]:  # check if reg names are in new qsys result
            set_reg.add(x[0])

        assert set_reg == {"000", "qbs"}

        for x in qs[i]:
            if x[0] == "000":
                assert type(x[1]) is int
                assert x[1] == U64MAX
            elif x[0] == "qbs":
                assert type(x[1]) is list
                assert x[1] == [U64MAX, U64MAX]
                for y in x[1]:
                    assert type(y) is int

    if not skip_snapshot_checks:
        snapshot.assert_match(
            _qs_to_str(qs),
            "test_backend_uarray.txt",
        )


def test_backend_iarray(snapshot: Snapshot) -> None:
    with BACKEND_RESULT_IARRAY.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    assert len(qs) == 1

    for i in range(1):
        assert len(qs[i]) == 2  # noqa: PLR2004

        set_reg = set()

        for x in qs[i]:  # check if reg names are in new qsys result
            set_reg.add(x[0])

        assert set_reg == {"000", "qbs"}

        for x in qs[i]:
            if x[0] == "000":
                assert type(x[1]) is int
                assert x[1] == -1
            elif x[0] == "qbs":
                assert type(x[1]) is list
                assert x[1] == [-1, -1]
                for y in x[1]:
                    assert type(y) is int

    if not skip_snapshot_checks:
        snapshot.assert_match(
            _qs_to_str(qs),
            "test_backend_iarray.txt",
        )


def test_rejects_register_with_incorrect_indices() -> None:
    backend_result = _make_backend_result(
        {"value___UINT": [0, *range(2, EXPECTED_REGISTER_SIZE + 1)]}
    )

    with pytest.raises(ResultConversionError, match="exactly bits 0 through 63"):
        backendresult_to_qsysresult(backend_result)


def test_malformed_array_index_falls_back_to_signed_integer(
    caplog: pytest.LogCaptureFixture,
) -> None:
    backend_result = _make_backend_result(
        {"items___ARRINT_invalid": list(range(EXPECTED_REGISTER_SIZE))}
    )

    with caplog.at_level(logging.WARNING):
        result = backendresult_to_qsysresult(backend_result)

    assert list(result[0]) == [("items", 0)]
    assert "Treating all results as signed 64 bit integers" in caplog.text


def test_mixed_typed_and_untyped_registers(
    caplog: pytest.LogCaptureFixture,
) -> None:
    backend_result = _make_backend_result(
        {
            "flag___BOOL": list(range(EXPECTED_REGISTER_SIZE)),
            "legacy": list(range(EXPECTED_REGISTER_SIZE)),
        }
    )

    with caplog.at_level(logging.WARNING):
        result = backendresult_to_qsysresult(backend_result)

    assert list(result[0]) == [("flag", False), ("legacy", 0)]
    assert "result tag legacy" in caplog.text


def test_incomplete_array_indices_are_returned_individually(
    caplog: pytest.LogCaptureFixture,
) -> None:
    backend_result = _make_backend_result(
        {
            "items___ARRINT_0": list(range(EXPECTED_REGISTER_SIZE)),
            "items___ARRINT_2": list(range(EXPECTED_REGISTER_SIZE)),
        }
    )

    with caplog.at_level(logging.WARNING):
        result = backendresult_to_qsysresult(backend_result)

    assert list(result[0]) == [("items_0", 0), ("items_2", 0)]
    assert "missing indices" in caplog.text


def test_duplicate_array_indices_are_rejected() -> None:
    backend_result = _make_backend_result(
        {
            "items___ARRINT_0": list(range(EXPECTED_REGISTER_SIZE)),
            "items___ARRUINT_0": list(range(EXPECTED_REGISTER_SIZE)),
        }
    )

    with pytest.raises(ResultConversionError, match="duplicate indices"):
        backendresult_to_qsysresult(backend_result)


def test_empty_result_registers_preserve_shot_count() -> None:
    backend_result = _make_backend_result({}, [[] for _ in range(EMPTY_RESULT_SHOTS)])

    result = backendresult_to_qsysresult(backend_result)

    assert len(result) == EMPTY_RESULT_SHOTS
    assert all(list(shot) == [] for shot in result)
