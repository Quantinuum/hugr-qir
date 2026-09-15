from guppylang import guppy
from guppylang.std.angles import angle
from guppylang.std.builtins import array, comptime, result
from guppylang.std.platform import output
from guppylang.std.qsystem import phased_x, zz_phase
from guppylang.std.qsystem.random import RNG
from guppylang.std.qsystem.utils import get_current_shot
from guppylang.std.quantum import (
    cz,
    measure,
    qubit,
    rz,
    x,
    y,
    z,
    collect_measurements,
    measure_array,
)

from random import randint

N_SHOTS = 200

error_pos = [randint(0, 326) for _ in range(N_SHOTS)]


@guppy.struct
class ErrorState:
    position: int
    first_qubit: int
    second_qubit: int
    counter: int


@guppy
def apply_pauli_error(q: qubit, error_type: int) -> None:
    if error_type == 1:
        x(q)
    elif error_type == 2:
        y(q)
    elif error_type == 3:
        z(q)


@guppy
def inject_error(q0: qubit, q1: qubit, errors: ErrorState) -> None:
    if errors.position == errors.counter:
        apply_pauli_error(q0, errors.first_qubit)
        apply_pauli_error(q1, errors.second_qubit)
    errors.counter += 1


@guppy
def noisy_zz_phase(q0: qubit, q1: qubit, theta: angle, errors: ErrorState) -> None:
    zz_phase(q0, q1, theta)
    inject_error(q0, q1, errors)


@guppy
def noisy_cz(q0: qubit, q1: qubit, errors: ErrorState) -> None:
    cz(q0, q1)
    inject_error(q0, q1, errors)


@guppy
def staggered_ring_layer(
    qs: array[qubit, 24],
    zz_angle: angle,
    x_angle: angle,
    last_x_angle: angle,
    errors: ErrorState,
) -> None:
    noisy_zz_phase(qs[1], qs[5], zz_angle, errors)
    for i in range(5, 17, 4):
        noisy_zz_phase(qs[i], qs[i + 4], zz_angle, errors)
        phased_x(qs[i], x_angle, angle(0.0))
    phased_x(qs[21], last_x_angle, angle(0.0))
    noisy_zz_phase(qs[17], qs[21], zz_angle, errors)
    phased_x(qs[17], x_angle, angle(0.0))
    noisy_zz_phase(qs[21], qs[1], zz_angle, errors)
    phased_x(qs[1], x_angle, angle(0.0))


@guppy
def closed_ring_layer(
    qs: array[qubit, 24], zz_angle: angle, x_angle: angle, errors: ErrorState
) -> None:
    noisy_zz_phase(qs[23], qs[3], zz_angle, errors)
    for i in range(3, 20, 4):
        noisy_zz_phase(qs[i], qs[i + 4], zz_angle, errors)
        phased_x(qs[i], x_angle, angle(0.0))
    phased_x(qs[23], x_angle, angle(0.0))


@guppy
def interior_cells(
    qs: array[qubit, 24],
    outer_zz: angle,
    middle_zz_1: angle,
    middle_zz_2: angle,
    side_x: angle,
    middle_x: angle,
    other_x: angle,
    finish_x: angle,
    bridge_x: angle,
    errors: ErrorState,
) -> None:
    for i in range(7, 16, 4):
        noisy_zz_phase(qs[i], qs[i + 4], outer_zz, errors)
        phased_x(qs[i], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[i - 2], qs[i], angle(0.5), errors)
        phased_x(qs[i - 2], side_x, angle(0.0))
        noisy_zz_phase(qs[i - 4], qs[i - 2], middle_zz_1, errors)
        phased_x(qs[i - 4], middle_x, angle(0.0))
        phased_x(qs[i - 2], other_x, angle(0.0))
        noisy_zz_phase(qs[i - 4], qs[i - 2], middle_zz_2, errors)
        phased_x(qs[i - 4], finish_x, angle(0.0))
        noisy_zz_phase(qs[i - 2], qs[i], angle(0.5), errors)
        phased_x(qs[i], bridge_x, angle(0.0))
        phased_x(qs[i + 4], angle(1.0), angle(0.0))


# insert-scripts-here


