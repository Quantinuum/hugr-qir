import qnexus as qnx  # type: ignore

import datetime  # noqa: E402

from qnexus.exceptions import AuthenticationError  # type: ignore [import-not-found]

from hugr_qir.h_series_helpers.results import HugrQirResults, ResultRepresentation

try:
    project = qnx.projects.get_or_create(name="QIR-Demonstration5")
except AuthenticationError:
    qnx.login()
    project = qnx.projects.get_or_create(name="QIR-Demonstration5")

qnx.context.set_active_project(project)

qir_name = "HUGR-QIR"
jobname_suffix = datetime.datetime.now().strftime("%Y_%m_%d-%H-%M-%S")

# You can write your guppy directly in a notebook or in a separate file
from typing import no_type_check  # noqa: E402

from guppylang import guppy, qubit  # noqa: E402
from guppylang.std.builtins import output  # noqa: E402
from guppylang.std.quantum import h, measure, x  # noqa: E402
from hugr_qir.guppy_to_qir import guppy_to_qir_bytes  # noqa: E402


# Generate a random 8 bit integer
@guppy.comptime()
@no_type_check
def main() -> None:
    qbs = [qubit() for _ in range(8)]

    results = []
    for i, q in enumerate(qbs):
        h(q)
        res = measure(q).read()
        results.append(res)
        output(f"q{i}", res)

    integer_value = 0
    for b in results:
        integer_value = (integer_value << 1) | int(b)  # for big-endian
    output(f"random_int", integer_value)

qir_bitcode = guppy_to_qir_bytes(main)

qir_program_ref = qnx.qir.upload(qir=qir_bitcode, name=qir_name, project=project)

# Run on the H2-1 Syntax checker
device_name = "H2-1E"

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

print("Job ref: ", ref_execute_job.id)

execute_job_result_refs = qnx.jobs.results(ref_execute_job)

result = execute_job_result_refs[0].download_result()

result_dict = {
    **{f"q{i}": ResultRepresentation.BOOL_BITSTRING for i in range(8)},
    "random_int": ResultRepresentation.INT,
}

hgr_result = HugrQirResults(result, result_dict)

for i, shot in enumerate(hgr_result.get_shots()):
    print(f"Shot {i}: ", "".join([shot[f"q{i}"] for i in range(8)]), " ",  shot["random_int"])
