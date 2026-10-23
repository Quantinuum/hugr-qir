"""Outputs must have one call site and execute on every returning path."""

import pytest
from guppylang import array, guppy, qubit
from guppylang.std.angles import angle
from guppylang.std.platform import output
from guppylang.std.quantum import discard, h, measure, rz
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat


@guppy
def conditional_outputs() -> None:
    q = qubit()
    h(q)
    condition = measure(q).read()
    if condition:
        output("left", 1)
    else:
        output("right", 0)
    target = qubit()
    theta = 0.3 if condition else 0.7
    rz(target, angle(theta))
    output("target", measure(target).read())


@guppy
def conditional_array_output() -> None:
    q = qubit()
    h(q)
    if measure(q).read():
        output("array_output", array(1, 2))


@guppy
def conditional_suffix_tag_output() -> None:
    q = qubit()
    h(q)
    if measure(q).read():
        output("literal___INT", 1)


@guppy
def branch_local_output() -> None:
    q = qubit()
    h(q)
    condition = measure(q).read()
    if condition:
        output("local", measure(qubit()).read())
    target = qubit()
    theta = 0.3 if condition else 0.7
    rz(target, angle(theta))
    output("target", measure(target).read())


@guppy
def unconditional_output() -> None:
    q = qubit()
    h(q)
    condition = measure(q).read()
    target = qubit()
    theta = 0.3 if condition else 0.7
    rz(target, angle(theta))
    output("target", measure(target).read())


@guppy
def constant_branch_output() -> None:
    if True:
        output("constant", 1)
    output("q", measure(qubit()).read())


@guppy
def no_outputs() -> None:
    q = qubit()
    h(q)
    discard(q)


@guppy
def repeated_output() -> None:
    for i in range(3):
        output("repeated", i)
    output("q", measure(qubit()).read())


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
@pytest.mark.parametrize("opt_level", ["default", "aggressive"])
def test_conditional_outputs_fail_before_sinking(target: str, opt_level: str) -> None:
    for program in [conditional_outputs, branch_local_output]:
        with pytest.raises(
            ValueError,
            match=(
                r"Compilation failed: Detected conditional output tag "
                r'"(left|right|local)"\.'
            ),
        ):
            hugr_to_qir(
                program.compile(),
                target=target,
                opt_level=opt_level,
                output_format=OutputFormat.LLVM_IR,
            )


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
def test_diagnostics_use_original_array_and_scalar_tags(target: str) -> None:
    for program, tag in [
        (conditional_array_output, "array_output"),
        (conditional_suffix_tag_output, "literal___INT"),
    ]:
        with pytest.raises(
            ValueError, match="Detected conditional output tag"
        ) as error:
            hugr_to_qir(
                program.compile(), target=target, output_format=OutputFormat.LLVM_IR
            )
        assert str(error.value) == (
            f'Compilation failed: Detected conditional output tag "{tag}". '
            "Each tag must be output exactly once on every run. "
            "Move the output outside conditional branches and loops."
        )


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
def test_unconditional_and_constant_outputs_are_allowed(target: str) -> None:
    for program in [unconditional_output, constant_branch_output]:
        hugr_to_qir(
            program.compile(), target=target, output_format=OutputFormat.LLVM_IR
        )


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
def test_programs_without_outputs_are_rejected(target: str) -> None:
    with pytest.raises(ValueError, match="Program has no outputs"):
        hugr_to_qir(
            no_outputs.compile(), target=target, output_format=OutputFormat.LLVM_IR
        )


@pytest.mark.parametrize("target", ["native", "quantinuum-hardware"])
def test_unrolling_cannot_duplicate_output_tags(target: str) -> None:
    with pytest.raises(
        ValueError, match='Detected duplicate output tag "repeated" after optimization'
    ):
        hugr_to_qir(
            repeated_output.compile(), target=target, output_format=OutputFormat.LLVM_IR
        )
