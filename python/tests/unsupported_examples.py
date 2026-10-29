from pathlib import Path

import pytest
from hugr_qir.hugr_to_qir import to_qir_str
from pytest_snapshot.plugin import Snapshot

from tests.hugr_generation import guppy_to_hugr_binary

UNSUPPORTED_SNAPSHOT_DIR = Path(__file__).parent / "snapshots" / "unsupported"


def assert_unsupported_example(guppy_file: Path, snapshot: Snapshot) -> None:
    hugr_bin = guppy_to_hugr_binary(guppy_file)
    with pytest.raises(Exception) as error:  # noqa: PT011
        to_qir_str(hugr_bin)

    snapshot.snapshot_dir = UNSUPPORTED_SNAPSHOT_DIR
    snapshot.assert_match(str(error.value) + "\n", guppy_file.stem + ".error")
