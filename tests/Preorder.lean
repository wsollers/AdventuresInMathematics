import Aim.OrderTheory.Preorder

/-! A preorder must allow distinct elements to be mutually comparable. -/

namespace PreorderTests

inductive Two where
  | left
  | right

instance : Aim.Preorder Two where
  le := fun _ _ => True
  lt := fun _ _ => False
  le_refl := fun _ => True.intro
  le_trans := fun _ _ _ _ _ => True.intro
  lt_iff_le_not_le := by
    intro a b
    constructor
    · intro h
      exact False.elim h
    · intro h
      exact h.2 True.intro

example : Two.left ≤ Two.right ∧ Two.right ≤ Two.left := by
  exact ⟨True.intro, True.intro⟩

example : Two.left ≠ Two.right := by
  intro h
  cases h

-- Distinct elements can be mutually below each other without either being strict.
example : ¬ Two.left < Two.right := by
  exact Aim.not_lt_of_le (show Two.right ≤ Two.left from True.intro)

example {X : Type} [Aim.Preorder X] {a b c : X}
    (hab : a < b) (hbc : b ≤ c) : a < c := by
  exact Aim.lt_of_lt_of_le hab hbc

example {X : Type} [Aim.Preorder X] {a b c : X}
    (hab : a ≤ b) (hbc : b < c) : a < c := by
  exact Aim.lt_of_le_of_lt hab hbc

example (a : Two) : a ≤ a := by
  exact Aim.le_refl a

example (a b c : Two) (hab : a ≤ b) (hbc : b ≤ c) : a ≤ c := by
  exact Aim.le_trans hab hbc

end PreorderTests
