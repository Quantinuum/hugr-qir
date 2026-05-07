prepare:
    cp -R pytket-docs-theming/_static .
    cp pytket-docs-theming/conf.py .
    cp pytket-docs-theming/pyproject.toml .
    cp pytket-docs-theming/uv.lock .

PROJECT_NAME := `basename "$(dirname "$PWD")"`

install: prepare
    uv sync && uv pip install ../.

build *SPHINX_ARGS: install
    uv run sphinx-build {{SPHINX_ARGS}} -b html . build -D html_title={{PROJECT_NAME}}

linkcheck: install
    uv run sphinx-build -b linkcheck . build

coverage: install
    uv run sphinx-build -v -b coverage . build/coverage

build-strict: install
    just build -W # Fail on sphinx warnings
    just linkcheck
    just coverage

serve: build
    npm exec serve build

cleanup:
    rm -rf build
    rm -rf .jupyter_cache
    rm -rf jupyter_execute
    rm -rf _static
    rm -f conf.py

cleanup-all:
    just cleanup
    rm -rf .venv
    rm -f pyproject.toml
    rm -f uv.lock
