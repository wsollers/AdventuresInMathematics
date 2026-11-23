/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Fields

Each algebraic axiom is its own `Prop`-valued class ("mixin"). `Field` extends
those mixins directly, so Lean generates the projection instances
automatically.

The associativity and commutativity mixins are bridged to core Lean's
`Std.Associative` / `Std.Commutative` so that `ac_rfl` works on fields.
-/

namespace Aim

universe u

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

-- 1a. Field bundle and derived operations

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

-- Other Arithmetic on F
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
    a - b = a + -b := by
  rfl

/-- Addition of a negation is subtraction. -/
corollary add_neg_eq_sub {R : Type u}
    [Add R] [Neg R] [Sub R] [IsSubEqAddNeg R] (a b : R) :
    a + -b = a - b := by
  have h : a - b = a + -b := IsSubEqAddNeg.sub_eq_add_neg a b
  exact h.symm

lemma div_eq_mul_inv {F : Type u} [Field F] (a b : F) :
    a / b = a * b⁻¹ := by
  rfl

/-- Multiplication by an inverse is division. -/
corollary mul_inv_eq_div {R : Type u}
    [Mul R] [Inv R] [Div R] [IsDivEqMulInv R] (a b : R) :
    a * b⁻¹ = a / b := by
  rw [IsDivEqMulInv.div_eq_mul_inv]

instance {F : Type u} [Field F] : IsSubEqAddNeg F := ⟨fun _ _ => rfl⟩
instance {F : Type u} [Field F] : IsDivEqMulInv F := ⟨fun _ _ => rfl⟩

-- 1b. Equality / Reflexivity

/-- Reflexivity of equality as a named theorem (`x = x`). -/
theorem identity {R : Type u} (x : R) : x = x := by
  rfl

-- 1c. Addition & Subtraction (Identities, Inverses, Cancellation)

-- | `add_zero` | `x + 0 = x` | `zero_add` (ax) | Z a |
corollary add_zero {R : Type u}
  [Zero R] [Add R] [IsZeroAdd R] [IsAddComm R] (x : R) : x + 0 = x := by
  rw [IsAddComm.add_comm x]
  rw [IsZeroAdd.zero_add]

-- | `zero_add` | `0 + x = x` | `zero_add` (ax) | Z a |
corollary zero_add {R : Type u}
  [Zero R] [Add R] [IsZeroAdd R] [IsAddComm R] (x : R) : 0 + x = x := by
  rw [IsAddComm.add_comm]
  rw [add_zero]

-- | `zero_unique` (left) | `(∀ x, z + x = x) → z = 0` | `(∀ x, x + z = x) → z = 0` | Z a.1° |
proposition zero_unique {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddComm R] (z : R) : (∀ x, z + x = x) → z = 0 := by
  intro h
  have hx0 := h 0
  rw [add_zero] at hx0
  exact hx0

-- | `zero_unique_right` | `(∀ x, x + z = x) → z = 0` | `zero_unique` | Z a.1° |
proposition zero_unique_right {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddComm R] (z : R) : (∀ x, x + z = x) → z = 0 := by
  intro h
  have hx0 := h 0
  rw [zero_add] at hx0
  exact hx0

-- | `neg_add` | `-x + x = 0` | `add_neg` (ax) | — |
corollary neg_add {R : Type u} [Neg R] [Add R] [Zero R] [IsAddComm R] [IsAddNeg R] (x : R) : -x + x = (0 : R) := by
  rw [IsAddComm.add_comm (-x)]
  rw [IsAddNeg.add_neg]

-- | `neg_unique` (right) | `x + y = 0 → y = -x` | `y + x = 0 → y = -x` | — |
proposition neg_unique {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R]
  (x y : R) : x + y = 0 → y = -x := by
  intro h
  rw [IsAddComm.add_comm] at h
  have h2 : y + x + -x = 0 + -x := congrArg (· + -x) h
  rw [IsAddAssoc.add_assoc] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [IsZeroAdd.zero_add] at h2
  rw [add_zero] at h2
  exact h2

