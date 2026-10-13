"""Check synthetic THC coefficients, select-record layout, and encoded angle tables."""

import numpy as np
from guppyalgos.algorithms.block_encoding.thc import (
    build_select_data,
    build_thc_alias_terms,
    build_thc_lcu_data,
    encode_combined_givens_rotations,
    encode_givens_rotations,
    generate_thc_parameters,
    validate_thc_parameters,
)

COMPONENT = "THC classical preprocessing; no quantum circuit"
CLASSICAL_ONLY = True
QUBIT_BUDGET = 0


def classical_check() -> dict:
    parameters = generate_thc_parameters(2, 2, seed=7)
    if validate_thc_parameters(parameters) != (2, 2):
        message = "Incorrect THC dimensions"
        raise AssertionError(message)
    terms = build_thc_alias_terms(parameters)
    coefficients = np.array(
        [
            parameters.two_body_coefficients[0, 0] / 4,
            parameters.two_body_coefficients[0, 1],
            parameters.two_body_coefficients[1, 1] / 4,
            *(-parameters.one_body_coefficients),
        ]
    )
    np.testing.assert_allclose([term.coefficient for term in terms], coefficients)
    data = build_thc_lcu_data(
        parameters, rotation_precision_bits=2, alias_precision_bits=3
    )
    np.testing.assert_allclose(
        data.alias_probabilities, abs(coefficients) / abs(coefficients).sum()
    )
    records = build_select_data(terms, data.n_index_qubits, 2)
    expected_records = []
    for mu, nu, coefficient in [
        (0, 0, coefficients[0]),
        (0, 1, coefficients[1]),
        (1, 1, coefficients[2]),
        (0, None, coefficients[3]),
        (1, None, coefficients[4]),
    ]:
        second_index = 2 if nu is None else nu
        expected_records.append(
            [
                bool(mu & 1),
                bool(mu & 2),
                bool(second_index & 1),
                bool(second_index & 2),
                nu is None,
                bool(coefficient < 0),
            ]
        )
    np.testing.assert_array_equal(records, expected_records)
    angles = encode_givens_rotations(parameters.two_body_rotations, 2, 4)
    combined = encode_combined_givens_rotations(
        parameters.two_body_rotations, parameters.one_body_rotations, 2, 2
    )
    np.testing.assert_array_equal(combined[:2], angles)
    np.testing.assert_array_equal(combined[2:4], np.zeros((2, 1, 2), dtype=bool))
    np.testing.assert_array_equal(
        combined[4:], encode_givens_rotations(parameters.one_body_rotations, 2, 4)
    )
    return {
        "modes": data.n_modes,
        "terms": len(terms),
        "alias_qubits": data.n_alias_qubits,
        "index_qubits": data.n_index_qubits,
        "normalization": float(abs(coefficients).sum()),
    }


if __name__ == "__main__":
    print(classical_check())
