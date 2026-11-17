# Project Instructions

## Mathematical scope

This repository formalizes undergraduate pure mathematics from first principles in
Lean 4. The project owns its mathematical definitions, algebraic hierarchy,
number-system constructions, and foundational theorem library.

- Do not use Mathlib as the source of definitions, structures, instances, tactics,
  or proofs.
- Mathlib may be used only in explicitly isolated comparison or isomorphism modules
  whose purpose is to validate that a project-owned construction agrees with the
  corresponding standard construction. Do not let those imports leak into the core
  development.
- Build the project-owned algebraic hierarchy explicitly, including magma,
  semigroup, monoid, group, abelian group, semiring, ring, commutative ring,
  integral domain, field, ordered structures, and complete ordered fields.
- Develop analysis first over the appropriate abstract axiomatic interfaces. Later
  constructions of the real numbers (including Dedekind cuts, Cauchy sequences, and
  nested intervals) should instantiate those interfaces and be related by proved
  isomorphisms.
- Prefer small named axioms and derived lemmas with clear dependency order. Preserve
  proof holes for the learner unless the user explicitly asks for a proof.

