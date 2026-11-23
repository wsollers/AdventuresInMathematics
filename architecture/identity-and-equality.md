# Identity and Equality

`Identity` has one requirement: Tarski's Leibniz law. Reflexivity, symmetry,
transitivity, replacement, and Euclid's common notion are derived theorems,
not fields copied from a general relation interface.

The package also owns the pre-relational notions of difference and the
numerical quantifiers at least one, at most one, exactly one, and at least two.
The latter are parameterized by an identity relation rather than silently
using Lean's kernel equality.

The project includes inductive, Leibniz, and Lean-kernel constructions. Each
construction owns a `Satisfies` certificate, while agreement with Lean and
Mathlib identity is checked by the separate validation package. Object-language
equality remains in the logic layer.

The initial source boundary is Tarski, *Introduction to Logic*, Chapter III,
§§16–17 and §20. General equivalence relations are deliberately deferred to the
future relations package.
