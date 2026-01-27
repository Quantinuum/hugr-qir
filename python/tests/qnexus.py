import qnexus as qnx  # type: ignore

qnx.login()

import datetime  # noqa: E402

project = qnx.projects.get_or_create(name="QIR-Demonstration")
qnx.context.set_active_project(project)

qir_name = "HUGR-QIR"
jobname_suffix = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-%S")

# You can write your guppy directly in a notebook or in a separate file
from typing import no_type_check  # noqa: E402

from guppylang import guppy, qubit  # noqa: E402
from guppylang.std.builtins import result  # noqa: E402
from guppylang.std.quantum import h, measure  # noqa: E402
from hugr_qir.hugr_to_qir import hugr_to_qir  # noqa: E402, F401


@guppy
@no_type_check
def main() -> None:
    q0 = qubit()
    q1 = qubit()

    h(q0)
    h(q1)

    b0 = measure(q0)
    b1 = measure(q1)
    b2 = b0 ^ b1

    result("0", b2)


qir_bitcode = main.compile().to_qir_bytes()

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

qnx.jobs.wait_for(ref_execute_job)
