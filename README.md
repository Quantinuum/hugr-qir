# hugr-qir

[![build_status][]](https://github.com/Quantinuum/hugr-qir/actions)
[![codecov][]](https://codecov.io/gh/Quantinuum/hugr-qir)

A tool for converting Hierarchical Unified Graph Representation (HUGR, pronounced _hugger_) formatted quantum programs into [QIR](https://github.com/qir-alliance/qir-spec) format.

> [!NOTE]
> Not all Guppy/HUGR programs can be converted to QIR.

## Documentation

Project documentation lives in [docs/](docs/) and can be viewed online [here](https://quantinuum.github.io/hugr-qir/).

- Getting started: [docs/getting-started.md](docs/getting-started.md)
- Examples: [docs/examples/index.md](docs/examples/index.md)
- Guppylang support: [docs/guppy-for-h-series/index.md](docs/guppy-for-h-series/index.md)
- Python API: [docs/python-api.md](docs/python-api.md)
- CLI: [docs/cli.md](docs/cli.md)
- WASM support: [docs/wasm.md](docs/wasm.md)
- Development: [docs/development.md](docs/development.md)

To build the documentation locally:

```bash
uv run --group docs sphinx-build -M html docs docs/_build
```

Then open `docs/_build/html/index.html` in a browser.


## Installation

You can install from pypi via `pip install hugr-qir`.

## Usage

### Python

Use `hugr_to_qir` to convert a HUGR package or serialized HUGR bytes into QIR.

```py
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat

qir = hugr_to_qir(
    hugr_package,
    validate_qir=False,
    output_format=OutputFormat.LLVM_IR,
)
```

By default, basic validity checks are run on the generated QIR. These can be disabled by passing `validate_qir=False`.

You can find an example notebook at `examples/submit-guppy-h2-via-qir.ipynb` showing the conversion and the submission to Quantinuum System Model H2.

### CLI

You can use the available CLI after installing the python package.

This will generate qir for a given hugr file:

```sh
hugr-qir test-file.hugr
```

Run `hugr-qir --help` to see the available options.

If you want to generate a HUGR file from Guppy, you can do this in two steps:

1. Add this to the end of your guppy file:

    ```py
    if __name__ == "__main__":
        sys.stdout.buffer.write(main.compile().to_bytes())
        # Or to compile a non-main guppy function:
        sys.stdout.buffer.write(guppy_func.compile_function().to_bytes())
    ```

1. Generate the hugr file with:

    ```sh
    python guppy_examples/general/quantum-classical-1.py > test-guppy.hugr
    ```

See [docs/guppy-for-h-series/support-matrix.md](docs/guppy-for-h-series/support-matrix.md) for the current Guppylang support matrix and caveats.

## Development

### Setting up the development environment

The easiest way to set up the development environment is to use the provided
[`devenv.nix`](devenv.nix) file. This will set up a development shell with all the
required dependencies.

To use this, you will need to install [devenv](https://devenv.sh/getting-started/).
Once you have it running, open a shell with:

```bash
devenv shell
```

All the required dependencies should be available. You can automate loading the
shell by setting up [direnv](https://devenv.sh/automatic-shell-activation/).

### Run tests

You can run the rust test with:

```bash
cargo test
```

You can run the Python test with:

```bash
uv run pytest -n auto
```

You can type-check the Python sources with:

```bash
uv run ty check
```

You can run the Python formatter and linter with:

```bash
uv run ruff format --check python guppy_examples
uv run ruff check python guppy_examples
```

You can run the configured Git hooks with:

```bash
uvx prek run --all-files
```

If you want to update the snapshots you can do that via:

```bash
uv run pytest --snapshot-update
```

## License

This project is licensed under Apache License, Version 2.0 ([LICENSE][] or <http://www.apache.org/licenses/LICENSE-2.0>).

[build_status]: https://github.com/Quantinuum/hugr-qir/actions/workflows/ci-py.yml/badge.svg?branch=main
[codecov]: https://img.shields.io/codecov/c/gh/Quantinuum/hugr-qir?logo=codecov
[LICENSE]: https://github.com/Quantinuum/hugr-qir/blob/main/LICENCE
