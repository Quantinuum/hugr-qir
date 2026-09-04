# Configuration file for the Sphinx documentation builder.  # noqa: INP001
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information


# Alias needed here to prevent naming clash with something else sphinx is doing.
from importlib.metadata import version as check_version

# Checking the version used in the Python environment means that pyproject.toml
#  serves as the single source of truth for the version of hugr-qir.


project = f"hugr-qir v{check_version('hugr-qir')}"
copyright = "2026, Quantinuum"  # noqa: A001

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.napoleon",
    "sphinx.ext.viewcode",
    "sphinx_copybutton",
    "myst_parser",
    "sphinx_autodoc_typehints",
    "sphinx_click",
]

# Include constructor docstrings and retain annotations in generated API docs.
autoclass_content = "both"
always_document_param_types = True
typehints_use_signature = True
typehints_use_signature_return = True


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "furo"


intersphinx_mapping = {
    "python": ("https://docs.python.org/3", None),
    "pytket": ("https://docs.quantinuum.com/tket/api-docs/", None),
    "hugr": ("https://quantinuum.github.io/hugr/", None),
}
