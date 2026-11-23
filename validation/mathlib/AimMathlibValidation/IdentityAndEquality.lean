import Aim.IdentityAndEquality.IdentityAndEquality

/-!
# Identity and Equality Validation

The project-owned constructions agree with the identity proposition used by
Lean and Mathlib.
-/

namespace AimMathlibValidation.IdentityAndEquality

open Aim.IdentityAndEquality.Constructions

universe u

theorem inductiveEquality_iff_eq {X : Sort u} {x y : X} :
    InductiveEquality.MetaEq x y ↔ x = y := by
  constructor
  · intro h
    cases h
    rfl
  · intro h
    cases h
    exact InductiveEquality.MetaEq.refl x

theorem leibnizEquality_iff_eq {X : Sort u} {x y : X} :
    LeibnizEquality.LeibEq x y ↔ x = y := by
  constructor
  · intro h
    exact h (fun z => x = z) rfl
  · intro h
    cases h
    intro P hx
    exact hx

theorem leanEquality_iff_eq {X : Sort u} {x y : X} :
    LeanEquality.LeanEq x y ↔ x = y := by
  rfl

end AimMathlibValidation.IdentityAndEquality
