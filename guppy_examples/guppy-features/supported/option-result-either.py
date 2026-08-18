from typing import no_type_check

from guppylang import guppy
from guppylang.std.builtins import output
from guppylang.std.either import Either, left, right
from guppylang.std.err import Result, ok
from guppylang.std.option import Option, some


@guppy
@no_type_check
def option_value(value: int) -> Option[int]:
    return some(value)


@guppy
@no_type_check
def result_value(value: int) -> Result[int, int]:
    return ok(value)


@guppy
@no_type_check
def choose(flag: bool) -> Either[int, bool]:
    if flag:
        return left(7)
    return right(False)


@guppy
@no_type_check
def main() -> None:
    opt = option_value(5)
    res = result_value(9)
    either = choose(True)

    output("option_is_some", opt.is_some())
    output("option_value", opt.unwrap())
    output("result_is_ok", res.is_ok())
    output("result_value", res.unwrap())
    output("either_is_left", either.is_left())
