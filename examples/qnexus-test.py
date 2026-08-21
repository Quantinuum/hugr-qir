import qnexus as qnx  # type: ignore
from typing import no_type_check

import datetime

from qnexus.exceptions import AuthenticationError

from hugr_qir.h_series_helpers.results import (
    HugrQirResultHelper,
    ResultRepresentation,
    ResultRepresentationSpec,
)

from guppylang import guppy, qubit
from guppylang.std.builtins import output
from guppylang.std.quantum import h, measure
from hugr_qir.guppy_to_qir import guppy_to_qir_bytes

# This demo requires access to Quantinuum Nexus

# Create a Nexus project (or retrieve if it already exists)
# Will prompt for login credentials if not already logged in
try:
    project = qnx.projects.get_or_create(name="QIR-Demo")
except AuthenticationError:
    qnx.login()
    project = qnx.projects.get_or_create(name="QIR-Demo")
qnx.context.set_active_project(project)
qir_name = "HUGR-QIR"
jobname_suffix = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-%S")


# This is the Guppy program
# It generates a random 8-bit integer
@guppy.comptime
@no_type_check
def main() -> None:
    # Allocate 8 qubits
    qbs = [qubit() for _ in range(8)]

    # Generate 8 random bits
    results = []
    for i, q in enumerate(qbs):
        h(q)
        res = measure(q).read()
        results.append(res)
        output(f"q{i}", res)

    # Create an integer from the random bits
    integer_value = 0
    for b in results:
        integer_value = (integer_value << 1) | int(b)  # for big-endian
    output(f"random_int", integer_value)

# Use hugr-qir to translate the guppy entrypoint directly into qir
# that is ready to submit to Nexus
qir_bitcode = guppy_to_qir_bytes(main)

# Upload the program to Nexus
qir_program_ref = qnx.qir.upload(qir=qir_bitcode, name=qir_name, project=project)

# Run on the H2-1E emulator
device_name = "H2-1E"
qnx.context.set_active_project(project)
config = qnx.QuantinuumConfig(device_name=device_name)

# Instruct Nexus to execute the program and wait for it to finish
job_name = f"execution-job-qir-{qir_name}-{device_name}-{jobname_suffix}"
ref_execute_job = qnx.start_execute_job(
    programs=[qir_program_ref],
    n_shots=[10],
    backend_config=config,
    name=job_name,
)
qnx.jobs.wait_for(ref_execute_job)

# Print the Job id. You can retrieve the job ref again later using
# ref_execute_job = qnx.jobs.get(id="<job_id>")
print("Job id: ", ref_execute_job.id)

# Get the result from Nexus
execute_job_result_refs = qnx.jobs.results(ref_execute_job)
result = execute_job_result_refs[0].download_result()

# Use a result representation spec to define how results will be
# formatted by the HugrQirResultHelper class
# Here we choose to represent the booleans as a 1-bit bitstring
# and "random_int" as an integer
# The tags must match those used in the guppy program `output` calls
result_spec = ResultRepresentationSpec({
    **{f"q{i}": ResultRepresentation.BOOL_BITSTRING for i in range(8)},
    "random_int": ResultRepresentation.INT,
})

# Create a HugrQirResultHelper from the Nexus results and representation spec
hgr_result = HugrQirResultHelper(
    result,
    result_spec,
)

# Get the shot data in the specified format
shots = hgr_result.get_shots()

# Print shot results
for i, shot in enumerate(shots):
    print(f"Shot {i}: ", "".join([shot[f"q{i}"] for i in range(8)]), " ",  shot["random_int"])
