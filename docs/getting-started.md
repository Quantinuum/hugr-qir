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
from guppylang.std.builtins import output
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

    b0 = measure(q0).read()
    b1 = measure(q1).read()
    b2 = b0 ^ b1

    output("0", b2)


# Generate QIR
hugr_package = main.compile()
qir_bitcode = hugr_to_qir(hugr_package, validate_qir=True, output_format=OutputFormat.BITCODE)


# Submit to device
import qnexus as qnx
qnx.login()


import datetime
project = qnx.projects.get_or_create(name="QIR-Demonstration3")
qnx.context.set_active_project(project)

qir_name = "HUGR-QIR"
jobname_suffix = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-%S")

qir_program_ref = qnx.qir.upload(qir=qir_bitcode, name=qir_name, project=project)

# Run on the H2-1 Syntax checker
device_name = "H2-1SC"

qnx.context.set_active_project(project)
config = qnx.QuantinuumConfig(device_name=device_name)

job_name = f"execution-job-qir-{qir_name}-{device_name}-{jobname_suffix}"
ref_execute_job = qnx.start_execute_job(
    programs=[qir_program_ref],
    n_shots=[10],
    backend_config=config,
    name=job_name,
)

qir_result = qnx.jobs.results(ref_execute_job)[0].download_result()

# Convert Pytket BackendResult to QSysResult

from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult
qsysres = backendresult_to_qsysresult(qir_result)

```

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
