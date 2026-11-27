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
  constructor
  . --
    intro hat hn
    unfold AtLeastTwo at hat
    unfold AtMostOne at hn
    unfold Different at hat
    obtain ⟨x, y, hx, hy, hdiff⟩ := hat
    have hident := hn x y hx hy
    exact hdiff hident
  . --
    intro hnat
    classical
    apply Classical.byContradiction
    intro hnoTwo
    apply hnat
    unfold AtMostOne
    intro x y hx hy
    apply Classical.byContradiction
    intro hdiff
    have hatleast : AtLeastTwo I P := ⟨x, y, hx, hy, hdiff⟩
    exact hnoTwo hatleast

end Aim
