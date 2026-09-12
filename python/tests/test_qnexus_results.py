from pathlib import Path

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.platform import _output_nat as output_nat

from tests.conftest import TEST_DIR

BACKEND_RESULT = TEST_DIR / Path("resources/backend_results/backend_result.json")
EXPECTED_SHOTS = 10
INTEGER_VALUE = 3


@guppy
def result_spec_program() -> None:
    output("flag", True)  # noqa: FBT003
    output("count", 42)


@guppy
def unsigned_result_spec_program() -> None:
    output_nat("unsigned_count", 42)


@guppy
def unsupported_result_spec_program() -> None:
    output("value", 1.0)


@guppy
def conflicting_result_spec_program() -> None:
    output("value", True)  # noqa: FBT003
    output("value", 42)
