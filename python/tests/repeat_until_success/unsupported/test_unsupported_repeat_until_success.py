import os
from pathlib import Path

import pytest
from hugr_qir.hugr_to_qir import to_qir_str

from tests.conftest import GUPPY_EXAMPLES_DIR
from tests.hugr_generation import guppy_to_hugr_binary

UNSUPPORTED_RUS_DIR = GUPPY_EXAMPLES_DIR / "repeat-until-success/unsupported"
UNSUPPORTED_RUS_FILES = list(UNSUPPORTED_RUS_DIR.glob("*.py"))


@pytest.mark.parametrize(
    "guppy_file",
    UNSUPPORTED_RUS_FILES,
    ids=[str(guppy_file.stem) for guppy_file in UNSUPPORTED_RUS_FILES],
)
def test_unsupported_repeat_until_success(guppy_file: Path) -> None:
    hugr_bin = guppy_to_hugr_binary(guppy_file)
    with pytest.raises(Exception) as error:  # noqa: PT011
        to_qir_str(hugr_bin)
    with guppy_file.with_suffix(".error").open("w") as error_file:
        error_file.write(str(error.value) + os.linesep)
