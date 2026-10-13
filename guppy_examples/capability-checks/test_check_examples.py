"""Check suite discovery, isolated artifacts, and expected runtime-error handling."""

import argparse
import json
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import Mock

import check_examples as checks
import pytest
from guppylang.emulator.exceptions import EmulatorError


def test_discovery_filters_helpers_and_combines_patterns(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    for suite in checks.SUITES:
        directory = tmp_path / suite
        directory.mkdir()
        for name in ("main.py", "other.py", "_helper.py", "notes.md"):
            (directory / name).write_text("")
    monkeypatch.setattr(checks, "ROOT", tmp_path)
    paths = checks.discover_examples(list(checks.SUITES), ["*.py", "main.py"])
    assert len(paths) == 4
    assert {p.name for p in paths} == {"main.py", "other.py"}
    assert len(checks.discover_examples([checks.SUITES[0]], ["main.py"])) == 1


def test_workers_keep_same_named_outputs_in_separate_suites(tmp_path: Path) -> None:
    output = tmp_path / "results"
    output.mkdir()
    args = argparse.Namespace(shots=None, timeout=10)
    for suite in checks.SUITES:
        directory = tmp_path / suite
        directory.mkdir()
        source = directory / "same.py"
        source.write_text(
            f'COMPONENT = "{suite}"\nCLASSICAL_ONLY = True\n'
            f'def classical_check():\n    return {{"suite": "{suite}"}}\n'
        )
        result = checks.run_worker(source, output, "compile", args)
        assert result["preprocess"] == "pass"
    for suite in checks.SUITES:
        record = json.loads((output / suite / "same.compile.json").read_text())
        assert record["details"]["suite"] == suite
        assert record["suite"] == suite


@pytest.mark.parametrize(
    ("runtime_message", "build_error", "expected_status"),
    [
        ("expected panic", False, "pass"),
        ("different panic", False, "fail"),
        (None, False, "fail"),
        ("expected panic", True, "fail"),
    ],
)
def test_expected_error_requires_matching_runtime_panic(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    runtime_message: str | None,
    *,
    build_error: bool,
    expected_status: str,
) -> None:
    source = tmp_path / "panic.py"
    source.write_text("# Stub source for the injected example.\n")
    emulator = Mock()
    emulator.with_seed.return_value = emulator
    emulator.with_shots.return_value = emulator
    emulator.run.return_value = SimpleNamespace(results=[])
    definition = Mock()
    definition.emulator.return_value = emulator
    if runtime_message:
        error = EmulatorError(
            completed_shots=SimpleNamespace(results=[]),
            failing_shot=None,
            underlying_exception=RuntimeError(runtime_message),
        )
        if build_error:
            definition.emulator.side_effect = error
        else:
            emulator.run.side_effect = error
    module = SimpleNamespace(
        COMPONENT="Expected panic",
        QUBIT_BUDGET=1,
        EXPECTED_EMULATOR_ERROR="expected panic",
        main=definition,
    )
    monkeypatch.setattr(checks, "load_example", lambda _: module)
    checks.worker(source, tmp_path, "emulate", 1)
    result = json.loads((tmp_path / "panic.emulate.json").read_text())
    assert result["emulate"] == expected_status
