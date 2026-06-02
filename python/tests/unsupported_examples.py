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
    try:
        expected_error = _normalize_newlines(
            guppy_file.with_suffix(".error").read_text(encoding="utf-8")
        )
    except FileNotFoundError as err:
        guppy_file.with_suffix(".error").write_text(actual_error, encoding="utf-8")
        msg = (
            f"Missing error file for {guppy_file.stem} example. "
            "Error file was regenerated."
        )
        raise AssertionError(msg) from err

    assert actual_error == expected_error
