import os
from pathlib import Path

import pytest
from click.testing import CliRunner
from hugr_qir.cli import hugr_qir

from tests.hugr_generation import GuppyExample, generate_guppy_example_dict

GUPPY_EXAMPLES_DIR = Path(__file__).parent / "../../guppy_examples"
GUPPY_EXAMPLES_DIR_GENERAL = Path(__file__).parent / "../../guppy_examples/general"
GUPPY_EXAMPLES_DIR_QHO = (
    Path(__file__).parent / "../../guppy_examples/quantinuum-hardware-only"
)
TEST_DIR = Path(__file__).parent
SNAPSHOT_DIR = TEST_DIR / "snapshots"

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


def get_guppy_files() -> list[Path]:
    guppy_dir_runable = Path(GUPPY_EXAMPLES_DIR_GENERAL)
    guppy_dir_unrunable = Path(GUPPY_EXAMPLES_DIR_QHO)
    return list(guppy_dir_runable.glob("*.py")) + list(guppy_dir_unrunable.glob("*.py"))


def cli_on_hugr(hugr_file: Path, *args: str) -> None:
    runner = CliRunner()
    runner.invoke(hugr_qir, [str(hugr_file), *[str(arg) for arg in args]])


@pytest.fixture
def wasm_file() -> Path:
    return TEST_DIR / Path("resources/test.wasm")


guppy_example_dict = generate_guppy_example_dict(get_guppy_files())
guppy_examples: list[GuppyExample] = [
    guppy_example for _, guppy_example in guppy_example_dict.items()
]
