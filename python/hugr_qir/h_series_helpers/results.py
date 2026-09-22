from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from logging import getLogger
from typing import TYPE_CHECKING

from hugr.qsystem.result import QsysResult, QsysShot

if TYPE_CHECKING:
    from pytket import Bit
    from pytket.backends.backendresult import BackendResult

logger = getLogger(__name__)

ShotValue = bool | int
Shots = list[ShotValue]
ShotsByTag = dict[str, Shots | list[Shots]]

EXPECTED_REGISTER_SIZE = 64
EXPECTED_REGISTER_INDICES = set(range(EXPECTED_REGISTER_SIZE))


class ResultType(Enum):
    BOOL = "BOOL"
    INT = "INT"
    UINT = "UINT"
    ARRBOOL = "ARRBOOL"
    ARRINT = "ARRINT"
    ARRUINT = "ARRUINT"
    MISSING = "MISSING"
    UNRECOGNIZED = "UNRECOGNIZED"

    @property
    def is_array(self) -> bool:
        return self in {self.ARRBOOL, self.ARRINT, self.ARRUINT}


@dataclass(frozen=True)
class CregResult:
    reg_name: str
    shots: list[list[int]]


@dataclass(frozen=True)
class TagResult:
    user_tag: str
    shots: list[list[int]]
    result_type: ResultType
    array_index: int | None = None

    @property
    def is_array(self) -> bool:
        return self.result_type.is_array

    def decode(self) -> Shots:
        match self.result_type:
            case ResultType.BOOL | ResultType.ARRBOOL:
                return [bool(shot[0]) for shot in self.shots]
            case ResultType.INT | ResultType.ARRINT:
                return [_decode_signed_i64_bit_value(shot) for shot in self.shots]
            case ResultType.UINT | ResultType.ARRUINT:
                return [_decode_unsigned_u64_bit_value(shot) for shot in self.shots]
            case ResultType.UNRECOGNIZED | ResultType.MISSING:
                return [_decode_signed_i64_bit_value(shot) for shot in self.shots]


class ResultConversionError(Exception):
    """Raised when a BackendResult cannot be converted to a QsysResult."""


def _get_creg_results(backres: BackendResult) -> list[CregResult]:
    """Extract and validate the classical registers from a backend result."""
    bits_by_register: dict[str, list[Bit]] = {}
    for bit in backres.c_bits:
        bits_by_register.setdefault(bit.reg_name, []).append(bit)

    creg_results = []
    for reg_name, bits in bits_by_register.items():
        indices = {bit.index[0] for bit in bits if len(bit.index) == 1}
        if len(indices) != len(bits) or indices != EXPECTED_REGISTER_INDICES:
            msg = (
                f"BackendResult register {reg_name!r} must contain exactly "
                f"bits 0 through {EXPECTED_REGISTER_SIZE - 1}"
            )
            raise ResultConversionError(msg)

        # BackendResult stores register readouts most-significant bit first.
        ordered_bits = sorted(bits, key=lambda bit: bit.index, reverse=True)
        shots = [
            [int(value) for value in reversed(shot)]
            for shot in backres.get_shots(cbits=ordered_bits)
        ]
        creg_results.append(CregResult(reg_name, shots))

    return creg_results


def _tag_result_from_creg_result(creg_result: CregResult) -> TagResult:
    user_tag, separator, type_tag = creg_result.reg_name.rpartition("___")
    if not separator:
        return TagResult(
            user_tag=creg_result.reg_name,
            shots=creg_result.shots,
            result_type=ResultType.MISSING,
        )

    result_type_name, index_separator, index_text = type_tag.partition("_")
    try:
        result_type = ResultType(result_type_name)
    except ValueError:
        result_type = ResultType.UNRECOGNIZED

    array_index = None
    if result_type.is_array:
        if index_separator and index_text.isdecimal():
            array_index = int(index_text)
        else:
            result_type = ResultType.UNRECOGNIZED
    elif index_separator:
        result_type = ResultType.UNRECOGNIZED

    return TagResult(
        user_tag=user_tag,
        shots=creg_result.shots,
        result_type=result_type,
        array_index=array_index,
    )


def _decode_signed_i64_bit_value(bits: list[int]) -> int:
    value = sum(bit << index for index, bit in enumerate(bits))
    return value - (1 << 64) if value >= (1 << 63) else value


def _decode_unsigned_u64_bit_value(bits: list[int]) -> int:
    return sum(bit << index for index, bit in enumerate(bits))


def backendresult_to_qsysresult(backres: BackendResult) -> QsysResult:
    """Convert a pytket BackendResult into a QsysResult.

    Register names produced by hugr-qir >= 0.3.0 contain the Guppy output
    type. Missing or malformed type information is interpreted as a signed
    64-bit integer. Every register must contain exactly bits 0 through 63.
    """
    n_shots = len(backres.get_shots())
    tag_results = [
        _tag_result_from_creg_result(creg_result)
        for creg_result in _get_creg_results(backres)
    ]

    _warn_about_missing_types(tag_results)
    shots_by_tag = _group_shots_by_tag(tag_results)

    return QsysResult(
        [
            QsysShot([(tag, shots[shot_index]) for tag, shots in shots_by_tag.items()])
            for shot_index in range(n_shots)
        ]
    )


def _group_shots_by_tag(tag_results: list[TagResult]) -> ShotsByTag:
    shots_by_tag: ShotsByTag = {}
    arrays_by_tag: dict[str, list[tuple[int, Shots]]] = {}

    for tag_result in tag_results:
        shots = tag_result.decode()
        if tag_result.is_array:
            if tag_result.array_index is None:
                msg = f"Array result {tag_result.user_tag!r} has no index"
                raise ResultConversionError(msg)
            arrays_by_tag.setdefault(tag_result.user_tag, []).append(
                (tag_result.array_index, shots)
            )
        else:
            shots_by_tag[tag_result.user_tag] = shots

    for array_tag, indexed_shots in arrays_by_tag.items():
        indexed_shots.sort(key=lambda item: item[0])
        indices = [index for index, _ in indexed_shots]
        if len(indices) != len(set(indices)):
            msg = f"Array result {array_tag!r} contains duplicate indices"
            raise ResultConversionError(msg)
        if indices != list(range(len(indexed_shots))):
            logger.warning(
                "Array type result %s is missing indices,"
                " treating each index individually",
                array_tag,
            )
            for index, shots in indexed_shots:
                shots_by_tag[f"{array_tag}_{index}"] = shots
            continue

        shots_per_index = [shots for _, shots in indexed_shots]
        shots_by_tag[array_tag] = [
            list(values) for values in zip(*shots_per_index, strict=True)
        ]

    return shots_by_tag


def _warn_about_missing_types(tag_results: list[TagResult]) -> None:
    missing_types = [
        tag_result
        for tag_result in tag_results
        if tag_result.result_type in {ResultType.MISSING, ResultType.UNRECOGNIZED}
    ]
    if not missing_types:
        return

    if len(missing_types) == len(tag_results):
        logger.warning(
            "Missing or unrecognized type information in BackendResult register names."
            " Treating all results as signed 64 bit integers."
        )
        return

    for tag_result in missing_types:
        logger.warning(
            "Unrecognized or missing type information for result tag %s."
            " Treating as signed 64 bit integer.",
            tag_result.user_tag,
        )
