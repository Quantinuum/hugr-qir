"""Complete three-node graph state."""

import networkx as nx
from guppylang import guppy
from guppylang.defs import GuppyFunctionDefinition
from guppylang.std.builtins import array, output
from guppylang.std.quantum import collect_measurements, cz, h, measure_array, qubit


def build_graph_state(graph: nx.Graph) -> GuppyFunctionDefinition:
    edges = list(graph.edges)
    n_qb = graph.number_of_nodes()

    @guppy
    def main() -> None:
        qs = array(qubit() for _ in range(n_qb))

        for i in range(len(qs)):
            h(qs[i])

        for i, j in edges:
            # apply CZ along every graph edge
            cz(qs[i], qs[j])

        output("c", collect_measurements(measure_array(qs)))

    return main


k3_graph = nx.complete_graph(3)

main = build_graph_state(k3_graph)


COMPONENT = "Complete three-node graph state"
QUBIT_BUDGET = 3
SOURCE_URL = "https://docs.quantinuum.com/guppy/guppylang/examples/ghz_and_graph.html"

EXPECTED = {"c": dict.fromkeys(range(8), 0.125)}
