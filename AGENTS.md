# Project Instructions

## Mathematical scope

This repository formalizes undergraduate pure mathematics from first principles in
Lean 4. The project owns its mathematical definitions, algebraic hierarchy,
number-system constructions, and foundational theorem library.

- Do not use Mathlib as the source of definitions, structures, instances, tactics,
  or proofs.
- Exception for tactics: proof-convenience tactics may be copied from Mathlib into
  `Aim/Common/Tactics.lean`, and only there. Each copy must keep its upstream
  attribution and licence, must import only Lean (never Mathlib), and must not
  carry mathematical content. This exception is provisional and under review.
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

## File and namespace conventions

- A file that only re-exports the other files in its folder is named
  `<Folder>Aggregator.lean` (for example `Aim/Algebra/AlgebraAggregator.lean`).
  Aggregators contain imports and a module docstring, no declarations.
- Namespaces do not mirror folders. Mathematics is declared directly in
  `namespace Aim`; a sub-namespace exists only when it is the name of a type
  and holds that type's own operations (for example `Aim.Set.union`).
- A consumer imports the interface files it needs, never the root `Aim`
  module: `Aim` also brings in every construction and its certificate.
- Subtraction and division on a field are the derived operations `a + -b`
  and `a * b⁻¹`. A construction of a number system supplies `+`, `*`, `-x`
  and `x⁻¹` and never its own `Sub` or `Div` instance.
- Variable names: a set is an uppercase letter (`S`, `T`), and so is a
  collection or family of sets (`C`, `D`, `F`, `G`). An element of a set is a
  lowercase letter (`x`, `a`, `b`). This holds in Lean code and in the
  English statements written in comments.
- `Aim/Common/conventions.json` is the single source for notation and
  conventions. After changing it, run `python scripts/build_notation.py` to
  regenerate `Aim/Common/Notation.tex`. Run `python scripts/check_conventions.py`
  before finishing any change to the Lean sources; CI runs both.
