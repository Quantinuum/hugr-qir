# Python CLI

Detailed information on options and option defaults can be generated using `hugr-qir -h/--help`.

The CLI outputs QIR to stdout by default but can be configured to write to a file and to output in various formats.

## Basic usage

```bash
hugr-qir input.hugr
```

This reads a HUGR package and emits QIR.

## Common options

- `-h, --help`: print help message including all options/defaults
- `-o, --output`: write to a file instead of stdout
- `-f, --output-format`: choose `llvm-ir` for readable LLVM IR, `bitcode` for LLVM bitcode, or `base64` for base64-encoded bitcode
- `-t, --target`: select the compilation target
- `-l, --opt-level`: choose the LLVM optimization level
- `--wasm-file`: provide a Wasm module for the Wasm extension

Example:

```bash
hugr-qir program.hugr \
  --output result.ll \
  --output-format llvm-ir \
  --opt-level aggressive
```
