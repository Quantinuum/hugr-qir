from guppylang import guppy
from guppylang.std.quantum import qubit, h, rx
from guppylang.std.qsystem.helios import zz_phase
from guppylang.std.builtins import array
from guppylang.std.angles import pi
from guppylang.defs import GuppyFunctionDefinition


def build_qaoa_instance(graph: nx.Graph, n_layers: int) -> GuppyFunctionDefinition:
    edges = list(graph.edges)
    n_qubits = graph.number_of_nodes()

    @guppy
    def qaoa_instance(
        cost_angles: array[float, n_layers],
        mixer_angles: array[float, n_layers],
    ) -> array[qubit, n_qubits]:
        qs = array(qubit() for _ in range(n_qubits))
        n = len(qs)

        for i in range(n):
            h(qs[i])

        for layer in range(n_layers):
            # Add cost layer
            for i, j in edges:
                zz_phase(qs[i], qs[j], -cost_angles[layer] * pi / 2)

            # Add mixer layer
            for i in range(n):
                rx(qs[i], mixer_angles[layer] * pi)

        return qs

    return qaoa_instance


from hugr.qsystem.result import QsysResult


def energy_from_result(graph: nx.Graph, result: QsysResult, n_shots: int) -> float:
    energy = 0.0
    dist = result.register_counts()["c"]
    for i, j in graph.edges:
        for meas, count in dist.items():
            prob = count / n_shots
            energy += (int(meas[i]) ^ int(meas[j])) * prob

    return energy
