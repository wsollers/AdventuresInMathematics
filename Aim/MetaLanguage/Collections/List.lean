import Init.Data.List.Basic

/-!
# Metalanguage Lists

Finite ordered sequences with repetitions, using Lean's host list directly.
These are tools for syntax, not a construction of mathematical sequences.
-/

namespace Aim

universe u

/-- A finite sequence in the metalanguage; all host list operations remain available. -/
abbrev MetaList (X : Type u) : Type u :=
  List X

end Aim
