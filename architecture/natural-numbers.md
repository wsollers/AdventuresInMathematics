# Natural-Number Interface

The project exposes natural numbers through a construction-independent Peano
interface. Each construction owns a `Satisfies` certificate proving that it
implements zero, successor, successor injectivity, zero-not-successor, and
induction.

Lean's kernel `Nat` is the first construction. Correspondence with Lean and
Mathlib is checked only by the separate `validation/mathlib` package.
