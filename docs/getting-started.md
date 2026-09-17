# Getting Started

## Installation

Install from PyPI:

```bash
pip install hugr-qir
```

## Python

The main Python entrypoint is `hugr_to_qir`.


.. literalinclude:: ../examples/qnexus-test.py.py
:language: python
:linenos:


This example shows the full flow:

1. define a Guppy program
2. compile it to a HUGR package with `main.compile()`
3. convert that HUGR package to QIR with `hugr_to_qir`
4. submit QIR via qnexus to the device
5. download results and convert it to a qsys result via `backendresult_to_qsysresult`

`hugr_to_qir` accepts either a `hugr.package.Package` or serialized HUGR bytes. In this example, `qir` is a string containing LLVM IR.

## CLI

The installed package also provides a CLI:

```bash
hugr-qir input.hugr
```

To write LLVM IR to a file:

```bash
hugr-qir input.hugr -f llvm-ir -o output.ll
```

To see the full set of options:

```bash
hugr-qir --help
```

## Guppy to HUGR

If you want to compile a Guppy program and feed it into `hugr-qir`, a simple pattern is:

```python
if __name__ == "__main__":
    import sys

    sys.stdout.buffer.write(main.compile().to_bytes())
```

Then:

```bash
python my_program.py > program.hugr
hugr-qir program.hugr -f llvm-ir
```

## Examples

See the working examples in [Examples](examples/index.md).
