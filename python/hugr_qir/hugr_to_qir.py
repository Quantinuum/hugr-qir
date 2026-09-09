import tempfile
from pathlib import Path

from hugr.package import Package

from ._hugr_qir import (
    compile_target_default,
    max_loop_unroll_default,
    opt_level_default,
)
from .cli import hugr_qir_impl
from .output import OutputFormat


def hugr_to_qir(  # noqa: PLR0913
    hugr: Package | bytes,
    *,
    validate_qir: bool = True,
    validate_hugr: bool = False,
    target: str = compile_target_default(),
    opt_level: str = opt_level_default(),
    max_loop_unroll: int = max_loop_unroll_default(),
    output_format: OutputFormat = OutputFormat.BASE64,
    wasm_file: Path | None = None,
) -> str | bytes:
    """A function for converting hugr to qir (llvm bitcode)

    :param hugr: HUGR in binary format
    :param validate_qir: Whether to validate the created QIR
    :param validate_hugr: Whether to validate the input hugr before
     and after each internal pass
    :param target: LLVM compilation target, same options as cli,
     run hugr-qir --help to see available options and default
    :param opt_level: LLVM optimization level, same options as cli,
     run hugr-qir --help to see available options and default
    :param max_loop_unroll: Maximum statically-known loop trip count to fully
     unroll before QIR emission
    :param output_format: Output format, see OutputFormat enum
     for available options
    :param wasm_file: Optional path to WASM binary file
    :returns: QIR corresponding to the HUGR input in format given
     by `output_format`
    """
    with tempfile.TemporaryDirectory(ignore_cleanup_errors=True) as tmp_dir:
        hugr_bytes: bytes
        tmp_infile_path = Path(f"{tmp_dir}/tmp.hugr")  # noqa: S108
        tmp_outfile_path = Path(f"{tmp_dir}/tmp_output")  # noqa: S108

        if type(hugr) is bytes:
            hugr_bytes = hugr
        else:
            assert type(hugr) is Package  # noqa: S101
            hugr_bytes = hugr.to_bytes()

        with Path.open(tmp_infile_path, "wb") as cli_input:
            cli_input.write(hugr_bytes)

        hugr_qir_impl(
            validate_qir,
            validate_hugr,
            target,
            opt_level,
            max_loop_unroll,
            output_format,
            tmp_infile_path,
            tmp_outfile_path,
            wasm_file,
        )

        read_mode = "rb" if output_format == OutputFormat.BITCODE else "r"

        with Path.open(tmp_outfile_path, mode=read_mode) as cli_output:
            return cli_output.read()


def to_qir_str(
    hugr: Package | bytes,
    *,
    validate_qir: bool = True,
    max_loop_unroll: int = max_loop_unroll_default(),
) -> str:
    """
    Converts hugr package to qir str

    Uses hugr_to_qir internally with default settings and llvm_ir output format.

    :param hugr: hugr package
    :type hugr: Package
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :param max_loop_unroll: Maximum statically-known loop trip count to fully unroll
    :return: QIR corresponding to the HUGR input as str
    :rtype: str
    """

    qir_str = hugr_to_qir(
        hugr,
        output_format=OutputFormat.LLVM_IR,
        validate_qir=validate_qir,
        max_loop_unroll=max_loop_unroll,
    )
    assert isinstance(qir_str, str)  # noqa: S101
    return qir_str


def to_qir_bytes(
    hugr: Package | bytes,
    *,
    validate_qir: bool = True,
    max_loop_unroll: int = max_loop_unroll_default(),
) -> bytes:
    """
    Converts hugr package to qir bytes.

    Uses hugr_to_qir internally with default settings and bitcode output format.

    :param hugr: hugr package
    :type hugr: Package
    :param validate_qir: Whether to validate the created QIR
    :type validate_qir: bool
    :param max_loop_unroll: Maximum statically-known loop trip count to fully unroll
    :return: QIR corresponding to the HUGR input as bytes
    :rtype: bytes
    """

    qir_bytes = hugr_to_qir(
        hugr,
        output_format=OutputFormat.BITCODE,
        validate_qir=validate_qir,
        max_loop_unroll=max_loop_unroll,
    )
    assert isinstance(qir_bytes, bytes)  # noqa: S101
    return qir_bytes
