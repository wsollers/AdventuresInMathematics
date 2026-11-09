/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

/-!
# Numbers in Analysis

Number systems and their properties used throughout real analysis.
-/

namespace aim.analysis

universe u

-- 1. Unstructured Bags of Points (Carriers in the same universe)
variable {N_Carrier : Type u}  -- 1-Based Natural Numbers
variable {W_Carrier : Type u}  -- Whole Numbers
variable {Z_Carrier : Type u}  -- Integers
variable {Q_Carrier : Type u}  -- Rational Numbers
variable {R_Carrier : Type u}  -- Real Numbers
variable {I_Carrier : Type u}  -- Irrational Numbers
variable {T_Carrier : Type u}  -- Transcendental Numbers
variable {C_Carrier : Type u}  -- Complex Numbers
variable {H_Carrier : Type u} -- Quaternion Numbers

-- 2. Algebraic Property Classes

/-- Associativity for an arbitrary binary operation. -/
class IsAssociativeOp {X : Type u} (op : X → X → X) : Prop where
  assoc : ∀ a b c : X, op (op a b) c = op a (op b c)

/-- Commutativity for an arbitrary binary operation. -/
class IsCommutativeOp {X : Type u} (op : X → X → X) : Prop where
  comm : ∀ a b : X, op a b = op b a

/-- Associativity specialized to addition. -/
class IsAddAssoc (X : Type u) [Add X] : Prop
    extends IsAssociativeOp ((· + ·) : X → X → X)

/-- Commutativity specialized to addition. -/
class IsAddComm (X : Type u) [Add X] : Prop
    extends IsCommutativeOp ((· + ·) : X → X → X)

/-- Associativity specialized to multiplication. -/
class IsMulAssoc (X : Type u) [Mul X] : Prop
    extends IsAssociativeOp ((· * ·) : X → X → X)

/-- Commutativity specialized to multiplication. -/
class IsMulComm (X : Type u) [Mul X] : Prop
    extends IsCommutativeOp ((· * ·) : X → X → X)

/-- The additive and multiplicative identities are distinct. -/
class IsZeroNeOne (X : Type u) [Zero X] [One X] : Prop where
  zero_ne_one : (0 : X) ≠ 1

/-- Zero is a left identity for addition. -/
class IsZeroAdd (X : Type u) [Zero X] [Add X] : Prop where
  zero_add : ∀ a : X, 0 + a = a

/-- Negation supplies an additive inverse. -/
class IsAddNeg
    (X : Type u) [Zero X] [Add X] [Neg X] : Prop where
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

