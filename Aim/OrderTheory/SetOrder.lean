import Aim.OrderTheory.PartialOrder
import Aim.OrderTheory.Bounds
import Aim.SetTheory.Interface.Relations

/-!
# Ordered Comparisons of Sets

The carrier supplies the order. These predicates do not install a global order
on sets: containment, separation, and Egli–Milner comparison are distinct.
Universal separation permits empty sets; transitivity needs a nonempty middle set.
-/

namespace Aim

universe u

/-- Every element of `A` is at most every element of `B`. -/
def SetBelow {P : Type u} [LE P] (A B : Set P) : Prop :=
  ∀ a ∈ A, ∀ b ∈ B, a ≤ b

/-- Every element of `A` is strictly below every element of `B`. -/
def SetStrictlyBelow {P : Type u} [LT P] (A B : Set P) : Prop :=
  ∀ a ∈ A, ∀ b ∈ B, a < b

/-- Every element of `A` has some element above it in `B`. -/
def CofinalDominates {P : Type u} [LE P] (A B : Set P) : Prop :=
  ∀ a ∈ A, ∃ b ∈ B, a ≤ b

/-- Every element of `B` has some element below it in `A`; no containment is assumed. -/
def CoinitialMinorizes {P : Type u} [LE P] (A B : Set P) : Prop :=
  ∀ b ∈ B, ∃ a ∈ A, a ≤ b

/-- Both directions of witness coverage, with comparisons always from `A` to `B`. -/
def EgliMilner {P : Type u} [LE P] (A B : Set P) : Prop :=
  (∀ a ∈ A, ∃ b ∈ B, a ≤ b) ∧ (∀ b ∈ B, ∃ a ∈ A, a ≤ b)

local infix:50 " ⊑ " => EgliMilner

/-- The defining equivalence from Schröder Proposition 1.3, restricted to a family. -/
proposition ElgiMilner_iff (P : Type u) [Preorder P]
  {A B : Set P} (J : Set (Set P)) (hA : A ∈ J) (hB : B ∈ J) :
  A ⊑ B ↔
  ((∀ a ∈ A, ∃ b ∈ B, a ≤ b) ∧ (∀ b ∈ B, ∃ a ∈ A, b ≥ a)) := by
  unfold EgliMilner
  rfl

/-- Compatibility name: every element of `B` is an upper bound of `A`.
Despite the historical name, this uses non-strict comparison. -/
def StrictlyDominates {P : Type u} [LE P] (A B : Set P) : Prop :=
  ∀ b : P, b ∈ B → IsUpperBound A b

/-- Compatibility name: every element of `A` is a lower bound of `B`.
Despite the historical name, this uses non-strict comparison. -/
def StrictlyMinorizes {P : Type u} [LE P] (A B : Set P) : Prop :=
  ∀ a : P, a ∈ A → IsLowerBound B a

/-- Set separation is equivalently a family of upper bounds. -/
theorem setBelow_iff_upperBounds {P : Type u} [LE P] (A B : Set P) :
    SetBelow A B ↔ B ⊆ upperBounds A := by
  sorry

/-- Set separation is equivalently a family of lower bounds. -/
theorem setBelow_iff_lowerBounds {P : Type u} [LE P] (A B : Set P) :
    SetBelow A B ↔ A ⊆ lowerBounds B := by
  sorry

/-- Strictly separated sets are disjoint. -/
theorem SetStrictlyBelow.disjoint {P : Type u} [Preorder P]
    {A B : Set P} (h : SetStrictlyBelow A B) : Set.Disjoint A B := by
  sorry

/-- Separation composes through a nonempty middle set. -/
theorem SetBelow.trans {P : Type u} [Preorder P] {A B C : Set P}
    (hAB : SetBelow A B) (hBC : SetBelow B C) (hB : B.Nonempty) :
    SetBelow A C := by
  sorry

/-- The Egli–Milner relation is reflexive, including on the empty set. -/
theorem EgliMilner.refl {P : Type u} [Preorder P] (A : Set P) :
    EgliMilner A A := by
  sorry

/-- The Egli–Milner relation is transitive. -/
theorem EgliMilner.trans {P : Type u} [Preorder P] {A B C : Set P}
    (hAB : EgliMilner A B) (hBC : EgliMilner B C) : EgliMilner A C := by
  sorry

/-- A three-element strict chain supplies a counterexample to antisymmetry on sets. -/
theorem exists_egliMilner_not_antisymm {P : Type u} [PartialOrder P]
    {a b c : P} (hab : a < b) (hbc : b < c) :
    ∃ A B : Set P, EgliMilner A B ∧ EgliMilner B A ∧ A ≠ B := by
  sorry

end Aim
