/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Order Relations

Individual laws for non-strict and strict comparisons, independent of any
preorder, partial-order, or total-order bundle. Decidability is an optional
computational capability. The named wrappers require only their own law.
-/

namespace Aim

universe u

/-- Reflexivity of the non-strict order. -/
class IsLERefl (X : Type u) [LE X] : Prop where
  le_refl : ∀ a : X, a ≤ a

/-- Transitivity of the non-strict order. -/
class IsLETrans (X : Type u) [LE X] : Prop where
  le_trans : ∀ a b c : X, a ≤ b → b ≤ c → a ≤ c

/-- Antisymmetry of the non-strict order. -/
class IsLEAntisymm (X : Type u) [LE X] : Prop where
  le_antisymm : ∀ a b : X, a ≤ b → b ≤ a → a = b

/-- Totality of the non-strict order. -/
class IsLETotal (X : Type u) [LE X] : Prop where
  le_total : ∀ a b : X, a ≤ b ∨ b ≤ a

/-- Strict order is the asymmetric part of non-strict order. -/
class IsLTIffLENotLE (X : Type u) [LE X] [LT X] : Prop where
  lt_iff_le_not_le : ∀ a b : X, a < b ↔ a ≤ b ∧ ¬b ≤ a

/-- The order `≤` is decidable. Data, not a `Prop`: it is what `if` branches on. -/
class LEDecidable (X : Type u) [LE X] where
  decLE : ∀ a b : X, Decidable (a ≤ b)

instance {X : Type u} [LE X] [LEDecidable X] (a b : X) : Decidable (a ≤ b) :=
  LEDecidable.decLE a b

-- Named forms of the individual laws

/-- Every element is less than or equal to itself. -/
lemma le_refl {F : Type u} [LE F] [IsLERefl F] (a : F) : a ≤ a := by
  exact IsLERefl.le_refl a

/-- Non-strict order is transitive. -/
lemma le_trans {F : Type u} [LE F] [IsLETrans F] {a b c : F}
    (hab : a ≤ b) (hbc : b ≤ c) : a ≤ c := by
  exact IsLETrans.le_trans a b c  hab hbc

/-- Two elements below each other are equal. -/
lemma le_antisymm {F : Type u} [LE F] [IsLEAntisymm F] {a b : F}
    (hab : a ≤ b) (hba : b ≤ a) : a = b := by
  exact IsLEAntisymm.le_antisymm a b hab hba

/-- Every pair of elements is comparable. -/
lemma le_total {F : Type u} [LE F] [IsLETotal F] (a b : F) : a ≤ b ∨ b ≤ a := by
  exact IsLETotal.le_total a b

end Aim
