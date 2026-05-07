# CLI

The Rust CLI is defined in `src/cli.rs` and exposed through the installed Python package.

## Basic usage

```bash
hugr-qir input.hugr
```

This reads a HUGR package and emits QIR.

## Common options

- `-o, --output`: write to a file instead of stdout
- `-f, --output-format`: choose `llvm-ir` or `bitcode`
- `-t, --target`: select the compilation target
- `-l, --opt-level`: choose the LLVM optimization level
- `--validate`: validate the HUGR before and after passes
- `--wasm-file`: provide a WASM module for the wasm extension

Example:

```bash
hugr-qir program.hugr \
  --output result.ll \
  --output-format llvm-ir \
  --opt-level aggressive
```

## Output format behavior

If no output format is explicitly provided, the CLI infers a default from the output destination:

- LLVM IR for tty output and `.ll` or `.asm` files
- bitcode otherwise

## Validation

The CLI always validates the generated QIR in the Python wrapper unless that wrapper disables validation. HUGR validation is opt-in through `--validate`.
