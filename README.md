# hugr-qir

[![build_status][]](https://github.com/Quantinuum/hugr-qir/actions)
[![codecov][]](https://codecov.io/gh/Quantinuum/hugr-qir)

A tool for converting Hierarchical Unified Graph Representation (HUGR, pronounced _hugger_) formatted quantum programs into [QIR](https://github.com/qir-alliance/qir-spec) format.

Warning: Not all hugr/guppy programs can be converted to QIR.

## Installation

You can install from pypi via `pip install hugr-qir`.

## Usage

### Python

Use the function `hugr_to_qir` from the `hugr_to_qir` module to convert hugr to qir. By default, some basic validity checks will be run on the generated QIR. These checks can be turned off by passing `validate_qir = False`.

You can find an example notebook at `examples/submit-guppy-h2-via-qir.ipynb` showing the conversion and the submission to H1/H2.

### CLI

You can use the available cli after installing the python package.

This will generate qir for a given hugr file:

```sh
hugr-qir test-file.hugr
```

Run `hugr-qir --help` to see the available options.

If you want to generate a hugr file from guppy, you can do this in two steps:

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

## Development

### #️⃣ Setting up the development environment

You'll need to install:

- [Rust](https://rustup.rs/) (via rustup)
- [uv](https://docs.astral.sh/uv/) for Python package management
- LLVM 14 development libraries

#### Installing LLVM 14

On macOS:

```sh
brew install llvm@14
export LLVM_SYS_140_PREFIX="$(brew --prefix llvm@14)"
```

On Ubuntu/Debian:

```sh
sudo apt-get install llvm-14-dev libclang-14-dev
export LLVM_SYS_140_PREFIX=/usr/lib/llvm-14
```

#### Setting up Python environment

Install dependencies with uv:

```sh
uv sync --all-groups
```

This will create a virtual environment and install all dependencies including development and example groups.

### Run tests

You can run the rust test with:

```sh
cargo test
```

You can run the Python test with:

```sh
uv run pytest -n auto
```

If you want to update the snapshots you can do that via:

```sh
uv run pytest --snapshot-update
```

## License

This project is licensed under Apache License, Version 2.0 ([LICENSE][] or <http://www.apache.org/licenses/LICENSE-2.0>).

[build_status]: https://github.com/Quantinuum/hugr-qir/actions/workflows/ci-py.yml/badge.svg?branch=main
[codecov]: https://img.shields.io/codecov/c/gh/Quantinuum/hugr-qir?logo=codecov
[LICENSE]: https://github.com/Quantinuum/hugr-qir/blob/main/LICENCE