-- | `neg_unique_left` | `y + x = 0 → y = -x` | `neg_unique` | — |
proposition neg_unique_left {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R]
  (x y : R) : y + x = 0 → y = -x := by
  intro h
  have h2 : y + x + -x = 0 + -x := congrArg (· + -x) h
  rw [IsAddAssoc.add_assoc] at h2
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
  rw [IsAddAssoc.add_assoc] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [IsAddAssoc.add_assoc] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [add_zero] at h2
  rw [add_zero] at h2
  exact h2

-- | `proposition` | `add_right_cancel` | `y + x = z + x → y = z` | `add_left_cancel` | Z a.3° |
proposition add_right_cancel {R : Type u}
  [Add R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R]
  (x y z : R) : y + x = z + x → y = z := by
  intro h
  have h2 : y + x + -x = z + x + -x := congrArg (· + -x) h
  rw [IsAddAssoc.add_assoc] at h2
  rw [IsAddNeg.add_neg] at h2
  rw [IsAddAssoc.add_assoc] at h2
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

-- | `proposition` | `add_eq_iff_eq_sub_left` | `a + x = b ↔ x = b - a` | `add_eq_iff_eq_sub` | Z a.3° |
proposition add_eq_iff_eq_sub_left {R : Type u}
  [Add R] [Sub R] [Zero R] [IsZeroAdd R] [IsAddAssoc R] [IsAddComm R] [Neg R] [IsAddNeg R] [IsSubEqAddNeg R]
  (a x b : R) : a + x = b ↔ x = b - a := by
  constructor
  . -- ->
    intro h
    rw [IsAddComm.add_comm a x] at h
    have h2 : x + a + -a = b + -a := congrArg (· + -a) h
    rw [IsAddAssoc.add_assoc] at h2
    rw [IsAddNeg.add_neg] at h2
    rw [add_zero] at h2
    rw [add_neg_eq_sub] at h2
    exact h2
  . -- <-
    intro h
    rw [IsSubEqAddNeg.sub_eq_add_neg] at h
    have h2 : x + a = b + -a + a := congrArg (· + a) h
    rw [IsAddAssoc.add_assoc] at h2

    rw [IsAddComm.add_comm (-a) a] at h2
    rw [IsAddNeg.add_neg] at h2
    rw [add_zero] at h2
    rw [IsAddComm.add_comm x a] at h2
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
    rw [IsAddComm.add_comm (-x) x] at h2
    rw [IsAddNeg.add_neg] at h2
    have h2 : 0 + -y = y + x + -y := congrArg (· + -y) h2
    rw [IsZeroAdd.zero_add] at h2
    rw [<-IsAddComm.add_comm x y] at h2
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
  [Add R] [Neg R] [Sub R] [Zero R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x : R) : x - x = (0:R) := by
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddNeg.add_neg]

