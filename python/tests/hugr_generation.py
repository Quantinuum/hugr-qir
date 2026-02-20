import hashlib
import importlib.util
import json
import sys
from dataclasses import dataclass
from pathlib import Path

import guppylang
import hugr
from mypy.moduleinspect import ModuleType


def load_py_module_from_path(module_name: str, file_path: str) -> ModuleType:
    # 1. Create a module spec from the file location
    spec = importlib.util.spec_from_file_location(module_name, file_path)
    msg = "Bad file path"
    if not spec:
        raise (ValueError(msg))

    # 2. Create a new module based on that spec
    module = importlib.util.module_from_spec(spec)
    # 3. Optional: Add it to sys.modules so it behaves like a normal import
    sys.modules[module_name] = module
    # 4. Execute the module to make its functions available
    loader = spec.loader
    if loader:
        loader.exec_module(module)
    return module


GUPPY_EXAMPLE_HASHES = (
    Path(__file__).parent / "resources/guppy_example_hugrs/hashes.json"
)
THIS_FILE = Path(__file__)


def guppy_to_hugr_binary(guppy_file: Path) -> bytes:
    guppy_example = load_py_module_from_path("guppy_example_mod", str(guppy_file))
    hugr_package = guppy_example.main.compile()
    return hugr_package.to_bytes()


def get_file_hash(path: Path) -> str:
    return hashlib.sha256(path.open("rb").read()).hexdigest()


def get_file_hashes() -> dict[str, str]:
    if GUPPY_EXAMPLE_HASHES.exists():
        with GUPPY_EXAMPLE_HASHES.open("r") as f:
            return json.load(f)
    return {}


def dump_file_hashes(hashes: dict[str, str]) -> None:
    sorted_hashes = dict(sorted(hashes.items()))
    with GUPPY_EXAMPLE_HASHES.open("w") as f:
        json.dump(sorted_hashes, f, indent=2)
        f.write("\n")  # add newline so it doesn't get changed by pre-commit


def get_guppylang_hugr_version_str() -> str:
    return f"guppy-v{guppylang.__version__} hugr-v{hugr.__version__}"


@dataclass
class GuppyExample:
    guppy_filepath: Path
    hugr_filepath: Path
    hugr_binary: bytes


def generate_guppy_example_dict(guppy_files: list[Path]) -> dict[str, GuppyExample]:
    """Generate a dictionary pointing from guppy example file
    stem to a GuppyExample object

    Only regenerate hugr from guppy files if necessary. Otherwise,
    load from `resources/guppy_example_hugrs` directory.

    This is only necessary if:
      - The hash file doesn't exist
      - The guppylang or hugr versions in the hashfile are different
        from the current ones
      - The hash of the guppy example file has changed

    :param guppy_files: list of paths to the guppy example files
    :return: Dictionary of guppy file stems to GuppyExample objects
    """
    example_dict: dict[str, GuppyExample] = {}
    hashes = get_file_hashes()
    versions = hashes.get("guppylang_hugr_version", "")
    this_file_hash_old = hashes.get("hugr_generation_module", "")
    current_versions = get_guppylang_hugr_version_str()
    this_file_hash = get_file_hash(THIS_FILE)
    if versions != current_versions or this_file_hash != this_file_hash_old:
        # if guppylang and/or hugr versions don't match
        # or this file changed regenerate everything
        hashes = {}
    new_hashes = {
        "guppylang_hugr_version": current_versions,
        "hugr_generation_module": this_file_hash,
    }
    for guppy_file in guppy_files:
        file_stem = guppy_file.stem
        hugr_file_path = (
            Path(__file__).parent / f"resources/guppy_example_hugrs/{file_stem}.hugr"
        )
        saved_hash = hashes.get(file_stem, "")
        new_hash = get_file_hash(guppy_file)
        if new_hash == saved_hash:
            example_dict[file_stem] = GuppyExample(
                guppy_file, hugr_file_path, hugr_file_path.open("rb").read()
            )
        else:
            print(f"Regenerating hugr file for {guppy_file.name}")
            hugr_bin = guppy_to_hugr_binary(guppy_file)
            with hugr_file_path.open("wb") as f:
                f.write(hugr_bin)
            example_dict[file_stem] = GuppyExample(guppy_file, hugr_file_path, hugr_bin)
        new_hashes[file_stem] = new_hash

    dump_file_hashes(new_hashes)
    return example_dict
