from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import array, result
from guppylang.std.lang import owned
from guppylang.std.quantum import discard, measure

T = guppy.type_var("T", copyable=False, droppable=False)
n = guppy.nat_var("n")


@guppy
@no_type_check
def identity(me: T @ owned) -> T:
    return me


@no_type_check
def apply_identity(a: array) -> array:
    """Since we are passing in an array, this must be pure python
    that we call from guppy.comptime.

    However, we can still call a guppy function from here, even a
    generic one
    """
    ret = array()
    for i in range(len(a)):
        ret.append(identity(a[i]))
    return ret


@guppy.comptime
@no_type_check
def main() -> None:
    arr1 = array(1, 2)
    arr1 = apply_identity(arr1)

    arr2 = array(1.5, 2.5, 3.5, 4.5)
    arr2 = apply_identity(arr2)

    arr3 = array(qubit() for _ in range(8))
    arr3 = apply_identity(arr3)

    for i in range(7):
        discard(arr3[i])

    result("arr1_1", arr1[1])
    result("arr3_7", measure(arr3[7]).read())
