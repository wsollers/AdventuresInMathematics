# Aim–Mathlib validation

This independent Lake package checks selected correspondences between the
project-owned undergraduate mathematics library and Mathlib. Nothing in `Aim/`
imports this package or Mathlib.

Current smoke tests cover typed sets and the Lean natural-number construction.

Build the core project from the repository root:

```bash
lake build
```

Build the optional validation package separately:

```bash
cd validation/mathlib
lake build
```
