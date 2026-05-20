# Repeat-Until-Success

These examples show two bounded repeat-until-success patterns written in Guppy.

They are useful because they demonstrate retry structures that stay within the subset that `hugr-qir` can lower: the retry budget is finite, the outer structure is known at compile time, and the resulting control flow is static from the backend's point of view.

## Bounded repeat-until-success

This version expands the retry structure at comptime and materializes fresh ancillas per attempt.

Source file: `guppy_examples/repeat-until-success/supported/bounded-rus.py`

```{literalinclude} ../../guppy_examples/repeat-until-success/supported/bounded-rus.py
:language: python
```

Compared to an unbounded retry loop, this version makes the retry count explicit and exposes both the number of attempts and the success flag as results.

## Flat bounded repeat-until-success

This version allocates its ancillas once and reuses them across attempts.

Source file: `guppy_examples/repeat-until-success/supported/rus-flat-bounded.py`

```{literalinclude} ../../guppy_examples/repeat-until-success/supported/rus-flat-bounded.py
:language: python
```

Compared to the first version above, this variant is useful for understanding a lower-qubit implementation of the same retry pattern.
