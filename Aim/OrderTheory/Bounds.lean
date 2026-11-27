/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.SetTheory.Interface.Set
import Aim.OrderTheory.OrderRelations

/-!
# Bounds

The vocabulary of bounds for a set of elements of an ordered type: upper and
lower bounds, boundedness, greatest and least elements, and least upper and
greatest lower bounds.

Everything here needs only a relation `≤` on the type `X`. Nothing assumes
that `X` is a field, or that the order is total. A theorem that needs a law
of order says which one, so that the same theorems serve the real numbers
under `≤` and sets under inclusion.

The file has two parts.

* **Definitions**, in the order Lean requires: each one comes after the
  definitions it is built from.
* **Theorems**, in order of strength, weakest property first:

    bounded above  ⟸  has a least upper bound  ⟸  has a greatest element

  and the same on the lower side.

Each concept with a short Lean name also has a readable full name, which is
an `abbrev` for it. Theorems are named after the Lean name and apply to both.
-/

namespace Aim

universe u

-- # Part 1. Definitions

-- ## 1. Bounds of a set

/-- `a` is an upper bound of `S`: every element of `S` is at most `a`.

  IsUpperBound S a  :⟺  ∀ x : X, x ∈ S → x ≤ a -/
def IsUpperBound {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  ∀ x : X, x ∈ S → x ≤ a

/-- `a` is a lower bound of `S`: `a` is at most every element of `S`.

  IsLowerBound S a  :⟺  ∀ x : X, x ∈ S → a ≤ x -/
def IsLowerBound {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  ∀ x : X, x ∈ S → a ≤ x

/-- Dieudonné's majorant: an upper bound of a set. -/
abbrev IsMajorant {X : Type u} [LE X] (S : Set X) (a : X) : Prop :=
  IsUpperBound S a

/-- Dieudonné's minorant: a lower bound of a set. -/
abbrev IsMinorant {X : Type u} [LE X] (S : Set X) (a : X) : Prop :=
  IsLowerBound S a

-- ## 2. The sets of bounds

/-- The set of all upper bounds of `S`.

  upperBounds S  :=  { b : X | IsUpperBound S b } -/
def upperBounds {X : Type u} [LE X]
  (S : Set X) : Set X :=
  {b | IsUpperBound S b}

/-- The set of all lower bounds of `S`.

  lowerBounds S  :=  { b : X | IsLowerBound S b } -/
def lowerBounds {X : Type u} [LE X]
  (S : Set X) : Set X :=
  {b | IsLowerBound S b}

-- ## 3. Boundedness

/-- `S` is bounded above: it has at least one upper bound.

  BddAbove S  :⟺  ∃ b : X, b ∈ upperBounds S -/
def BddAbove {X : Type u} [LE X]
  (S : Set X) : Prop :=
  ∃ b : X, b ∈ upperBounds S

/-- Readable name for `BddAbove`. -/
abbrev BoundedAbove {X : Type u} [LE X]
  (S : Set X) : Prop :=
  BddAbove S

/-- `S` is bounded below: it has at least one lower bound.

  BddBelow S  :⟺  ∃ b : X, b ∈ lowerBounds S -/
def BddBelow {X : Type u} [LE X]
  (S : Set X) : Prop :=
  ∃ b : X, b ∈ lowerBounds S

/-- Readable name for `BddBelow`. -/
abbrev BoundedBelow {X : Type u} [LE X]
  (S : Set X) : Prop :=
  BddBelow S

/-- `S` is bounded: it is bounded above and bounded below.

  Bounded S  :⟺  BddAbove S ∧ BddBelow S -/
def Bounded {X : Type u} [LE X]
  (S : Set X) : Prop :=
  BddAbove S ∧ BddBelow S

-- ## 4. Greatest and least elements

/-- `a` is the greatest element (maximum) of `S`: `a` belongs to `S` and is
an upper bound of `S`.

  IsGreatest S a  :⟺  a ∈ S ∧ a ∈ upperBounds S -/
def IsGreatest {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  a ∈ S ∧ a ∈ upperBounds S

/-- Readable name for `IsGreatest`. -/
abbrev IsMaximum {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsGreatest S a

/-- `a` is the least element (minimum) of `S`: `a` belongs to `S` and is a
lower bound of `S`.

  IsLeast S a  :⟺  a ∈ S ∧ a ∈ lowerBounds S -/
def IsLeast {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  a ∈ S ∧ a ∈ lowerBounds S

/-- Readable name for `IsLeast`. -/
abbrev IsMinimum {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsLeast S a

-- ## 5. Least upper bound and greatest lower bound

/-- `a` is the least upper bound (supremum) of `S`: `a` is the least element
of the set of upper bounds of `S`.

  IsLUB S a  :⟺  IsLeast (upperBounds S) a

Unfolded, this says that `a` is an upper bound of `S` and that `a ≤ b` for
every upper bound `b` of `S`. -/
def IsLUB {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsLeast (upperBounds S) a

/-- Readable name for `IsLUB`. -/
abbrev IsLeastUpperBound {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsLUB S a

/-- `a` is the greatest lower bound (infimum) of `S`: `a` is the greatest
element of the set of lower bounds of `S`.

  IsGLB S a  :⟺  IsGreatest (lowerBounds S) a

Unfolded, this says that `a` is a lower bound of `S` and that `b ≤ a` for
every lower bound `b` of `S`. -/
def IsGLB {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsGreatest (lowerBounds S) a

/-- Readable name for `IsGLB`. -/
abbrev IsGreatestLowerBound {X : Type u} [LE X]
  (S : Set X) (a : X) : Prop :=
  IsGLB S a

-- # Part 2. Theorems

-- ## 6. Membership in the sets of bounds

/-- An element belongs to the set of upper bounds of `S` if and only if it is
an upper bound of `S`.

  ∀ S : Set X, ∀ a : X,  a ∈ upperBounds S ↔ IsUpperBound S a -/
lemma mem_upperBounds_iff {X : Type u} [LE X]
  {S : Set X} {a : X} : a ∈ upperBounds S ↔ IsUpperBound S a := by
  constructor
  . --
    intro haub
    exact haub
  . --
    intro hub
    exact hub

/-- An element belongs to the set of lower bounds of `S` if and only if it is
a lower bound of `S`.

  ∀ S : Set X, ∀ a : X,  a ∈ lowerBounds S ↔ IsLowerBound S a -/
lemma mem_lowerBounds_iff {X : Type u} [LE X]
  {S : Set X} {a : X} : a ∈ lowerBounds S ↔ IsLowerBound S a := by
  sorry

-- ## 7. The upper side: bounded above ⟸ supremum ⟸ maximum

/-- A set that has an upper bound is bounded above.

  ∀ S : Set X, ∀ a : X,  a ∈ upperBounds S → BddAbove S -/
lemma bddAbove_of_mem_upperBounds {X : Type u} [LE X]
  {S : Set X} {a : X} (h : a ∈ upperBounds S) : BddAbove S := by
  sorry

/-- A least upper bound of `S` is an upper bound of `S`.

  ∀ S : Set X, ∀ a : X,  IsLUB S a → a ∈ upperBounds S -/
lemma IsLUB.mem_upperBounds {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsLUB S a) : a ∈ upperBounds S := by
  sorry

/-- A least upper bound of `S` is at most every upper bound of `S`.

  ∀ S : Set X, ∀ a b : X,  IsLUB S a → b ∈ upperBounds S → a ≤ b -/
lemma IsLUB.le_of_mem_upperBounds {X : Type u} [LE X]
  {S : Set X} {a b : X} (h : IsLUB S a) (hb : b ∈ upperBounds S) : a ≤ b := by
  sorry

/-- A set that has a least upper bound is bounded above.

  ∀ S : Set X, ∀ a : X,  IsLUB S a → BddAbove S -/
corollary IsLUB.bddAbove {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsLUB S a) : BddAbove S := by
  sorry

/-- A maximum is a supremum: the greatest element of `S` is the least upper
bound of `S`.

  ∀ S : Set X, ∀ a : X,  IsGreatest S a → IsLUB S a -/
proposition IsGreatest.isLUB {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsGreatest S a) : IsLUB S a := by
  sorry

/-- A supremum that belongs to the set is its maximum: if `a` is the least
upper bound of `S` and `a` belongs to `S`, then `a` is the greatest element
of `S`.

  ∀ S : Set X, ∀ a : X,  IsLUB S a → a ∈ S → IsGreatest S a -/
proposition IsLUB.isGreatest_of_mem {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsLUB S a) (ha : a ∈ S) : IsGreatest S a := by
  sorry

-- ## 8. The lower side: bounded below ⟸ infimum ⟸ minimum

/-- A set that has a lower bound is bounded below.

  ∀ S : Set X, ∀ a : X,  a ∈ lowerBounds S → BddBelow S -/
lemma bddBelow_of_mem_lowerBounds {X : Type u} [LE X]
  {S : Set X} {a : X} (h : a ∈ lowerBounds S) : BddBelow S := by
  sorry

/-- A greatest lower bound of `S` is a lower bound of `S`.

  ∀ S : Set X, ∀ a : X,  IsGLB S a → a ∈ lowerBounds S -/
lemma IsGLB.mem_lowerBounds {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsGLB S a) : a ∈ lowerBounds S := by
  sorry

/-- A greatest lower bound of `S` is at least every lower bound of `S`.

  ∀ S : Set X, ∀ a b : X,  IsGLB S a → b ∈ lowerBounds S → b ≤ a -/
lemma IsGLB.ge_of_mem_lowerBounds {X : Type u} [LE X]
  {S : Set X} {a b : X} (h : IsGLB S a) (hb : b ∈ lowerBounds S) : b ≤ a := by
  sorry

/-- A set that has a greatest lower bound is bounded below.

  ∀ S : Set X, ∀ a : X,  IsGLB S a → BddBelow S -/
corollary IsGLB.bddBelow {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsGLB S a) : BddBelow S := by
  sorry

/-- A minimum is an infimum: the least element of `S` is the greatest lower
bound of `S`.

  ∀ S : Set X, ∀ a : X,  IsLeast S a → IsGLB S a -/
proposition IsLeast.isGLB {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsLeast S a) : IsGLB S a := by
  sorry

/-- An infimum that belongs to the set is its minimum: if `a` is the greatest
lower bound of `S` and `a` belongs to `S`, then `a` is the least element of
`S`.

  ∀ S : Set X, ∀ a : X,  IsGLB S a → a ∈ S → IsLeast S a -/
proposition IsGLB.isLeast_of_mem {X : Type u} [LE X]
  {S : Set X} {a : X} (h : IsGLB S a) (ha : a ∈ S) : IsLeast S a := by
  sorry

-- ## 9. Uniqueness
--
-- These need `≤` to be antisymmetric, and nothing more. The first two are
-- the real proofs. The last two are the first two applied to the set of
-- upper bounds and to the set of lower bounds.

/-- A set has at most one greatest element.

  ∀ S : Set X, ∀ a b : X,  IsGreatest S a → IsGreatest S b → a = b -/
theorem IsGreatest.unique {X : Type u} [LE X] [IsLEAntisymm X]
  {S : Set X} {a b : X} (ha : IsGreatest S a) (hb : IsGreatest S b) : a = b := by
  sorry

/-- A set has at most one least element.

  ∀ S : Set X, ∀ a b : X,  IsLeast S a → IsLeast S b → a = b -/
theorem IsLeast.unique {X : Type u} [LE X] [IsLEAntisymm X]
  {S : Set X} {a b : X} (ha : IsLeast S a) (hb : IsLeast S b) : a = b := by
  sorry

/-- A set has at most one least upper bound.

  ∀ S : Set X, ∀ a b : X,  IsLUB S a → IsLUB S b → a = b -/
corollary IsLUB.unique {X : Type u} [LE X] [IsLEAntisymm X]
  {S : Set X} {a b : X} (ha : IsLUB S a) (hb : IsLUB S b) : a = b := by
  sorry

/-- A set has at most one greatest lower bound.

  ∀ S : Set X, ∀ a b : X,  IsGLB S a → IsGLB S b → a = b -/
corollary IsGLB.unique {X : Type u} [LE X] [IsLEAntisymm X]
  {S : Set X} {a b : X} (ha : IsGLB S a) (hb : IsGLB S b) : a = b := by
  sorry

end Aim
