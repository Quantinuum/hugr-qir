import base64
import re
from collections.abc import Sequence
from enum import StrEnum
from typing import Any, TypeAlias, cast

from hugr.qsystem.result import QsysResult, QsysShot
from pyqir import Context, Module, Opcode
from pytket import Bit
from pytket.backends.backendresult import BackendResult

from hugr_qir.output import OutputFormat

ShotValue: TypeAlias = bool | int | str


class ResultRep(StrEnum):
    """Supported user-facing representations for recorded result values.

    Examples:
        ``BOOL`` converts to a bool ``True``/ ``False``.

        ``BIT`` converts to ``"1"``/``"0"``.

        ``BITSTRING`` shows full 64-bit bitstring, such as
         ``"0000000000000000100000000000000000000000000000000010000000000000"``.

        ``INT`` converts a signed two's-complement bitstring to an int, such as
        to ``-2``.
    """

    BOOL = "bool"
    BIT = "bit"
    BITSTRING = "bitstring"
    INT = "int"


def _decode_signed_64_bit_value(bits: Sequence[bool | int]) -> int:
    value = sum(int(bits[i]) * (2**i) for i in range(64))
    if value >= (1 << 63):
        value -= 1 << 64
    return value


def qir_to_result_spec(
    qir: bytes | str, qir_format: OutputFormat
) -> dict[str, ResultRep]:
    """Infer result representations from QIR."""
    operation_representations = {
        "__quantum__rt__bool_record_output": ResultRep.BOOL,
        "__quantum__rt__int_record_output": ResultRep.INT,
    }
    result_representations: dict[str, ResultRep] = {}
    ctx = Context()
    if qir_format == OutputFormat.BITCODE:
        assert isinstance(qir, bytes)  # noqa: S101
        mod = Module.from_bitcode(ctx, qir)
    elif qir_format == OutputFormat.BASE64:
        assert isinstance(qir, str)  # noqa: S101
        qir_bytes = base64.b64decode(qir)
        mod = Module.from_bitcode(ctx, qir_bytes)
    elif qir_format == OutputFormat.LLVM_IR:
        assert isinstance(qir, str)  # noqa: S101
        mod = Module.from_ir(ctx, qir)
    else:
        msg = f"Unsupported QIR output format {qir_format!r}"
        raise ValueError(msg)
    for function in mod.functions:
        for block in function.basic_blocks:
            for inst in block.instructions:
                inst_any = cast("Any", inst)
                opcode = inst.opcode
                if opcode == Opcode.CALL:  # noqa: SIM102
                    if inst_any.callee.name in operation_representations:
                        global_str = str(inst_any.args[1])
                        match = re.search(r'c"([^"\\]+)', global_str)
                        if match:
                            variable_name = match.group(1).removesuffix("\\00")
                            result_representations[variable_name] = (
                                operation_representations[inst_any.callee.name]
                            )
    return result_representations


