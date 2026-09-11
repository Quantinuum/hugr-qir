"""Range propagation and checks around H2 shot and random values.

These inspect compilation, not execution on H2. In particular, acceptance of
wide unsigned division does not establish that the hardware computes it correctly.
"""

import re
from typing import no_type_check

import pytest
from guppylang import array, guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.num import nat
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import measure
from hugr_qir.guppy_to_qir import guppy_to_qir_str


@guppy
@no_type_check
def wide_unsigned_dividend() -> None:
    rng = RNG(4)
    left = nat(rng.random_int())
    right = nat(rng.random_int())
    rng.discard()
    # The product can exceed INT_MAX without overflowing unsigned i64.
    quotient = (left * right) // nat(3)
    output("quotient", quotient)
    q = qubit()
    output("q", measure(q).read())


@guppy
@no_type_check
def random_value_as_bound() -> None:
    rng = RNG(4)
    bound = rng.random_int()
    value = rng.random_int_bounded(bound)
    rng.discard()
    output("value", value)


@guppy
@no_type_check
def choose_values() -> tuple[nat, nat]:
    shot = nat(get_current_shot())
    rng = RNG(4)
    random_value = nat(rng.random_int())
    rng.discard()
    if shot % nat(2) == nat(0):
        return shot, random_value
    return random_value, shot


@guppy
@no_type_check
def values_through_containers() -> None:
    left, right = choose_values()
    values = array(left, right)
    # Static array accesses isolate range propagation from dynamic-index support.
    output("left", values[0])
    output("right", values[1])
    q = qubit()
    output("q", measure(q).read())


@guppy
@no_type_check
def potentially_negative_conversion() -> None:
    value = nat(get_current_shot() - 5)
    output("value", value)


@guppy
@no_type_check
def guarded_nonnegative_conversion() -> None:
    shot = get_current_shot()
    if shot >= 5:  # noqa: PLR2004
        output("value", nat(shot - 5))
    q = qubit()
    output("q", measure(q).read())


def test_wide_unsigned_dividend_currently_reaches_udiv() -> None:
    """Characterize the known downstream risk, without claiming H2 correctness."""
    qir = guppy_to_qir_str(wide_unsigned_dividend, validate_qir=True)
    assert re.search(r"\bmul(?: nuw)?(?: nsw)? i64\b", qir)
    assert "udiv i64" in qir
    assert "@abort" not in qir


def test_random_bound_retains_signed_narrowing_check() -> None:
    qir = guppy_to_qir_str(random_value_as_bound, validate_qir=False)
    assert re.search(r"icmp sgt i32 %[^,]+, -1", qir)
    assert "@abort" in qir


def test_range_survives_helper_branch_tuple_and_array() -> None:
    qir = guppy_to_qir_str(values_through_containers, validate_qir=True)
    assert "@abort" not in qir


def test_potentially_negative_conversion_keeps_panic() -> None:
    qir = guppy_to_qir_str(potentially_negative_conversion, validate_qir=False)
    assert "is_to_u called on negative value" in qir
    assert "@abort" in qir
    with pytest.raises(Exception):  # noqa: B017, PT011
        guppy_to_qir_str(potentially_negative_conversion, validate_qir=True)


def test_guard_proves_conversion_is_safe() -> None:
    qir = guppy_to_qir_str(guarded_nonnegative_conversion, validate_qir=True)
    assert "@abort" not in qir
