/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

/-!
# Numerals

What a numeral literal such as `2` or `15` means in a type that has a `1`
and an addition: that many ones added together.

Lean reads the digits of a literal as an element of its own `Nat` and asks
the class `OfNat` for the corresponding element of the target type. Core
Lean already answers for `0` and `1` from `Zero` and `One`. This file
answers for every literal from `2` upward.

The `Nat` in this file is notation, not mathematics: it is how Lean hands
over the digits that were typed. It is unrelated to the project's
`NaturalNumbers` interface and to the cast from that interface into a field.
-/

namespace Aim

universe u

/-- `numeral n` is the sum of `n + 1` ones: `numeral 0 = 1`,
`numeral 1 = 1 + 1`, and so on. -/
def numeral {X : Type u} [One X] [Add X] : Nat → X
  | 0 => 1
  | n + 1 => numeral n + 1

/-- A literal `n + 2` denotes the sum of `n + 2` ones.

The instance starts at `2` because `0` and `1` already have meanings. Its
priority is low so that a type with its own numerals keeps them. -/
instance (priority := low) {X : Type u} [One X] [Add X] (n : Nat) :
    OfNat X (n + 2) :=
  ⟨numeral (n + 1)⟩

variable {X : Type u} [One X] [Add X]

/-- `numeral 0` is `1`. -/
theorem numeral_zero : (numeral 0 : X) = 1 := by
  rfl

/-- `numeral (n + 1)` adds one more `1`. -/
theorem numeral_succ (n : Nat) : (numeral (n + 1) : X) = numeral n + 1 := by
  rfl

/-- The literal `2` is `1 + 1`. -/
theorem two_eq_one_add_one : (2 : X) = 1 + 1 := by
  rfl

-- ## Statements to translate and prove
--
-- Throughout, `X` is a type with a `1` and an associative addition, and
-- `m`, `n` are Lean natural numbers (the counts of ones).

/-
`numeral_add`

Adding two sums of ones gives the sum of all the ones: the sum of `m + 1`
ones plus the sum of `n + 1` ones is the sum of `m + n + 2` ones.

  ∀ m n : Nat,  numeral m + numeral n = numeral (m + n + 1)

This needs addition on `X` to be associative. It is the one lemma behind
every numeric fact of the form `25 = 10 + 15`.
-/

end Aim
