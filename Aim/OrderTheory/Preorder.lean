/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.OrderRelations

/-!
# Preorders

A preorder bundles a non-strict comparison with reflexivity and transitivity.
Distinct elements may be below each other; antisymmetry belongs to PartialOrder.
Strict comparison is the asymmetric part: `a < b` means `a ≤ b` and not `b ≤ a`.
In particular, it is not generally equivalent to `a ≤ b` and `a ≠ b`.
-/

namespace Aim

universe u

/-- A reflexive and transitive comparison with its linked strict comparison. -/
class Preorder (X : Type u)
    extends LE X, LT X, IsLERefl X, IsLETrans X, IsLTIffLENotLE X

-- Strict and mixed comparisons

/-- No element is strictly less than itself. -/
lemma lt_irrefl {F : Type u} [Preorder F] (a : F) : ¬ a < a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  intro h
  exact h.2 h.1

/-- A strict inequality implies the corresponding non-strict inequality. -/
lemma le_of_lt {F : Type u} [Preorder F] {a b : F} (h : a < b) : a ≤ b := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le] at h
  exact h.1

/-- Strict inequality implies that the elements are unequal. -/
lemma ne_of_lt {F : Type u} [Preorder F] {a b : F} (h : a < b) : a ≠ b := by
  intro hne
  rw [hne] at h
  exact (lt_irrefl b) h

/-- A strict inequality rules out the reverse non-strict inequality. -/
lemma not_le_of_lt {F : Type u} [Preorder F] {a b : F} (h : a < b) : ¬ b ≤ a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le] at h
  exact h.2

/-- A non-strict inequality rules out the reverse strict inequality. -/
lemma not_lt_of_le {F : Type u} [Preorder F] {a b : F} (h : a ≤ b) : ¬ b < a := by
  rw [IsLTIffLENotLE.lt_iff_le_not_le]
  intro hneg
  have h1 := hneg.1
  have h2 : ¬(a <= b) := hneg.2
  exact h2 h

/-- Strict order is asymmetric. -/
lemma lt_asymm {F : Type u} [Preorder F] {a b : F} (h : a < b) : ¬ b < a := by
  intro hba
  have h1 : ¬ b ≤ a := not_le_of_lt h
  have h2 : b ≤ a   := le_of_lt hba
  exact h1 h2

/-- Strict order is transitive. -/
proposition lt_trans {F : Type u} [Preorder F] {a b c : F}
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
lemma lt_of_lt_of_le {F : Type u} [Preorder F] {a b c : F}
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
lemma lt_of_le_of_lt {F : Type u} [Preorder F] {a b c : F}
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

-- 1. Relation Refinement (Two preorders on the same carrier type `P`)
/-- `B` dominates/refines `A` as a preorder relation on `P`: every comparison in `A` holds in `B`. -/
def PreorderDominates {P : Type u} (A B : Preorder P) : Prop :=
  ∀ x y : P, A.le x y → B.le x y

/-- Compatibility name with the same comparison direction as PreorderDominates. -/
def PreorderMinorizes {P : Type u} (A B : Preorder P) : Prop :=
  ∀ x y : P, A.le x y → B.le x y

end Aim
