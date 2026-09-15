import json
from pathlib import Path

from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult
from pytket.backends.backendresult import BackendResult

from tests.conftest import TEST_DIR

BACKEND_RESULT = TEST_DIR / Path("resources/backend_results/backend_result.json")
BACKEND_RESULT_array = TEST_DIR / Path(
    "resources/backend_results/backend_result_array.json"
)
QSYS_SNAPSHOT_DIR = Path(__file__).parent / "snapshots" / "qsysresult"

EXPECTED_SHOTS = 10
EXPECTED_VALUES = 10
EXPECTED_VALUES_ARRAY = 3


def test_backend() -> None:

    with BACKEND_RESULT.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    set_reg = set()

    for x in qs[0]:  # check if reg names are in new object
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

    assert len(qs) == EXPECTED_SHOTS
    assert len(qs[0]) == EXPECTED_VALUES


def test_backend_array() -> None:
    with BACKEND_RESULT_array.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    set_reg = set()

    for x in qs[0]:  # check if reg names are in new object
        set_reg.add(x[0])

    assert set_reg == {"000", "qbs", "ires"}

    assert len(qs) == EXPECTED_SHOTS
    assert len(qs[0]) == EXPECTED_VALUES_ARRAY
