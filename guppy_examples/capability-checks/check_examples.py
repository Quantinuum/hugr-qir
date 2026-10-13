"""Compile each example independently and optionally check its local simulation."""

from __future__ import annotations

import argparse
import hashlib
import importlib.metadata
import importlib.util
import json
import os
import re
import signal
import subprocess
import sys
import tempfile
import traceback
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from collections.abc import Callable
    from types import ModuleType

from _checks import check_distribution

ROOT = Path(__file__).resolve().parent
SUITES = ("guppyalgos", "guppylang_docs_examples")


def json_value(value: object) -> object:
    """Serialize numerical arrays and complex values in simulation diagnostics."""
    if isinstance(value, complex):
        return {"real": value.real, "imag": value.imag}
    if hasattr(value, "tolist"):
        return value.tolist()
    # Raw simulator state entries have a dedicated validated state summary.
    return {"type": type(value).__name__}


def discover_examples(suites: list[str], patterns: list[str]) -> list[Path]:
    return sorted(
        {
            path.resolve()
            for suite in suites
            for pattern in patterns
            for path in (ROOT / suite).glob(pattern)
            if path.is_file() and path.suffix == ".py" and not path.name.startswith("_")
        }
    )


def load_example(path: Path) -> ModuleType:
    sys.path.insert(0, str(path.parent))
    spec = importlib.util.spec_from_file_location(
        f"{path.parent.name}_{path.stem}", path
    )
    if spec is None or spec.loader is None:
        message = f"Cannot load {path}"
        raise ImportError(message)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def worker(path: Path, output: Path, mode: str, shots: int | None) -> None:  # noqa: PLR0915
    result = {
        "file": path.name,
        "suite": path.parent.name,
        "source_sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    }
    result_path = output / f"{path.stem}.{mode}.json"

    def save() -> None:
        result_path.write_text(json.dumps(result, indent=2, default=json_value) + "\n")

    def stage(name: str, action: Callable[[], object]) -> tuple[bool, object]:
        result["running"] = name
        save()
        try:
            value = action()
        except Exception:  # noqa: BLE001 - Record failures and continue to other examples.
            result[name] = "fail"
            result["error"] = traceback.format_exc()
            print(result["error"], file=sys.stderr)
            result.pop("running", None)
            save()
            return False, None
        result[name] = "pass"
        result.pop("running", None)
        save()
        return True, value

    ok, module = stage("import", lambda: load_example(path))
    if not ok:
        return
    result["component"] = module.COMPONENT
    if getattr(module, "CLASSICAL_ONLY", False):
        result["classical_only"] = True
        result["qubit_budget"] = 0
        ok, details = stage("preprocess", module.classical_check)
        if ok:
            result["details"] = details
            save()
        return
    result["qubit_budget"] = module.QUBIT_BUDGET
    if not 0 < module.QUBIT_BUDGET <= 56:
        message = f"Invalid qubit budget: {module.QUBIT_BUDGET}"
        raise ValueError(message)
    shots = shots if shots is not None else getattr(module, "DEFAULT_SHOTS", 256)
    result["requested_shots"] = shots
    if hasattr(module, "SOURCE_URL"):
        result["source_url"] = module.SOURCE_URL
    save()

    if mode == "compile":
        ok, _ = stage("check", module.main.check)
        if not ok:
            return
        ok, package = stage("compile", module.main.compile)
        if not ok:
            return
        (output / f"{path.stem}.hugr").write_bytes(package.to_bytes())

        def convert() -> None:
            from hugr_qir.hugr_to_qir import hugr_to_qir  # noqa: PLC0415
            from hugr_qir.output import OutputFormat  # noqa: PLC0415
            from quantinuum_qircheck import qircheck  # noqa: PLC0415
            from quantinuum_qircheck.qircheck import ValidationError  # noqa: PLC0415

            qir = hugr_to_qir(
                package,
                output_format=OutputFormat.LLVM_IR,
                validate_hugr=True,
                validate_qir=False,
            )
            (output / f"{path.stem}.ll").write_text(qir)
            result["qir_emitted"] = True
            match = re.search(r'"required_num_qubits"="(\d+)"', qir)
            if match is None:
                message = "QIR has no required_num_qubits attribute"
                raise AssertionError(message)
            result["qir_qubits"] = int(match[1])
            if result["qir_qubits"] > 56:
                message = f"QIR needs {result['qir_qubits']} qubits; limit is 56"
                raise AssertionError(message)
            try:
                qircheck(qir)
            except ValidationError as error:
                message = f"Generated QIR failed validation: {error.error_message}"
                raise ValueError(message) from error

        stage("qir", convert)
    else:

        def emulate() -> None:
            from guppylang.emulator.exceptions import EmulatorError  # noqa: PLC0415

            # Building errors must not satisfy a program's expected runtime panic.
            emulator = module.main.emulator(n_qubits=module.QUBIT_BUDGET)
            try:
                simulation = emulator.with_seed(7).with_shots(shots).run()
            except EmulatorError as error:
                expected_error = getattr(module, "EXPECTED_EMULATOR_ERROR", None)
                if not expected_error or expected_error not in str(error):
                    raise
                result["expected_emulator_error"] = str(error)
                result["shots"] = len(error.completed_shots.results)
                return
            if getattr(module, "EXPECTED_EMULATOR_ERROR", None):
                message = (
                    "Simulation returned normally instead of raising the expected error"
                )
                raise AssertionError(message)
            records = [shot.as_dict() for shot in simulation.results]
            (output / f"{path.stem}.shots.json").write_text(
                json.dumps(records, indent=2, default=json_value) + "\n"
            )
            expectations = (
                module.expected_probabilities()
                if hasattr(module, "expected_probabilities")
                else getattr(module, "EXPECTED", {})
            )
            validators = ("validate_shot", "validate_records", "validate_simulation")
            if not expectations and not any(
                hasattr(module, name) for name in validators
            ):
                message = "No simulation outcome checks are declared"
                raise AssertionError(message)
            for label, distribution in expectations.items():
                check_distribution(records, label, distribution)
            if hasattr(module, "validate_shot"):
                for record in records:
                    module.validate_shot(record)
            if hasattr(module, "validate_records"):
                module.validate_records(records)
            if hasattr(module, "validate_simulation"):
                result["validation_details"] = module.validate_simulation(simulation)
            result["shots"] = len(records)

        stage("emulate", emulate)


def run_worker(path: Path, output: Path, mode: str, args: argparse.Namespace) -> dict:
    output = output / path.parent.name
    output.mkdir(parents=True, exist_ok=True)
    command = [
        sys.executable,
        str(Path(__file__).resolve()),
        "--worker",
        str(path),
        "--mode",
        mode,
        "--output",
        str(output),
    ]
    if args.shots is not None:
        command.extend(["--shots", str(args.shots)])
    with (output / f"{path.stem}.{mode}.log").open("w") as log:
        process = subprocess.Popen(  # noqa: S603 - Local script via sys.executable.
            command, stdout=log, stderr=log, start_new_session=True
        )
        try:
            process.wait(timeout=args.timeout)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
            timed_out = True
        else:
            timed_out = False
    result_path = output / f"{path.stem}.{mode}.json"
    result = (
        json.loads(result_path.read_text())
        if result_path.exists()
        else {"file": path.name}
    )
    if timed_out:
        stage = result.pop("running", mode)
        result[stage] = "timeout"
        result["error"] = f"{stage} exceeded {args.timeout:g} seconds"
    elif process.returncode != 0:
        stage = result.pop("running", mode)
        result[stage] = "fail"
        result["error"] = (output / f"{path.stem}.{mode}.log").read_text()
    result_path.write_text(json.dumps(result, indent=2, default=json_value) + "\n")
    return result


def package_version(name: str) -> str | None:
    try:
        return importlib.metadata.version(name)
    except importlib.metadata.PackageNotFoundError:
        return None


def check_succeeded(result: dict, mode: str) -> bool:
    stage = "preprocess" if result.get("classical_only") else mode
    return result.get(stage) == "pass"


def stage_summary(result: dict) -> str:
    stages = ", ".join(
        f"{key}={result[key]}"
        for key in ("import", "preprocess", "check", "compile", "qir", "emulate")
        if key in result
    )
    if "simulation" in result:
        simulation = result["simulation"]
        stage = "preprocess" if simulation.get("classical_only") else "emulate"
        stages += f", {stage}={simulation.get(stage, simulation.get('import'))}"
    return stages


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--suite",
        choices=SUITES,
        action="append",
        help="Example suite; repeat to combine suites (default: both)",
    )
    parser.add_argument(
        "--pattern", action="append", help="Example glob; repeat to combine selections"
    )
    parser.add_argument(
        "--emulate", action="store_true", help="Also run Guppy's local emulator"
    )
    parser.add_argument(
        "--emulate-only",
        action="store_true",
        help="Run only the local simulation checks",
    )
    parser.add_argument(
        "--shots",
        type=int,
        help="Shots per simulation; defaults to each example's budget or 256",
    )
    parser.add_argument(
        "--timeout", type=float, default=90, help="Seconds per example per mode"
    )
    parser.add_argument("--worker", type=Path, help=argparse.SUPPRESS)
    parser.add_argument(
        "--mode", choices=["compile", "emulate"], help=argparse.SUPPRESS
    )
    args = parser.parse_args()
    if sys.flags.optimize:
        parser.error("Run without -O/PYTHONOPTIMIZE so the outcome checks are enabled")
    if (args.shots is not None and args.shots < 1) or args.timeout <= 0:
        parser.error("--shots and --timeout must be positive")
    output = (
        args.output or Path(tempfile.mkdtemp(prefix="capability-checks-"))
    ).resolve()
    output.mkdir(parents=True, exist_ok=True)
    if args.worker:
        worker(args.worker, output, args.mode, args.shots)
        return 0
    suites = args.suite or list(SUITES)
    paths = discover_examples(suites, args.pattern or ["*.py"])
    if not paths:
        parser.error("--pattern matched no examples")
    versions = {
        name: package_version(name)
        for name in ("guppyalgos", "guppylang", "hugr-qir", "selene-sim", "numpy")
    }
    summary = {
        "python": sys.version,
        "versions": versions,
        "suites": suites,
        "examples": [],
    }
    print(f"Evidence: {output}", flush=True)
    failed = False
    for path in paths:
        if args.emulate_only:
            result = run_worker(path, output, "emulate", args)
        else:
            result = run_worker(path, output, "compile", args)
        if args.emulate and not args.emulate_only:
            simulation = run_worker(path, output, "emulate", args)
            result["simulation"] = simulation
        summary["examples"].append(result)
        (output / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
        print(f"{path.parent.name}/{path.name}: {stage_summary(result)}", flush=True)
        success = check_succeeded(result, "emulate" if args.emulate_only else "qir")
        if args.emulate and not args.emulate_only:
            success = success and check_succeeded(simulation, "emulate")
        failed |= not success
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
