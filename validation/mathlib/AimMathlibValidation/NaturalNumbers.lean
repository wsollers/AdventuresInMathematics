import Aim.NumberSystems.NaturalNumbers.NaturalNumbersAggregator
import Mathlib.Data.Nat.Basic

/-!
# Natural Number Validation

Smoke tests showing that the `Aim.LeanNat` construction is the natural-number
type used by Lean and Mathlib.
-/

namespace AimMathlibValidation.NaturalNumbers

/-- Regard the Aim Lean-natural construction as Lean/Mathlib's `Nat`. -/
def toMathlib (n : Aim.LeanNat) : Nat :=
  n

/-- Regard Lean/Mathlib's `Nat` as the Aim Lean-natural construction. -/
def fromMathlib (n : Nat) : Aim.LeanNat :=
  n

theorem fromMathlib_toMathlib (n : Aim.LeanNat) :
    fromMathlib (toMathlib n) = n := by
  rfl

theorem toMathlib_fromMathlib (n : Nat) :
    toMathlib (fromMathlib n) = n := by
  rfl

theorem toMathlib_zero :
    toMathlib (0 : Aim.LeanNat) = 0 := by
  rfl

theorem toMathlib_succ (n : Aim.LeanNat) :
    toMathlib (Aim.succ n) =
      Nat.succ (toMathlib n) := by
  rfl

end AimMathlibValidation.NaturalNumbers
