import networkx as nx

from guppylang import guppy
from guppylang.defs import GuppyFunctionDefinition
from guppylang.std.builtins import array, output
from guppylang.std.quantum import cz, h, measure_array, qubit, collect_measurements


def build_graph_state(graph: nx.Graph) -> GuppyFunctionDefinition:
    edges = list(graph.edges)
    n_qb = graph.number_of_nodes()

    @guppy
    def main_p() -> None:
        qs = array(qubit() for _ in range(n_qb))

        for i in range(len(qs)):
            h(qs[i])

        for i, j in edges:
            # apply CZ along every graph edge
            cz(qs[i], qs[j])

        output("c", collect_measurements(measure_array(qs)))

    return main_p


k3_graph = nx.complete_graph(3)

main = build_graph_state(k3_graph)
