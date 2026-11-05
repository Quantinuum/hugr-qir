import subprocess
import sys
from textwrap import dedent

import pytest


@pytest.mark.parametrize("suffix", ["", ".results"])
def test_deprecated_helpers_import(suffix: str) -> None:
    script = dedent(
        f"""\
        import importlib
        import warnings

        from hugr_qir.h2_helpers import results

        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always", DeprecationWarning)
            importlib.import_module("hugr_qir.h_series_helpers{suffix}")

        assert len(caught) == 1
        assert caught[0].category is DeprecationWarning
        assert "use hugr_qir.h2_helpers instead" in str(caught[0].message)

        from hugr_qir.h_series_helpers import results as legacy_results
        from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult

        assert backendresult_to_qsysresult is results.backendresult_to_qsysresult
        for name, value in vars(results).items():
            if not name.startswith("_") and (
                getattr(value, "__module__", None) == results.__name__
                or name in (
                    "EXPECTED_REGISTER_SIZE", "EXPECTED_REGISTER_INDICES",
                    "ShotValue", "Shots", "ShotsByTag",
                )
            ):
                assert getattr(legacy_results, name) is value, name
        """
    )
    subprocess.run([sys.executable, "-c", script], check=True)  # noqa: S603
