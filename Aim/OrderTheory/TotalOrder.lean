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

-- 2. Total-order axioms and consequences

/-- Totality of the non-strict order. -/
class IsLETotal (X : Type u) [LE X] : Prop where
  le_total : ∀ a b : X, a ≤ b ∨ b ≤ a

/-- Strict order is the asymmetric part of non-strict order. -/
class IsLTIffLENotLE (X : Type u) [LE X] [LT X] : Prop where
  lt_iff_le_not_le : ∀ a b : X, a < b ↔ a ≤ b ∧ ¬b ≤ a

/-- A total order, with strict comparison linked to non-strict comparison.

The four non-strict order laws are the mathematical contract. The `LT` parent
and its linking law expose the equivalent strict comparison. Decidability
is supplied separately by `LEDecidable`. -/
class TotalOrder (X : Type u)
    extends PartialOrder X, LT X, IsLETotal X,
      IsLTIffLENotLE X

/-- The order `≤` is decidable. Data, not a `Prop`: it is what `if` branches on. -/
class LEDecidable (X : Type u) [LE X] where
  decLE : ∀ a b : X, Decidable (a ≤ b)

instance {X : Type u} [LE X] [LEDecidable X] (a b : X) : Decidable (a ≤ b) :=
  LEDecidable.decLE a b

-- 2a. Named forms of the non-strict order axioms

/-- Every pair of elements is comparable. -/
lemma le_total {F : Type u} [TotalOrder F] (a b : F) : a ≤ b ∨ b ≤ a := by
  exact IsLETotal.le_total a b

-- 2b. Strict and non-strict comparisons

/-- No element is strictly less than itself. -/
lemma lt_irrefl {F : Type u} [TotalOrder F] (a : F) : ¬ a < a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  intro h
  exact h.2 h.1


/-- A strict inequality implies the corresponding non-strict inequality. -/
lemma le_of_lt {F : Type u} [TotalOrder F] {a b : F} (h : a < b) : a ≤ b := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le] at h
  exact h.1

/-- Strict inequality implies that the elements are unequal. -/
lemma ne_of_lt {F : Type u} [TotalOrder F] {a b : F} (h : a < b) : a ≠ b := by
  intro hne
  rw [hne] at h
  exact (lt_irrefl b) h

/-- A strict inequality rules out the reverse non-strict inequality. -/
lemma not_le_of_lt {F : Type u} [TotalOrder F] {a b : F} (h : a < b) : ¬ b ≤ a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le] at h
  exact h.2

/-- A non-strict inequality rules out the reverse strict inequality. -/
lemma not_lt_of_le {F : Type u} [TotalOrder F] {a b : F} (h : a ≤ b) : ¬ b < a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  intro hneg
  have h1 := hneg.1
  have h2 : ¬(a <= b) := hneg.2
  exact h2 h

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

/-- Strict order is asymmetric. -/
lemma lt_asymm {F : Type u} [TotalOrder F] {a b : F} (h : a < b) : ¬ b < a := by
  intro hba
  have h1 : ¬ b ≤ a := not_le_of_lt h
  have h2 : b ≤ a   := le_of_lt hba
  exact h1 h2

/-- Strict order is transitive. -/
proposition lt_trans {F : Type u} [TotalOrder F] {a b c : F}
  (hab : a < b) (hbc : b < c) : a < c := by
  have h1 := le_of_lt hab
  have h2 := le_of_lt hbc
  have h3 : a ≤ c := IsLETrans.le_trans a b c h1 h2
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  constructor
  . -- ->
    exact h3
  . -- <-
    rw [IsLTIffLENotLE.lt_iff_le_not_le] at hab
    rw [IsLTIffLENotLE.lt_iff_le_not_le] at hbc
    intro hca
    have hba : b ≤ a := IsLETrans.le_trans b c a h2 hca
    exact hab.2 hba

/-- A strict inequality followed by a non-strict one remains strict. -/
lemma lt_of_lt_of_le {F : Type u} [TotalOrder F] {a b c : F}
    (hab : a < b) (hbc : b ≤ c) : a < c := by
  have h1 := le_of_lt hab
  have h3 : a ≤ c := IsLETrans.le_trans a b c h1 hbc
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  constructor
  . -- ->
    exact h3
  . -- <-
    intro h
    have hba : b ≤ a := IsLETrans.le_trans b c a hbc h
    rw [IsLTIffLENotLE.lt_iff_le_not_le] at hab
    exact hab.2 hba

/-- A non-strict inequality followed by a strict one remains strict. -/
lemma lt_of_le_of_lt {F : Type u} [TotalOrder F] {a b c : F}
    (hab : a ≤ b) (hbc : b < c) : a < c := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  constructor
  . -- ->
    have hx := le_of_lt hbc
    have hac : a ≤ c := IsLETrans.le_trans a b c hab hx
    exact hac
  . -- <-
    intro h
    have hcb : c ≤ b := IsLETrans.le_trans c a b h hab
    rw [IsLTIffLENotLE.lt_iff_le_not_le] at hbc
    exact hbc.2 hcb

/-- A non-strict inequality between unequal elements is strict. -/
lemma lt_of_le_of_ne {F : Type u} [TotalOrder F] (a b : F) :
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
lemma le_iff_lt_or_eq {F : Type u} [TotalOrder F] (a b : F) :
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
corollary lt_or_eq_of_le {F : Type u} [TotalOrder F] {a b : F}
    (h : a ≤ b) : a < b ∨ a = b := by
  exact (le_iff_lt_or_eq a b).mp h

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

/-- Strict order is non-strict order between unequal elements. -/
lemma lt_iff_le_and_ne {F : Type u} [TotalOrder F] (a b : F) :
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
