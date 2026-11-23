import Aim.NumberSystems.NaturalNumbers.Interface.NaturalNumbers
import Aim.NumberSystems.NaturalNumbers.Constructions.LeanNat.LeanNat

/-!
# Lean Natural Numbers Satisfy the Interface
-/

namespace Aim.NumberSystems.NaturalNumbers.Constructions.LeanNat.Satisfies

open Aim.NumberSystems.NaturalNumbers.Constructions

/-- Lean's `Nat` construction satisfies the project natural-number interface. -/
instance : Aim.NumberSystems.NaturalNumbers LeanNat where
  ofNat := Nat.zero
  succ := Nat.succ

  zero_not_succ := by
    sorry

  succ_injective := by
    sorry

  induction := by
    sorry

end Aim.NumberSystems.NaturalNumbers.Constructions.LeanNat.Satisfies
