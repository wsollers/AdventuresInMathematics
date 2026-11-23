/-!
# Leibniz Equality
-/

namespace Aim.IdentityAndEquality.Constructions.LeibnizEquality

universe u

/-- Two objects are Leibniz-equal when every property of one holds of the other. -/
def LeibEq {X : Sort u} (x y : X) : Prop :=
  ∀ P : X → Prop, P x → P y

end Aim.IdentityAndEquality.Constructions.LeibnizEquality
