/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.PartialOrder

/-!
# Total Orders

The four non-strict order laws are the mathematical contract of `TotalOrder`;
the strict comparison is linked to it by one further law. Decidability is a
separate computational requirement, `LEDecidable`, which is what `max` and
`min` branch on.
-/

namespace Aim

universe u

/-- A total order, with strict comparison linked to non-strict comparison.

Totality is added to the inherited partial order. Strict comparison and its
linking law are inherited from Preorder. Decidability is supplied separately
by `LEDecidable`. -/
class TotalOrder (X : Type u)
    extends PartialOrder X, IsLETotal X

-- Consequences of totality

/-- If the reverse strict comparison fails, the forward non-strict comparison holds. -/
lemma le_of_not_gt {F : Type u} [TotalOrder F] {a b : F} (h : ¬ b < a) : a ≤ b := by
  rcases IsLETotal.le_total a b with hab | hba
  . exact hab
  . by_cases hab : a <= b
    . exact hab
    . have hlt : b < a := (IsLTIffLENotLE.lt_iff_le_not_le b a).mpr ⟨hba, hab⟩
      exact False.elim (h hlt)

/-- If the reverse non-strict comparison fails, the forward strict comparison holds. -/
lemma lt_of_not_ge {F : Type u} [TotalOrder F] {a b : F} (h : ¬ b ≤ a) : a < b := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  constructor
  . --
    rcases IsLETotal.le_total a b with hab | hba
    . exact hab
    · have hContra : False := h hba
      cases hContra
  . --
    exact h

/-- Exactly one of `a < b`, `a = b`, and `b < a` can hold. -/
theorem lt_trichotomy {F : Type u} [TotalOrder F] (a b : F) :
    a < b ∨ a = b ∨ b < a := by
  rcases IsLETotal.le_total a b with hab | hba
  · rcases lt_or_eq_of_le hab with hlt | heq
    · exact Or.inl hlt
    · exact Or.inr (Or.inl heq)
  · rcases lt_or_eq_of_le hba with hlt | heq
    · exact Or.inr (Or.inr hlt)
    · exact Or.inr (Or.inl heq.symm)

/-- Failure of a non-strict comparison is the reverse strict comparison. -/
lemma not_le {F : Type u} [TotalOrder F] (a b : F) : ¬ a ≤ b ↔ b < a := by
  constructor
  . --
    intro h
    exact lt_of_not_ge h
  . --
    intro h
    have hlt := le_of_lt h
    exact  not_le_of_lt h

/-- Failure of a strict comparison is the reverse non-strict comparison. -/
lemma not_lt {F : Type u} [TotalOrder F] (a b : F) : ¬ a < b ↔ b ≤ a := by
  constructor
  . --
    intro h
    exact le_of_not_gt h
  . --
    intro h
    have hle := not_lt_of_le h
    exact hle

end Aim
