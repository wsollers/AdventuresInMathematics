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

theorem symm (h : MetaEq x y) : MetaEq y x := by
  cases h
  exact MetaEq.refl x

theorem trans (hxy : MetaEq x y) (hyz : MetaEq y z) : MetaEq x z := by
  cases hxy
  cases hyz
  exact MetaEq.refl x

theorem congrArg (f : X → Y) (h : MetaEq x y) : MetaEq (f x) (f y) := by
  cases h
  exact MetaEq.refl (f x)

end MetaEq

/-- Inductive equality satisfies the project identity interface. -/
instance {X : Sort u} : Aim.Identity (@MetaEq X) where
  leibniz := by
    intro x y
    constructor
    · --
      intro h
      cases h
      constructor <;> intro P hP <;> exact hP
    · --
      rintro ⟨hyx, hxy⟩
      exact hxy (fun z => MetaEq x z) (MetaEq.refl x)

end Aim.IdentityAndEquality.Constructions.InductiveEquality
