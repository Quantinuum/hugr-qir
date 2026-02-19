from collections.abc import Callable

from guppylang.defs import GuppyFunctionDefinition
from tket_exts import tket_registry

from .hugr_to_qir import to_qir_bytes, to_qir_str


def guppy_to_qir_bytes(entrypoint: Callable, *, validate_qir: bool = True) -> bytes:
    """
    Converts guppy entrypoint to qir bytes

    :param entrypoint: Guppy entrypoint function
    :type entrypoint: GuppyFunctionDefinition
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as bytes
    :rtype: bytes
    """
    if not hasattr(entrypoint, "compile"):
        message = "Provided value for entrypoint is not a Guppy entrypoint"
        raise ValueError(message)

    assert isinstance(entrypoint, GuppyFunctionDefinition)  # noqa: S101
    return to_qir_bytes(entrypoint.compile(), validate_qir=validate_qir)


def guppy_to_qir_str(entrypoint: Callable, *, validate_qir: bool = True) -> str:
    """
    Converts guppy entrypoint to qir str

    :param entrypoint: Guppy entrypoint function
    :type entrypoint: GuppyFunctionDefinition
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as a str
    :rtype: str
    """

    if not hasattr(entrypoint, "compile"):
        message = "Provided value for entrypoint is not a Guppy entrypoint"
        raise ValueError(message)

    assert isinstance(entrypoint, GuppyFunctionDefinition)  # noqa: S101

    hugr_package = entrypoint.compile()
    # Remove this once guppy extension handling bug is fixed
    for ext in tket_registry().extensions.values():
        if ext not in hugr_package.extensions:
            hugr_package.extensions.append(ext)
    return to_qir_str(hugr_package, validate_qir=validate_qir)
