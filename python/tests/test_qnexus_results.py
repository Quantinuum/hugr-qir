import json
from pathlib import Path

from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult
from pytket.backends.backendresult import BackendResult

from tests.conftest import TEST_DIR

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


def test_backend() -> None:

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


def test_backend_array() -> None:
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


def test_backend_uarray() -> None:
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


def test_backend_iarray() -> None:
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
