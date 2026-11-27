/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.TotalOrder

/-!
# Betweenness

Inclusive and strict betweenness, with their basic order consequences.
-/

namespace Aim

universe u

-- Betweenness
--
-- In both definitions the middle element is the middle argument, so that
-- `Between a c b` reads left to right as `a ≤ c ≤ b`.
--
-- These are the closed and open intervals in another form: the closed
-- interval from `a` to `b` is the set of `c` with `Between a c b`, and the
-- open interval is the set of `c` with `StrictlyBetween a c b`.

/-- `c` is between `a` and `b`, endpoints allowed.

  Between a c b  :⟺  a ≤ c ∧ c ≤ b -/
def Between {X : Type u} [LE X]
  (a c b : X) : Prop :=
  a ≤ c ∧ c ≤ b

/-- `c` is strictly between `a` and `b`.

  StrictlyBetween a c b  :⟺  a < c ∧ c < b -/
def StrictlyBetween {X : Type u} [LT X]
  (a c b : X) : Prop :=
  a < c ∧ c < b

/-- An element strictly between `a` and `b` is between `a` and `b`.

  ∀ a b c : X,  StrictlyBetween a c b → Between a c b -/
lemma StrictlyBetween.between {X : Type u} [TotalOrder X]
  {a b c : X} (h : StrictlyBetween a c b) : Between a c b := by
  sorry

/-- If some element is between `a` and `b`, then `a` is at most `b`.

  ∀ a b c : X,  Between a c b → a ≤ b -/
lemma Between.le {X : Type u} [TotalOrder X]
  {a b c : X} (h : Between a c b) : a ≤ b := by
  sorry

/-- If some element is strictly between `a` and `b`, then `a` is less than
`b`.

  ∀ a b c : X,  StrictlyBetween a c b → a < b -/
lemma StrictlyBetween.lt {X : Type u} [TotalOrder X]
  {a b c : X} (h : StrictlyBetween a c b) : a < b := by
  sorry

end Aim
