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
def IsGreatestLowerBound {F : Type u}[LE F] (S : Set F) (a : F) : Prop :=
  IsLowerBound S a ∧ ∀ b : F, IsLowerBound S b → b ≤ a

-- ### The bounds vocabulary: Lean names and readable names
--
-- Each concept below has a short Lean name, which is the definition, and a
-- readable full name, which is an `abbrev` for it:
--
--   def IsLUB … := …
--   abbrev IsLeastUpperBound (S : Set F) (a : F) : Prop := IsLUB S a
--
-- Lemmas are named after the Lean name (`IsLUB.unique`). Statements may be
-- written with either; a lemma about one applies to the other.
--
-- Order of work: the two sets of bounds, then least and greatest, then the
-- four concepts built from them. When they exist, `IsLeastUpperBound` and
-- `IsGreatestLowerBound` above become `abbrev`s. The new and old forms are
-- the same statement by definition, so nothing that uses them changes.

/-
`upperBounds`  (definition)

The set of upper bounds of `S`: all elements that are at least every
element of `S`.

  upperBounds S  :=  { b : F | ∀ x : F, x ∈ S → x ≤ b }

`a ∈ upperBounds S` and `IsUpperBound S a` say the same thing.
-/

/-
`lowerBounds`  (definition)

The set of lower bounds of `S`: all elements that are at most every
element of `S`.

  lowerBounds S  :=  { b : F | ∀ x : F, x ∈ S → b ≤ x }

`a ∈ lowerBounds S` and `IsLowerBound S a` say the same thing.
-/

/-
`IsLeast`  (definition)        readable name: `IsMinimum`

`a` is the least element (minimum) of `S` when `a` belongs to `S` and `a`
is a lower bound of `S`.

  IsLeast S a  :⟺  a ∈ S ∧ a ∈ lowerBounds S
-/

/-
`IsGreatest`  (definition)     readable name: `IsMaximum`

`a` is the greatest element (maximum) of `S` when `a` belongs to `S` and
`a` is an upper bound of `S`.

  IsGreatest S a  :⟺  a ∈ S ∧ a ∈ upperBounds S
-/

/-
`IsLUB`  (definition)          readable name: `IsLeastUpperBound`

`a` is the least upper bound (supremum) of `S` when `a` is the least
element of the set of upper bounds of `S`.

  IsLUB S a  :⟺  IsLeast (upperBounds S) a

`IsLUB S` on its own is a property of elements: "is the supremum of `S`".
-/

/-
`IsGLB`  (definition)          readable name: `IsGreatestLowerBound`

`a` is the greatest lower bound (infimum) of `S` when `a` is the greatest
element of the set of lower bounds of `S`.

  IsGLB S a  :⟺  IsGreatest (lowerBounds S) a
-/

/-
`BddAbove`  (definition)       readable name: `BoundedAbove`

`S` is bounded above when it has at least one upper bound, that is, when
its set of upper bounds is nonempty.

  BddAbove S  :⟺  ∃ b : F, b ∈ upperBounds S
-/

/-
`BddBelow`  (definition)       readable name: `BoundedBelow`

`S` is bounded below when it has at least one lower bound, that is, when
its set of lower bounds is nonempty.

  BddBelow S  :⟺  ∃ b : F, b ∈ lowerBounds S
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
--
-- The first two are the real proofs. The last two are the first two applied
-- to the set of upper bounds and the set of lower bounds.

/-
`IsLeast.unique`

A set has at most one least element.

  ∀ S : Set F, ∀ a b : F,  IsLeast S a → IsLeast S b → a = b
-/

/-
`IsGreatest.unique`

A set has at most one greatest element.

  ∀ S : Set F, ∀ a b : F,  IsGreatest S a → IsGreatest S b → a = b
-/

/-
`IsLUB.unique`

A set has at most one least upper bound.

  ∀ S : Set F, ∀ a b : F,
    IsLeastUpperBound S a → IsLeastUpperBound S b → a = b
-/

/-
`IsGLB.unique`

A set has at most one greatest lower bound.

  ∀ S : Set F, ∀ a b : F,
    IsGreatestLowerBound S a → IsGreatestLowerBound S b → a = b
-/

-- ### Minimum and supremum
--
-- These also assume `F` is totally ordered.

/-
`IsGreatest.isLUB`

A maximum is a supremum: if `a` is the greatest element of `S`, then `a` is
the least upper bound of `S`.

  ∀ S : Set F, ∀ a : F,  IsGreatest S a → IsLUB S a
-/

/-
`IsLUB.isGreatest_of_mem`

A supremum that belongs to the set is its maximum: if `a` is the least
upper bound of `S` and `a` belongs to `S`, then `a` is the greatest element
of `S`.

  ∀ S : Set F, ∀ a : F,  IsLUB S a → a ∈ S → IsGreatest S a
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
