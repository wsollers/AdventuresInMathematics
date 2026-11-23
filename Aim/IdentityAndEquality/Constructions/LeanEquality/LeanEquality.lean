/-!
# Lean Equality
-/

namespace Aim.IdentityAndEquality.Constructions.LeanEquality

universe u

/-- Lean's kernel identity, exposed as a named construction. -/
def LeanEq {X : Sort u} (x y : X) : Prop :=
  x = y

end Aim.IdentityAndEquality.Constructions.LeanEquality
