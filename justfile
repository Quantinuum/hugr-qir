# Build the Sphinx documentation in a reusable environment separate from the test environment.
docs:
    UV_PROJECT_ENVIRONMENT=.venv-docs uv run --no-default-groups --group docs sphinx-build -M html docs docs/_build

# Remove generated Sphinx documentation without changing the test environment.
docs-clean:
    UV_PROJECT_ENVIRONMENT=.venv-docs uv run --no-default-groups --group docs sphinx-build -M clean docs docs/_build

# Build and open the documentation in the default browser.
docs-open: docs
    UV_PROJECT_ENVIRONMENT=.venv-docs uv run --no-default-groups --group docs python -c "import pathlib, webbrowser; webbrowser.open(pathlib.Path('docs/_build/html/index.html').resolve().as_uri())"
