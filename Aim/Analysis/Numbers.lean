/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Numbers in Analysis

Number systems and their properties used throughout real analysis.

## Roadmap of carriers

The concrete number systems are *constructed* elsewhere; this file only
fixes the axiom bundles they must satisfy. Planned carriers, in order:

* `ℕ`  — 1-based natural numbers
* `𝕎`  — whole numbers (ℕ with 0)
* `ℤ`  — integers
* `ℚ`  — rational numbers
* `ℝ`  — real numbers (a `CompleteOrderedField`)
* `𝕀`  — irrational numbers (a subtype of ℝ)
* `𝕋`  — transcendental numbers (a subtype of 𝕀)
* `ℂ`  — complex numbers
* `ℍ`  — quaternions

A bare `variable` declaration contributes nothing to the environment unless a
later declaration mentions it, so the carriers are not declared here.

## Design

Each algebraic / order axiom is its own `Prop`-valued class ("mixin"). The
structures `Field`, `OrderedField`, `CompleteOrderedField` `extend` those
mixins directly, so Lean generates the projection instances automatically —
no hand-written `instance … := Field.foo` boilerplate.

The associativity and commutativity mixins are bridged to core Lean's
`Std.Associative` / `Std.Commutative` so that `ac_rfl` works on fields.
-/

namespace aim.analysis

universe u v

-- 1. Algebraic Property Classes

/-- Associativity of addition. -/
class IsAddAssoc (X : Type u) [Add X] : Prop where
  add_assoc : ∀ a b c : X, a + b + c = a + (b + c)

/-- Commutativity of addition. -/
class IsAddComm (X : Type u) [Add X] : Prop where
  add_comm : ∀ a b : X, a + b = b + a

/-- Associativity of multiplication. -/
class IsMulAssoc (X : Type u) [Mul X] : Prop where
  mul_assoc : ∀ a b c : X, a * b * c = a * (b * c)

/-- Commutativity of multiplication. -/
class IsMulComm (X : Type u) [Mul X] : Prop where
  mul_comm : ∀ a b : X, a * b = b * a

/-- The additive and multiplicative identities are distinct. -/
class IsZeroNeOne (X : Type u) [Zero X] [One X] : Prop where
  zero_ne_one : (0 : X) ≠ 1

/-- Zero is a left identity for addition. -/
class IsZeroAdd (X : Type u) [Zero X] [Add X] : Prop where
  zero_add : ∀ a : X, 0 + a = a

/-- Negation supplies an additive inverse. -/
class IsAddNeg (X : Type u) [Zero X] [Add X] [Neg X] : Prop where
  add_neg : ∀ a : X, a + -a = 0

/-- One is a left identity for multiplication. -/
class IsOneMul (X : Type u) [One X] [Mul X] : Prop where
  one_mul : ∀ a : X, 1 * a = a

/-- Every nonzero element has a multiplicative inverse. -/
class IsMulInvCancel
    (X : Type u) [Zero X] [One X] [Mul X] [Inv X] : Prop where
  mul_inv_cancel : ∀ a : X, a ≠ 0 → a * a⁻¹ = 1

/-- Multiplication distributes over addition from the left. -/
class IsMulAdd (X : Type u) [Add X] [Mul X] : Prop where
  mul_add : ∀ a b c : X, a * (b + c) = a * b + a * c

-- Bridges to core Lean's generic associativity/commutativity classes.
-- These are what `ac_rfl` looks for.

instance {X : Type u} [Add X] [IsAddAssoc X] :
    Std.Associative ((· + ·) : X → X → X) :=
  ⟨IsAddAssoc.add_assoc⟩

instance {X : Type u} [Add X] [IsAddComm X] :
    Std.Commutative ((· + ·) : X → X → X) :=
  ⟨IsAddComm.add_comm⟩

instance {X : Type u} [Mul X] [IsMulAssoc X] :
    Std.Associative ((· * ·) : X → X → X) :=
  ⟨IsMulAssoc.mul_assoc⟩

instance {X : Type u} [Mul X] [IsMulComm X] :
    Std.Commutative ((· * ·) : X → X → X) :=
  ⟨IsMulComm.mul_comm⟩

-- 4. Algebraic and Order Hierarchy

/-- A field, presented independently of Mathlib's hierarchy.

