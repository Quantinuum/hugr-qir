from base64 import b64decode
import os
import re
from pathlib import Path

import pytest
from click.testing import CliRunner
from hugr_qir.cli import hugr_qir
from hugr_qir.output import GENERATOR_SECTION, OutputFormat, ir_string_to_output_format
from llvmlite.binding import create_context, parse_bitcode

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

GENERATOR_VERSION_LINE_RE = re.compile(
    rf'^@gen_version = (?:local_unnamed_addr )?global \[[0-9]+ x i8\] c"[^"]+", section "{re.escape(GENERATOR_SECTION)}"$',
    re.MULTILINE,
)


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


def stabilize_qir_snapshot_output(
    qir_output: str | bytes,
    output_format: OutputFormat = OutputFormat.LLVM_IR,
) -> str | bytes:
    match output_format:
        case OutputFormat.LLVM_IR:
            assert isinstance(qir_output, str)  # noqa: S101
            qir_ir = qir_output
        case OutputFormat.BITCODE:
            assert isinstance(qir_output, bytes)  # noqa: S101
            qir_ir = str(parse_bitcode(qir_output, context=create_context()))
        case OutputFormat.BASE64:
            assert isinstance(qir_output, str)  # noqa: S101
            qir_ir = str(
                parse_bitcode(b64decode(qir_output.encode("utf-8")), context=create_context())
            )
    normalized_qir_ir = GENERATOR_VERSION_LINE_RE.sub(
        f'@gen_version = global [5 x i8] c"0.0.0", section "{GENERATOR_SECTION}"',
        qir_ir,
    )
    return ir_string_to_output_format(normalized_qir_ir, output_format)


@pytest.fixture
def helios_wasm_file() -> Path:
    return TEST_DIR / Path("resources/helios.wasm")


@pytest.fixture
def h2_wasm_file() -> Path:
    return TEST_DIR / Path("resources/h2.wasm")


guppy_example_dict = generate_guppy_example_dict(get_guppy_files())
guppy_examples: list[GuppyExample] = [
    guppy_example for _, guppy_example in guppy_example_dict.items()
]
