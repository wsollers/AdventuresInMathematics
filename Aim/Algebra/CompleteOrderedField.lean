/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Algebra.OrderedField
import Aim.OrderTheory.Completeness

/-!
# Complete Ordered Fields

The axiomatic interface for the real numbers.
-/

namespace Aim

universe u

/-- A complete ordered field. -/
class CompleteOrderedField (F : Type u)
    extends OrderedField F, IsOrderComplete F

-- ## Statements to translate and prove
--
-- Throughout, `F` is an ordered field, `s` is a set of elements of `F`, and
-- `a`, `ε` are elements of `F`.

/-
`exists_mem_gt_sub_of_isLeastUpperBound`  (approximation property)

Elements of a set come arbitrarily close to its least upper bound: if `a`
is the least upper bound of `s`, then for every positive `ε` some element
of `s` is greater than `a - ε`.

  ∀ s : Set F, ∀ a : F, IsLeastUpperBound s a →
    ∀ ε : F, 0 < ε → ∃ x : F, x ∈ s ∧ a - ε < x
-/

/-
`isLeastUpperBound_iff_forall_pos`  (ε-characterization of the supremum)

`a` is the least upper bound of `s` if and only if `a` is an upper bound of
`s` and, for every positive `ε`, some element of `s` is greater than
`a - ε`.

  ∀ s : Set F, ∀ a : F,
    IsLeastUpperBound s a ↔
      IsUpperBound s a ∧ ∀ ε : F, 0 < ε → ∃ x : F, x ∈ s ∧ a - ε < x
-/

end Aim
