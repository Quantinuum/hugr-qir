
import qnexus as qnx  # type: ignore

from qnexus.exceptions import AuthenticationError  # type: ignore [import-not-found]

from hugr_qir.h_series_helpers.results import backendresult_to_qsysresult

if __name__ == "__main__":
    # Print the Job id. You can retrieve the job ref again later using
    ref_execute_job = qnx.jobs.get(id="c28f9b67-5341-4135-b7ab-c9055f06decd")
    print("Job id: ", ref_execute_job.id)

    # Get the result from Nexus
    execute_job_result_refs = qnx.jobs.results(ref_execute_job)
    result = execute_job_result_refs[0].download_result()
    print(result.c_bits)

    qsys_result = backendresult_to_qsysresult(result)
    print(qsys_result.results)
