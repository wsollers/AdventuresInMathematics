/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Algebra.Field
import Aim.Algebra.Numerals
import Aim.OrderTheory.TotalOrder

/-!
# Ordered Fields

A field with a compatible total order and decidable comparison: order with
addition, order with multiplication, signs, division, and absolute value.
-/

namespace Aim

universe u

-- 3. Ordered fields and order with addition/subtraction

/-- Addition on the right preserves non-strict order. -/
class IsAddLEAddRight (X : Type u) [Add X] [LE X] : Prop where
  add_le_add_right : ∀ a b : X, a ≤ b → ∀ c : X, a + c ≤ b + c

/-- The product of two positive elements is positive. -/
class IsMulPos (X : Type u) [Zero X] [Mul X] [LT X] : Prop where
  mul_pos : ∀ a b : X, 0 < a → 0 < b → 0 < a * b

/-- A field equipped with a compatible total order and decidable comparison. -/
class OrderedField (F : Type u)
    extends Field F, TotalOrder F, LEDecidable F,
      IsAddLEAddRight F, IsMulPos F

/-- Positive elements: `{ x : R // 0 < x }` (e.g. ℝ⁺). -/
def RPos (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // 0 < x }

/-- Negative elements: `{ x : R // x < 0 }` (e.g. ℝ⁻). -/
def RNeg (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // x < 0 }

/-- Non-negative elements: `{ x : R // 0 ≤ x }` (e.g. ℝ≥0, needed for metric codomains). -/
def RNonneg (R : Type u) [Zero R] [LE R] : Type u :=
  { x : R // 0 ≤ x }

-- 3b. Order and addition/subtraction

/-- Adding the same element on the right preserves `≤`. -/
corollary add_le_add_right {F : Type u} [OrderedField F] {a b : F}
    (hab : a ≤ b) (c : F) : a + c ≤ b + c := by
  have hadd : a + c ≤ b + c := IsAddLEAddRight.add_le_add_right a b hab c
  exact hadd

/-- Adding the same element on the left preserves `≤`. -/
corollary add_le_add_left {F : Type u} [OrderedField F] {a b : F}
    (hab : a ≤ b) (c : F) : c + a ≤ c + b := by
  have hadd : a + c ≤ b + c := IsAddLEAddRight.add_le_add_right a b hab c
  rw [IsAddComm.add_comm a c] at hadd
  rw [IsAddComm.add_comm b c] at hadd
  exact hadd

/-- Adding the same element on the right reflects `≤`. -/
lemma le_of_add_le_add_right {F : Type u} [OrderedField F] {a b c : F}
    (h : a + c ≤ b + c) : a ≤ b := by
  have hadd : a + c + (-c) ≤ b + c + (-c) :=
    IsAddLEAddRight.add_le_add_right (a + c) (b + c) h (-c)
  rw [IsAddAssoc.add_assoc a c (-c)] at hadd
  rw [IsAddAssoc.add_assoc b c (-c)] at hadd
  rw [IsAddNeg.add_neg] at hadd
  rw [add_zero, add_zero]  at hadd -- do two add_zero rw on current
  exact hadd

/-- Adding the same element on the left reflects `≤`. -/
lemma le_of_add_le_add_left {F : Type u} [OrderedField F] {a b c : F}
    (h : c + a ≤ c + b) : a ≤ b := by
  sorry

/-- Adding two non-strict inequalities preserves `≤`. -/
proposition add_le_add {F : Type u} [OrderedField F] {a b c d : F}
    (hab : a ≤ b) (hcd : c ≤ d) : a + c ≤ b + d := by
  sorry

/-- Adding the same element on the right preserves `<`. -/
proposition add_lt_add_right {F : Type u} [OrderedField F] {a b : F}
    (hab : a < b) (c : F) : a + c < b + c := by
  sorry

/-- Adding the same element on the left preserves `<`. -/
proposition add_lt_add_left {F : Type u} [OrderedField F] {a b : F}
    (hab : a < b) (c : F) : c + a < c + b := by
  sorry

/-- Adding the same element on the right reflects `<`. -/
lemma lt_of_add_lt_add_right {F : Type u} [OrderedField F] {a b c : F}
    (h : a + c < b + c) : a < b := by
  sorry

/-- Adding the same element on the left reflects `<`. -/
lemma lt_of_add_lt_add_left {F : Type u} [OrderedField F] {a b c : F}
    (h : c + a < c + b) : a < b := by
  sorry

/-- Adding two strict inequalities preserves `<`. -/
proposition add_lt_add {F : Type u} [OrderedField F] {a b c d : F}
    (hab : a < b) (hcd : c < d) : a + c < b + d := by
  sorry

/-- Subtraction detects non-strict order. -/
lemma sub_nonneg {F : Type u} [OrderedField F] {a b : F} :
    0 ≤ a - b ↔ b ≤ a := by
  sorry

/-- Subtraction detects strict order. -/
lemma sub_pos {F : Type u} [OrderedField F] {a b : F} :
    0 < a - b ↔ b < a := by
  sorry

/-- Negation reverses non-strict order. -/
lemma neg_le_neg {F : Type u} [OrderedField F] {a b : F}
    (h : a ≤ b) : -b ≤ -a := by
  sorry

/-- Negation reverses non-strict order. -/
lemma neg_le_neg_iff {F : Type u} [OrderedField F] (a b : F) :
    -a ≤ -b ↔ b ≤ a := by
  sorry

/-- Negation reverses strict order. -/
lemma neg_lt_neg {F : Type u} [OrderedField F] {a b : F}
    (h : a < b) : -b < -a := by
  sorry

/-- Negation reverses strict order. -/
lemma neg_lt_neg_iff {F : Type u} [OrderedField F] (a b : F) :
    -a < -b ↔ b < a := by
  sorry

/-- A negation is negative exactly when the original element is positive. -/
lemma neg_lt_zero {F : Type u} [OrderedField F] {a : F} :
    -a < 0 ↔ 0 < a := by
  sorry

/-- A negation is positive exactly when the original element is negative. -/
lemma neg_pos {F : Type u} [OrderedField F] {a : F} :
    0 < -a ↔ a < 0 := by
  sorry

/-- A negation is nonpositive exactly when the original element is nonnegative. -/
lemma neg_le_zero {F : Type u} [OrderedField F] {a : F} :
    -a ≤ 0 ↔ 0 ≤ a := by
  sorry

/-- A negation is nonnegative exactly when the original element is nonpositive. -/
lemma neg_nonneg {F : Type u} [OrderedField F] {a : F} :
    0 ≤ -a ↔ a ≤ 0 := by
  sorry

/-- A positive element has a negative negation. -/
corollary neg_neg_of_pos {F : Type u} [OrderedField F] {a : F}
    (h : 0 < a) : -a < 0 := by
  sorry

/-- A negative element has a positive negation. -/
lemma neg_pos_of_neg {F : Type u} [OrderedField F] {a : F} (h : a < 0) : 0 < -a := by
  sorry

/-- A nonnegative element has a nonpositive negation. -/
lemma neg_nonpos_of_nonneg {F : Type u} [OrderedField F] {a : F}
    (h : 0 ≤ a) : -a ≤ 0 := by
  sorry

/-- A nonpositive element has a nonnegative negation. -/
lemma neg_nonneg_of_nonpos {F : Type u} [OrderedField F] {a : F}
    (h : a ≤ 0) : 0 ≤ -a := by
  sorry

-- 4. Order and multiplication/division

/-- The product of two nonnegative elements is nonnegative. -/
lemma mul_nonneg {F : Type u} [OrderedField F] {a b : F}
    (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ a * b := by
  sorry

/-- Multiplication by a positive right factor preserves `<`. -/
proposition mul_lt_mul_of_pos_right {F : Type u} [OrderedField F] {a b c : F}
    (hab : a < b) (hc : 0 < c) : a * c < b * c := by
  sorry

/-- Multiplication by a positive left factor preserves `<`. -/
proposition mul_lt_mul_of_pos_left {F : Type u} [OrderedField F] {a b c : F}
    (hab : a < b) (hc : 0 < c) : c * a < c * b := by
  sorry

/-- Multiplication by a nonnegative right factor preserves `≤`. -/
proposition mul_le_mul_of_nonneg_right {F : Type u} [OrderedField F] {a b c : F}
    (hab : a ≤ b) (hc : 0 ≤ c) : a * c ≤ b * c := by
  sorry

/-- Multiplication by a nonnegative left factor preserves `≤`. -/
proposition mul_le_mul_of_nonneg_left {F : Type u} [OrderedField F] {a b c : F}
    (hab : a ≤ b) (hc : 0 ≤ c) : c * a ≤ c * b := by
  sorry

/-- Multiplication by a negative right factor reverses `<`. -/
proposition mul_lt_mul_of_neg_right {F : Type u} [OrderedField F] {a b c : F}
    (hab : a < b) (hc : c < 0) : b * c < a * c := by
  sorry

/-- Multiplication by a negative left factor reverses `<`. -/
proposition mul_lt_mul_of_neg_left {F : Type u} [OrderedField F] {a b c : F}
    (hab : a < b) (hc : c < 0) : c * b < c * a := by
  sorry

/-- Multiplication by a nonpositive right factor reverses `≤`. -/
proposition mul_le_mul_of_nonpos_right {F : Type u} [OrderedField F] {a b c : F}
    (hab : a ≤ b) (hc : c ≤ 0) : b * c ≤ a * c := by
  sorry

/-- Multiplication by a nonpositive left factor reverses `≤`. -/
proposition mul_le_mul_of_nonpos_left {F : Type u} [OrderedField F] {a b c : F}
    (hab : a ≤ b) (hc : c ≤ 0) : c * b ≤ c * a := by
  sorry

-- 4b. Signs, squares, and inverses

/-- One is strictly positive. -/
lemma zero_lt_one {F : Type u} [OrderedField F] : (0 : F) < 1 := by
  sorry

/-- One is nonnegative. -/
lemma zero_le_one {F : Type u} [OrderedField F] : (0 : F) ≤ 1 := by
  sorry

/-- The square of any element is nonnegative. -/
lemma mul_self_nonneg {F : Type u} [OrderedField F] (a : F) : 0 ≤ a * a := by
  sorry

/-- The square of a nonzero element is strictly positive. -/
lemma mul_self_pos {F : Type u} [OrderedField F] {a : F}
    (ha : a ≠ 0) : 0 < a * a := by
  sorry

/-- A positive element has a positive inverse. -/
lemma inv_pos {F : Type u} [OrderedField F] {a : F}
    (ha : 0 < a) : 0 < a⁻¹ := by
  sorry

/-- A negative element has a negative inverse. -/
lemma inv_neg {F : Type u} [OrderedField F] {a : F}
    (ha : a < 0) : a⁻¹ < 0 := by
  sorry

-- 4c. Division and comparison

/-- A quotient of positive elements is positive. -/
lemma div_pos {F : Type u} [OrderedField F] {a b : F}
    (ha : 0 < a) (hb : 0 < b) : 0 < a / b := by
  sorry

/-- A nonnegative element divided by a positive element is nonnegative. -/
lemma div_nonneg {F : Type u} [OrderedField F] {a b : F}
    (ha : 0 ≤ a) (hb : 0 < b) : 0 ≤ a / b := by
  sorry

/-- Division by a positive element preserves and reflects non-strict order. -/
lemma div_le_div_right {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a / c ≤ b / c ↔ a ≤ b := by
  sorry

/-- Division by a positive element preserves and reflects strict order. -/
lemma div_lt_div_right {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a / c < b / c ↔ a < b := by
  sorry

/-- Division by a negative element reverses non-strict order. -/
lemma div_le_div_right_of_neg {F : Type u} [OrderedField F] {a b c : F}
    (hc : c < 0) : a / c ≤ b / c ↔ b ≤ a := by
  sorry

/-- Division by a negative element reverses strict order. -/
lemma div_lt_div_right_of_neg {F : Type u} [OrderedField F] {a b c : F}
    (hc : c < 0) : a / c < b / c ↔ b < a := by
  sorry

/-- A positive denominator can be moved across a non-strict inequality. -/
lemma div_le_iff {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a / c ≤ b ↔ a ≤ b * c := by
  sorry

/-- A positive denominator can be moved across a strict inequality. -/
lemma div_lt_iff {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a / c < b ↔ a < b * c := by
  sorry

/-- A positive denominator on the right can be moved across non-strict order. -/
lemma le_div_iff {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a ≤ b / c ↔ a * c ≤ b := by
  sorry

/-- A positive denominator on the right can be moved across strict order. -/
lemma lt_div_iff {F : Type u} [OrderedField F] {a b c : F}
    (hc : 0 < c) : a < b / c ↔ a * c < b := by
  sorry

-- 4d. Halves and the ε-principle: statements to translate and prove
--
-- Throughout, `F` is an ordered field, `x`, `y`, `ε` are elements of `F`,
-- and `2` is the numeral from `Numerals.lean`, equal to `1 + 1` by
-- `two_eq_one_add_one`.

/-
`two_pos`

Two is positive.

  0 < 2
-/

/-
`half_pos`

Half of a positive element is positive.

  ∀ ε : F,  0 < ε → 0 < ε / 2
-/

/-
`add_halves`

Every element is the sum of its two halves.

  ∀ x : F,  x / 2 + x / 2 = x
-/

/-
`midpoint_between`

The midpoint of two distinct elements lies strictly between them. In
particular an ordered field has no two adjacent elements.

  ∀ x y : F,  x < y → x < (x + y) / 2 ∧ (x + y) / 2 < y
-/

/-
`le_of_forall_pos_le_add`  (the ε-principle)

If `x` exceeds `y` by at most `ε` for every positive `ε`, then `x` is at
most `y`.

  ∀ x y : F,  (∀ ε : F, 0 < ε → x ≤ y + ε) → x ≤ y

The worklist calls this `le_of_forall_pos_lt_add`.
-/

-- 5. Absolute value

/-- Absolute value: `|x| = max x (-x)`. -/
def abs {F : Type u} [OrderedField F] (x : F) : F :=
  max x (-x)

/-- The triangle inequality. -/
theorem abs_add_le {F : Type u} [OrderedField F] (x y : F) :
    abs (x + y) ≤ abs x + abs y := by
  sorry

-- 6. Smoke tests

/-- Order mixins are found through the `OrderedField` parents. -/
theorem ordered_field_smoke_test {F : Type u} [OrderedField F] (a : F) :
    a ≤ a := by
  exact IsLERefl.le_refl a

/-- The decidability of `≤` is found through `OrderedField`. -/
example {F : Type u} [OrderedField F] (a b : F) : Decidable (a ≤ b) := by
  exact inferInstance

/-- `max` (via core's `Max` class) unfolds to the expected `if`. -/
theorem max_smoke_test {F : Type u} [OrderedField F] (a b : F) :
    max a b = if a ≤ b then b else a := by
  rfl

/-- `abs` is defined through `max`. -/
theorem abs_smoke_test {F : Type u} [OrderedField F] (x : F) :
    abs x = max x (-x) := by
  rfl

/-- The negative branch of `abs` is reachable with core's `if_pos`. -/
theorem abs_branch_pos_smoke_test {F : Type u} [OrderedField F] (x : F)
    (h : x ≤ -x) : abs x = -x := by
  show (if x ≤ -x then -x else x) = -x
  exact if_pos h

/-- The positive branch of `abs` is reachable with core's `if_neg`. -/
theorem abs_branch_neg_smoke_test {F : Type u} [OrderedField F] (x : F)
    (h : ¬ x ≤ -x) : abs x = x := by
  show (if x ≤ -x then -x else x) = x
  exact if_neg h

end Aim
