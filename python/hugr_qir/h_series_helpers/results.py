from enum import StrEnum
from typing import TypeAlias

from pytket.backends.backendresult import BackendResult

ShotValue: TypeAlias = bool | int | str


class ResultRepresentation(StrEnum):
    """Supported user-facing representations for recorded result values.

    Examples:
        ``BOOL`` converts to a bool ``True``/ ``False``.

        ``BOOL_BITSTRING`` converts to ``"1"``/``"0"``.

        ``BITSTRING`` shows full 64-bit bitstring, such as
         ``"0000000000000000100000000000000000000000000000000010000000000000"``.

        ``INT`` converts to an int, such as to ``2``.
    """

    BOOL = "bool"
    BOOL_BITSTRING = "bool_bitstring"
    BITSTRING = "bitstring"
    INT = "int"


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


class HugrQirResults:
    """Convert H-Series ``BackendResult`` data into tag-keyed shot dictionaries."""

    def __init__(
        self,
        results: BackendResult,
        result_representations: dict[str, ResultRepresentation] | None = None,
    ) -> None:
        """Create a helper around a ``BackendResult``.

        Args:
            results: The backend result returned by the H-Series submission flow.
            result_representations: Optional mapping from result tag to the
                representation to use for that tag in ``get_shots``. Tags omitted
                from the mapping use the ``get_shots`` default representation.

        Raises:
            ValueError: If a configured tag is unknown, or if a tag configured as
                ``BOOL`` or ``BOOL_BITSTRING`` is not representable as a bool.
        """
        self._shots = _handle_results(results)
        self._result_representations = result_representations or {}
        self._validate_result_representations()

    def __str__(self) -> str:
        return str(self._shots)

    def get_shots_bit_repr(self) -> list[dict[str, str]]:
        """Return all shots as 64-bit bitstrings keyed by result tag.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to its
            64-bit bitstring representation.
        """
        return [
            {name: "".join(str(x) for x in raw_bits) for name, raw_bits in shot.items()}
            for shot in self._shots
        ]

    def get_shots_int_repr(self) -> list[dict[str, int]]:
        """Return all shots as integers keyed by result tag.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to the
            integer value obtained by interpreting that tag's 64-bit bitstring
            as a base-2 integer.
        """
        return [
            {
                name: int(bitstring, 2) if bitstring else 0
                for name, bitstring in shot.items()
            }
            for shot in self.get_shots_bit_repr()
        ]

    def _repr_for(
        self, name: str, default_representation: ResultRepresentation
    ) -> ResultRepresentation:
        return self._result_representations.get(name, default_representation)

    def _validate_result_representations(self) -> None:
        known_tags = {name for shot in self.get_shots_bit_repr() for name in shot}
        for name, representation in self._result_representations.items():
            if name not in known_tags:
                msg = f"Unknown result tag {name!r}."
                raise ValueError(msg)
            if representation in (
                ResultRepresentation.BOOL,
                ResultRepresentation.BOOL_BITSTRING,
            ):
                for shot in self.get_shots_bit_repr():
                    self._validate_bool_bitstring(name, shot[name])

    def _convert_bitstring(
        self, name: str, bitstring: str, representation: ResultRepresentation
    ) -> ShotValue:
        match representation:
            case ResultRepresentation.BOOL:
                self._validate_bool_bitstring(name, bitstring)
                return bitstring[-1] == "1"
            case ResultRepresentation.BOOL_BITSTRING:
                self._validate_bool_bitstring(name, bitstring)
                return bitstring[-1]
            case ResultRepresentation.BITSTRING:
                return bitstring
            case ResultRepresentation.INT:
                return int(bitstring, 2) if bitstring else 0

    def _validate_bool_bitstring(self, name: str, bitstring: str) -> None:
        if not bitstring or any(bit != "0" for bit in bitstring[:-1]):
            msg = f"Result {name!r} cannot be represented as a bool"
            raise ValueError(msg)

    def get_shots(
        self,
        default_representation: ResultRepresentation = ResultRepresentation.BITSTRING,
    ) -> list[dict[str, ShotValue]]:
        """Return all shots using configured per-tag result representations.

        Args:
            default_representation: Representation to use for tags that were not
                included in ``result_representations`` at construction time.
                Defaults to ``ResultRepresentation.BITSTRING``.

        Returns:
            One dictionary per shot. Each dictionary maps a result tag to a bool,
            int, one-bit string, or 64-bit string according to its configured
            representation.

        Raises:
            ValueError: If ``default_representation`` is ``BOOL`` or
                ``BOOL_BITSTRING`` and a fallback tag is not representable as a bool.
        """
        return [
            {
                name: self._convert_bitstring(
                    name, bitstring, self._repr_for(name, default_representation)
                )
                for name, bitstring in shot.items()
            }
            for shot in self.get_shots_bit_repr()
        ]
