"""Cli for hugr-qir."""

import logging
import tempfile
from importlib.metadata import version
from pathlib import Path

import click
from quantinuum_qircheck import qircheck
from quantinuum_qircheck.qircheck import ValidationError

from hugr_qir._hugr_qir import (
    cli,
    compile_target_choices,
    compile_target_default,
    opt_level_choices,
    opt_level_default,
)
from hugr_qir.output import OutputFormat, get_write_mode, ir_string_to_output_format

logger = logging.getLogger()

CONTEXT_SETTINGS = {"help_option_names": ["-h", "--help"]}


@click.command(name="hugr-qir", context_settings=CONTEXT_SETTINGS)
@click.argument("hugr_file", type=click.Path(exists=True, path_type=Path))
@click.option(
    "--validate-qir/--no-validate-qir",
    "validate_qir",
    default=True,
    show_default=True,
    help="Whether to validate the QIR output",
)
@click.option(
    "--validate-hugr/--no-validate-hugr",
    "validate_hugr",
    default=False,
    show_default=True,
    help="Whether to validate the input hugr before and after each internal pass",
)
@click.option(
    "-t",
    "--target",
    "target",
    type=click.Choice(compile_target_choices()),
    default=compile_target_default(),
    show_default=True,
    help="LLVM compile target",
)
@click.option(
    "-l",
    "--opt-level",
    "opt_level",
    type=click.Choice(opt_level_choices()),
    default=opt_level_default(),
    show_default=True,
    help="LLVM optimization level",
)
@click.option(
    "-f",
    "--output-format",
    "output_format",
    type=click.Choice([c.value for c in OutputFormat], case_sensitive=False),
    default="llvm-ir",
    show_default=True,
    help="Choice of output format",
)
@click.option(
    "-o",
    "--output",
    "outfile",
    type=click.Path(path_type=Path),
    default=None,
    help="Name of output file (optional)",
)
@click.option(
    "-w",
    "--wasm-file",
    "wasm_file",
    type=click.Path(path_type=Path),
    default=None,
    help="Name of wasm binary file to link against (optional)",
)
@click.version_option(version=version("hugr_qir"))
def hugr_qir(  # noqa: PLR0913
    validate_qir: bool,
    validate_hugr: bool,
    target: str,
    opt_level: str,
    output_format: str,
    hugr_file: Path,
    outfile: Path | None,
    wasm_file: Path | None,
) -> None:
    """Convert a HUGR file to QIR.

    Provide the name of the HUGR file as the first argument.
    Per default, QIR is emitted to stdout, but can
    be written to a file using the `-o` option.
    """
    hugr_qir_impl(
        validate_qir,
        validate_hugr,
        target,
        opt_level,
        OutputFormat(output_format),
        hugr_file,
        outfile,
        wasm_file,
    )


def hugr_qir_impl(  # noqa: PLR0913
    validate_qir: bool,
    validate_hugr: bool,
    target: str,
    opt_level: str,
    output_format: OutputFormat,
    hugr_file: Path,
    outfile: Path | None,
    wasm_file: Path | None,
) -> None:
    options = ["-q"]
    options.extend(["-t", target])
    options.extend(["-l", opt_level])
    format_setting, read_mode = tmp_file_settings(output_format)
    options.extend(["-f", format_setting])
    if wasm_file:
        options.extend(["--wasm-file", str(wasm_file)])
    if opt_level == "none":
        logger.warning(
            "WARNING: Chosen optimization level"
            " `none` will generally not result"
            " in valid QIR."
        )
    if validate_hugr:
        options.append("--validate")
    with tempfile.TemporaryDirectory(ignore_cleanup_errors=True) as tmp_dir:
        tmp_outfile_name = f"{tmp_dir}/tmp.ll"  # noqa: S108
        tmp_outfile_path = Path(tmp_outfile_name)
        tmp_options = [*options, "-o", tmp_outfile_name]
        failedqirmsg = "QIR generation failed. This may be the result of a bug \
but can also happen when trying to convert a feature in HUGR/Guppylang \
which is not supported in QIR."
        try:
            cli(str(hugr_file), *tmp_options)
        except (RuntimeError, BaseException) as e:
            msg = f"{failedqirmsg} Error details: {e}"
            raise ValueError(msg) from e
        try:
            with Path.open(tmp_outfile_path, mode=read_mode) as output:
                qir = output.read()
        except FileNotFoundError as e:
            msg = f"{failedqirmsg} Error details: {e}"
            raise ValueError(msg) from e
    if validate_qir:
        try:
            qircheck(qir)
        except (ValueError, ValidationError) as e:
            error_message = (
                e.error_message if isinstance(e, ValidationError) else str(e)
            )
            if "__quantum__rt__qubit_release" in error_message and target == "native":
                pass
            else:
                msg = (
                    f"{failedqirmsg} The failure occurred in the validity check of the "
                    "generated QIR. This check can be disabled by setting "
                    f"`--no-validate-qir` on the cli or passing "
                    f"`validate_qir=False` for library calls. Error details: "
                    f"{error_message}"
                )
                raise ValueError(msg) from e

    qir_out = ir_string_to_output_format(qir, output_format)

    if outfile:
        llvm_write_mode = get_write_mode(output_format)
        with outfile.open(mode=llvm_write_mode) as output:
            output.write(qir_out)
    else:
        print(qir_out)


def tmp_file_settings(output_format: OutputFormat) -> tuple[str, str]:
    """Returns the file format option to pass to rust and read mode
    for reading the temporary file gerated by the rust code."""
    match output_format:
        case OutputFormat.LLVM_IR:
            return "llvm-ir", "r"
        case _:
            return "bitcode", "rb"


if __name__ == "__main__":
    hugr_qir()
