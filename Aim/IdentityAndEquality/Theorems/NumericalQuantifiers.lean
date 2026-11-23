import Aim.IdentityAndEquality.Interface.NumericalQuantifiers

/-!
# Numerical Quantifier Theorems

The initial relationship among Tarski's numerical quantifiers. Its proof uses
classical logic but requires no additional law of identity.
-/

namespace Aim

universe u

variable {X : Sort u}

/-- At least two objects satisfy `P` exactly when it is not true that at most one does. -/
theorem atLeastTwo_iff_not_atMostOne (I : X → X → Prop) (P : X → Prop) :
    AtLeastTwo I P ↔ ¬ AtMostOne I P := by
  sorry

end Aim
