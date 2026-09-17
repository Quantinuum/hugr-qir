import datetime
import qnexus as qnx  # type: ignore
from qnexus.exceptions import AuthenticationError  # type: ignore [import-not-found]
from typing import no_type_check
from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import measure, x
from hugr_qir.hugr_to_qir import hugr_to_qir
from hugr_qir.output import OutputFormat
from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult


# Define Guppy program
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

# Get or create a Nexus project to submit jobs in
try:
    project = qnx.projects.get_or_create(name="HUGR-QIR-Demo")
except AuthenticationError:
    qnx.login()
    project = qnx.projects.get_or_create(name="HUGR-QIR-Demo")
qnx.context.set_active_project(project)

# Run job on Nexus
# Use the H2-1 syntax checker (emits dummy results)
# Switch to H2-1E or H2-2E for actual emulation
device_name = "H2-1SC"
qir_name = "HUGR-QIR"
jobname_suffix = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-%S")
job_name = f"execution-job-qir-{qir_name}-{device_name}-{jobname_suffix}"
qir_program_ref = qnx.qir.upload(qir=qir_bitcode, name=qir_name, project=project)
config = qnx.QuantinuumConfig(device_name=device_name)
ref_execute_job = qnx.start_execute_job(
    programs=[qir_program_ref],
    n_shots=[10],
    backend_config=config,
    name=job_name,
)
qnx.jobs.wait_for(ref_execute_job)
qir_result = qnx.jobs.results(ref_execute_job)[0].download_result()

# Convert Pytket BackendResult to QSysResult
qsysres = backendresult_to_qsysresult(qir_result)

# Print QSysResult
for i, shot in enumerate(qsysres.results):
    print(f"{i}: {shot.entries}")
