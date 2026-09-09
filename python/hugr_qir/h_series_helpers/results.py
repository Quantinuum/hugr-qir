import base64

import re
from dataclasses import dataclass, field
from enum import StrEnum
from hugr_qir.output import OutputFormat
from typing import TypeAlias

from hugr import ops, tys
from hugr.package import Package
from pytket.backends.backendresult import BackendResult
from pyqir import Module, Context, Opcode

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


@dataclass
class ResultSpec:
    """Configure user-facing representations for named recorded results.

    Args:
        result_representations: Mapping from result tag to the representation to
            use for that tag in :meth:`HugrQirResultHelper.get_shots`. Tags
            omitted from the mapping use the method's default representation.
    """

    result_representations: dict[str, ResultRep] = field(default_factory=dict)


def hugr_to_result_spec(hugr: Package) -> ResultSpec:
    """Infer result representations from a HUGR package.

    Guppy lowers calls to ``output`` to operations in the ``tket.result``
    extension. Boolean outputs are represented as Python booleans and signed or
    unsigned integer outputs are represented as Python integers.

    Args:
        hugr: HUGR package to inspect.

    Returns:
        A result specification containing every supported tagged result in the
        package.

    Raises:
        ValueError: If the package contains an unsupported result operation, a
            malformed result tag, or conflicting operations for the same tag.
    """
    operation_representations = {
        "result_bool": ResultRep.BOOL,
        "result_int": ResultRep.INT,
    }
    result_representations: dict[str, ResultRep] = {}

    for module in hugr.modules:
        for _, node_data in module.nodes():
            op = node_data.op
            if not isinstance(op, ops.ExtOp):
                continue

            custom_op = op.to_custom_op()
            if custom_op.extension != "tket.result":
                continue

            representation = operation_representations.get(custom_op.op_name)
            if representation is None:
                msg = f"Unsupported HUGR result operation {custom_op.op_name!r}"
                raise ValueError(msg)

            type_args = op.type_args()
            if not type_args or not isinstance(type_args[0], tys.StringArg):
                msg = f"Malformed result tag for operation {custom_op.op_name!r}"
                raise ValueError(msg)
            tag = type_args[0].value

            previous_representation = result_representations.get(tag)
            if (
                previous_representation is not None
                and previous_representation != representation
            ):
                msg = f"Conflicting result representations for tag {tag!r}"
                raise ValueError(msg)
            result_representations[tag] = representation

    return ResultSpec(result_representations)


def qir_to_result_spec(qir: bytes | str, format: OutputFormat) -> ResultSpec:
    """Infer result representations from QIR."""
    operation_representations = {
        "__quantum__rt__bool_record_output": ResultRep.BOOL,
        "__quantum__rt__int_record_output": ResultRep.INT,
    }
    result_representations: dict[str, ResultRep] = {}
    ctx = Context()
    if format == OutputFormat.BITCODE:
        assert isinstance(qir, bytes)
        mod = Module.from_bitcode(ctx, qir)
    if format == OutputFormat.BASE64:
        assert isinstance(qir, str)
        qir_bytes = base64.b64decode(qir)
        mod = Module.from_bitcode(ctx, qir_bytes)
    if format == OutputFormat.LLVM_IR:
        assert isinstance(qir, str)
        mod = Module.from_ir(ctx, qir)
    for function in mod.functions:
        for block in function.basic_blocks:
            for inst in block.instructions:
                opcode = inst.opcode
                if opcode == Opcode.CALL:
                    if inst.callee.name in operation_representations.keys():
                        global_str = str(inst.args[1])
                        match = re.search(r'c"([^"\\]+)', global_str)
                        if match:
                            variable_name = match.group(1)
                            result_representations[variable_name] = (
                                operation_representations.get(inst.callee.name)
                            )
    return ResultSpec(result_representations)


def _handle_results(results: BackendResult) -> list[dict[str, list[int]]]:
    bitlist = results.get_bitlist()
    shots = results.get_shots()
    n_shots, n_bits = shots.shape
    shots_res = [
        [int(x) for x in reversed(results.get_shots()[s])] for s in range(n_shots)
    ]
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


