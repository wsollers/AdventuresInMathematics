import Aim.NumberSystems.NaturalNumbers.Interface.NaturalNumbers
import Aim.NumberSystems.NaturalNumbers.Constructions.LeanNat.LeanNat

/-!
# Lean Natural Numbers Satisfy the Interface
-/

namespace Aim

/-- Lean's `Nat` construction satisfies the project natural-number interface. -/
instance : NaturalNumbers LeanNat where
  base := Nat.zero
  succ := Nat.succ

  base_not_succ := by
    sorry

  succ_injective := by
    sorry

  induction := by
    sorry

end Aim
