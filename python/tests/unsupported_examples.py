from pathlib import Path

import pytest
from hugr_qir.hugr_to_qir import to_qir_str

from tests.hugr_generation import guppy_to_hugr_binary


def _normalize_newlines(text: str) -> str:
    return text.replace("\r\n", "\n").replace("\r", "\n")


def assert_unsupported_example(guppy_file: Path) -> None:
    hugr_bin = guppy_to_hugr_binary(guppy_file)
    with pytest.raises(Exception) as error:  # noqa: PT011
        to_qir_str(hugr_bin)

    actual_error = _normalize_newlines(str(error.value) + "\n")
    expected_error = _normalize_newlines(
        guppy_file.with_suffix(".error").read_text(encoding="utf-8")
    )
    assert actual_error == expected_error
