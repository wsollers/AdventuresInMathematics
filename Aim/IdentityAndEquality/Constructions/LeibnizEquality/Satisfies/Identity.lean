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
   unfold LeibnizLaw
   intro x y
   constructor
   . --
    intro hleib
    constructor
    . --
      intro p
      have hhh := hleib p
      intro hpy

      sorry
    . --
      intro p px
      sorry
   . --
    intro hm
    intro p
    intro px
    obtain ⟨j,k⟩ := hm
    have hpy := k p
    have py := hpy px
    exact py


end Aim.IdentityAndEquality.Constructions.LeibnizEquality
