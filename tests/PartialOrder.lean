import Aim.OrderTheory.TotalOrder
import Aim.OrderTheory.Bounds

/-! Check that partial-order reasoning works without totality or decidability. -/

namespace PartialOrderTests

inductive Two where
  | left
  | right

-- Equality is a partial order with incomparable distinct elements.
instance : Aim.PartialOrder Two where
  le := Eq
  le_refl := fun _ => rfl
  le_trans := fun _ _ _ hab hbc => Eq.trans hab hbc
  le_antisymm := fun _ _ hab _ => hab

example : ¬ (Two.left ≤ Two.right ∨ Two.right ≤ Two.left) := by
  intro h
  cases h with
  | inl h => cases h
  | inr h => cases h

example (a b : Two) : a = b ↔ a ≤ b ∧ b ≤ a := by
  exact Aim.le_antisymm_iff a b

example (a b c : Two) (hab : a ≤ b) (hbc : b ≤ c) : a ≤ c := by
  exact Aim.le_trans hab hbc

-- The new parent is available to all existing total-order consumers.
example {X : Type} [Aim.TotalOrder X] : Aim.PartialOrder X := by
  infer_instance

end PartialOrderTests
