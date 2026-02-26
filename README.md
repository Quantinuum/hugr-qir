# hugr-qir

[![build_status][]](https://github.com/Quantinuum/hugr-qir/actions)
[![codecov][]](https://codecov.io/gh/Quantinuum/hugr-qir)

A tool for converting Hierarchical Unified Graph Representation (HUGR, pronounced _hugger_) formatted quantum programs into [QIR](https://github.com/qir-alliance/qir-spec) format.

> [!NOTE]
> Not all Guppy/HUGR programs can be converted to QIR.

## Installation

You can install from pypi via `pip install hugr-qir`.

## Usage

### Python

Use the function `hugr_to_qir` from the `hugr_to_qir` module to convert hugr to qir. By default, some basic validity checks will be run on the generated QIR. These checks can be turned off by passing `validate_qir = False`.

You can find an example notebook at `examples/submit-guppy-h2-via-qir.ipynb` showing the conversion and the submission to Quantinuum System Model H2.

### CLI

You can use the available CLI after installing the python package.

This will generate qir for a given hugr file:

```sh
hugr-qir test-file.hugr
```

Run `hugr-qir --help` to see the available options.

If you want to generate a hugr file from guppy, you can do this in two steps:

1. Add this to the end of your guppy file:

    ```py
    if __name__ == "__main__":
        sys.stdout.buffer.write(main.compile().to_bytes())
        # Or to compile a non-main guppy function:
        sys.stdout.buffer.write(guppy_func.compile_function().to_bytes())
    ```

1. Generate the hugr file with:

    ```sh
    python guppy_examples/general/quantum-classical-1.py > test-guppy.hugr
    ```

## Guppy language support

✅ = full support, *️⃣ = partial support, ❌ = unsupported

### Overview Data Types



| Data Types | Support | Caveats                                             |
|------------|---------|-----------------------------------------------------|
| struct     |  ✅     | Cannot contain arrays                               |
| int        |  ✅     |                                                     |
| bool       |  ✅     |                                                     |
| nat        |  ✅     |                                                     |
| float      |  *️⃣     | Must be runtime constant, arithmetic comptime only  |
| array      |  *️⃣     | Comptime only                                       |
| tuple      |  *️⃣     | Unpacking with * returns array, so only at comptime |



#### Arrays
- Only supported within comptime guppy
- Cannot use guppy builtins that use runtime arrays internally
- Cannot be used within structs
- Cannot be used as parameter to either `@guppy` or `@guppy.comtime` decorated functions

Array examples:
```py
def py_function(arr: array[qubit]) -> None: # ✅ no need to fully qualify array type, will be treated as python list
   """This python function can be called from @guppy.comptime, but not @guppy
      Can do anything here that is allowed within @guppy.comptime
   """
    for q in arr:
       h(q)

@guppy.comptime
def guppy_comptime_function(arr: array[qubit, 4]) -> None: # ❌ no support for passing in arrays (even to guppy.comptime functions)
   for q in arr:
      h(q)

@guppy
def guppy_function(arr: array[qubit, 4]) -> None: # ❌ no support for passing in arrays
   for q in arr:
      h(q)

@guppy.comptime
def main() -> None:
    comptime_array = array(qubit() for _ in range(4)) # ✅: array initialization at comptime
    py_function(comptime_array)             # ✅: can call python function from comptime and pass in comptime array
    guppy_comptime_function(comptime_array) # ❌: parameters to guppy comptime functions are NOT comptime
    guppy_function(comptime_array)          # ❌: parameters to guppy functions are NOT comptime

@guppy
def main_noncomptime() -> None:
   array = array(qubit() for _ in range(4)) # ❌: non-comptime array initialization
```


#### Tuples
- Unpacking with * only supported at comptime (creates array)

#### Structs
- Cannot contain arrays

### Overview Guppy Features
| Features                            | Support | Remarks                                                  |
|-------------------------------------|---------|----------------------------------------------------------|
| if elif else constructs             | ✅       |                                                          |
| function overloading                | ✅       |                                                          |
| Generics (type_var/nat_var)         | ✅       | nat_vars not really useful without runtime array support |
| First class/ Higher order functions | ✅       |                                                          |
| Recursive functions/loops           | *️⃣       | Only if unrollable/serializable                          |
| measure_array/discard_array         | ❌       | Use non-comptime arrays internally                       |




## Development

### #️⃣ Setting up the development environment

The easiest way to set up the development environment is to use the provided
[`devenv.nix`](devenv.nix) file. This will set up a development shell with all the
required dependencies.

To use this, you will need to install [devenv](https://devenv.sh/getting-started/).
Once you have it running, open a shell with:

```bash
devenv shell
```

All the required dependencies should be available. You can automate loading the
shell by setting up [direnv](https://devenv.sh/automatic-shell-activation/).

### Run tests

You can run the rust test with:

```bash
cargo test
```

You can run the Python test with:

```bash
pytest -n auto
```

If you want to update the snapshots you can do that via:

```bash
pytest --snapshot-update
```

## License

This project is licensed under Apache License, Version 2.0 ([LICENSE][] or <http://www.apache.org/licenses/LICENSE-2.0>).

[build_status]: https://github.com/Quantinuum/hugr-qir/actions/workflows/ci-py.yml/badge.svg?branch=main
[codecov]: https://img.shields.io/codecov/c/gh/Quantinuum/hugr-qir?logo=codecov
[LICENSE]: https://github.com/Quantinuum/hugr-qir/blob/main/LICENCE