def build_prog(random_seed: int):
    @guppy
    def main() -> None:
        curr_shot_num = get_current_shot()
        result("shot_num", curr_shot_num)
        rng = RNG(comptime(random_seed) + curr_shot_num)

        errors = ErrorState(
            rng.random_int_bounded(367),
            rng.random_int_bounded(4),
            rng.random_int_bounded(4),
            0,
        )

        result("error position", errors.position)
        result("error type first qubit", errors.first_qubit)
        result("error type second qubit", errors.second_qubit)

        # guppy-circ start

        qs = array(qubit() for _ in range(24))

        phased_x(qs[0], angle(0.5), angle(1.5))
        phased_x(qs[1], angle(1.5), angle(0.5))
        phased_x(qs[2], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[0], qs[2], angle(3.5173432372693605), errors)
        phased_x(qs[3], angle(1.5), angle(0.5))
        phased_x(qs[4], angle(0.5), angle(1.5))
        phased_x(qs[5], angle(1.5), angle(0.5))
        noisy_zz_phase(qs[1], qs[5], angle(2.21353314103693), errors)
        phased_x(qs[6], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[4], qs[6], angle(3.5173432372693605), errors)
        noisy_zz_phase(qs[2], qs[4], angle(3.5173432372693605), errors)
        phased_x(qs[2], angle(0.536232104463014), angle(0.0))
        phased_x(qs[4], angle(0.536232104463014), angle(0.0))
        phased_x(qs[7], angle(1.5), angle(0.5))
        phased_x(qs[8], angle(0.5), angle(1.5))
        phased_x(qs[9], angle(1.5), angle(0.5))
        noisy_zz_phase(qs[5], qs[9], angle(2.21353314103693), errors)
        phased_x(qs[5], angle(0.694037006200836), angle(0.0))
        phased_x(qs[10], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[8], qs[10], angle(3.5173432372693605), errors)
        noisy_zz_phase(qs[6], qs[8], angle(3.5173432372693605), errors)
        phased_x(qs[6], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[4], qs[6], angle(0.554680848902804), errors)
        phased_x(qs[8], angle(0.536232104463014), angle(0.0))
        phased_x(qs[11], angle(1.5), angle(0.5))
        phased_x(qs[12], angle(0.5), angle(1.5))
        phased_x(qs[13], angle(1.5), angle(0.5))
        noisy_zz_phase(qs[9], qs[13], angle(2.21353314103693), errors)
        phased_x(qs[9], angle(0.694037006200836), angle(0.0))
        phased_x(qs[14], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[12], qs[14], angle(3.5173432372693605), errors)
        noisy_zz_phase(qs[10], qs[12], angle(3.5173432372693605), errors)
        phased_x(qs[10], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[8], qs[10], angle(0.554680848902804), errors)
        noisy_zz_phase(qs[6], qs[8], angle(0.554680848902804), errors)
        phased_x(qs[6], angle(2.58786871845695), angle(0.0))
        phased_x(qs[8], angle(2.58786871845695), angle(0.0))
        phased_x(qs[12], angle(0.536232104463014), angle(0.0))
        phased_x(qs[15], angle(1.5), angle(0.5))
        phased_x(qs[16], angle(0.5), angle(1.5))
        phased_x(qs[17], angle(1.5), angle(0.5))
        noisy_zz_phase(qs[13], qs[17], angle(2.21353314103693), errors)
        phased_x(qs[13], angle(0.694037006200836), angle(0.0))
        phased_x(qs[18], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[16], qs[18], angle(3.5173432372693605), errors)
        noisy_zz_phase(qs[14], qs[16], angle(3.5173432372693605), errors)
        phased_x(qs[14], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[12], qs[14], angle(0.554680848902804), errors)
        noisy_zz_phase(qs[10], qs[12], angle(0.554680848902804), errors)
        phased_x(qs[10], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[8], qs[10], angle(3.5855378072290303), errors)
        phased_x(qs[12], angle(2.58786871845695), angle(0.0))
        phased_x(qs[16], angle(0.536232104463014), angle(0.0))
        phased_x(qs[19], angle(1.5), angle(0.5))
        phased_x(qs[20], angle(0.5), angle(1.5))
        phased_x(qs[21], angle(1.5), angle(0.5))
        noisy_zz_phase(qs[17], qs[21], angle(2.21353314103693), errors)
        phased_x(qs[17], angle(0.694037006200836), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(2.21353314103693), errors)
        phased_x(qs[1], angle(0.694037006200836), angle(0.0))
        staggered_ring_layer(
            qs,
            angle(3.81898112750226),
            angle(3.80656406892676),
            angle(0.694037006200836),
            errors,
        )
        staggered_ring_layer(
            qs,
            angle(0.394065296334771),
            angle(0.359624987889191),
            angle(3.80656406892676),
            errors,
        )
        phased_x(qs[21], angle(0.359624987889191), angle(0.0))
        phased_x(qs[22], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[20], qs[22], angle(3.5173432372693605), errors)
        noisy_zz_phase(qs[18], qs[20], angle(3.5173432372693605), errors)
        phased_x(qs[18], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[16], qs[18], angle(0.554680848902804), errors)
        noisy_zz_phase(qs[14], qs[16], angle(0.554680848902804), errors)
        phased_x(qs[14], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[12], qs[14], angle(3.5855378072290303), errors)
        noisy_zz_phase(qs[10], qs[12], angle(3.5855378072290303), errors)
        phased_x(qs[10], angle(3.50642850586368), angle(0.0))
        phased_x(qs[12], angle(3.50642850586368), angle(0.0))
        phased_x(qs[16], angle(2.58786871845695), angle(0.0))
        phased_x(qs[20], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[22], qs[0], angle(3.5173432372693605), errors)
        phased_x(qs[0], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[0], qs[2], angle(0.554680848902804), errors)
        noisy_zz_phase(qs[2], qs[4], angle(0.554680848902804), errors)
        phased_x(qs[2], angle(2.58786871845695), angle(0.0))
        phased_x(qs[4], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[4], qs[6], angle(3.5855378072290303), errors)
        noisy_zz_phase(qs[6], qs[8], angle(3.5855378072290303), errors)
        phased_x(qs[6], angle(3.50642850586368), angle(0.0))
        phased_x(qs[8], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[8], qs[10], angle(0.456092427629891), errors)
        phased_x(qs[22], angle(0.536232104463014), angle(0.0))
        noisy_zz_phase(qs[20], qs[22], angle(0.554680848902804), errors)
        noisy_zz_phase(qs[18], qs[20], angle(0.554680848902804), errors)
        phased_x(qs[18], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[16], qs[18], angle(3.5855378072290303), errors)
        noisy_zz_phase(qs[14], qs[16], angle(3.5855378072290303), errors)
        phased_x(qs[14], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[12], qs[14], angle(0.456092427629891), errors)
        noisy_zz_phase(qs[10], qs[12], angle(0.456092427629891), errors)
        phased_x(qs[10], angle(0.498931520675966), angle(0.0))
        phased_x(qs[12], angle(0.498931520675966), angle(0.0))
        phased_x(qs[16], angle(3.50642850586368), angle(0.0))
        phased_x(qs[20], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[22], qs[0], angle(0.554680848902804), errors)
        phased_x(qs[0], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[0], qs[2], angle(3.5855378072290303), errors)
        noisy_zz_phase(qs[2], qs[4], angle(3.5855378072290303), errors)
        phased_x(qs[2], angle(3.50642850586368), angle(0.0))
        phased_x(qs[4], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[4], qs[6], angle(0.456092427629891), errors)
        noisy_zz_phase(qs[6], qs[8], angle(0.456092427629891), errors)
        phased_x(qs[6], angle(0.498931520675966), angle(0.0))
        phased_x(qs[8], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[8], qs[10], angle(3.55128257051747), errors)
        phased_x(qs[22], angle(2.58786871845695), angle(0.0))
        noisy_zz_phase(qs[20], qs[22], angle(3.5855378072290303), errors)
        noisy_zz_phase(qs[18], qs[20], angle(3.5855378072290303), errors)
        phased_x(qs[18], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[16], qs[18], angle(0.456092427629891), errors)
        noisy_zz_phase(qs[14], qs[16], angle(0.456092427629891), errors)
        phased_x(qs[14], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[12], qs[14], angle(3.55128257051747), errors)
        noisy_zz_phase(qs[10], qs[12], angle(3.55128257051747), errors)
        phased_x(qs[10], angle(0.576688488856061), angle(0.0))
        phased_x(qs[12], angle(0.576688488856061), angle(0.0))
        phased_x(qs[16], angle(0.498931520675966), angle(0.0))
        phased_x(qs[20], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[22], qs[0], angle(3.5855378072290303), errors)
        phased_x(qs[0], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[0], qs[2], angle(0.456092427629891), errors)
        noisy_zz_phase(qs[2], qs[4], angle(0.456092427629891), errors)
        phased_x(qs[2], angle(0.498931520675966), angle(0.0))
        phased_x(qs[4], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[4], qs[6], angle(3.55128257051747), errors)
        noisy_zz_phase(qs[6], qs[8], angle(3.55128257051747), errors)
        phased_x(qs[6], angle(0.576688488856061), angle(0.0))
        phased_x(qs[8], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[8], qs[10], angle(0.592538532286453), errors)
        phased_x(qs[22], angle(3.50642850586368), angle(0.0))
        noisy_zz_phase(qs[20], qs[22], angle(0.456092427629891), errors)
        noisy_zz_phase(qs[18], qs[20], angle(0.456092427629891), errors)
        phased_x(qs[18], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[16], qs[18], angle(3.55128257051747), errors)
        noisy_zz_phase(qs[14], qs[16], angle(3.55128257051747), errors)
        phased_x(qs[14], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[12], qs[14], angle(0.592538532286453), errors)
        noisy_zz_phase(qs[10], qs[12], angle(0.592538532286453), errors)
        phased_x(qs[10], angle(0.5), angle(0.5))
        phased_x(qs[12], angle(0.5), angle(0.5))
        phased_x(qs[16], angle(0.576688488856061), angle(0.0))
        phased_x(qs[20], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[22], qs[0], angle(0.456092427629891), errors)
        phased_x(qs[0], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[0], qs[2], angle(3.55128257051747), errors)
        noisy_zz_phase(qs[2], qs[4], angle(3.55128257051747), errors)
        phased_x(qs[2], angle(0.576688488856061), angle(0.0))
        phased_x(qs[4], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[4], qs[6], angle(0.592538532286453), errors)
        noisy_zz_phase(qs[6], qs[8], angle(0.592538532286453), errors)
        phased_x(qs[6], angle(0.5), angle(0.5))
        phased_x(qs[8], angle(0.5), angle(0.5))
        phased_x(qs[22], angle(0.498931520675966), angle(0.0))
        noisy_zz_phase(qs[20], qs[22], angle(3.55128257051747), errors)
        noisy_zz_phase(qs[18], qs[20], angle(3.55128257051747), errors)
        phased_x(qs[18], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[16], qs[18], angle(0.592538532286453), errors)
        noisy_zz_phase(qs[14], qs[16], angle(0.592538532286453), errors)
        phased_x(qs[14], angle(0.5), angle(0.5))
        phased_x(qs[16], angle(0.5), angle(0.5))
        phased_x(qs[20], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[22], qs[0], angle(3.55128257051747), errors)
        phased_x(qs[0], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[0], qs[2], angle(0.592538532286453), errors)
        noisy_zz_phase(qs[2], qs[4], angle(0.592538532286453), errors)
        phased_x(qs[2], angle(0.5), angle(0.5))
        phased_x(qs[4], angle(0.5), angle(0.5))
        phased_x(qs[22], angle(0.576688488856061), angle(0.0))
        noisy_zz_phase(qs[20], qs[22], angle(0.592538532286453), errors)
        noisy_zz_phase(qs[18], qs[20], angle(0.592538532286453), errors)
        phased_x(qs[18], angle(0.5), angle(0.5))
        phased_x(qs[20], angle(0.5), angle(0.5))
        noisy_zz_phase(qs[22], qs[0], angle(0.592538532286453), errors)
        phased_x(qs[0], angle(3.62761192522423), angle(0.0))
        phased_x(qs[22], angle(0.5), angle(0.5))
        phased_x(qs[23], angle(1.5), angle(0.5))
        closed_ring_layer(qs, angle(2.21353314103693), angle(0.694037006200836), errors)
        closed_ring_layer(qs, angle(3.81898112750226), angle(3.80656406892676), errors)
        closed_ring_layer(
            qs, angle(0.394065296334771), angle(0.24821652772486402), errors
        )
        noisy_zz_phase(qs[23], qs[3], angle(0.0890420730088731), errors)
        noisy_zz_phase(qs[3], qs[7], angle(0.0890420730088731), errors)
        phased_x(qs[3], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(3.5), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        interior_cells(
            qs,
            angle(0.0890420730088731),
            angle(3.98885915398357),
            angle(3.97771830796713),
            angle(3.5),
            angle(3.5),
            angle(0.5),
            angle(1.5),
            angle(2.77718307967135),
            errors,
        )
        phased_x(qs[23], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.98885915398357), errors)
        phased_x(qs[19], angle(3.5), angle(0.0))
        phased_x(qs[21], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.97771830796713), errors)
        phased_x(qs[19], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(2.77718307967135), angle(0.0))
        phased_x(qs[23], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.98885915398357), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        phased_x(qs[23], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.97771830796713), errors)
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[1], qs[5], angle(0.178084146017746), errors)
        phased_x(qs[3], angle(2.77718307967135), angle(0.0))
        noisy_zz_phase(qs[5], qs[9], angle(0.178084146017746), errors)
        phased_x(qs[5], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[9], qs[13], angle(0.178084146017746), errors)
        phased_x(qs[9], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[13], qs[17], angle(0.178084146017746), errors)
        phased_x(qs[13], angle(3.77718307967135), angle(0.0))
        phased_x(qs[23], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        noisy_zz_phase(qs[17], qs[21], angle(0.178084146017746), errors)
        phased_x(qs[17], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(0.178084146017746), errors)
        phased_x(qs[1], angle(3.77718307967135), angle(0.0))
        phased_x(qs[21], angle(3.77718307967135), angle(0.0))
        phased_x(qs[23], angle(2.77718307967135), angle(0.0))
        noisy_zz_phase(qs[23], qs[3], angle(0.162962961489783), errors)
        noisy_zz_phase(qs[3], qs[7], angle(0.162962961489783), errors)
        phased_x(qs[3], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        interior_cells(
            qs,
            angle(0.162962961489783),
            angle(3.9331549239014003),
            angle(3.9331549239014003),
            angle(0.5),
            angle(0.5),
            angle(3.5),
            angle(2.5),
            angle(1.22281692032865),
            errors,
        )
        phased_x(qs[23], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.9331549239014003), errors)
        phased_x(qs[19], angle(0.5), angle(0.0))
        phased_x(qs[21], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.9331549239014003), errors)
        phased_x(qs[19], angle(2.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(1.22281692032865), angle(0.0))
        phased_x(qs[23], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.9331549239014003), errors)
        phased_x(qs[1], angle(3.5), angle(0.0))
        phased_x(qs[23], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.9331549239014003), errors)
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[1], qs[5], angle(0.162962961489783), errors)
        phased_x(qs[3], angle(1.22281692032865), angle(0.0))
        noisy_zz_phase(qs[5], qs[9], angle(0.162962961489783), errors)
        phased_x(qs[5], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[9], qs[13], angle(0.162962961489783), errors)
        phased_x(qs[9], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[13], qs[17], angle(0.162962961489783), errors)
        phased_x(qs[13], angle(0.222816920328653), angle(0.0))
        phased_x(qs[23], angle(2.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        noisy_zz_phase(qs[17], qs[21], angle(0.162962961489783), errors)
        phased_x(qs[17], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(0.162962961489783), errors)
        phased_x(qs[1], angle(0.222816920328653), angle(0.0))
        phased_x(qs[21], angle(0.222816920328653), angle(0.0))
        phased_x(qs[23], angle(1.22281692032865), angle(0.0))
        noisy_zz_phase(qs[23], qs[3], angle(0.14784177696182), errors)
        noisy_zz_phase(qs[3], qs[7], angle(0.14784177696182), errors)
        phased_x(qs[3], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(3.5), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        interior_cells(
            qs,
            angle(0.14784177696182),
            angle(3.88859153983567),
            angle(3.88859153983567),
            angle(3.5),
            angle(3.5),
            angle(0.5),
            angle(1.5),
            angle(2.77718307967135),
            errors,
        )
        phased_x(qs[23], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.88859153983567), errors)
        phased_x(qs[19], angle(3.5), angle(0.0))
        phased_x(qs[21], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.88859153983567), errors)
        phased_x(qs[19], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(2.77718307967135), angle(0.0))
        phased_x(qs[23], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.88859153983567), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        phased_x(qs[23], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.88859153983567), errors)
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[1], qs[5], angle(0.14784177696182), errors)
        phased_x(qs[3], angle(2.77718307967135), angle(0.0))
        noisy_zz_phase(qs[5], qs[9], angle(0.14784177696182), errors)
        phased_x(qs[5], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[9], qs[13], angle(0.14784177696182), errors)
        phased_x(qs[9], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[13], qs[17], angle(0.14784177696182), errors)
        phased_x(qs[13], angle(3.77718307967135), angle(0.0))
        phased_x(qs[23], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        noisy_zz_phase(qs[17], qs[21], angle(0.14784177696182), errors)
        phased_x(qs[17], angle(3.77718307967135), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(0.14784177696182), errors)
        phased_x(qs[1], angle(3.77718307967135), angle(0.0))
        phased_x(qs[21], angle(3.77718307967135), angle(0.0))
        phased_x(qs[23], angle(2.77718307967135), angle(0.0))
        noisy_zz_phase(qs[23], qs[3], angle(0.132720592433857), errors)
        noisy_zz_phase(qs[3], qs[7], angle(0.132720592433857), errors)
        phased_x(qs[3], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        interior_cells(
            qs,
            angle(0.132720592433857),
            angle(3.8440281557699403),
            angle(3.8440281557699403),
            angle(0.5),
            angle(0.5),
            angle(3.5),
            angle(2.5),
            angle(1.22281692032865),
            errors,
        )
        phased_x(qs[23], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.8440281557699403), errors)
        phased_x(qs[19], angle(0.5), angle(0.0))
        phased_x(qs[21], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.8440281557699403), errors)
        phased_x(qs[19], angle(2.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(1.22281692032865), angle(0.0))
        phased_x(qs[23], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.8440281557699403), errors)
        phased_x(qs[1], angle(3.5), angle(0.0))
        phased_x(qs[23], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.8440281557699403), errors)
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[1], qs[5], angle(0.132720592433857), errors)
        phased_x(qs[3], angle(1.22281692032865), angle(0.0))
        noisy_zz_phase(qs[5], qs[9], angle(0.132720592433857), errors)
        phased_x(qs[5], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[9], qs[13], angle(0.132720592433857), errors)
        phased_x(qs[9], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[13], qs[17], angle(0.132720592433857), errors)
        phased_x(qs[13], angle(0.222816920328653), angle(0.0))
        phased_x(qs[23], angle(2.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        noisy_zz_phase(qs[17], qs[21], angle(0.132720592433857), errors)
        phased_x(qs[17], angle(0.222816920328653), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(0.132720592433857), errors)
        phased_x(qs[1], angle(0.222816920328653), angle(0.0))
        phased_x(qs[21], angle(0.222816920328653), angle(0.0))
        phased_x(qs[23], angle(1.22281692032865), angle(0.0))
        noisy_zz_phase(qs[23], qs[3], angle(0.117599407905894), errors)
        noisy_zz_phase(qs[3], qs[7], angle(0.117599407905894), errors)
        phased_x(qs[3], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(3.5), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        interior_cells(
            qs,
            angle(0.117599407905894),
            angle(3.79946477170421),
            angle(3.89973238585211),
            angle(3.5),
            angle(3.5),
            angle(0.5),
            angle(1.5),
            angle(2.88859153983567),
            errors,
        )
        phased_x(qs[23], angle(3.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.79946477170421), errors)
        phased_x(qs[19], angle(3.5), angle(0.0))
        phased_x(qs[21], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(3.89973238585211), errors)
        phased_x(qs[19], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(2.88859153983567), angle(0.0))
        phased_x(qs[23], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.79946477170421), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        phased_x(qs[23], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[23], qs[1], angle(3.89973238585211), errors)
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[1], qs[5], angle(0.058799703952947), errors)
        phased_x(qs[3], angle(2.88859153983567), angle(0.0))
        noisy_zz_phase(qs[5], qs[9], angle(0.058799703952947), errors)
        phased_x(qs[5], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[3], qs[5], angle(0.5), errors)
        phased_x(qs[5], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[9], qs[13], angle(0.058799703952947), errors)
        phased_x(qs[9], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[7], qs[9], angle(0.5), errors)
        phased_x(qs[9], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[13], qs[17], angle(0.058799703952947), errors)
        phased_x(qs[13], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[11], qs[13], angle(0.5), errors)
        phased_x(qs[11], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[7], qs[11], angle(0.5), errors)
        phased_x(qs[11], angle(0.5), angle(0.5))
        phased_x(qs[13], angle(3.5), angle(0.0))
        phased_x(qs[23], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        noisy_zz_phase(qs[17], qs[21], angle(0.058799703952947), errors)
        phased_x(qs[17], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[15], qs[17], angle(0.5), errors)
        phased_x(qs[17], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[1], angle(0.058799703952947), errors)
        phased_x(qs[23], angle(0.5), angle(1.5))
        noisy_zz_phase(qs[21], qs[23], angle(0.5), errors)
        phased_x(qs[21], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[19], qs[21], angle(0.5), errors)
        phased_x(qs[19], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[15], qs[19], angle(0.5), errors)
        phased_x(qs[15], angle(2.5), angle(0.5))
        noisy_zz_phase(qs[7], qs[15], angle(0.5), errors)
        phased_x(qs[7], angle(2.5), angle(0.0))
        noisy_zz_phase(qs[3], qs[7], angle(0.5), errors)
        phased_x(qs[3], angle(2.5), angle(0.5))
        noisy_zz_phase(qs[1], qs[3], angle(0.5), errors)
        phased_x(qs[1], angle(3.0), angle(0.0))
        phased_x(qs[3], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[3], qs[2], angle(0.5), errors)
        phased_x(qs[2], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[3], qs[1], angle(0.5), errors)
        noisy_zz_phase(qs[0], qs[1], angle(0.5), errors)
        phased_x(qs[0], angle(3.5), angle(0.0))
        phased_x(qs[1], angle(3.5), angle(0.5))
        phased_x(qs[3], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[5], qs[7], angle(0.5), errors)
        phased_x(qs[5], angle(3.5), angle(1.5))
        noisy_zz_phase(qs[5], qs[4], angle(0.5), errors)
        phased_x(qs[4], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[5], qs[3], angle(0.5), errors)
        noisy_zz_phase(qs[2], qs[3], angle(0.5), errors)
        phased_x(qs[2], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[1], qs[2], angle(0.25), errors)
        phased_x(qs[1], angle(3.5), angle(0.5))
        phased_x(qs[2], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[1], qs[2], angle(0.25), errors)
        phased_x(qs[1], angle(0.5), angle(0.0))
        rz(qs[1], angle(0.5))
        phased_x(qs[2], angle(0.5), angle(0.127611925224232))
        rz(qs[2], angle(1.87238807477577))
        phased_x(qs[3], angle(3.5), angle(1.5))
        phased_x(qs[5], angle(2.5), angle(1.5))
        phased_x(qs[7], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[7], qs[6], angle(0.5), errors)
        phased_x(qs[6], angle(0.5), angle(1.62761192522423))
        phased_x(qs[7], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[11], qs[15], angle(0.5), errors)
        phased_x(qs[11], angle(1.5), angle(0.0))
        noisy_zz_phase(qs[9], qs[11], angle(0.5), errors)
        phased_x(qs[9], angle(3.5), angle(1.5))
        noisy_zz_phase(qs[9], qs[8], angle(0.5), errors)
        phased_x(qs[8], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[9], qs[7], angle(0.5), errors)
        phased_x(qs[7], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[9], qs[5], angle(0.5), errors)
        noisy_zz_phase(qs[7], qs[5], angle(0.5), errors)
        noisy_zz_phase(qs[4], qs[5], angle(0.5), errors)
        phased_x(qs[4], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[3], qs[4], angle(0.25), errors)
        phased_x(qs[3], angle(3.5), angle(1.5))
        phased_x(qs[4], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[3], qs[4], angle(0.25), errors)
        phased_x(qs[3], angle(3.5), angle(0.0))
        rz(qs[3], angle(1.5))
        phased_x(qs[4], angle(0.5), angle(0.127611925224232))
        rz(qs[4], angle(1.87238807477577))
        phased_x(qs[5], angle(3.5), angle(0.5))
        phased_x(qs[7], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[6], qs[7], angle(0.5), errors)
        phased_x(qs[6], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[5], qs[6], angle(0.25), errors)
        phased_x(qs[5], angle(3.5), angle(0.5))
        phased_x(qs[6], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[5], qs[6], angle(0.25), errors)
        phased_x(qs[5], angle(0.5), angle(0.0))
        rz(qs[5], angle(0.5))
        phased_x(qs[6], angle(0.5), angle(0.127611925224232))
        rz(qs[6], angle(1.87238807477577))
        phased_x(qs[7], angle(3.5), angle(1.5))
        phased_x(qs[9], angle(1.5), angle(0.0))
        phased_x(qs[11], angle(1.0), angle(1.0))
        noisy_zz_phase(qs[11], qs[10], angle(0.5), errors)
        phased_x(qs[10], angle(0.5), angle(1.62761192522423))
        phased_x(qs[11], angle(2.5), angle(1.0))
        noisy_zz_phase(qs[13], qs[15], angle(0.5), errors)
        phased_x(qs[13], angle(3.5), angle(1.5))
        noisy_zz_phase(qs[13], qs[12], angle(0.5), errors)
        phased_x(qs[12], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[13], qs[11], angle(0.5), errors)
        phased_x(qs[11], angle(0.5), angle(0.5))
        phased_x(qs[13], angle(2.5), angle(1.5))
        phased_x(qs[15], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[15], qs[14], angle(0.5), errors)
        phased_x(qs[14], angle(0.5), angle(1.62761192522423))
        phased_x(qs[15], angle(2.5), angle(0.5))
        noisy_zz_phase(qs[17], qs[19], angle(0.5), errors)
        phased_x(qs[17], angle(3.5), angle(1.5))
        noisy_zz_phase(qs[17], qs[16], angle(0.5), errors)
        phased_x(qs[16], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[17], qs[15], angle(0.5), errors)
        phased_x(qs[15], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[13], angle(0.5), errors)
        phased_x(qs[13], angle(3.5), angle(0.0))
        noisy_zz_phase(qs[17], qs[9], angle(0.5), errors)
        noisy_zz_phase(qs[13], qs[9], angle(0.5), errors)
        noisy_zz_phase(qs[11], qs[9], angle(0.5), errors)
        noisy_zz_phase(qs[8], qs[9], angle(0.5), errors)
        phased_x(qs[8], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[7], qs[8], angle(0.25), errors)
        phased_x(qs[7], angle(3.5), angle(1.5))
        phased_x(qs[8], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[7], qs[8], angle(0.25), errors)
        phased_x(qs[7], angle(3.5), angle(0.0))
        rz(qs[7], angle(1.5))
        phased_x(qs[8], angle(0.5), angle(0.127611925224232))
        rz(qs[8], angle(1.87238807477577))
        phased_x(qs[9], angle(3.5), angle(0.5))
        phased_x(qs[11], angle(2.5), angle(1.0))
        noisy_zz_phase(qs[10], qs[11], angle(0.5), errors)
        phased_x(qs[10], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[9], qs[10], angle(0.25), errors)
        phased_x(qs[9], angle(3.5), angle(0.5))
        phased_x(qs[10], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[9], qs[10], angle(0.25), errors)
        phased_x(qs[9], angle(0.5), angle(0.0))
        rz(qs[9], angle(0.5))
        phased_x(qs[10], angle(0.5), angle(0.127611925224232))
        rz(qs[10], angle(1.87238807477577))
        phased_x(qs[11], angle(3.5), angle(1.0))
        phased_x(qs[13], angle(2.5), angle(1.5))
        noisy_zz_phase(qs[15], qs[13], angle(0.5), errors)
        noisy_zz_phase(qs[12], qs[13], angle(0.5), errors)
        phased_x(qs[12], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[11], qs[12], angle(0.25), errors)
        phased_x(qs[11], angle(3.5), angle(1.0))
        phased_x(qs[12], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[11], qs[12], angle(0.25), errors)
        phased_x(qs[11], angle(0.5), angle(0.5))
        phased_x(qs[12], angle(0.5), angle(0.127611925224232))
        rz(qs[12], angle(1.87238807477577))
        phased_x(qs[13], angle(3.5), angle(0.0))
        phased_x(qs[15], angle(2.5), angle(0.5))
        noisy_zz_phase(qs[14], qs[15], angle(0.5), errors)
        phased_x(qs[14], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[13], qs[14], angle(0.25), errors)
        phased_x(qs[13], angle(3.5), angle(0.0))
        phased_x(qs[14], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[13], qs[14], angle(0.25), errors)
        phased_x(qs[13], angle(0.5), angle(1.5))
        rz(qs[13], angle(1.0))
        phased_x(qs[14], angle(0.5), angle(0.127611925224232))
        rz(qs[14], angle(1.87238807477577))
        phased_x(qs[15], angle(3.5), angle(0.5))
        phased_x(qs[17], angle(2.5), angle(0.5))
        phased_x(qs[19], angle(1.0), angle(0.0))
        noisy_zz_phase(qs[19], qs[18], angle(0.5), errors)
        phased_x(qs[18], angle(0.5), angle(1.62761192522423))
        phased_x(qs[19], angle(2.5), angle(0.5))
        phased_x(qs[21], angle(1.0), angle(1.0))
        noisy_zz_phase(qs[21], qs[20], angle(0.5), errors)
        phased_x(qs[20], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[21], qs[19], angle(0.5), errors)
        phased_x(qs[19], angle(0.5), angle(0.0))
        noisy_zz_phase(qs[21], qs[17], angle(0.5), errors)
        noisy_zz_phase(qs[19], qs[17], angle(0.5), errors)
        noisy_zz_phase(qs[16], qs[17], angle(0.5), errors)
        phased_x(qs[16], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[15], qs[16], angle(0.25), errors)
        phased_x(qs[15], angle(3.5), angle(0.5))
        phased_x(qs[16], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[15], qs[16], angle(0.25), errors)
        phased_x(qs[15], angle(0.5), angle(0.0))
        rz(qs[15], angle(0.5))
        phased_x(qs[16], angle(0.5), angle(0.127611925224232))
        rz(qs[16], angle(1.87238807477577))
        phased_x(qs[17], angle(3.5), angle(1.5))
        phased_x(qs[19], angle(2.5), angle(0.5))
        noisy_zz_phase(qs[18], qs[19], angle(0.5), errors)
        phased_x(qs[18], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[17], qs[18], angle(0.25), errors)
        phased_x(qs[17], angle(3.5), angle(1.5))
        phased_x(qs[18], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[17], qs[18], angle(0.25), errors)
        phased_x(qs[17], angle(3.5), angle(0.0))
        rz(qs[17], angle(1.5))
        phased_x(qs[18], angle(0.5), angle(0.127611925224232))
        rz(qs[18], angle(1.87238807477577))
        phased_x(qs[19], angle(3.5), angle(0.5))
        phased_x(qs[21], angle(1.5), angle(1.0))
        phased_x(qs[23], angle(1.0), angle(0.222816920328653))
        noisy_zz_phase(qs[23], qs[22], angle(0.5), errors)
        phased_x(qs[22], angle(0.5), angle(1.62761192522423))
        noisy_zz_phase(qs[23], qs[21], angle(0.5), errors)
        noisy_zz_phase(qs[20], qs[21], angle(0.5), errors)
        phased_x(qs[20], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[19], qs[20], angle(0.25), errors)
        phased_x(qs[19], angle(3.5), angle(0.5))
        phased_x(qs[20], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[19], qs[20], angle(0.25), errors)
        phased_x(qs[19], angle(0.5), angle(0.0))
        rz(qs[19], angle(0.5))
        phased_x(qs[20], angle(0.5), angle(0.127611925224232))
        rz(qs[20], angle(1.87238807477577))
        phased_x(qs[21], angle(3.5), angle(0.5))
        phased_x(qs[23], angle(2.5), angle(1.3342253804929802))
        noisy_zz_phase(qs[22], qs[23], angle(0.5), errors)
        phased_x(qs[22], angle(0.5), angle(1.12761192522423))
        noisy_zz_phase(qs[21], qs[22], angle(0.25), errors)
        phased_x(qs[21], angle(3.5), angle(0.5))
        phased_x(qs[22], angle(2.5), angle(0.627611925224232))
        noisy_zz_phase(qs[21], qs[22], angle(0.25), errors)
        phased_x(qs[21], angle(0.5), angle(0.0))
        rz(qs[21], angle(0.5))
        phased_x(qs[22], angle(0.5), angle(0.127611925224232))
        rz(qs[22], angle(1.87238807477577))
        phased_x(qs[23], angle(3.5), angle(1.3342253804929802))
        noisy_zz_phase(qs[23], qs[0], angle(0.25), errors)
        phased_x(qs[0], angle(2.5), angle(0.5))
        phased_x(qs[23], angle(3.5), angle(1.3342253804929802))
        noisy_zz_phase(qs[23], qs[0], angle(0.25), errors)
        phased_x(qs[0], angle(0.5), angle(0.0))
        phased_x(qs[23], angle(0.5), angle(0.834225380492978))
        rz(qs[23], angle(3.66577461950702))
        output("qs", collect_measurements(measure_array(qs)))
        rng.discard()

    # return the compiled program (HUGR)
    return main


main = build_prog(4)
