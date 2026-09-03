import sys
from typing import no_type_check

from guppylang import array, guppy
from guppylang.std.builtins import control, output, qubit
from guppylang.std.quantum import collect_measurements, cx, h, measure, measure_array, x


@guppy
@no_type_check
def controlled_x(ctl: qubit, target: qubit) -> None:
    with control(ctl):
        x(target)


@guppy
@no_type_check
def double_controlled_x(ctl: array[qubit, 2], target: qubit) -> None:
    with control(ctl[0], ctl[1]):
        x(target)


@guppy
@no_type_check
def main() -> None:
    # single control
    ctl = qubit()
    target = qubit()
    h(ctl)
    controlled_x(ctl, target)
    output("control_target", measure(target).read())
    output("control_ctl", measure(ctl).read())

    # double control
    ctl2 = array(qubit(), qubit())
    for i in range(2):
        h(ctl2[i])
    trg2 = qubit()
    double_controlled_x(ctl2, trg2)
    output("control_target_2", measure(trg2).read())
    output("control_ctl2", collect_measurements(measure_array(ctl2)))

    # multi control, multi target
    ctlm = array(qubit() for _ in range(3))
    for i in range(3):
        h(ctlm[i])
    targets = array(qubit() for _ in range(3))
    with control(ctlm):
        h(targets[0])
        cx(targets[0], targets[1])
        x(targets[2])
        cx(targets[1], targets[2])

    output("targets", collect_measurements(measure_array(targets)))
    output("ctlm", collect_measurements(measure_array(ctlm)))


if __name__ == "__main__":
    sys.stdout.buffer.write(main.compile().to_bytes())
