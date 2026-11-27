/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.Preorder

/-!
# Partial Orders

A partial order extends a preorder with antisymmetry. Strict comparison is
inherited from Preorder. It requires neither totality, decidability, nor
existence of bounds. Named lemmas use only the individual laws they need.
-/

namespace Aim

universe u

/-- A reflexive, transitive, antisymmetric non-strict order. -/
class PartialOrder (X : Type u)
    extends Preorder X, IsLEAntisymm X

/-- Equality is equivalent to non-strict comparison in both directions. -/
lemma le_antisymm_iff {F : Type u} [LE F] [IsLERefl F] [IsLEAntisymm F] (a b : F) :
    a = b ↔ a ≤ b ∧ b ≤ a := by
  constructor
  . -- ->
    intro he
    rw [he]
    constructor
    . exact le_refl b
    . exact le_refl b
  . -- <-
    intro h
    exact le_antisymm h.1 h.2

-- Strict comparison and inequality of elements

/-- A non-strict inequality between unequal elements is strict. -/
lemma lt_of_le_of_ne {F : Type u} [PartialOrder F] (a b : F) :
  a ≤ b → a ≠ b → a < b := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  intro hlte
  intro hne
  constructor
  . --
    exact hlte
  . --
    intro htemp
    have he := le_antisymm hlte htemp
    exact hne he

/-- Non-strict order is strict order or equality. -/
lemma le_iff_lt_or_eq {F : Type u} [PartialOrder F] (a b : F) :
    a ≤ b ↔ a < b ∨ a = b := by
  classical
  constructor
  · intro h
    by_cases heq : a = b
    · right
      exact heq
    · left
      exact lt_of_le_of_ne a b h heq
  · intro h
    cases h with
    | inl hlt =>
      exact le_of_lt hlt
    | inr heq =>
      rw [heq]
      exact le_refl b

/-- A non-strict inequality is either strict or equality. -/
corollary lt_or_eq_of_le {F : Type u} [PartialOrder F] {a b : F}
    (h : a ≤ b) : a < b ∨ a = b := by
  exact (le_iff_lt_or_eq a b).mp h

/-- Strict order is non-strict order between unequal elements. -/
lemma lt_iff_le_and_ne {F : Type u} [PartialOrder F] (a b : F) :
    a < b ↔ a ≤ b ∧ a ≠ b := by
  constructor
  . --
    intro h
    constructor
    . exact le_of_lt h
    . exact ne_of_lt h
  . --
    intro h
    exact lt_of_le_of_ne a b h.1 h.2

end Aim
