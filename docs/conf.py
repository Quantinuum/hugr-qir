import runpy
from pathlib import Path

DOCS_DIR = Path(__file__).resolve().parent
THEMING_DIR = DOCS_DIR / "pytket-docs-theming"

# Load the shared Quantinuum/pytket docs configuration first, then override the
# project-specific pieces that should remain local to hugr-qir.
_shared_conf = runpy.run_path(str(THEMING_DIR / "conf.py"))
globals().update(_shared_conf)

project = "hugr-qir"
copyright = "2026 Quantinuum"  # noqa: A001
author = "Quantinuum"
root_doc = "index"
html_title = "hugr-qir"

# Our docs are Markdown-based and live directly under docs/.
source_suffix = {
    ".md": "myst-nb",
}

templates_path = ["_templates"]
html_static_path = ["pytket-docs-theming/_static"]
html_favicon = "pytket-docs-theming/_static/assets/quantinuum_favicon.svg"

# Exclude the theming submodule itself from the documentation source tree.
exclude_patterns = [
    *_shared_conf.get("exclude_patterns", []),
    "pytket-docs-theming",
    "pytket-docs-theming/**",
]

# This repository does not build API docs via autodoc yet and does not ship
# notebooks, so keep notebook execution disabled and avoid repo-name-based
# coverage configuration from the shared config.
nb_execution_mode = "off"
coverage_modules: list[str] = []
