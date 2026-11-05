from pathlib import Path
from unittest.mock import patch

import pytest
from hugr_qir.hugr_to_qir import hugr_to_qir

from .conftest import cli_on_hugr, guppy_examples


def test_validate_qir_by_default(tmp_path: Path) -> None:
    out_file = tmp_path / "out.ll"
    with patch("hugr_qir.cli.qircheck") as mock_qircheck:
        cli_on_hugr(guppy_examples[0].hugr_filepath, "-o", str(out_file))
        mock_qircheck.assert_called_once()


def test_validate_qir_if_validate_requested(tmp_path: Path) -> None:
    out_file = tmp_path / "out.ll"
    with patch("hugr_qir.cli.qircheck") as mock_qircheck:
        cli_on_hugr(
            guppy_examples[0].hugr_filepath, "-o", str(out_file), "--validate-qir"
        )
        mock_qircheck.assert_called_once()


def test_no_validate_qir_if_no_validate_requested(tmp_path: Path) -> None:
    out_file = tmp_path / "out.ll"
    with patch("hugr_qir.cli.qircheck") as mock_qircheck:
        cli_on_hugr(
            guppy_examples[0].hugr_filepath, "-o", str(out_file), "--no-validate-qir"
        )
        mock_qircheck.assert_not_called()


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
def test_qubit_release_validation_errors_are_reported(target: str) -> None:
    message = "Unsupported call to __quantum__rt__qubit_release"
    with (
        patch("hugr_qir.cli.qircheck", side_effect=ValueError(message)),
        pytest.raises(ValueError, match="Generated QIR failed validation") as error,
    ):
        hugr_to_qir(guppy_examples[0].hugr_filepath.read_bytes(), target=target)
    assert message in str(error.value)