def backendresult_to_qsysresult(backres: BackendResult) -> QsysResult:  # noqa: C901, PLR0912, PLR0915
    number_of_shots = len(backres.get_shots())
    clean_creg: dict[str, tuple[str, str, int | None]] = {}

    set_cregnames = set()
    for b in backres.c_bits:
        set_cregnames.add(b.reg_name)

    for cregname in set_cregnames:
        split_creg = cregname.split("___")

        if len(split_creg) != 2:  # noqa: PLR2004
            raise ValueError(f"unexpected ___ in reg name: {cregname}")  # noqa: TRY003, EM102

        type_tokens = split_creg[1].split("_")
        ctype = type_tokens[0]
        index = int(type_tokens[1]) if len(type_tokens) > 1 else None
        clean_creg[cregname] = (split_creg[0], ctype, index)

        if clean_creg[cregname][1] not in ["BOOL", "INT", "ARRBOOL", "ARRINT"]:
            raise ValueError(f"unexpected TYPE in reg name: {clean_creg[cregname][1]}")  # noqa: TRY003, EM102

    list_shots: list[QsysShot] = []
    result_arrays: dict[str, list[int | bool]] = {}
    for cregname in set_cregnames:
        regname, ctype, _ = clean_creg[cregname]
        if ctype in ["ARRBOOL", "ARRINT"]:
            result_arrays[regname] = []

    for cregname in set_cregnames:
        regname, ctype, index = clean_creg[cregname]
        if ctype in ["ARRBOOL", "ARRINT"]:
            assert index is not None  # noqa: S101
            while len(result_arrays[regname]) <= index:
                result_arrays[regname].append(0)

    for i in range(number_of_shots):
        shot_result: list[tuple[str, bool | int | list[int] | list[bool]]] = []
        shot_arrays = {k: [0 for _ in v] for k, v in result_arrays.items()}
        for cregname in set_cregnames:
            regname, ctype, index = clean_creg[cregname]
            if ctype == "BOOL":  # BOOL
                bitlist = [Bit(name=cregname, index=0)]
                res = backres.get_shots(cbits=bitlist)[i]
                shot_result.append((regname, bool(res)))
            elif ctype == "INT":  # INT
                bitlist = [
                    Bit(name=cregname, index=bit_index) for bit_index in range(64)
                ]
                res = backres.get_shots(cbits=bitlist)[i]
                shot_result.append(
                    (
                        regname,
                        _decode_signed_64_bit_value(res),
                    )
                )
            elif ctype == "ARRBOOL":  # ARRBOOL
                bitlist = [Bit(name=cregname, index=0)]
                res = backres.get_shots(cbits=bitlist)[i]
                assert index is not None  # noqa: S101
                shot_arrays[regname][index] = bool(res)
            elif ctype == "ARRINT":  # ARRINT
                bitlist = [
                    Bit(name=cregname, index=bit_index) for bit_index in range(64)
                ]
                res = backres.get_shots(cbits=bitlist)[i]
                assert index is not None  # noqa: S101
                shot_arrays[regname][index] = _decode_signed_64_bit_value(res)
            else:
                raise ValueError("found unexpected type")  # noqa: EM101, TRY003

        for regname, values in shot_arrays.items():
            if all(isinstance(value, bool) for value in values):
                shot_result.append((regname, cast("list[bool]", values)))
            else:
                shot_result.append((regname, [int(value) for value in values]))

        list_shots.append(QsysShot(cast("Any", shot_result)))

    return QsysResult(list_shots)


def backendresult_to_qsysresult_with_qir(
    backres: BackendResult, qir: str
) -> QsysResult:
    result_representations = qir_to_result_spec(qir, OutputFormat.LLVM_IR)
    number_of_shots = len(backres.get_shots())

    list_shots: list[QsysShot] = []

    for i in range(number_of_shots):
        shot_result: list[tuple[str, bool | int]] = []
        for cregname in result_representations:
            ctype = result_representations[cregname]
            if ctype == ResultRep.BOOL:  # BOOL
                bitlist = [Bit(name=cregname, index=0)]
                res = backres.get_shots(cbits=bitlist)[i]
                shot_result.append((cregname, bool(res)))
            elif ctype == ResultRep.INT:  # INT
                bitlist = [
                    Bit(name=cregname, index=bit_index) for bit_index in range(64)
                ]
                res = backres.get_shots(cbits=bitlist)[i]
                shot_result.append((cregname, _decode_signed_64_bit_value(res)))
            else:
                raise ValueError("found unexpected type")  # noqa: EM101, TRY003

        list_shots.append(QsysShot(cast("Any", shot_result)))

    return QsysResult(list_shots)


def _handle_results(results: BackendResult) -> list[dict[str, list[int]]]:
    bitlist = results.get_bitlist()
    shots = results.get_shots()
    n_shots, n_bits = shots.shape
    shots_res = [[int(x) for x in reversed(shots[s])] for s in range(n_shots)]
    hqr_results = []
    for s in range(n_shots):
        pairs = []
        for i in range(n_bits // 64):
            start = i * 64
            end = (i + 1) * 64
            res_name = bitlist[start].reg_name
            res_val = shots_res[s][start:end]
            pairs.append((res_name, res_val))
        hqr_results.append(dict(pairs))
    return hqr_results
