from collections.abc import Sequence
from typing import Any, TypeAlias, cast

from hugr.qsystem.result import QsysResult, QsysShot
from pytket import Bit
from pytket.backends.backendresult import BackendResult

ShotValue: TypeAlias = bool | int | str


def _decode_signed_i64_bit_value(bits: Sequence[bool | int]) -> int:
    value = sum(int(bits[i]) * (2**i) for i in range(64))
    if value >= (1 << 63):
        value -= 1 << 64
    return value


def _decode_unsigned_u64_bit_value(bits: Sequence[bool | int]) -> int:
    return sum(int(bits[i]) * (2**i) for i in range(64))


def backendresult_to_qsysresult(backres: BackendResult) -> QsysResult:
    """
    converts a given pytket BackendResult result into a QsysResult
    """

    try:
        return _to_qsysresult_using_type_tags(backres)
    except ValueError:
        return _to_qsysresult_fallback(backres)


def _check_backres(backres: BackendResult, set_cregnames: set) -> None:
    """check if all cregs are of size 64"""
    for x in set_cregnames:
        for i in range(64):
            if Bit(name=x, index=i) not in backres.c_bits:
                msg = f"creg {x} is missing Bit {i}, they all must be of length 64"
                raise ValueError(msg)


def _get_creg_names(backres: BackendResult) -> set:
    """set up a set of all creg names"""
    set_cregnames = set()
    for b in backres.c_bits:
        set_cregnames.add(b.reg_name)

    return set_cregnames


def _get_creg_shape(set_cregnames: set) -> dict[str, tuple[str, str, int | None]]:
    """generate a dict mapping:
    original creg name with type information
    to a tuple of creg name, type, and index in array"""

    creg_shape: dict[str, tuple[str, str, int | None]] = {}

    for cregname in set_cregnames:
        split_creg = cregname.rsplit("___", maxsplit=1)

        if len(split_creg) != 2:  # noqa: PLR2004
            raise ValueError(f"No type information found in reg name: {cregname}")  # noqa: TRY003, EM102

        type_tokens = split_creg[1].split("_")
        ctype = type_tokens[0]
        index = int(type_tokens[1]) if len(type_tokens) > 1 else None
        creg_shape[cregname] = (split_creg[0], ctype, index)

        if creg_shape[cregname][1] not in [
            "BOOL",
            "INT",
            "UINT",
            "ARRBOOL",
            "ARRINT",
            "ARRUINT",
        ]:
            raise ValueError(f"unexpected TYPE in reg name: {creg_shape[cregname][1]}")  # noqa: TRY003, EM102
    return creg_shape


def _to_qsysresult_using_type_tags(backres: BackendResult) -> QsysResult:  # noqa: C901, PLR0912, PLR0915
    """returns a qsys result based on the type information in the name of the creg"""

    set_cregnames = _get_creg_names(backres)

    _check_backres(backres, set_cregnames)

    creg_shape = _get_creg_shape(set_cregnames)

    list_shots: list[QsysShot] = []

    result_arrays: dict[str, list[int | bool]] = {}

    cached_results = {}

    for cregname in set_cregnames:
        regname, ctype, index = creg_shape[cregname]

        # set up the result array
        if ctype in {"ARRBOOL", "ARRINT", "ARRUINT"}:
            if index is None:
                raise ValueError(f"missing array index in reg name: {cregname}")  # noqa: TRY003, EM102
            if regname not in result_arrays:
                result_arrays[regname] = []
            while len(result_arrays[regname]) <= index:
                result_arrays[regname].append(0)

        # cache the result based on the register groups
        if ctype == "BOOL":
            bitlist = [Bit(name=cregname, index=0)]
            cached_results[cregname] = backres.get_shots(cbits=bitlist)
        elif ctype in {"INT", "UINT"}:
            bitlist = [Bit(name=cregname, index=bit_index) for bit_index in range(64)]
            cached_results[cregname] = backres.get_shots(cbits=bitlist)
        elif ctype == "ARRBOOL":
            bitlist = [Bit(name=cregname, index=0)]
            cached_results[cregname] = backres.get_shots(cbits=bitlist)
        elif ctype in {"ARRINT", "ARRUINT"}:
            bitlist = [Bit(name=cregname, index=bit_index) for bit_index in range(64)]
            cached_results[cregname] = backres.get_shots(cbits=bitlist)

    # set up a qsys shot for each shot in the backend result:
    for i in range(len(backres.get_shots())):
        shot_result: list[tuple[str, bool | int | list[int] | list[bool]]] = []
        shot_arrays: dict[str, list[bool | int | None]] = {
            k: [None for _ in v] for k, v in result_arrays.items()
        }
        for cregname in set_cregnames:
            regname, ctype, index = creg_shape[cregname]

            if ctype == "BOOL":
                res = cached_results[cregname][i]
                shot_result.append((regname, bool(res)))
            elif ctype == "INT":
                res = cached_results[cregname][i]
                shot_result.append(
                    (
                        regname,
                        _decode_signed_i64_bit_value(res),
                    )
                )
            elif ctype == "UINT":
                res = cached_results[cregname][i]
                shot_result.append(
                    (
                        regname,
                        _decode_unsigned_u64_bit_value(res),
                    )
                )
            elif ctype == "ARRBOOL":
                if index is None:
                    raise ValueError(f"missing array index in reg name: {cregname}")  # noqa: TRY003, EM102
                res = cached_results[cregname][i]
                shot_arrays[regname][index] = bool(res)
            elif ctype == "ARRINT":
                if index is None:
                    raise ValueError(f"missing array index in reg name: {cregname}")  # noqa: TRY003, EM102
                res = cached_results[cregname][i]
                shot_arrays[regname][index] = _decode_signed_i64_bit_value(res)
            elif ctype == "ARRUINT":
                if index is None:
                    raise ValueError(f"missing array index in reg name: {cregname}")  # noqa: TRY003, EM102
                res = cached_results[cregname][i]
                shot_arrays[regname][index] = _decode_unsigned_u64_bit_value(res)
            else:
                raise ValueError("found unexpected type")  # noqa: EM101, TRY003

        # check and cast the type for each of the arrays:
        for regname, values in shot_arrays.items():
            if any(value is None for value in values):
                raise ValueError(f"incomplete array result for reg name: {regname}")  # noqa: TRY003, EM102
            if all(isinstance(value, bool) for value in values):
                shot_result.append((regname, cast("list[bool]", values)))
            else:
                shot_result.append((regname, cast("list[int]", values)))

        list_shots.append(QsysShot(cast("Any", shot_result)))

    return QsysResult(list_shots)


def _to_qsysresult_fallback(backres: BackendResult) -> QsysResult:
    """convert to qsysresult, assuming that all cregs are signed i64"""

    set_cregnames = _get_creg_names(backres)

    _check_backres(backres, set_cregnames)

    list_shots: list[QsysShot] = []

    cached_results = {}

    for cregname in set_cregnames:
        bitlist = [Bit(name=cregname, index=bit_index) for bit_index in range(64)]
        cached_results[cregname] = backres.get_shots(cbits=bitlist)

    for i in range(len(backres.get_shots())):
        shot_result: list[tuple[str, bool | int]] = []
        for cregname in set_cregnames:
            res = cached_results[cregname][i]
            shot_result.append((cregname, _decode_signed_i64_bit_value(res)))

        list_shots.append(QsysShot(cast("Any", shot_result)))

    return QsysResult(list_shots)
