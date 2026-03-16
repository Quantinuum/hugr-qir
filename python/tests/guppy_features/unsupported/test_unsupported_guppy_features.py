from pathlib import Path

import pytest

from tests.conftest import GUPPY_EXAMPLES_DIR
from tests.unsupported_examples import assert_unsupported_example

FEATURES_DIR = GUPPY_EXAMPLES_DIR / "guppy-features/unsupported"
FEATURES_FILES = list(FEATURES_DIR.glob("*.py"))


@pytest.mark.parametrize(
    "guppy_file",
    FEATURES_FILES,
    ids=[str(guppy_file.stem) for guppy_file in FEATURES_FILES],
)
def test_unsupported_features_fail(guppy_file: Path) -> None:
    assert_unsupported_example(guppy_file)
