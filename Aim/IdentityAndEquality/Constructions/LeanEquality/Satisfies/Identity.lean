import Aim.IdentityAndEquality.Interface.Identity
import Aim.IdentityAndEquality.Constructions.LeanEquality.LeanEquality

/-!
# Lean Equality Satisfies Identity
-/

namespace Aim.IdentityAndEquality.Constructions.LeanEquality

universe u

/-- Lean's kernel equality satisfies the project identity interface. -/
instance {X : Sort u} : Aim.Identity (@LeanEq X) where
  leibniz := by
    sorry

end Aim.IdentityAndEquality.Constructions.LeanEquality
