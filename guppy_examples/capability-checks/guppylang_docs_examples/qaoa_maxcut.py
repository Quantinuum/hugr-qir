"""Run the gallery's seven-node, three-layer QAOA kernel at fixed parameters."""

import networkx as nx
from guppylang import guppy
from guppylang.defs import GuppyFunctionDefinition
from guppylang.std.angles import pi
from guppylang.std.builtins import array, output
from guppylang.std.qsystem.helios import zz_phase
from guppylang.std.quantum import collect_measurements, h, measure_array, qubit, rx

COMPONENT = "Fixed-parameter Max-Cut QAOA kernel"
QUBIT_BUDGET = 7
SOURCE_URL = (
    "https://docs.quantinuum.com/guppy/guppylang/examples/qaoa_maxcut_example.html"
)
EDGES = [(0, 1), (1, 2), (1, 3), (3, 4), (4, 5), (4, 6)]
GRAPH = nx.Graph(EDGES)
COST = [0.37, 0.22, 0.18]
MIXER = [0.19, 0.24, 0.15]


def build_qaoa_instance(graph: nx.Graph, n_layers: int) -> GuppyFunctionDefinition:
    edges = list(graph.edges)
    n_qubits = graph.number_of_nodes()

    @guppy
    def qaoa_instance(
        cost_angles: array[float, n_layers], mixer_angles: array[float, n_layers]
    ) -> array[qubit, n_qubits]:
        qs = array(qubit() for _ in range(n_qubits))
        for i in range(n_qubits):
            h(qs[i])
        for layer in range(n_layers):
            for i, j in edges:
                zz_phase(qs[i], qs[j], -cost_angles[layer] * pi / 2)
            for i in range(n_qubits):
                rx(qs[i], mixer_angles[layer] * pi)
        return qs

    return qaoa_instance


qaoa = build_qaoa_instance(GRAPH, 3)


@guppy
def main() -> None:
    state = qaoa(array(0.37, 0.22, 0.18), array(0.19, 0.24, 0.15))
    bits = collect_measurements(measure_array(state))
    cut = 0
    for i, j in EDGES:
        if bits[i] != bits[j]:
            cut += 1
    output("cut", cut)
    output("c", bits)


def expected_probabilities() -> dict:
    from _references import qaoa_probabilities  # noqa: PLC0415

    return {"c": qaoa_probabilities(EDGES, COST, MIXER)}


def validate_shot(shot: dict) -> None:
    from _checks import require_equal  # noqa: PLC0415

    require_equal(shot["cut"], sum(shot["c"][a] != shot["c"][b] for a, b in EDGES))
