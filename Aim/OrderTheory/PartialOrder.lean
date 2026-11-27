/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Partial Orders

A partial order bundles a non-strict comparison with reflexivity, transitivity,
and antisymmetry. It requires neither totality, strict comparison, decidability,
nor existence of bounds. Named lemmas use only the individual laws they need.
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

/-- A reflexive, transitive, antisymmetric non-strict order. -/
class PartialOrder (X : Type u)
    extends LE X, IsLERefl X, IsLETrans X, IsLEAntisymm X

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

end Aim
