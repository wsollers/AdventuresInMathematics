import Aim.IdentityAndEquality.Interface.Identity
import Aim.IdentityAndEquality.Constructions.InductiveEquality.InductiveEquality

/-!
# Inductive Equality Satisfies Identity
-/

namespace Aim.IdentityAndEquality.Constructions.InductiveEquality

universe u

namespace MetaEq

variable {X Y : Sort u} {x y z : X}

/-- Substitute identical objects into any property. -/
theorem subst {P : X → Prop} (h : MetaEq x y) (hx : P x) : P y := by
  cases h
  exact hx

theorem symm (h : MetaEq x y) : MetaEq y x :=
  match h with
    | .refl _ => .refl x

theorem trans (hxy : MetaEq x y) (hyz : MetaEq y z) : MetaEq x z :=
  match hxy, hyz with
    | .refl _, .refl _ => .refl x

theorem congrArg (f : X → Y) (h : MetaEq x y) : MetaEq (f x) (f y) :=
  match h with
    | .refl _ => .refl (f x)

end MetaEq

/-- Inductive equality satisfies the project identity interface. -/
instance {X : Sort u} : Aim.Identity (@MetaEq X) where
  leibniz := by
    sorry

end Aim.IdentityAndEquality.Constructions.InductiveEquality
