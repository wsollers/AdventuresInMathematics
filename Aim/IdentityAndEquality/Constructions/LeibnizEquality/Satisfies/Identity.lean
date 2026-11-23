import Aim.IdentityAndEquality.Interface.Identity
import Aim.IdentityAndEquality.Constructions.LeibnizEquality.LeibnizEquality

/-!
# Leibniz Equality Satisfies Identity
-/

namespace Aim.IdentityAndEquality.Constructions.LeibnizEquality

universe u

/-- Leibniz equality satisfies the project identity interface. -/
instance {X : Sort u} : Aim.Identity (@LeibEq X) where
  leibniz := by
    sorry

end Aim.IdentityAndEquality.Constructions.LeibnizEquality
