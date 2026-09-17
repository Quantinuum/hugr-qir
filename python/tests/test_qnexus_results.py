import json
from pathlib import Path

from hugr.qsystem.result import QsysResult
from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult
from pytest_snapshot.plugin import Snapshot
from pytket.backends.backendresult import BackendResult

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
