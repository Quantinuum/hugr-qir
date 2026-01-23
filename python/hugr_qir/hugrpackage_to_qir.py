from hugr.package import Package

from .hugr_to_qir import hugr_to_qir  # noqa: F401
from .output import OutputFormat


def try_hugr_qir() -> bool:
    try:
        import hugr_qir  # noqa: F401, PLC0415

        return True  # noqa: TRY300
    except ImportError:
        return False


def package_to_qir_str(self: Package, *, validate_qir: bool = True) -> str:
    """
    Converts hugr package to qir str

    :param self: hugr package
    :type self: Package
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as str
    :rtype: str
    """
    if try_hugr_qir():
        from hugr_qir.hugr_to_qir import hugr_to_qir  # noqa: PLC0415

        qir_str = hugr_to_qir(
            self, output_format=OutputFormat.LLVM_IR, validate_qir=validate_qir
        )
        assert isinstance(qir_str, str)  # noqa: S101
        return qir_str
    raise ValueError(  # noqa: TRY003
        "please install hugr-qir for example via `pip install hugr-qir`"  # noqa: EM101
    )


def package_to_qir_bytes(self: Package, *, validate_qir: bool = True) -> bytes:
    """
    Converts hugr package to qir bytes

    :param self: hugr package
    :type self: Package
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :return: QIR corresponding to the HUGR input as bytes
    :rtype: bytes
    """
    if try_hugr_qir():
        from hugr_qir.hugr_to_qir import hugr_to_qir  # noqa: PLC0415

        qir_bytes = hugr_to_qir(
            self, output_format=OutputFormat.BITCODE, validate_qir=validate_qir
        )
        assert isinstance(qir_bytes, bytes)  # noqa: S101
        return qir_bytes
    raise ValueError(  # noqa: TRY003
        "please install hugr-qir for example via `pip install hugr-qir`"  # noqa: EM101
    )


setattr(Package, "to_qir_str", package_to_qir_str)  # noqa: B010
setattr(Package, "to_qir_bytes", package_to_qir_bytes)  # noqa: B010
