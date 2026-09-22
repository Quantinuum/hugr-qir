from dataclasses import dataclass, field
from enum import Enum
from logging import getLogger

from hugr.qsystem.result import QsysResult, QsysShot
from pytket.backends.backendresult import BackendResult

logger = getLogger(__name__)

ShotValue = bool | int


class ResultType(Enum):
    BOOL = "BOOL"
    INT = "INT"
    UINT = "UINT"
    ARRBOOL = "ARRBOOL"
    ARRINT = "ARRINT"
    ARRUINT = "ARRUINT"
    MISSING = "MISSING"
    UNRECOGNIZED = "UNRECOGNIZED"


@dataclass
class CregResult:
    reg_name: str
    reg_size: int
    shots: list[list[int]]


@dataclass
class TagResult:
    user_tag: str
    shots: list[list[int]]
    result_type: ResultType
    array_index: int | None = None
    shots_qsys: list[ShotValue] = field(default_factory=list)

    def __post_init__(self) -> None:
        """If array type is malformed, treat as unrecognized"""
        if self.is_array_type() and self.array_index is None:
            self.result_type = ResultType.UNRECOGNIZED

    def is_array_type(self) -> bool:
        return self.result_type in [
            ResultType.ARRBOOL,
            ResultType.ARRINT,
            ResultType.ARRUINT,
        ]

    def update_qsysresult_values(self) -> None:
        match self.result_type:
            case ResultType.BOOL | ResultType.ARRBOOL:
                self.shots_qsys = [bool(shot[0]) for shot in self.shots]
            case ResultType.INT | ResultType.ARRINT:
                self.shots_qsys = [
                    _decode_signed_i64_bit_value(shot) for shot in self.shots
                ]
            case ResultType.UINT | ResultType.ARRUINT:
                self.shots_qsys = [
                    _decode_unsigned_u64_bit_value(shot) for shot in self.shots
                ]
            case ResultType.UNRECOGNIZED | ResultType.MISSING:
                logger.warning(
                    "Unrecognized or missing type information for result tag"
                    " %s. Treating as signed 64 bit integer.",
                    self.user_tag,
                )
                self.shots_qsys = [
                    _decode_signed_i64_bit_value(shot) for shot in self.shots
                ]


def _get_creg_results(br: BackendResult) -> tuple[list[CregResult], int]:
    """list of all creg names"""
    reg_names = [b.reg_name for b in br.c_bits if b.index == [0]]
    bits_per_reg = [[b for b in br.c_bits if b.reg_name == name] for name in reg_names]
    bit_results = [
        [[int(i) for i in reversed(shot)] for shot in br.get_shots(cbits=bits)]
        for bits in bits_per_reg
    ]
    n_shots = len(bit_results[0])
    return [
        CregResult(reg_names[i], len(bits_per_reg[i]), bit_results[i])
        for i in range(len(reg_names))
    ], n_shots


def _tag_result_from_creg_result(creg_result: CregResult) -> TagResult:
    split_creg_name = creg_result.reg_name.rsplit(sep="___", maxsplit=1)
    user_tag = split_creg_name[0]
    hugr_qir_type_tag = split_creg_name[1] if len(split_creg_name) > 1 else None
    if hugr_qir_type_tag:
        type_tokens = hugr_qir_type_tag.split("_")
        result_type_str = type_tokens[0]
        result_index = int(type_tokens[1]) if len(type_tokens) > 1 else None
    else:
        result_type_str = "MISSING"
        result_index = None

    try:
        result_type = ResultType(result_type_str)
    except ValueError:
        result_type = ResultType.UNRECOGNIZED

    return TagResult(
        user_tag=user_tag,
        shots=creg_result.shots,
        result_type=result_type,
        array_index=result_index,
    )


def _decode_signed_i64_bit_value(bits: list[int]) -> int:
    value = sum(int(bits[i]) * (2**i) for i in range(64))
    if value >= (1 << 63):
        value -= 1 << 64
    return value


def _decode_unsigned_u64_bit_value(bits: list[int]) -> int:
    return sum(int(bits[i]) * (2**i) for i in range(64))


class ResultConversionError(Exception):
    """Exception raised issues in the conversion if the
    reg names are not as expected"""

    def __init__(self, message: str) -> None:
        self.message = message
        super().__init__(self.message)


EXPECTED_REGISTER_SIZE = 64


def backendresult_to_qsysresult(backres: BackendResult) -> QsysResult:
    """This function can generate a qsys result from a given pytket result.
    When hugr-qir >= 0.3.0 was used for the generation of the submitted
    qir the register names in the pytket BackendResult contain the
    type of the value recorded. This information is used to map each
    guppy output tag to the appropriate type in the QsysResult data
    If this type information is missing in the register name or is
    incomplete, each register will be interpreted as a 64 bit signed
    integer. If any registers are not 64 bits, the results are either
    not from a hugr-qir converted program or corrupted, and
    conversion will fail
    """

    creg_results, n_shots = _get_creg_results(backres)

    if not all(creg.reg_size == EXPECTED_REGISTER_SIZE for creg in creg_results):
        msg = "Not all BackendResult registers are 64 bits"
        raise ResultConversionError(msg)

    tag_results = [
        _tag_result_from_creg_result(creg_result) for creg_result in creg_results
    ]

    _handle_all_type_tags_missing(tag_results)

    for tagres in tag_results:
        tagres.update_qsysresult_values()

    tag_shots_dict = extract_shots_info(tag_results)

    qsys_shots = [
        QsysShot([(tag, shot[i]) for tag, shot in tag_shots_dict.items()])
        for i in range(n_shots)
    ]
    return QsysResult(qsys_shots)


def extract_shots_info(
    tag_results: list[TagResult],
) -> dict[str, list[list[ShotValue]] | list[ShotValue]]:
    tag_shots_dict: dict[str, list[list[ShotValue]] | list[ShotValue]] = {}
    arrtag_dict = {}
    for tagres in tag_results:
        if tagres.is_array_type():
            arrtag_dict.setdefault(tagres.user_tag, []).append(tagres)
        else:
            tag_shots_dict[tagres.user_tag] = tagres.shots_qsys

    for arrtag, arrres in arrtag_dict.items():
        sorted_arrres = sorted(arrres, key=lambda x: x.array_index)
        if not all(i == res.array_index for i, res in enumerate(sorted_arrres)):
            logger.warning(
                "Array type result %s is missing indices,"
                " treating each index individually",
                arrtag,
            )
            for res in sorted_arrres:
                indexed_tag = f"{res.user_tag}_{res.array_index}"
                tag_shots_dict[indexed_tag] = res.shots_qsys
        else:
            shots_per_index: list[list[bool | int]] = [
                res.shots_qsys for res in sorted_arrres
            ]
            indices_per_shot: list[list[bool | int]] = [
                list(column) for column in zip(*shots_per_index, strict=True)
            ]
            tag_shots_dict[arrtag] = indices_per_shot
    return tag_shots_dict


def _handle_all_type_tags_missing(tag_results: list[TagResult]) -> None:
    if all(
        tagres.result_type in [ResultType.MISSING, ResultType.UNRECOGNIZED]
        for tagres in tag_results
    ):
        logger.warning(
            "Missing or unrecognized type information in BackendResult register names."
            " Treating all results as signed 64 bit integers."
        )
        for tagres in tag_results:
            tagres.result_type = ResultType.INT
