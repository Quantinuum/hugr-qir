import hashlib
import json
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

import guppylang
import hugr

GUPPY_EXAMPLE_HASHES = (
    Path(__file__).parent / "resources/guppy_example_hugrs/hashes.json"
)


def guppy_to_hugr_binary(guppy_file: Path) -> bytes:
    result = subprocess.run(  # noqa: S603
        [sys.executable, guppy_file],
        check=True,
        capture_output=True,
        text=False,
    )
    hugr = result.stdout
    assert isinstance(hugr, bytes)
    return hugr


def get_file_hash(path: Path) -> str:
    return hashlib.sha256(path.open("rb").read()).hexdigest()


def get_file_hashes() -> dict[str, str]:
    if GUPPY_EXAMPLE_HASHES.exists():
        with GUPPY_EXAMPLE_HASHES.open("r") as f:
            return json.load(f)
    return {}


def dump_file_hashes(hashes: dict[str, str]) -> None:
    with GUPPY_EXAMPLE_HASHES.open("w") as f:
        json.dump(hashes, f, indent=2)
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
    current_versions = get_guppylang_hugr_version_str()
    if versions != current_versions:
        # if guppylang and/or hugr versions don't match regenerate everythin
        hashes = {}
    new_hashes = {"guppylang_hugr_version": current_versions}
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
