# Python CLI

The `hugr-qir` command line tool reads a HUGR package and emits QIR. Run `hugr-qir -h/--help` for more information.

To inspect the HUGR after all HUGR passes, save a binary dump:

```sh
hugr-qir input.hugr --dump-hugr -o output.ll
```

The dump is saved beside the input: `input.hugr` produces
`input.post-passes.hugr`. It includes its extension definitions and is written before LLVM
generation. It remains available if later compilation or QIR validation fails.
An existing dump file is overwritten.

```{eval-rst}
.. click:: hugr_qir.cli:hugr_qir
   :prog: hugr-qir
   :nested: full
```
