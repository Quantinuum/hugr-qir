# Getting Started

## Installation

Install from PyPI:

```bash
pip install hugr-qir
```

## Python

The main Python entrypoint is `hugr_to_qir`.

```python
from typing import no_type_check

from guppylang import guppy, qubit
from guppylang.std.builtins import result
from guppylang.std.quantum import measure, x
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    x(q0)
    x(q1)

    b0 = measure(q0)
    b1 = measure(q1)
    b2 = b0 ^ b1

    result("0", b2)


hugr_package = main.compile()
qir = hugr_to_qir(hugr_package, validate_qir=False, output_format=OutputFormat.LLVM_IR)
```

This example shows the full flow:

1. define a Guppy program
2. compile it to a HUGR package with `main.compile()`
3. convert that HUGR package to QIR with `hugr_to_qir`

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
