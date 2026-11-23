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
-- Throughout, `F` is an ordered field, `S` is a set of elements of `F`, and
-- `a`, `ε` are elements of `F`.

/-
`exists_mem_gt_sub_of_isLeastUpperBound`  (approximation property)

Elements of a set come arbitrarily close to its least upper bound: if `a`
is the least upper bound of `S`, then for every positive `ε` some element
of `S` is greater than `a - ε`.

  ∀ S : Set F, ∀ a : F, IsLeastUpperBound S a →
    ∀ ε : F, 0 < ε → ∃ x : F, x ∈ S ∧ a - ε < x
-/

/-
`isLeastUpperBound_iff_forall_pos`  (ε-characterization of the supremum)

`a` is the least upper bound of `S` if and only if `a` is an upper bound of
`S` and, for every positive `ε`, some element of `S` is greater than
`a - ε`.

  ∀ S : Set F, ∀ a : F,
    IsLeastUpperBound S a ↔
      IsUpperBound S a ∧ ∀ ε : F, 0 < ε → ∃ x : F, x ∈ S ∧ a - ε < x
-/

end Aim
