import Aim.NumberSystems.NaturalNumbers.NaturalNumbers
import Mathlib.Data.Nat.Basic

/-!
# Natural Number Validation

Smoke tests showing that the Aim `LeanNat` construction is the natural-number
type used by Lean and Mathlib.
-/

namespace AimMathlibValidation.NaturalNumbers

open Aim.NumberSystems.NaturalNumbers.Constructions

/-- Regard the Aim Lean-natural construction as Lean/Mathlib's `Nat`. -/
def toMathlib (n : LeanNat) : Nat :=
  n

/-- Regard Lean/Mathlib's `Nat` as the Aim Lean-natural construction. -/
def fromMathlib (n : Nat) : LeanNat :=
  n

theorem fromMathlib_toMathlib (n : LeanNat) :
    fromMathlib (toMathlib n) = n := by
  rfl

theorem toMathlib_fromMathlib (n : Nat) :
    toMathlib (fromMathlib n) = n := by
  rfl

theorem toMathlib_zero :
    toMathlib (0 : LeanNat) = 0 := by
  rfl

theorem toMathlib_succ (n : LeanNat) :
    toMathlib (Aim.NumberSystems.NaturalNumbers.succ n) =
      Nat.succ (toMathlib n) := by
  rfl

end AimMathlibValidation.NaturalNumbers
