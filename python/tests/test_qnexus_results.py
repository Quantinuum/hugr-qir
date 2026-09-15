import json
from pathlib import Path

from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult
from pytest_snapshot.plugin import Snapshot
from pytket.backends.backendresult import BackendResult

from tests.conftest import TEST_DIR

from .conftest import (
    skip_snapshot_checks,
)

BACKEND_RESULT = TEST_DIR / Path("resources/backend_results/backend_result.json")
BACKEND_RESULT_array = TEST_DIR / Path(
    "resources/backend_results/backend_result_array.json"
)
QSYS_SNAPSHOT_DIR = Path(__file__).parent / "snapshots" / "qsysresult"

EXPECTED_SHOTS = 10
INTEGER_VALUE = 3




def test_backend(snapshot: Snapshot) -> None:

    snapshot.snapshot_dir = QSYS_SNAPSHOT_DIR

    with BACKEND_RESULT.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    for x in qs[0]:  # check if reg names are in new object
        assert x[0] in [
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
        ]

    if not skip_snapshot_checks:
        snapshot.assert_match(str(qs), "backend.txt")


def test_backend_array(snapshot: Snapshot) -> None:
    snapshot.snapshot_dir = QSYS_SNAPSHOT_DIR

    with BACKEND_RESULT_array.open() as f:
        backend_result = BackendResult.from_dict(json.load(f))

    qs = backendresult_to_qsysresult(backend_result)

    for x in qs[0]:  # check if reg names are in new object
        assert x[0] in ["000", "qbs", "ires"]

    if not skip_snapshot_checks:
        snapshot.assert_match(str(qs), "backend-array.txt")
