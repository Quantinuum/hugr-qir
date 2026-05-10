from pathlib import Path

import pytest
from hugr_qir.hugr_to_qir import to_qir_str
from pytest_snapshot.plugin import Snapshot

from tests.conftest import GUPPY_EXAMPLES_DIR, skip_snapshot_checks
from tests.hugr_generation import guppy_to_hugr_binary

SUPPORTED_RUS_DIR = GUPPY_EXAMPLES_DIR / "repeat-until-success/supported"
SUPPORTED_RUS_FILES = list(SUPPORTED_RUS_DIR.glob("*.py"))
SNAPSHOT_DIR = Path(__file__).parent / "snapshots"


@pytest.mark.parametrize(
    "guppy_file",
    SUPPORTED_RUS_FILES,
    ids=[str(guppy_file.stem) for guppy_file in SUPPORTED_RUS_FILES],
)
def test_supported_repeat_until_success(guppy_file: Path, snapshot: Snapshot) -> None:
    snapshot.snapshot_dir = SNAPSHOT_DIR
    hugr_bin = guppy_to_hugr_binary(guppy_file)
    qir = to_qir_str(hugr_bin)
    if not skip_snapshot_checks:
        snapshot.assert_match(qir, str(Path(guppy_file.stem).with_suffix(".ll")))
