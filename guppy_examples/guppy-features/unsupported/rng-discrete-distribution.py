from guppylang import array, guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.qsystem.random import RNG, make_discrete_distribution
from guppylang.std.quantum import measure


@guppy
def main() -> None:
    output("q", measure(qubit()).read())
    # Sampling uses RNG.random_float(), whose qsystem RandomFloat operation is
    # not currently lowered by hugr-qir.
    distribution = make_discrete_distribution(array(1.0, 2.0, 3.0))
    rng = RNG(11)
    sample = distribution.sample(rng)
    rng.discard()
    output("sample", sample)
