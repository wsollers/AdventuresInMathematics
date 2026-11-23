/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Algebra.OrderedField

/-!
# Absolute Value

Statements about `abs`, which is defined in `OrderedField.lean` by
`abs x = max x (-x)`. The triangle inequality `abs_add_le` is stated there.

Each statement below is given in English and in quantified form. The Lean
statement and proof are to be written beneath it.

Throughout, `F` is an ordered field, `x`, `y`, `a`, `ε` are elements of `F`,
and `|x|` denotes `abs x`. There is no `|x|` notation in Lean yet.
-/

namespace Aim

universe u

variable {F : Type u} [OrderedField F]

-- ## Sign and value

/-
`abs_nonneg`

The absolute value of every element is non-negative.

  ∀ x : F,  0 ≤ |x|
-/

/-
`abs_of_nonneg`

The absolute value of a non-negative element is the element itself.

  ∀ x : F,  0 ≤ x → |x| = x
-/

/-
`abs_of_neg`

The absolute value of a negative element is its negation.

  ∀ x : F,  x < 0 → |x| = -x
-/

/-
`abs_eq_zero_iff`

An element has absolute value zero if and only if it is zero.

  ∀ x : F,  |x| = 0 ↔ x = 0
-/

/-
`abs_neg`

An element and its negation have the same absolute value.

  ∀ x : F,  |-x| = |x|
-/

/-
`abs_sub_comm`

The absolute value of a difference does not depend on the order of the two
terms.

  ∀ x y : F,  |x - y| = |y - x|
-/

-- ## Comparison with the element

/-
`le_abs_self`

Every element is at most its absolute value.

  ∀ x : F,  x ≤ |x|
-/

/-
`neg_le_abs_self`

The negation of every element is at most its absolute value.

  ∀ x : F,  -x ≤ |x|
-/

-- ## Absolute value and inequalities

/-
`abs_le_iff`

The absolute value of `x` is at most `a` if and only if `x` lies between
`-a` and `a`, endpoints included.

  ∀ x a : F,  |x| ≤ a ↔ -a ≤ x ∧ x ≤ a
-/

/-
`abs_lt_iff`

The absolute value of `x` is less than `a` if and only if `x` lies strictly
between `-a` and `a`.

  ∀ x a : F,  |x| < a ↔ -a < x ∧ x < a
-/

/-
`abs_sub_lt_iff`

`x` is within distance `ε` of `y` if and only if `x` lies strictly between
`y - ε` and `y + ε`. This is the form in which limit definitions are used.

  ∀ x y ε : F,  |x - y| < ε ↔ y - ε < x ∧ x < y + ε
-/

/-
`abs_le_of_le_of_neg_le`

If both `x` and `-x` are at most `a`, then the absolute value of `x` is at
most `a`.

  ∀ x a : F,  x ≤ a → -x ≤ a → |x| ≤ a
-/

-- ## Absolute value and arithmetic

/-
`abs_mul`

The absolute value of a product is the product of the absolute values.

  ∀ x y : F,  |x * y| = |x| * |y|
-/

/-
`abs_sub_abs_le_abs_sub`  (reverse triangle inequality)

The distance between two absolute values is at most the distance between
the elements.

  ∀ x y : F,  | |x| - |y| | ≤ |x - y|
-/

end Aim
