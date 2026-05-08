from pathlib import Path

import pytest
from pytest_snapshot.plugin import Snapshot  # type: ignore

from tests.conftest import GUPPY_EXAMPLES_DIR
from tests.unsupported_examples import assert_unsupported_example

UNSUPPORTED_RUS_DIR = GUPPY_EXAMPLES_DIR / "repeat-until-success/unsupported"
UNSUPPORTED_RUS_FILES = list(UNSUPPORTED_RUS_DIR.glob("*.py"))


@pytest.mark.parametrize(
    "guppy_file",
    UNSUPPORTED_RUS_FILES,
    ids=[str(guppy_file.stem) for guppy_file in UNSUPPORTED_RUS_FILES],
)
def test_unsupported_repeat_until_success(guppy_file: Path, snapshot: Snapshot) -> None:
    assert_unsupported_example(guppy_file, snapshot)
