# Build the Sphinx documentation without adding its dependencies to the test environment.
docs:
    uv run --isolated --no-default-groups --group docs sphinx-build -M html docs docs/_build

# Remove generated Sphinx documentation without changing the test environment.
docs-clean:
    uv run --isolated --no-default-groups --group docs sphinx-build -M clean docs docs/_build
