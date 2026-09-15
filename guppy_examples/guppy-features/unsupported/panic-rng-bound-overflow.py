"""Guppy's signed 32-bit bound conversion rejects this positive bound.

This is a Guppy conversion check, even though H2 accepts larger unsigned bounds.
"""

from guppylang import guppy
from guppylang.std.platform import output
from guppylang.std.qsystem.random import RNG


@guppy
def main() -> None:
    rng = RNG(4)
    value = rng.random_int_bounded(2**31)
    rng.discard()
    output("value", value)
