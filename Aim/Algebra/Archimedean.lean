/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Algebra.OrderedField
import Aim.NumberSystems.NaturalNumbers.Interface.NaturalNumbers
import Aim.PeanoSystem.Theorems.Recursion

/-!
# The Cast from the Natural Numbers and the Archimedean Property

`natCast` sends a natural number into any type with a `0`, a `1` and an
addition, by starting at `0` and adding `1` at each successor. It is defined
by recursion on the project's `NaturalNumbers` interface, so it does not
depend on how the natural numbers are constructed.

Numeral literals such as `2` are a separate matter: see `Numerals.lean`.
-/

namespace Aim

universe u v

/-- The cast of a natural number: `0` goes to `0`, and each successor adds `1`. -/
noncomputable def natCast {N : Type u} [NaturalNumbers N]
    {F : Type v} [Zero F] [One F] [Add F] : N → F :=
  recurse 0 (· + 1)

/-- The Archimedean property as an independent mixin: every element of the
ordered field `F` is exceeded by the cast of some natural number.

Redundant for a `CompleteOrderedField` (where it is a theorem), but kept
separate so that non-Archimedean ordered fields can be discussed. -/
class ArchimedeanProperty (N : Type u) (F : Type v)
    [NaturalNumbers N] [OrderedField F] : Prop where
  archimedean : ∀ x : F, ∃ n : N, x < natCast n

-- ## Statements to translate and prove
--
-- `natCast_zero` and `natCast_succ` follow from `recurse_base` and
-- `recurse_succ`. The rest wait on addition and order on `N`. Throughout, `N` is a system of
-- natural numbers, `F` is an ordered field, `m`, `n` are elements of `N`,
-- and `ι : N → F` is the cast `natCast`.

/-
`natCast_zero`

The cast sends zero to zero.

  ι 0 = 0
-/

/-
`natCast_succ`

The cast of a successor is the cast plus one.

  ∀ n : N,  ι (succ n) = ι n + 1
-/

/-
`natCast_add`

The cast preserves addition.

  ∀ m n : N,  ι (m + n) = ι m + ι n
-/

/-
`natCast_nonneg`

The cast of every natural number is non-negative.

  ∀ n : N,  0 ≤ ι n
-/

/-
`natCast_lt`

The cast preserves and reflects strict order. In particular it is injective.

  ∀ m n : N,  m < n ↔ ι m < ι n
-/

/-
`archimedean_of_complete`  (Archimedean property)

Let `F` be a complete ordered field. Then the natural numbers are unbounded
in `F`: every element of `F` is exceeded by the cast of some natural number.

  ∀ x : F,  ∃ n : N, x < ι n
-/

/-
`exists_natCast_inv_lt`

Let `F` be an Archimedean ordered field. For every positive `ε` there is a
natural number `n` such that the reciprocal of `ι (succ n)` is less than `ε`.

  ∀ ε : F,  0 < ε → ∃ n : N, 1 / ι (succ n) < ε

The successor guarantees that the denominator is positive.
-/

end Aim
