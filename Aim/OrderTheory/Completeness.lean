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

/-- `a` is an upper bound for `S`. -/
def IsUpperBound {F : Type u} [LE F] (S : Set F) (a : F) : Prop :=
  ∀ x : F, x ∈ S → x ≤ a

/-- `a` is the least upper bound for `S`. -/
def IsLeastUpperBound {F : Type u} [LE F] (S : Set F) (a : F) : Prop :=
  IsUpperBound S a ∧ ∀ b : F, IsUpperBound S b → a ≤ b

/-- Every nonempty set bounded above has a least upper bound. -/
class IsOrderComplete (F : Type u) [LE F] : Prop where
  exists_isLeastUpperBound :
    ∀ S : Set F,
      (∃ x : F, x ∈ S) →
      (∃ b : F, IsUpperBound S b) →
      ∃ a : F, IsLeastUpperBound S a

-- ## Statements to translate and prove
--
-- Throughout, `F` is a type with an order `≤`, `S` is a set of elements of
-- `F`, and `a`, `b` are elements of `F`. Where a statement needs more than
-- `≤`, it says so.

-- ### Definitions

/-
`IsLowerBound`  (definition)

`a` is a lower bound for `S` when `a` is at most every element of `S`.

  IsLowerBound S a  :⟺  ∀ x : F, x ∈ S → a ≤ x
-/
def IsLowerBound {F : Type u}[LE F] (S : Set F) (a : F) : Prop :=
  ∀ x : F, x ∈ S → a ≤ x
/-
`IsGreatestLowerBound`  (definition)

`a` is the greatest lower bound (infimum) of `S` when `a` is a lower bound
for `S` and every lower bound for `S` is at most `a`.

  IsGreatestLowerBound S a  :⟺
    IsLowerBound S a ∧ ∀ b : F, IsLowerBound S b → b ≤ a
-/

/-
`BoundedAbove`  (definition)

`S` is bounded above when it has at least one upper bound.

  BoundedAbove S  :⟺  ∃ b : F, IsUpperBound S b
-/

/-
`BoundedBelow`  (definition)

`S` is bounded below when it has at least one lower bound.

  BoundedBelow S  :⟺  ∃ b : F, IsLowerBound S b
-/

/-
`Set.Nonempty`  (definition; belongs with the set interface)

`S` is nonempty when it has at least one element.

  S.Nonempty  :⟺  ∃ x : F, x ∈ S

`IsOrderComplete` currently spells out nonemptiness and boundedness. Once
these three definitions exist it can be restated with them.
-/

-- ### Uniqueness
--
-- These need `≤` to be antisymmetric: assume `F` is totally ordered.

/-
`isLeastUpperBound_unique`

A set has at most one least upper bound.

  ∀ S : Set F, ∀ a b : F,
    IsLeastUpperBound S a → IsLeastUpperBound S b → a = b
-/

/-
`isGreatestLowerBound_unique`

A set has at most one greatest lower bound.

  ∀ S : Set F, ∀ a b : F,
    IsGreatestLowerBound S a → IsGreatestLowerBound S b → a = b
-/

-- ### Consequences of completeness
--
-- These assume `F` is totally ordered and order complete.

/-
`exists_isGreatestLowerBound`

Every nonempty set that is bounded below has a greatest lower bound.

  ∀ S : Set F,
    (∃ x : F, x ∈ S) → (∃ b : F, IsLowerBound S b) →
    ∃ a : F, IsGreatestLowerBound S a

This is a theorem, not an axiom: it follows from the least-upper-bound
property applied to the set of lower bounds of `S`.
-/

/-
`exists_mem_gt_of_lt_isLeastUpperBound`

Nothing smaller than the least upper bound is an upper bound: if `a` is the
least upper bound of `S` and `b` is less than `a`, then some element of `S`
is greater than `b`.

  ∀ S : Set F, ∀ a b : F,
    IsLeastUpperBound S a → b < a → ∃ x : F, x ∈ S ∧ b < x

This needs only a total order, not completeness.
-/

end Aim