-- | `lemma` | `sub_eq_zero_iff` | `x - y = 0 ↔ x = y` | `sub_ne_zero_iff` | — |
lemma sub_eq_zero_iff {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
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

-- | `lemma` | `neg_add_rev` | `-(x + y) = -y + -x` | `neg_add' : -(x + y) = -x + -y` | — |
lemma neg_add_rev {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : -(x + y) = -y + -x := by
  have h : (x + y) + -(x + y) = 0 := IsAddNeg.add_neg (x + y)
  have h2 := congrArg ((-y + -x) + ·) h
  rw [<- IsAddAssoc.add_assoc] at h2
  rw [<- IsAddAssoc.add_assoc (-y + -x) x y] at h2
  rw [IsAddAssoc.add_assoc (-y) (-x) x] at h2
  rw [neg_add x] at h2
  rw [add_zero] at h2
  rw [neg_add y] at h2
  rw [IsZeroAdd.zero_add] at h2
  rw [add_zero] at h2
  exact h2

-- | `lemma` | `neg_sub` | `-(x - y) = y - x` | — | — |
lemma neg_sub {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : -(x - y) = y - x := by
  rw [IsSubEqAddNeg.sub_eq_add_neg x y]
  rw [IsSubEqAddNeg.sub_eq_add_neg y x]
  rw [neg_add_rev]
  rw [neg_neg]

-- | `lemma` | `add_sub_cancel_right` | `x + y - y = x` | `add_sub_cancel_left` | — |
lemma add_sub_cancel_right {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : x + y - y = x := by
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddAssoc.add_assoc]
  rw [IsAddNeg.add_neg]
  rw [add_zero]

-- | `lemma` | `add_sub_cancel_left` | `y + x - y = x` | `add_sub_cancel_right` | — |
lemma add_sub_cancel_left {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : y + x - y = x := by
  rw [IsAddComm.add_comm y x]
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddAssoc.add_assoc]
  rw [IsAddNeg.add_neg]
  rw [add_zero]

-- | `lemma` | `sub_add_cancel_right` | `x - y + y = x` | `sub_add_cancel_left` | — |
lemma sub_add_cancel_right {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : x - y + y = x := by
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [IsAddAssoc.add_assoc]
  rw [neg_add]
  rw [add_zero]


-- | `lemma` | `sub_add_cancel_left` | `y + (x - y) = x` | `sub_add_cancel_right` | — |
lemma sub_add_cancel_left {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
  (x y : R) : y + (x - y) = x := by
  rw [IsSubEqAddNeg.sub_eq_add_neg]
  rw [<-IsAddAssoc.add_assoc]
  rw [IsAddComm.add_comm y x]
  rw [IsAddAssoc.add_assoc]
  rw [IsAddNeg.add_neg]
  rw [add_zero]

-- | `lemma` | `sub_sub` | `x - y - z = x - (y + z)` | `sub_add : x - y + z = x - (y - z)` | — |
lemma sub_sub {R : Type u}
  [Add R] [IsAddComm R] [IsAddAssoc R] [Neg R] [Sub R] [Zero R] [IsZeroAdd R] [IsSubEqAddNeg R] [IsAddNeg R]
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

-- 1d. Multiplication & Division (Identities, Inverses, Cancellation, Distributivity)

-- | `corollary` | `mul_one` | `x * 1 = x` | `one_mul` (ax) | Z b |
corollary mul_one {R : Type u}
  [One R] [Mul R] [IsOneMul R] [IsMulComm R]
  (x : R) : x * 1 = x := by
  rw [IsMulComm.mul_comm x]
  rw [IsOneMul.one_mul]

-- | `proposition` | `one_unique` (right) | `(∀ x, x * e = x) → e = 1` | `one_unique_left` | Z b.1° |
proposition one_unique {R : Type u}
  [One R] [Mul R] [IsOneMul R]
  (e : R) : (∀ x, x * e = x) → e = 1 := by
  intro h
  have hx1 := h 1
  rw [IsOneMul.one_mul] at hx1
  exact hx1

-- | `proposition` | `one_unique_left` | `(∀ x, e * x = x) → e = 1` | `one_unique` | Z b.1° |
proposition one_unique_left {R : Type u}
  [One R] [Mul R] [IsOneMul R] [IsMulComm R]
  (e : R) : (∀ x, e * x = x) → e = 1 := by
  intro h
  have hx1 := h 1
  rw [mul_one] at hx1
  exact hx1

-- | `corollary` | `inv_mul_cancel` | `x ≠ 0 → x⁻¹ * x = 1` | `mul_inv_cancel` (ax) | — |
corollary inv_mul_cancel {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [IsMulInvCancel R] [IsMulComm R]
  (x : R) : x ≠ 0 → x⁻¹ * x = 1 := by
  intro hne0
  rw [IsMulComm.mul_comm]
  rw [IsMulInvCancel.mul_inv_cancel]
  exact hne0

-- | `proposition` | `inv_unique` (right) | `x ≠ 0 → x * y = 1 → y = x⁻¹` | `inv_unique_left` | Z b.2° |
proposition inv_unique {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R]
  (x y : R) : x ≠ 0 → x * y = 1 → y = x⁻¹ := by
  intro hne0
  intro hxy
  have h2 : x⁻¹ * (x * y) = x⁻¹ * 1 := congrArg (x⁻¹ * ·) hxy
  rw [<-IsMulAssoc.mul_assoc] at h2
  rw [inv_mul_cancel x hne0] at h2
  rw [IsOneMul.one_mul] at h2
  rw [mul_one] at h2
  exact h2

-- | `proposition` | `inv_unique_left` | `x ≠ 0 → y * x = 1 → y = x⁻¹` | `inv_unique` | Z b.2° |
proposition inv_unique_left {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R]
  (x y : R) : x ≠ 0 → y * x = 1 → y = x⁻¹ := by
  intro hxne0
  intro h2
  have h3 : (y * x) * x⁻¹ = 1 * x⁻¹ := congrArg (· * x⁻¹) h2
  rw [IsMulAssoc.mul_assoc] at h3
  rw [IsMulComm.mul_comm x x⁻¹] at h3
  rw [inv_mul_cancel x hxne0] at h3
  rw [mul_one] at h3
  rw [IsOneMul.one_mul] at h3
  exact h3

-- | `proposition` | `mul_left_cancel` | `x ≠ 0 → x * y = x * z → y = z` | `mul_right_cancel` | Z b.3° |
proposition mul_left_cancel {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R]
  (x y z : R) : x ≠ 0 → x * y = x * z → y = z := by
  intro hxne0
  intro hxy
  have h2 : x⁻¹ * (x * y) = x⁻¹ * (x * z) := congrArg (x⁻¹ * ·) hxy
  rw [<-IsMulAssoc.mul_assoc] at h2
  rw [inv_mul_cancel x hxne0] at h2
  rw [IsOneMul.one_mul] at h2
  rw [<-IsMulAssoc.mul_assoc] at h2
  rw [IsMulComm.mul_comm] at h2
  rw [inv_mul_cancel x hxne0] at h2
  rw [mul_one] at h2
  exact h2

-- | `proposition` | `mul_right_cancel` | `x ≠ 0 → y * x = z * x → y = z` | `mul_left_cancel` | Z b.3° |
proposition mul_right_cancel {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R]
  (x y z : R) : x ≠ 0 → y * x = z * x → y = z := by
  intro hxne0
  intro hxy
  apply mul_left_cancel x y z hxne0
  rw [IsMulComm.mul_comm x y, IsMulComm.mul_comm x z]
  exact hxy

-- | `lemma` | `mul_div_cancel_right` | `y ≠ 0 → x * y / y = x` | `mul_div_cancel_left` | — |
lemma mul_div_cancel_right {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [Div R]
  [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R] [IsDivEqMulInv R]
  (x y : R) (hy : y ≠ 0) : x * y / y = x := by
  rw [IsDivEqMulInv.div_eq_mul_inv]
  rw [IsMulAssoc.mul_assoc]
  rw [IsMulInvCancel.mul_inv_cancel y hy]
  rw [mul_one]

-- | `lemma` | `mul_div_cancel_left` | `y ≠ 0 → y * x / y = x` | `mul_div_cancel_right` | — |
lemma mul_div_cancel_left {R : Type u}
    [Zero R] [One R] [Mul R] [Inv R] [Div R]
    [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R]
    [IsOneMul R] [IsDivEqMulInv R]
    (x y : R) (hy : y ≠ 0) : y * x / y = x := by
  rw [IsMulComm.mul_comm y x]
  rw [IsDivEqMulInv.div_eq_mul_inv]
  rw [IsMulAssoc.mul_assoc]
  rw [IsMulInvCancel.mul_inv_cancel y hy]
  rw [mul_one]

-- | `lemma` | `div_mul_cancel_right` | `y ≠ 0 → x / y * y = x` | `div_mul_cancel_left` | — |
lemma div_mul_cancel_right {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [Div R]
  [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R] [IsDivEqMulInv R]
  (x y : R) (hy : y ≠ 0) : x / y * y = x := by
  rw [IsDivEqMulInv.div_eq_mul_inv]
  rw [IsMulAssoc.mul_assoc]
  rw [IsMulComm.mul_comm y⁻¹ y]
  rw [IsMulInvCancel.mul_inv_cancel y hy]
  rw [mul_one]

-- | `lemma` | `div_mul_cancel_left` | `y ≠ 0 → y * (x / y) = x` | `div_mul_cancel_right` | — |
lemma div_mul_cancel_left {R : Type u}
  [Zero R] [One R] [Mul R] [Inv R] [Div R]
  [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R] [IsDivEqMulInv R]
  (x y : R) (hy : y ≠ 0) : y * (x / y) = x := by
  rw [IsDivEqMulInv.div_eq_mul_inv]
  rw [<-IsMulAssoc.mul_assoc]
  rw [IsMulComm.mul_comm y x]
  rw [IsMulAssoc.mul_assoc]
  rw [IsMulInvCancel.mul_inv_cancel y hy]
  rw [mul_one]

-- | `proposition` | `mul_eq_iff_eq_div` (left) | `a ≠ 0 → (a * x = b ↔ x = b / a)` | `mul_eq_iff_eq_div_right` | Z b.3° |
proposition mul_eq_iff_eq_div {R : Type u}
  [Zero R] [One R] [Mul R] [Div R] [Inv R]
  [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R] [IsDivEqMulInv R]
  (a x b : R) : a ≠ 0 → (a * x = b ↔ x = b / a) := by
  intro hane0
  constructor
  . -- .->
    intro h
    have h2 : a * x / a = b / a := congrArg (· / a) h
    rw [IsDivEqMulInv.div_eq_mul_inv] at h2
    rw [IsMulComm.mul_comm a x] at h2
    rw [IsMulAssoc.mul_assoc] at h2
    rw [IsMulInvCancel.mul_inv_cancel a hane0] at h2
    rw [mul_one] at h2
    exact h2
  . -- <-
    intro h
    have h2 : a * x = a * (b / a) := congrArg (fun t => a * t) h
    rw [div_mul_cancel_left b a hane0] at h2
    exact h2

-- | `proposition` | `mul_eq_iff_eq_div_right` | `a ≠ 0 → (x * a = b ↔ x = b / a)` | `mul_eq_iff_eq_div` | Z b.3° |
proposition mul_eq_iff_eq_div_right {R : Type u}
  [Zero R] [One R] [Mul R] [Div R] [Inv R] [IsDivEqMulInv R]
  [IsMulInvCancel R] [IsMulComm R] [IsMulAssoc R] [IsOneMul R] [IsDivEqMulInv R]
  (a x b : R) : a ≠ 0 → (x * a = b ↔ x = b / a) := by
  intro hane0
  constructor
  . -- ->
    intro hxa
    have h2 : x * a * a⁻¹ = b * a⁻¹ := congrArg (· * a⁻¹) hxa
    rw [IsMulAssoc.mul_assoc] at h2
    rw [IsMulInvCancel.mul_inv_cancel a hane0] at h2
    rw [mul_one] at h2
    rw [mul_inv_eq_div b a] at h2
    exact h2
  . -- <-
    intro h
    have h2 : x * a = b / a * a := congrArg (· * a) h
    rw [IsDivEqMulInv.div_eq_mul_inv b a] at h2
    rw [IsMulAssoc.mul_assoc] at h2
    rw [inv_mul_cancel a hane0] at h2
    rw [mul_one] at h2
    exact h2


-- | `corollary` | `add_mul` | `(a + b) * c = a * c + b * c` | `mul_add` (ax) | — |
corollary add_mul {R : Type u}
  [Add R] [Mul R] [IsMulComm R] [IsMulAdd R]
  (a b c : R) : (a + b) * c = a * c + b * c := by
  rw [IsMulComm.mul_comm]
  rw [IsMulAdd.mul_add]
  rw [IsMulComm.mul_comm]
  rw [IsMulComm.mul_comm b c]

/-- Multiplication by zero gives zero. -/
proposition mul_zero {F : Type u} [Field F] (a : F) : a * 0 = 0 := by
  have hdist := IsMulAdd.mul_add a (0 : F) 0
  have hdist := hdist.symm
  rw [IsZeroAdd.zero_add] at hdist
  have h2 := congrArg (fun x => -(a * 0) + x) hdist
  rw [← IsAddAssoc.add_assoc] at h2
  rw [neg_add (a * 0)] at h2
  rw [IsZeroAdd.zero_add] at h2
  exact h2

/-- Zero multiplied by any element is zero. -/
proposition zero_mul {F : Type u} [Field F] (a : F) : 0 * a = 0 := by
  rw [IsMulComm.mul_comm]
  exact mul_zero a

/-- A negated left factor negates the product. -/
lemma neg_mul {F : Type u} [Field F] (a b : F) : (-a) * b = -(a * b) := by
  have h : b * 0 = 0 := mul_zero b
  nth_rewrite 1 [← IsAddNeg.add_neg a] at h
  rw [IsMulAdd.mul_add] at h
  have h2 := congrArg (fun x => -(b * a) + x) h
  rw [← IsAddAssoc.add_assoc] at h2
  rw [add_zero] at h2
  rw [neg_add (b * a)] at h2
  rw [zero_add] at h2
  rw [IsMulComm.mul_comm] at h2
  nth_rewrite 2 [IsMulComm.mul_comm] at h2
  exact h2

/-- A negated right factor negates the product. -/
lemma mul_neg {F : Type u} [Field F] (a b : F) : a * (-b) = -(a * b) := by
  rw [IsMulComm.mul_comm]
  nth_rewrite 2 [IsMulComm.mul_comm]
  rw [neg_mul b a]

/-- Multiplication distributes over subtraction on the right. -/
lemma mul_sub {F : Type u} [Field F] (a b c : F) :
    a * (b - c) = a * b - a * c := by
  rw [sub_eq_add_neg b c]
  rw [IsMulAdd.mul_add]
  rw [mul_neg]
  rw [sub_eq_add_neg (a * b) (a * c)]

/-- Multiplication distributes over subtraction on the left. -/
lemma sub_mul {F : Type u} [Field F] (a b c : F) :
    (a - b) * c = a * c - b * c := by
  rw [IsMulComm.mul_comm]
  nth_rewrite 2 [IsMulComm.mul_comm]
  nth_rewrite 3 [IsMulComm.mul_comm]
  rw [mul_sub  c a b]

/-- The inverse of a nonzero element is nonzero. -/
lemma inv_ne_zero {F : Type u} [Field F] {a : F}
    (ha : a ≠ 0) : a⁻¹ ≠ 0 := by
  intro h
  have h2 : a * a⁻¹ = a * 0 :=
    congrArg (fun x => a * x) h
  rw [mul_zero] at h2
  rw [IsMulInvCancel.mul_inv_cancel a ha] at h2
  have h3 : (0 : F) = 1 := h2.symm
  have c := IsZeroNeOne.zero_ne_one h3
  exact c
-- 1d'. Further field statements to translate and prove
--
-- Throughout, `F` is a field and `x`, `y`, `z` are elements of `F`.

/-
`mul_eq_zero_iff`  (a field has no zero divisors)

A product is zero if and only if at least one of its factors is zero.

  ∀ x y : F,  x * y = 0 ↔ x = 0 ∨ y = 0
-/

/-
`add_div`

Division distributes over addition in the numerator.

  ∀ x y z : F,  (x + y) / z = x / z + y / z

No hypothesis `z ≠ 0` is needed: division is multiplication by the inverse,
so the identity is an instance of distributivity.
-/

-- 1e. Smoke tests

/-- The mixin projections are found through `extends`. -/
theorem field_smoke_test {F : Type u} [Field F] (a b c : F) :
    a + b + c = a + (b + c) := by
  exact IsAddAssoc.add_assoc a b c

/-- The `Std.Associative` / `Std.Commutative` bridges let `ac_rfl` work. -/
theorem field_ac_smoke_test {F : Type u} [Field F] (a b c : F) :
    a + b + c = c + (b + a) := by
  ac_rfl

end Aim