class HugrQirResultHelper:
    """Convert H-Series ``BackendResult`` data into tag-keyed shot dictionaries."""

    def __init__(
        self,
        results: BackendResult,
        result_representation_spec: ResultSpec | None = None,
    ) -> None:
        """Create a helper around a ``BackendResult``.

        Args:
            results: The backend result returned by the H-Series submission flow.
            result_representation_spec: Optional configuration of per-tag
                representations for ``get_shots``.

        Raises:
            ValueError: If a configured tag is unknown, or if a tag configured as
                ``BOOL`` or ``BIT`` is not representable as a bool.
        """
        self._shots = _handle_results(results)
        self._result_representations = (
            result_representation_spec.result_representations
            if result_representation_spec is not None
            else {}
        )
        self._validate_result_representations()

    def __str__(self) -> str:
        return str(self._shots)

    def get_shots_all_bitstring(self) -> list[dict[str, str]]:
        """Return all shots as 64-bit bitstrings keyed by result tag.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to its
            64-bit bitstring representation.
        """
        return [
            {name: "".join(str(x) for x in raw_bits) for name, raw_bits in shot.items()}
            for shot in self._shots
        ]

    def get_shots_all_integer(self) -> list[dict[str, int]]:
        """Return all shots as signed integers keyed by result tag.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to the
            integer value obtained by interpreting that tag's 64-bit bitstring
            as a base-2 integer.
        """
        return [
            {
                name: self._bitstring_to_signed_int(bitstring)
                for name, bitstring in shot.items()
            }
            for shot in self.get_shots_all_bitstring()
        ]

    def _repr_for(self, name: str, default_representation: ResultRep) -> ResultRep:
        return self._result_representations.get(name, default_representation)

    def _validate_result_representations(self) -> None:
        known_tags = {name for shot in self.get_shots_all_bitstring() for name in shot}
        for name, representation in self._result_representations.items():
            if name not in known_tags:
                msg = f"Unknown result tag {name!r}."
                raise ValueError(msg)
            if representation in (
                ResultRep.BOOL,
                ResultRep.BIT,
            ):
                for shot in self.get_shots_all_bitstring():
                    self._validate_bit(name, shot[name])

    def _convert_bitstring(
        self, name: str, bitstring: str, representation: ResultRep
    ) -> ShotValue:
        match representation:
            case ResultRep.BOOL:
                self._validate_bit(name, bitstring)
                return bitstring[-1] == "1"
            case ResultRep.BIT:
                self._validate_bit(name, bitstring)
                return bitstring[-1]
            case ResultRep.BITSTRING:
                return bitstring
            case ResultRep.INT:
                return self._bitstring_to_signed_int(bitstring)

    @staticmethod
    def _bitstring_to_signed_int(bitstring: str) -> int:
        if not bitstring:
            return 0
        value = int(bitstring, 2)
        return value - (1 << len(bitstring)) if bitstring[0] == "1" else value

    def _validate_bit(self, name: str, bitstring: str) -> None:
        if not bitstring or any(bit != "0" for bit in bitstring[:-1]):
            msg = f"Result {name!r} cannot be represented as a bool"
            raise ValueError(msg)

    def get_shots(
        self,
        default_representation: ResultRep = ResultRep.BITSTRING,
    ) -> list[dict[str, ShotValue]]:
        """Return all shots using configured per-tag result representations.

        Args:
            default_representation: Representation to use for tags that were not
                included in ``result_representations`` at construction time.
                Defaults to ``ResultRep.BITSTRING``.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to a bool,
            int, one-bit string, or 64-bit string according to its configured
            representation.

        Raises:
            ValueError: If ``default_representation`` is ``BOOL`` or ``BIT`` and
                a fallback tag is not representable as a bool.
        """
        return [
            {
                name: self._convert_bitstring(
                    name, bitstring, self._repr_for(name, default_representation)
                )
                for name, bitstring in shot.items()
            }
            for shot in self.get_shots_all_bitstring()
        ]
