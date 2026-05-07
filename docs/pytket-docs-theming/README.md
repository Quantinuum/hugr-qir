# pytket-docs-theming

Docs configuration for docs.quantinuum.com/tket based on the [Quantinuum-sphinx](https://github.com/Quantinuum/quantinuum-sphinx) theme.

This repository is intended to be used as a git submodule in documentation source repositories.

```shell
git submodule add -b main https://github.com/Quantinuum/pytket-docs-theming.git
```

## Contents

Contains a single source of truth for the following docs config

1. Sphinx configuration - ([conf.py](https://github.com/Quantinuum/pytket-docs-theming/blob/main/conf.py))
2. A `_static` directory. This currently contains the Quantinuum favicon.
3. Python packages required to build the docs for the pytket extensions modules. These are specified in [pyproject.toml](https://github.com/Quantinuum/pytket-docs-theming/blob/main/extensions/pyproject.toml) and [poetry.lock](https://github.com/Quantinuum/pytket-docs-theming/blob/main/extensions/poetry.lock) (see the [README](https://github.com/Quantinuum/pytket-docs-theming/tree/main/extensions#building-the-api-docs-for-pytket-extensions) for instructions).
