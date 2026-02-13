import hashlib
import json
import os
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import IO

import pytest
from click.testing import CliRunner
from hugr_qir.cli import hugr_qir

GUPPY_EXAMPLES_DIR_GENERAL = Path(__file__).parent / "../../guppy_examples/general"
GUPPY_EXAMPLES_DIR_QHO = (
    Path(__file__).parent / "../../guppy_examples/quantinuum-hardware-only"
)
TEST_DIR = Path(__file__).parent
GUPPY_EXAMPLE_HASHES = TEST_DIR / "resources/guppy_example_hugrs/hashes.pkl"
# Within the cibuildwheels environments, ssa variable names tend to be slightly
# different, so verbatim snapshot tests do not pass. So we just test
# that generation works for the wheel builds
skip_snapshot_checks = os.getenv("CIBUILDWHEEL") == "1"


def pytest_configure(config: pytest.Config) -> None:
    if skip_snapshot_checks:
        config.issue_config_time_warning(
            UserWarning(
                "Detected tests running on cibuildwheel,"
                " so skipping all snapshot checks"
            ),
            stacklevel=2,
        )


def guppy_to_hugr_file(guppy_file: Path, outfd: IO) -> None:
    subprocess.run(  # noqa: S603
        [sys.executable, guppy_file],
        check=True,
        stdout=outfd,
        text=True,
    )


def guppy_to_hugr_binary(guppy_file: Path) -> bytes:
    result = subprocess.run(  # noqa: S603
        [sys.executable, guppy_file],
        check=True,
        capture_output=True,
        text=False,
    )
    hugr = result.stdout
    assert isinstance(hugr, bytes)
    return hugr


def get_guppy_files() -> list[Path]:
    guppy_dir_runable = Path(GUPPY_EXAMPLES_DIR_GENERAL)
    guppy_dir_unrunable = Path(GUPPY_EXAMPLES_DIR_QHO)

    return list(guppy_dir_runable.glob("*.py")) + list(guppy_dir_unrunable.glob("*.py"))


guppy_files = get_guppy_files()


@dataclass
class GuppyExample:
    guppy_filepath: Path
    hugr_filepath: Path
    hugr_binary: bytes


def cli_on_guppy(guppy_file: Path, tmp_path: Path, *args: str) -> None:
    guppy_file = Path(guppy_file)
    hugr_file = tmp_path / Path(f"{guppy_file.name}.hugr")
    with Path.open(hugr_file, "w") as f:
        guppy_to_hugr_file(guppy_file, f)
    runner = CliRunner()
    runner.invoke(hugr_qir, [str(hugr_file), *[str(arg) for arg in args]])


def cli_on_hugr(hugr_file: Path, *args: str) -> None:
    runner = CliRunner()
    runner.invoke(hugr_qir, [str(hugr_file), *[str(arg) for arg in args]])


@pytest.fixture
def wasm_file(request) -> Path:
    return TEST_DIR / Path("resources/test.wasm")


def hash_file(path: Path) -> str:
    return hashlib.sha256(path.open("rb").read()).hexdigest()


def get_file_hashes() -> dict[str, str]:
    if GUPPY_EXAMPLE_HASHES.exists():
        with GUPPY_EXAMPLE_HASHES.open("r") as f:
            return json.load(f)
    return dict()


def dump_file_hashes(hashes: dict[str, str]) -> None:
    with GUPPY_EXAMPLE_HASHES.open("w") as f:
        json.dump(hashes, f, indent=2)


def get_guppy_example_dict() -> dict[str, GuppyExample]:
    example_dict: dict[str, GuppyExample] = {}
    hashes = get_file_hashes()
    new_hashes = {}
    for guppy_file in guppy_files:
        file_stem = guppy_file.stem
        hugr_file_path = TEST_DIR / f"resources/guppy_example_hugrs/{file_stem}.hugr"
        saved_hash = hashes.get(file_stem, "")
        new_hash = hash_file(guppy_file)
        if new_hash == saved_hash:
            example_dict[file_stem] = GuppyExample(
                guppy_file, hugr_file_path, hugr_file_path.open("rb").read()
            )
        else:
            print(f"Regenerating hugr file for {guppy_file.name}")
            hugr_bin = guppy_to_hugr_binary(guppy_file)
            with hugr_file_path.open("wb") as f:
                f.write(hugr_bin)
            example_dict[file_stem] = GuppyExample(guppy_file, hugr_file_path, hugr_bin)
        new_hashes[file_stem] = new_hash
    dump_file_hashes(new_hashes)
    return example_dict


guppy_example_dict = get_guppy_example_dict()
guppy_examples = [guppy_example for _, guppy_example in guppy_example_dict.items()]