The data parents (`Zero`, `One`, …) come first so that the `Prop` mixin
parents can find the instances they need. -/
class Field (F : Type u)
    extends Zero F, One F, Add F, Mul F, Neg F, Inv F,
      IsZeroNeOne F,
      IsAddAssoc F, IsAddComm F, IsZeroAdd F, IsAddNeg F,
      IsMulAssoc F, IsMulComm F, IsOneMul F, IsMulInvCancel F,
      IsMulAdd F

/-- Every field is nonempty, witnessed by zero. -/
instance {F : Type u} [Field F] : Nonempty F :=
  ⟨0⟩

-- Other Airthmetic on F
/-- Subtraction, defined as addition of the negation. -/
instance {F : Type u} [Field F] : Sub F :=
  ⟨fun a b => a + -b⟩

/-- Division, defined as multiplication by the inverse. -/
instance {F : Type u} [Field F] : Div F :=
  ⟨fun a b => a * b⁻¹⟩

/-- Subtraction is addition of the negation. -/
class IsSubEqAddNeg (X : Type u) [Add X] [Neg X] [Sub X] : Prop where
  sub_eq_add_neg : ∀ a b : X, a - b = a + -b

/-- Division is multiplication by the inverse. -/
class IsDivEqMulInv (X : Type u) [Mul X] [Inv X] [Div X] : Prop where
  div_eq_mul_inv : ∀ a b : X, a / b = a * b⁻¹

lemma sub_eq_add_neg {F : Type u} [Field F] (a b : F) :
    a - b = a + -b :=
  rfl

lemma div_eq_mul_inv {F : Type u} [Field F] (a b : F) :
    a / b = a * b⁻¹ :=
  rfl

instance {F : Type u} [Field F] : IsSubEqAddNeg F := ⟨fun _ _ => rfl⟩
instance {F : Type u} [Field F] : IsDivEqMulInv F := ⟨fun _ _ => rfl⟩

-- 2. Order Property Classes

/-- Reflexivity of the non-strict order. -/
class IsLERefl (X : Type u) [LE X] : Prop where
  le_refl : ∀ a : X, a ≤ a

/-- Transitivity of the non-strict order. -/
class IsLETrans (X : Type u) [LE X] : Prop where
  le_trans : ∀ a b c : X, a ≤ b → b ≤ c → a ≤ c

/-- Antisymmetry of the non-strict order. -/
class IsLEAntisymm (X : Type u) [LE X] : Prop where
  le_antisymm : ∀ a b : X, a ≤ b → b ≤ a → a = b

/-- Totality of the non-strict order. -/
class IsLETotal (X : Type u) [LE X] : Prop where
  le_total : ∀ a b : X, a ≤ b ∨ b ≤ a

/-- Strict order is the asymmetric part of non-strict order. -/
class IsLTIffLENotLE (X : Type u) [LE X] [LT X] : Prop where
  lt_iff_le_not_le : ∀ a b : X, a < b ↔ a ≤ b ∧ ¬b ≤ a

/-- Addition on the right preserves non-strict order. -/
class IsAddLEAddRight (X : Type u) [Add X] [LE X] : Prop where
  add_le_add_right : ∀ a b : X, a ≤ b → ∀ c : X, a + c ≤ b + c

/-- The product of two positive elements is positive. -/
class IsMulPos (X : Type u) [Zero X] [Mul X] [LT X] : Prop where
  mul_pos : ∀ a b : X, 0 < a → 0 < b → 0 < a * b

-- 3. Subtypes Carved Out of an Ordered Carrier

