"""Binary dumps expose the transformed graph even when LLVM compilation fails."""

from pathlib import Path

import pytest
from click.testing import CliRunner
from hugr import ops
from hugr.package import Package
from hugr_qir.cli import hugr_qir
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat

from .conftest import GUPPY_EXAMPLES_DIR, guppy_example_dict
from .hugr_generation import guppy_to_hugr_binary


def test_dump_contains_inlined_hugr(tmp_path: Path) -> None:
    source = guppy_example_dict["quantum-functions-3"].hugr_binary
    dump = tmp_path / "quantum-functions-3.post-passes.hugr"
    hugr_to_qir(source, dump_hugr=dump, output_format=OutputFormat.LLVM_IR)

    before = Package.from_bytes(source).modules[0]
    after = Package.from_bytes(dump.read_bytes()).modules[0]
    assert sum(isinstance(before[n].op, ops.FuncDefn) for n in before) > 1
    assert sum(isinstance(after[n].op, ops.FuncDefn) for n in after) == 1
    assert not any(isinstance(after[n].op, ops.Call) for n in after)


def test_dump_survives_llvm_failure(tmp_path: Path) -> None:
    source = guppy_to_hugr_binary(
        GUPPY_EXAMPLES_DIR / "guppy-features/unsupported/non-unrollable-loops.py"
    )
    dump = tmp_path / "non-unrollable-loops.post-passes.hugr"
    with pytest.raises(ValueError, match="Loop cannot be unrolled"):
        hugr_to_qir(source, dump_hugr=dump)

    package = Package.from_bytes(dump.read_bytes())
    assert len(package.modules) == 1
    assert package.extensions


def test_cli_writes_binary_dump(tmp_path: Path) -> None:
    source = tmp_path / "input.hugr"
    source.write_bytes(guppy_example_dict["quantum-functions-1"].hugr_binary)
    dump = tmp_path / "input.post-passes.hugr"
    qir = tmp_path / "output.ll"
    result = CliRunner().invoke(hugr_qir, [str(source), "--dump-hugr", "-o", str(qir)])
    assert result.exit_code == 0, result.output
    assert qir.exists()
    assert len(Package.from_bytes(dump.read_bytes()).modules) == 1
