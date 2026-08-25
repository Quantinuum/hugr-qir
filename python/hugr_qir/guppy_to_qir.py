from collections.abc import Callable

from guppylang.defs import GuppyFunctionDefinition

from .h_series_helpers.results import ResultSpec, hugr_to_result_spec
from .hugr_to_qir import to_qir_bytes, to_qir_str


def guppy_to_qir_bytes(
    entrypoint: Callable, *, validate_qir: bool = True
) -> tuple[bytes, ResultSpec]:
    """
    Converts guppy entrypoint to qir bytes

    :param entrypoint: Guppy entrypoint function
    :type entrypoint: GuppyFunctionDefinition
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as bytes and its result spec
    :rtype: tuple[bytes, ResultSpec]
    """
    if not hasattr(entrypoint, "compile"):
        message = "Provided value for entrypoint is not a Guppy entrypoint"
        raise ValueError(message)

    assert isinstance(entrypoint, GuppyFunctionDefinition)  # noqa: S101
    hugr = entrypoint.compile()
    result_spec = hugr_to_result_spec(hugr)
    return to_qir_bytes(hugr, validate_qir=validate_qir), result_spec


def guppy_to_qir_str(
    entrypoint: Callable, *, validate_qir: bool = True
) -> tuple[str, ResultSpec]:
    """
    Converts guppy entrypoint to qir str

    :param entrypoint: Guppy entrypoint function
    :type entrypoint: GuppyFunctionDefinition
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as a str and its result spec
    :rtype: tuple[str, ResultSpec]
    """

    if not hasattr(entrypoint, "compile"):
        message = "Provided value for entrypoint is not a Guppy entrypoint"
        raise ValueError(message)

    assert isinstance(entrypoint, GuppyFunctionDefinition)  # noqa: S101

    hugr = entrypoint.compile()
    result_spec = hugr_to_result_spec(hugr)
    return to_qir_str(hugr, validate_qir=validate_qir), result_spec
