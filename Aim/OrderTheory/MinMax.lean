/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.TotalOrder

/-!
# Maximum and Minimum

Maximum and minimum constructed from decidable comparison, with their basic laws.
-/

namespace Aim

universe u

-- Maximum and minimum

instance {X : Type u} [LE X] [LEDecidable X] : Max X :=
  ⟨fun a b => if a ≤ b then b else a⟩

instance {X : Type u} [LE X] [LEDecidable X] : Min X :=
  ⟨fun a b => if a ≤ b then a else b⟩

/-- Maximum is commutative. -/
lemma max_comm {X : Type u} [TotalOrder X] [LEDecidable X] (a b : X) : max a b = max b a := by
  change (if a ≤ b then b else a) =
       (if b ≤ a then a else b)
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    by_cases hba : b ≤ a
    . -- both comparisons hold
      rw [if_pos hba]
      -- goal: b = a
      exact le_antisymm hba hab
    . -- the reverse comparison fails
      rw [if_neg hba]
      -- both sides are now b
  . -- neg
    rw [if_neg hab]
    by_cases hba : b <= a
    . --
      rw [if_pos hba]
    . --
      have htot := Aim.IsLETotal.le_total a b
      rcases htot with hab' | hba'
      . exact False.elim (hab hab')
      . exact False.elim (hba hba')

-- Basic bounds and evaluation

/-- Each element is at most the maximum: the first. -/
lemma le_max_left {X : Type u} [TotalOrder X] [LEDecidable X]
    (a b : X) : a ≤ max a b := by
  change a ≤ (if a ≤ b then b else a)
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact hab
  . -- neg
    rw [if_neg hab]
    by_cases hba : b <= a
    . --
      exact le_refl a
    . --
      exact le_refl a

/-- Each element is at most the maximum: the second. -/
lemma le_max_right {X : Type u} [TotalOrder X] [LEDecidable X]
    (a b : X) : b ≤ max a b := by
  change b ≤ (if a ≤ b then b else a)
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact le_refl b
  . -- neg
    rw [if_neg hab]
    by_cases hba : b <= a
    . --
      exact hba
    . --
      have htot := Aim.IsLETotal.le_total a b
      rcases htot with hab' | hba'
      . exact False.elim (hab hab')
      . exact False.elim (hba hba')

/-- An upper bound of both elements bounds their maximum. -/
lemma max_le {X : Type u} [TotalOrder X] [LEDecidable X]
    {a b c : X}
    (ha : a ≤ c) (hb : b ≤ c) : max a b ≤ c := by
  change (if a ≤ b then b else a) <= c
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact hb
  . -- neg
    rw [if_neg hab]
    by_cases hba : b <= a
    . --
      exact ha
    . --
      have htot := Aim.IsLETotal.le_total a b
      rcases htot with hab' | hba'
      . exact False.elim (hab hab')
      . exact False.elim (hba hba')

/-- If the second element is at most the first, their maximum is the first. -/
lemma max_eq_left {X : Type u} [TotalOrder X] [LEDecidable X]
    {a b : X} (h : b ≤ a) : max a b = a := by
  change (if a ≤ b then b else a) = a
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    have halt := le_antisymm_iff a b
    obtain ⟨heq, hand⟩ := halt
    have hans := (hand ⟨hab, h⟩).symm
    exact hans
  . -- neg
    rw [if_neg hab]

/-- If the first element is at most the second, their maximum is the second. -/
lemma max_eq_right {X : Type u} [TotalOrder X] [LEDecidable X]
    {a b : X} (h : a ≤ b) : max a b = b := by
  change (if a ≤ b then b else a) = b
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
  . -- neg
    rw [if_neg hab]
    exact False.elim (hab h)

/-- The minimum is at most the first element. -/
lemma min_le_left {X : Type u} [TotalOrder X] [LEDecidable X]
    (a b : X) : min a b ≤ a := by
  change (if a ≤ b then a else b) ≤ a
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact le_refl a
  . -- neg
    rw [if_neg hab]
    rcases le_total a b with hab' | hba
    . exact False.elim (hab hab')
    . exact hba

/-- The minimum is at most the second element. -/
lemma min_le_right {X : Type u} [TotalOrder X] [LEDecidable X]
    (a b : X) : min a b ≤ b := by
  change (if a ≤ b then a else b) ≤ b
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact hab
  . -- neg
    rw [if_neg hab]
    exact le_refl b

/-- A lower bound of both elements bounds their minimum. -/
lemma le_min {X : Type u} [TotalOrder X] [LEDecidable X]
    {a b c : X}
    (ha : c ≤ a) (hb : c ≤ b) : c ≤ min a b := by
  change c ≤ (if a ≤ b then a else b)
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    exact ha
  . -- neg
    rw [if_neg hab]
    exact hb

/-- Minimum is commutative. -/
lemma min_comm {X : Type u} [TotalOrder X] [LEDecidable X]
    (a b : X) : min a b = min b a := by
  unfold min
  change (if a ≤ b then a else b) =
       (if b ≤ a then b else a)
  by_cases hab : a ≤ b
  . -- pos
    rw [if_pos hab]
    by_cases hba : b ≤ a
    . -- both comparisons hold
      rw [if_pos hba]
      -- goal: b = a
      exact le_antisymm hab hba
    . -- the reverse comparison fails
      rw [if_neg hba]
      -- both sides are now b
  . -- neg
    rw [if_neg hab]
    by_cases hba : b <= a
    . --
      rw [if_pos hba]
    . --
      have htot := Aim.IsLETotal.le_total a b
      rcases htot with hab' | hba'
      . exact False.elim (hab hab')
      . exact False.elim (hba hba')

end Aim
