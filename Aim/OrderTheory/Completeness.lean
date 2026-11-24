/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.OrderTheory.Bounds

/-!
# Order Completeness and Density

Two properties an ordered type may have, both stated with the order alone.

* **Order completeness**, the least-upper-bound property: every nonempty set
  that is bounded above has a least upper bound.
* **Density**: between any two elements there is a third.

The vocabulary of bounds is in `Aim/OrderTheory/Bounds.lean`.

The Archimedean property is not here. It speaks of the natural numbers inside
a field, so it needs addition and `1` as well as the order. It is in
`Aim/Algebra/Archimedean.lean`, with the theorem that it follows from
completeness.
-/

namespace Aim

universe u

-- ## 1. Order completeness

/-- The least-upper-bound property: every nonempty set that is bounded above
has a least upper bound.

  ∀ S : Set X,
    (∃ x : X, x ∈ S) → (∃ b : X, IsUpperBound S b) →
    ∃ a : X, IsLeastUpperBound S a -/
class IsOrderComplete (X : Type u) [LE X] : Prop where
  exists_isLeastUpperBound :
    ∀ S : Set X,
      (∃ x : X, x ∈ S) →
      (∃ b : X, IsUpperBound S b) →
      ∃ a : X, IsLeastUpperBound S a

/-
`Set.Nonempty`  (definition, not yet written; belongs with the set interface)

`S` is nonempty when it has at least one element.

  S.Nonempty  :⟺  ∃ x : X, x ∈ S

`IsOrderComplete` spells out nonemptiness and boundedness. Once
`Set.Nonempty` exists it can be restated as

  ∀ S : Set X,  S.Nonempty → BddAbove S → ∃ a : X, IsLUB S a
-/

-- ## 2. Consequences of completeness

/-- Every nonempty set that is bounded below has a greatest lower bound.

  ∀ S : Set X,  (∃ x : X, x ∈ S) → BddBelow S → ∃ a : X, IsGLB S a

This is a theorem, not an axiom: it follows from the least-upper-bound
property applied to the set of lower bounds of `S`. -/
theorem exists_isGLB {X : Type u} [LE X] [IsOrderComplete X]
  {S : Set X} (hne : ∃ x : X, x ∈ S) (hbdd : BddBelow S) : ∃ a : X, IsGLB S a := by
  sorry

-- ## 3. The approximation property
--
-- This needs a total order. It does not need completeness: it is a fact
-- about any least upper bound, however it was obtained.

/-- Nothing smaller than the least upper bound is an upper bound: if `a` is
the least upper bound of `S` and `b` is less than `a`, then some element of
`S` is greater than `b`.

  ∀ S : Set X, ∀ a b : X,  b < a → IsLUB S a → ∃ x : X, x ∈ S ∧ b < x -/
proposition exists_mem_gt_of_lt_isLUB {X : Type u} [TotalOrder X]
  {S : Set X} {a b : X} (hb : b < a) (h : IsLUB S a) : ∃ x : X, x ∈ S ∧ b < x := by
  sorry

-- ## 4. Density

/-- A densely ordered type: strictly between any two elements there is a
third.

  ∀ a b : X,  a < b → ∃ c : X, StrictlyBetween a c b -/
class DenselyOrdered (X : Type u) [LT X] : Prop where
  dense : ∀ a b : X, a < b → ∃ c : X, StrictlyBetween a c b

end Aim