-- 3. Subsets / Subtypes Carved Out of R_Carrier
/-- Positive Reals: ℝ⁺ = { x : ℝ // 0 < x } -/
def RPos (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // 0 < x }

/-- Negative Reals: ℝ⁻ = { x : ℝ // x < 0 } -/
def RNeg (R : Type u) [Zero R] [LT R] : Type u :=
  { x : R // x < 0 }

/-- Non-negative Reals: ℝ≥0 = { x : ℝ // 0 ≤ x } (Required for Metric Codomains) -/
def RNonneg (R : Type u) [Zero R] [LE R] : Type u :=
  { x : R // 0 ≤ x }

-- 4. Algebraic and Order Hierarchy
/-- A field, presented independently of Mathlib's hierarchy. -/
class Field (F : Type u)
    extends Zero F, One F, Add F, Mul F, Neg F, Inv F where
  zero_ne_one : IsZeroNeOne F

  add_assoc : IsAddAssoc F
  add_comm : IsAddComm F
  zero_add : IsZeroAdd F
  add_neg : IsAddNeg F

  mul_assoc : IsMulAssoc F
  mul_comm : IsMulComm F
  one_mul : IsOneMul F
  mul_inv_cancel : IsMulInvCancel F

  mul_add : IsMulAdd F

/-- Every field is nonempty, witnessed by zero. -/
instance {F : Type u} [Field F] : Nonempty F :=
  ⟨0⟩

instance {F : Type u} [Field F] : IsZeroNeOne F :=
  Field.zero_ne_one

instance {F : Type u} [Field F] : IsAddAssoc F :=
  Field.add_assoc

instance {F : Type u} [Field F] : IsAddComm F :=
  Field.add_comm

instance {F : Type u} [Field F] : IsZeroAdd F :=
  Field.zero_add

instance {F : Type u} [Field F] : IsAddNeg F :=
  Field.add_neg

instance {F : Type u} [Field F] : IsMulAssoc F :=
  Field.mul_assoc

instance {F : Type u} [Field F] : IsMulComm F :=
  Field.mul_comm

instance {F : Type u} [Field F] : IsOneMul F :=
  Field.one_mul

instance {F : Type u} [Field F] : IsMulInvCancel F :=
  Field.mul_inv_cancel

instance {F : Type u} [Field F] : IsMulAdd F :=
  Field.mul_add

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
class IsLTIffLENotLE
    (X : Type u) [LE X] [LT X] : Prop where
  lt_iff_le_not_le :
    ∀ a b : X, a < b ↔ a ≤ b ∧ ¬b ≤ a

/-- Addition on the right preserves non-strict order. -/
class IsAddLEAddRight
    (X : Type u) [Add X] [LE X] : Prop where
  add_le_add_right :
    ∀ a b : X, a ≤ b → ∀ c : X, a + c ≤ b + c

/-- The product of two positive elements is positive. -/
class IsMulPos
    (X : Type u) [Zero X] [Mul X] [LT X] : Prop where
  mul_pos :
    ∀ a b : X, 0 < a → 0 < b → 0 < a * b

/-- A field equipped with a compatible linear order. -/
class OrderedField (F : Type u)
    extends Field F, LE F, LT F where
  le_refl : IsLERefl F
  le_trans : IsLETrans F
  le_antisymm : IsLEAntisymm F
  le_total : IsLETotal F
  lt_iff_le_not_le : IsLTIffLENotLE F
  add_le_add_right : IsAddLEAddRight F
  mul_pos : IsMulPos F

instance {F : Type u} [OrderedField F] : IsLERefl F :=
  OrderedField.le_refl

instance {F : Type u} [OrderedField F] : IsLETrans F :=
  OrderedField.le_trans

instance {F : Type u} [OrderedField F] : IsLEAntisymm F :=
  OrderedField.le_antisymm

instance {F : Type u} [OrderedField F] : IsLETotal F :=
  OrderedField.le_total

instance {F : Type u} [OrderedField F] : IsLTIffLENotLE F :=
  OrderedField.lt_iff_le_not_le

instance {F : Type u} [OrderedField F] : IsAddLEAddRight F :=
  OrderedField.add_le_add_right

instance {F : Type u} [OrderedField F] : IsMulPos F :=
  OrderedField.mul_pos

/-- `a` is an upper bound for `s`. -/
def IsUpperBound {F : Type u} [LE F]
    (s : F → Prop) (a : F) : Prop :=
  ∀ x : F, s x → x ≤ a

/-- `a` is the least upper bound for `s`. -/
def IsLeastUpperBound {F : Type u} [LE F]
    (s : F → Prop) (a : F) : Prop :=
  IsUpperBound s a ∧
    ∀ b : F, IsUpperBound s b → a ≤ b

/-- Every nonempty set bounded above has a least upper bound. -/
class IsOrderComplete (F : Type u) [LE F] : Prop where
  exists_isLeastUpperBound :
    ∀ s : F → Prop,
      (∃ x : F, s x) →
      (∃ b : F, IsUpperBound s b) →
      ∃ a : F, IsLeastUpperBound s a

/-- A complete ordered field. -/
class CompleteOrderedField (F : Type u)
    extends OrderedField F where
  order_complete : IsOrderComplete F

instance {F : Type u} [CompleteOrderedField F] :
    IsOrderComplete F :=
  CompleteOrderedField.order_complete

/-- Embed a natural number by repeated addition of one. -/
def natCast {F : Type u} [Zero F] [One F] [Add F] : Nat → F
  | 0 => 0
  | n + 1 => natCast n + 1

/-- The Archimedean property as an independent mixin. -/
class ArchimedeanProperty
    (F : Type u) [OrderedField F] : Prop where
  archimedean :
    ∀ x : F, ∃ n : Nat, x < natCast n

-- 5. Metric / Distance Signatures
/-- A distance function maps pairs in X to non-negative reals -/
def Distance (X : Type u) [Zero R_Carrier] [LE R_Carrier] : Type u :=
  X → X → RNonneg R_Carrier

/-- Smoke test for the custom field hierarchy. -/
theorem field_smoke_test {F : Type u} [Field F] (a b c : F) :
    (a + b) + c = a + (b + c) := by
  exact IsAssociativeOp.assoc a b c


end aim.analysis
