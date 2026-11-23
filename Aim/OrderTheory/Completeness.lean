/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.SetTheory.Interface.Set

/-!
# Order Completeness

Upper bounds, least upper bounds, and the least-upper-bound property. These
need only `≤` and a set of elements.
-/

namespace Aim

universe u

/-- `a` is an upper bound for `s`. -/
def IsUpperBound {F : Type u} [LE F] (s : Set F) (a : F) : Prop :=
  ∀ x : F, x ∈ s → x ≤ a

/-- `a` is the least upper bound for `s`. -/
def IsLeastUpperBound {F : Type u} [LE F] (s : Set F) (a : F) : Prop :=
  IsUpperBound s a ∧ ∀ b : F, IsUpperBound s b → a ≤ b

/-- Every nonempty set bounded above has a least upper bound. -/
class IsOrderComplete (F : Type u) [LE F] : Prop where
  exists_isLeastUpperBound :
    ∀ s : Set F,
      (∃ x : F, x ∈ s) →
      (∃ b : F, IsUpperBound s b) →
      ∃ a : F, IsLeastUpperBound s a

-- ## Statements to translate and prove
--
-- Throughout, `F` is a type with an order `≤`, `s` is a set of elements of
-- `F`, and `a`, `b` are elements of `F`. Where a statement needs more than
-- `≤`, it says so.

-- ### Definitions

/-
`IsLowerBound`  (definition)

`a` is a lower bound for `s` when `a` is at most every element of `s`.

  IsLowerBound s a  :⟺  ∀ x : F, x ∈ s → a ≤ x
-/

/-
`IsGreatestLowerBound`  (definition)

`a` is the greatest lower bound (infimum) of `s` when `a` is a lower bound
for `s` and every lower bound for `s` is at most `a`.

  IsGreatestLowerBound s a  :⟺
    IsLowerBound s a ∧ ∀ b : F, IsLowerBound s b → b ≤ a
-/

/-
`BoundedAbove`  (definition)

`s` is bounded above when it has at least one upper bound.

  BoundedAbove s  :⟺  ∃ b : F, IsUpperBound s b
-/

/-
`BoundedBelow`  (definition)

`s` is bounded below when it has at least one lower bound.

  BoundedBelow s  :⟺  ∃ b : F, IsLowerBound s b
-/

/-
`Set.Nonempty`  (definition; belongs with the set interface)

`s` is nonempty when it has at least one element.

  s.Nonempty  :⟺  ∃ x : F, x ∈ s

`IsOrderComplete` currently spells out nonemptiness and boundedness. Once
these three definitions exist it can be restated with them.
-/

-- ### Uniqueness
--
-- These need `≤` to be antisymmetric: assume `F` is totally ordered.

/-
`isLeastUpperBound_unique`

A set has at most one least upper bound.

  ∀ s : Set F, ∀ a b : F,
    IsLeastUpperBound s a → IsLeastUpperBound s b → a = b
-/

/-
`isGreatestLowerBound_unique`

A set has at most one greatest lower bound.

  ∀ s : Set F, ∀ a b : F,
    IsGreatestLowerBound s a → IsGreatestLowerBound s b → a = b
-/

-- ### Consequences of completeness
--
-- These assume `F` is totally ordered and order complete.

/-
`exists_isGreatestLowerBound`

Every nonempty set that is bounded below has a greatest lower bound.

  ∀ s : Set F,
    (∃ x : F, x ∈ s) → (∃ b : F, IsLowerBound s b) →
    ∃ a : F, IsGreatestLowerBound s a

This is a theorem, not an axiom: it follows from the least-upper-bound
property applied to the set of lower bounds of `s`.
-/

/-
`exists_mem_gt_of_lt_isLeastUpperBound`

Nothing smaller than the least upper bound is an upper bound: if `a` is the
least upper bound of `s` and `b` is less than `a`, then some element of `s`
is greater than `b`.

  ∀ s : Set F, ∀ a b : F,
    IsLeastUpperBound s a → b < a → ∃ x : F, x ∈ s ∧ b < x

This needs only a total order, not completeness.
-/

end Aim
