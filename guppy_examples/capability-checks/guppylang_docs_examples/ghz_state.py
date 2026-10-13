"""Six-qubit GHZ preparation."""

from collections import Counter

from guppylang import guppy
from guppylang.defs import GuppyFunctionDefinition
from guppylang.emulator import EmulatorResult
from guppylang.std.builtins import array, output
from guppylang.std.num import nat
from guppylang.std.quantum import collect_measurements, cx, h, measure_array, qubit


# Define guppy function generic over array size
@guppy
def build_ghz_state[n: nat](q: array[qubit, n]) -> None:
    h(q[0])
    # array size argument used in range to produce statically sized array
    for i in range(n - 1):
        cx(q[i], q[i + 1])


def build_ghz_prog(n_qb: int) -> GuppyFunctionDefinition:
    """Build a Guppy program that prepares a GHZ state on `n_qb` qubits."""

    # we can define the entry point to the guppy program dependent on
    # the number of qubits we want to use.

    @guppy
    def main() -> None:
        # Allocate the number of qubits specified by an outer Python
        # variable, implicitly referenced as a compile-time value.
        q = array(qubit() for _ in range(n_qb))

        build_ghz_state(q)

        output("c", collect_measurements(measure_array(q)))

    # return the guppy function
    return main


def get_counts(shots: EmulatorResult) -> Counter[str]:
    """Counter treating all results from a shot as entries in a single bitstring"""
    counter_list = []
    for shot in shots:
        for e in shot:
            bitstring = "".join(str(k) for k in e[1])
            counter_list.append(bitstring)

    return Counter(counter_list)


main = build_ghz_prog(6)


COMPONENT = "Six-qubit GHZ preparation"
QUBIT_BUDGET = 6
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/ghz_and_graph.html"

EXPECTED = {"c": {0: 0.5, 63: 0.5}}
