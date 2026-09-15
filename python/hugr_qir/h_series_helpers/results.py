from collections.abc import Sequence
from typing import Any, TypeAlias, cast

from hugr.qsystem.result import QsysResult, QsysShot
from pytket import Bit
from pytket.backends.backendresult import BackendResult

ShotValue: TypeAlias = bool | int | str


def _decode_signed_64_bit_value(bits: Sequence[bool | int]) -> int:
    value = sum(int(bits[i]) * (2**i) for i in range(64))
    if value >= (1 << 63):
        value -= 1 << 64
    return value


def backendresult_to_qsysresult(backres: BackendResult) -> QsysResult:
    """
    converts a given pytket BackendResult result into a QsysResult
    """

    try:
        return _backendresult_to_qsysresult_new(backres)
    except ValueError:
        return _backendresult_to_qsysresult_old(backres)


def _backendresult_to_qsysresult_new(backres: BackendResult) -> QsysResult:  # noqa: C901, PLR0912, PLR0915
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


def _backendresult_to_qsysresult_old(backres: BackendResult) -> QsysResult:
    set_cregnames = set()
    for b in backres.c_bits:
        set_cregnames.add(b.reg_name)

    number_of_shots = len(backres.get_shots())

    list_shots: list[QsysShot] = []

    for i in range(number_of_shots):
        shot_result: list[tuple[str, bool | int]] = []
        for cregname in set_cregnames:
            bitlist = [Bit(name=cregname, index=bit_index) for bit_index in range(64)]
            res = backres.get_shots(cbits=bitlist)[i]
            shot_result.append((cregname, _decode_signed_64_bit_value(res)))

        list_shots.append(QsysShot(cast("Any", shot_result)))

    return QsysResult(list_shots)
