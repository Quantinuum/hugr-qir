"""Concise diagnostics without losing the underlying exception chain."""

import importlib
from pathlib import Path

import pytest
from click.testing import CliRunner
from hugr_qir._hugr_qir import CompilationError
from hugr_qir.cli import hugr_qir, hugr_qir_impl
from hugr_qir.output import OutputFormat

cli_module = importlib.import_module("hugr_qir.cli")


@pytest.mark.parametrize("expected", [True, False])
def test_wrapper_classifies_by_type(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, *, expected: bool
) -> None:
    # Identical text must not cause an unexpected error to be misclassified.
    detail = "Program always panics: example"
    cause = CompilationError(detail) if expected else RuntimeError(detail)

    def fail(*_args: str) -> None:
        raise cause

    monkeypatch.setattr(cli_module, "cli", fail)
    with pytest.raises(ValueError, match="Compilation failed") as error:
        hugr_qir_impl(
            validate_qir=False,
            validate_hugr=False,
            target="native",
            opt_level="default",
            max_loop_unroll=100,
            output_format=OutputFormat.LLVM_IR,
            hugr_file=tmp_path / "input.hugr",
            outfile=None,
            wasm_file=None,
        )
    assert error.value.__cause__ is cause
    if expected:
        assert str(error.value) == f"Compilation failed: {detail}"
    else:
        assert str(error.value) == (
            f"Compilation failed unexpectedly: {detail}\n"
            "This may be a compiler bug. Please report it with a reproducing example."
        )


def test_cli_displays_error_without_traceback(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path
) -> None:
    def fail(*_args: str) -> None:
        message = "Program always panics: example"
        raise CompilationError(message)

    monkeypatch.setattr(cli_module, "cli", fail)
    source = tmp_path / "input.hugr"
    source.touch()
    result = CliRunner().invoke(hugr_qir, [str(source)])
    assert result.exit_code == 1
    assert (
        result.output == "Error: Compilation failed: Program always panics: example\n"
    )


@pytest.mark.parametrize("exception", [KeyboardInterrupt, SystemExit, GeneratorExit])
def test_wrapper_preserves_process_control_exceptions(
    monkeypatch: pytest.MonkeyPatch, tmp_path: Path, exception: type[BaseException]
) -> None:
    def fail(*_args: str) -> None:
        raise exception

    monkeypatch.setattr(cli_module, "cli", fail)
    with pytest.raises(exception):
        hugr_qir_impl(
            validate_qir=False,
            validate_hugr=False,
            target="native",
            opt_level="default",
            max_loop_unroll=100,
            output_format=OutputFormat.LLVM_IR,
            hugr_file=tmp_path / "input.hugr",
            outfile=None,
            wasm_file=None,
        )
