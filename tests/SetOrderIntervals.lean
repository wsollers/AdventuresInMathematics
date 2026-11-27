import Aim.OrderTheory.Intervals

/-! Check the new definitions directly, without depending on learner proof holes. -/

namespace Aim

example {X : Type} [Preorder X] {a b : X} (hab : a ≤ b) :
    a ∈ Set.Icc a b := by
  exact ⟨le_refl a, hab⟩

example {X : Type} [Preorder X] {a b : X} (hab : a ≤ b) :
    Set.Overlaps (Set.Icc a b) (Set.Icc a a) := by
  exact ⟨a, ⟨le_refl a, hab⟩, ⟨le_refl a, le_refl a⟩⟩

-- Universal separation is vacuous when its left set is empty.
example {X : Type} [LE X] (B : Set X) : SetBelow ∅ B := by
  intro a ha
  exact False.elim ha

-- Mutual witness coverage does not relate a nonempty singleton to the empty set.
example {X : Type} [LE X] (a : X) : ¬ EgliMilner {a} ∅ := by
  intro h
  obtain ⟨b, hb, _⟩ := h.1 a rfl
  exact hb

-- Overlap alone does not imply partial overlap.
example {X : Type} (S : Set X) : ¬ Set.PartiallyOverlaps S S := by
  intro h
  obtain ⟨x, hx, hn⟩ := h.2.1
  exact hn hx

end Aim
