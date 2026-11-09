/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

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

/-- Subtraction, defined as addition of the negation. -/
instance {F : Type u} [Field F] : Sub F :=
  ⟨fun a b => a + -b⟩

/-- Division, defined as multiplication by the inverse. -/
instance {F : Type u} [Field F] : Div F :=
  ⟨fun a b => a * b⁻¹⟩

theorem sub_eq_add_neg {F : Type u} [Field F] (a b : F) :
    a - b = a + -b :=
  rfl

theorem div_eq_mul_inv {F : Type u} [Field F] (a b : F) :
    a / b = a * b⁻¹ :=
  rfl

/-- A field equipped with a compatible linear order. -/
class OrderedField (F : Type u)
    extends Field F, LE F, LT F,
      IsLERefl F, IsLETrans F, IsLEAntisymm F, IsLETotal F,
      IsLTIffLENotLE F,
      IsAddLEAddRight F, IsMulPos F

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

end aim.analysis
