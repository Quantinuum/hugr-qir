# Development

## Environment

The easiest way to set up the development environment is with `devenv.nix`.

```bash
devenv shell
```

Using `direnv` is a convenient way to auto-load the shell.

## Tests

Rust tests:

```bash
cargo test
```

Python tests:

```bash
uv run pytest -n auto
```

Snapshot updates:

```bash
uv run pytest --snapshot-update
```

## Documentation

The documentation site is powered by Sphinx using the shared `pytket-docs-theming` configuration.

Build locally:

```bash
just docs
```

The recipe uses an isolated environment so that the Sphinx dependencies do not
interfere with Guppy compilation in the test environment. The rendered site will
be written under `docs/_build/html`.

Clean and rebuild:

```bash
just docs-clean
just docs
```

## Useful source locations

- CLI: `src/cli.rs`
- Python wrapper: `python/hugr_qir/hugr_to_qir.py`
- Wasm lowering: `src/qir/wasm_ext.rs`
- Examples in the docs: [Examples](examples/index.md)
