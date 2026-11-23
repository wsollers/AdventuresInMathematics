import Aim.IdentityAndEquality.IdentityAndEquality

/-!
# Metalanguage Equality Compatibility

Compatibility names for the identity constructions now housed in
`Aim.IdentityAndEquality`.
-/

namespace Aim.Meta

universe u

abbrev MetaEq {X : Sort u} : X → X → Prop :=
  Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq

namespace MetaEq

variable {X Y : Sort u} {x y z : X}

theorem subst {P : X → Prop} (h : MetaEq x y) (hx : P x) : P y :=
  Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq.subst h hx

theorem symm (h : MetaEq x y) : MetaEq y x :=
  Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq.symm h

theorem trans (hxy : MetaEq x y) (hyz : MetaEq y z) : MetaEq x z :=
  Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq.trans hxy hyz

theorem congrArg (f : X → Y) (h : MetaEq x y) : MetaEq (f x) (f y) :=
  Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq.congrArg f h

end MetaEq

abbrev LeibEq {X : Sort u} : X → X → Prop :=
  Aim.IdentityAndEquality.Constructions.LeibnizEquality.LeibEq

/-- Compatibility bridge from inductive equality to Lean identity. -/
theorem metaEq_iff_eq {X : Sort u} {x y : X} : MetaEq x y ↔ x = y := by
  constructor
  · intro h
    cases h
    rfl
  · intro h
    cases h
    exact Aim.IdentityAndEquality.Constructions.InductiveEquality.MetaEq.refl x

/-- Compatibility bridge from Leibniz equality to Lean identity. -/
theorem leibEq_iff_eq {X : Sort u} {x y : X} : LeibEq x y ↔ x = y := by
  constructor
  · intro h
    exact h (fun z => x = z) rfl
  · intro h
    cases h
    intro P hx
    exact hx

end Aim.Meta