/-- Positive elements: `{ x : R // 0 < x }` (e.g. ℝ⁺). -/
def RPos (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // 0 < x }

/-- Negative elements: `{ x : R // x < 0 }` (e.g. ℝ⁻). -/
def RNeg (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // x < 0 }

/-- Non-negative elements: `{ x : R // 0 ≤ x }` (e.g. ℝ≥0, needed for metric codomains). -/
def RNonneg (R : Type u) [Zero R] [LE R] : Type u :=
  { x : R // 0 ≤ x }

/-- The order `≤` is decidable. Data, not a `Prop`: it is what `if` branches on. -/
class LEDecidable (X : Type u) [LE X] where
  decLE : ∀ a b : X, Decidable (a ≤ b)

instance {X : Type u} [LE X] [LEDecidable X] (a b : X) : Decidable (a ≤ b) :=
  LEDecidable.decLE a b

/-- A field equipped with a compatible linear order. -/
class OrderedField (F : Type u)
    extends Field F, LE F, LT F,
      IsLERefl F, IsLETrans F, IsLEAntisymm F, IsLETotal F,
      IsLTIffLENotLE F, LEDecidable F,
      IsAddLEAddRight F, IsMulPos F

instance {X : Type u} [LE X] [LEDecidable X] : Max X :=
  ⟨fun a b => if a ≤ b then b else a⟩

instance {X : Type u} [LE X] [LEDecidable X] : Min X :=
  ⟨fun a b => if a ≤ b then a else b⟩

/-- Absolute value: `|x| = max x (-x)`. -/
def abs {F : Type u} [OrderedField F] (x : F) : F :=
  max x (-x)

-- needs only decidability + totality + antisymmetry, nothing algebraic
lemma max_comm {X : Type u} [LE X] [LEDecidable X]
    [IsLETotal X] [IsLEAntisymm X] (a b : X) : max a b = max b a := by
  sorry


-- needs the field/order interaction
theorem abs_add_le {F : Type u} [OrderedField F] (x y : F) :
    abs (x + y) ≤ abs x + abs y := by
  sorry

/-- `a` is an upper bound for `s`. -/
def IsUpperBound {F : Type u} [LE F] (s : F → Prop) (a : F) : Prop :=
  ∀ x : F, s x → x ≤ a

/-- `a` is the least upper bound for `s`. -/
def IsLeastUpperBound {F : Type u} [LE F] (s : F → Prop) (a : F) : Prop :=
  IsUpperBound s a ∧ ∀ b : F, IsUpperBound s b → a ≤ b

/-- Every nonempty set bounded above has a least upper bound. -/
class IsOrderComplete (F : Type u) [LE F] : Prop where
  exists_isLeastUpperBound :
    ∀ s : F → Prop,
      (∃ x : F, s x) →
      (∃ b : F, IsUpperBound s b) →
      ∃ a : F, IsLeastUpperBound s a

/-- A complete ordered field. -/
class CompleteOrderedField (F : Type u)
    extends OrderedField F, IsOrderComplete F

/-- Embed a natural number by repeated addition of one.

This is the first bridge between core `Nat` and the "naturals inside `F`";
injectivity and compatibility with `+` and `*` are proved later. -/
def natCast {F : Type u} [Zero F] [One F] [Add F] : Nat → F
  | 0 => 0
  | n + 1 => natCast n + 1

/-- The Archimedean property as an independent mixin.

Redundant for a `CompleteOrderedField` (where it is a theorem), but kept
separate so that non-Archimedean ordered fields can be discussed. -/
class ArchimedeanProperty (F : Type u) [OrderedField F] : Prop where
  archimedean : ∀ x : F, ∃ n : Nat, x < natCast n

-- 5. Metric / Distance Signatures

/-- A distance function on `X` valued in `R`, together with a proof that every
distance is non-negative.

The domain and codomain may live in different universes. The codomain will
normally be instantiated with the reals once they are constructed. -/
structure Distance (X : Type u) (R : Type v) [Zero R] [LE R] where
  dist : X → X → R
  dist_nonneg : ∀ x y : X, 0 ≤ dist x y







-- | `add_zero` | `x + 0 = x` | `zero_add` (ax) | Z a |
corollary add_zero {R : Type u}
  [Zero R] [Add R] [IsZeroAdd R] [IsAddComm R] (x : R) : x + 0 = x := by
  rw [IsAddComm.add_comm x]
  rw [IsZeroAdd.zero_add]

--zero_unique	(∀ x, x + z = x) → z = 0	(∀ x, z + x = x) → z = 0	Z a.1°
proposition zero_unique {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddComm R] (z : R) : (∀ x, z + x = x) → z = 0 := by
  intro h
  have hx0 := h 0
  rw [add_zero] at hx0
  exact hx0

--neg_add	-x + x = 0	add_neg (ax)
corollary neg_add {R : Type u} [Neg R] [Add R] [Zero R] [IsAddComm R] [IsAddNeg R] (x : R) : -x + x = (0 : R) := by
  rw [IsAddComm.add_comm  (-x)]
  rw [IsAddNeg.add_neg]

-- neg_unique	x + y = 0 → y = -x	y + x = 0 → y = -x
proposition neg_unique {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R]
  (x y : R) : x + y = 0 → y = -x := by
  intro h
  rw [IsAddComm.add_comm] at h
  have h2 : y + x + -x = 0 + -x := congrArg (· + -x) h
  rw [IsAddAssoc.add_assoc ] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [IsZeroAdd.zero_add] at h2
  rw [add_zero] at h2
  exact h2

-- | `proposition` | `add_left_cancel` | `x + y = x + z → y = z` | `add_right_cancel` | Z a.3° |
proposition add_left_cancel {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R]
  (x y z : R) : x + y = x + z → y = z := by
  intro h
  have h2 : x + y + -x = x + z + -x := congrArg (· + -x) h
  rw [IsAddComm.add_comm x y] at h2
  rw [IsAddComm.add_comm x z] at h2
  rw [IsAddAssoc.add_assoc ] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [IsAddAssoc.add_assoc ] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [add_zero] at h2
  rw [add_zero] at h2
  exact h2

-- | `proposition` | `add_eq_iff_eq_sub` | `x + a = b ↔ x = b - a` | `a + x = b ↔ x = b - a` | Z a.3° |
proposition add_eq_iff_eq_sub {R : Type u}
  [Add R] [Sub R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R] [IsSubEqAddNeg R]
  (x a b : R) : x + a = b ↔ x = b - a := by
  constructor
  . -- ->
    intro h
    have h2 : x + a + -a = b + -a := congrArg (· + -a) h
    rw [IsAddAssoc.add_assoc] at h2
    rw [IsAddNeg.add_neg] at h2
    rw [add_zero] at h2
    rw [← IsSubEqAddNeg.sub_eq_add_neg] at h2
    exact h2
  . -- <-
    intro h
    have h2 : x + a = b - a + a := congrArg (· + a) h
    rw [IsSubEqAddNeg.sub_eq_add_neg] at h2
    rw [IsAddAssoc.add_assoc] at h2
    rw [IsAddComm.add_comm (-a) a] at h2
    rw [IsAddNeg.add_neg] at h2
    rw [add_zero] at h2
    exact h2

-- | `corollary` | `neg_neg` | `-(-x) = x` | — | — |
corollary neg_neg {R : Type u}
  [Add R] [Sub R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R] [IsSubEqAddNeg R]
  (x : R) : -(-x) = x := by

  have h : -x + x = 0 := neg_add x
  have h2 : x = -(-x) := neg_unique (-x) x h
  exact h2.symm

-- | `corollary` | `neg_zero` | `-0 = 0` | — | — |
corollary neg_zero {R : Type u}
  [Add R] [Zero R] [Neg R] [IsZeroAdd R] [IsAddNeg R] :
  -(0 : R) = 0 := by
  have h : (0 : R) + -0 = 0 := IsAddNeg.add_neg 0
  rw [IsZeroAdd.zero_add] at h
  exact h


-- | `lemma` | `neg_eq_iff_eq_neg` | `-x = y ↔ x = -y` | `neg_inj : -x = -y ↔ x = y` | — |
lemma neg_eq_iff_eq_neg {R : Type u}
  [Add R] [Sub R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R] [IsSubEqAddNeg R]
  (x y : R) : -x = y ↔ x = -y := by
  constructor
  . -- ->
    intro h
    have h2 : -x + x = y + x := congrArg (· + x) h
    rw [IsAddComm.add_comm (-x) x]  at h2
    rw [IsAddNeg.add_neg] at h2
    have h2 : 0 + -y = y + x + -y := congrArg (· + -y) h2
    rw [IsZeroAdd.zero_add] at h2
    rw [<-IsAddComm.add_comm x y]  at h2
    rw [IsAddAssoc.add_assoc] at h2
    rw [IsAddNeg.add_neg] at h2
    rw [add_zero] at h2
    exact h2.symm
  . -- <-
    intro h
    have h2 : -x = -(-y) := congrArg (- ·) h
    rw [neg_neg] at h2
    exact h2





-- | `corollary` | `sub_self` | `x - x = 0` | — | — |
corollary sub_self {R : Type u}
  [Add R] [Neg R] [Sub R]  [Zero R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x : R) : x - x = (0:R) := by
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddNeg.add_neg]

-- | `lemma` | `sub_eq_zero_iff` | `x - y = 0 ↔ x = y` | `sub_ne_zero_iff` | — |
lemma sub_eq_zero_iff {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R]  [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : x - y = 0 ↔ x = y := by
  constructor
  . -- ->
    intro h
    rw [IsSubEqAddNeg.sub_eq_add_neg] at h
    have h2 : x + -y + y = 0 + y := congrArg (· + y) h
    rw [IsAddAssoc.add_assoc] at h2
    rw [neg_add y] at h2
    rw [IsZeroAdd.zero_add] at h2
    rw [add_zero] at h2
    exact h2
  . -- ->
    intro h
    have h2 : x + -y = y + -y := congrArg (· + -y) h
    rw [IsAddNeg.add_neg] at h2
    rw [IsSubEqAddNeg.sub_eq_add_neg]
    exact h2

--| `lemma` | `neg_add_rev` | `-(x + y) = -y + -x` | `neg_add' : -(x + y) = -x + -y` | — |
lemma neg_add_rev {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R]  [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : -(x + y) = -y + -x := by
  have h : (x + y) + -(x + y) = 0 := IsAddNeg.add_neg (x + y)
  have h2 := congrArg ((-y + -x) + ·) h             --Smarter use of congrArg
  rw [<- IsAddAssoc.add_assoc] at h2
  rw [<- IsAddAssoc.add_assoc (-y + -x) x y] at h2
  rw [IsAddAssoc.add_assoc (-y) (-x) x] at h2
  rw [neg_add x] at h2
  rw [add_zero] at h2
  rw [neg_add y] at h2
  rw [IsZeroAdd.zero_add] at h2
  rw [add_zero] at h2
  exact h2

corollary add_neg_eq_sub {R : Type u}
  [Add R] [Neg R] [Sub R] [IsSubEqAddNeg R] (a b : R) :
  a + -b = a - b :=
  (IsSubEqAddNeg.sub_eq_add_neg a b).symm

-- | `lemma` | `neg_sub` | `-(x - y) = y - x` | — | — |
lemma neg_sub {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R]  [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : -(x - y) = y - x := by
  --rw [<-IsAddComm.add_comm y (-x)]
  rw [IsSubEqAddNeg.sub_eq_add_neg x y]
  rw [IsSubEqAddNeg.sub_eq_add_neg y x]
  rw [neg_add_rev]
  rw [neg_neg]

-- | `lemma` | `add_sub_cancel_right` | `x + y - y = x` | `sub_add_cancel : x - y + y = x` | — |
lemma add_sub_cancel_right { R: Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R]  [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : x + y - y = x := by

  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddAssoc.add_assoc]
  rw [IsAddNeg.add_neg]
  rw [add_zero]

-- | `lemma` | `sub_sub` | `x - y - z = x - (y + z)` | `sub_add : x - y + z = x - (y - z)` | — |
lemma sub_sub {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R]  [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y z : R) : x - y - z = x - (y + z) := by
  have h : x = x := rfl
  have h2 : x + -y = x + -y := congrArg (· + -y) h
  have h3 : x + -y + -z = x + (-y + -z) := IsAddAssoc.add_assoc x (-y) (-z)
  rw [add_neg_eq_sub x y] at h3
  rw [add_neg_eq_sub (x - y) z] at h3
  rw [IsAddComm.add_comm (-y) (-z)] at h3
  rw [<- neg_add_rev y z] at h3
  rw [add_neg_eq_sub x (y + z)] at h3
  exact h3







-- 6. Smoke Tests

/-- The mixin projections are found through `extends`. -/
theorem field_smoke_test {F : Type u} [Field F] (a b c : F) :
    a + b + c = a + (b + c) :=
  IsAddAssoc.add_assoc a b c

/-- The `Std.Associative` / `Std.Commutative` bridges let `ac_rfl` work. -/
theorem field_ac_smoke_test {F : Type u} [Field F] (a b c : F) :
    a + b + c = c + (b + a) := by
  ac_rfl

/-- Order mixins are found through the `OrderedField` parents. -/
theorem ordered_field_smoke_test {F : Type u} [OrderedField F] (a : F) :
    a ≤ a :=
  IsLERefl.le_refl a

/-- The decidability of `≤` is found through `OrderedField`. -/
example {F : Type u} [OrderedField F] (a b : F) : Decidable (a ≤ b) :=
  inferInstance

/-- `max` (via core's `Max` class) unfolds to the expected `if`. -/
theorem max_smoke_test {F : Type u} [OrderedField F] (a b : F) :
    max a b = if a ≤ b then b else a :=
  rfl

/-- `abs` is defined through `max`. -/
theorem abs_smoke_test {F : Type u} [OrderedField F] (x : F) :
    abs x = max x (-x) :=
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

end aim.analysis
