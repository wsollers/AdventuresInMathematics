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
      intro P
      have hhh := hleib P
      intro hpy
      have hImp : P y → P x :=
        hleib (fun z => P z → P x) (fun hPx => hPx)
      have hpx := hImp hpy
      exact hpx
    . --
      intro P px
      have hpp := hleib P
      have hImp : P y → P x :=
        hleib (fun z => P z → P x) (fun hPx => hPx)
      have hpx := hpp px
      exact hpx
   . --
    intro hm
    intro P
    intro px
    obtain ⟨j,k⟩ := hm
    have hpy := k P
    have py := hpy px
    exact py

end Aim.IdentityAndEquality.Constructions.LeibnizEquality
