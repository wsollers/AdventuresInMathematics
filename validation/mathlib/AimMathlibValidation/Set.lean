import Aim.SetTheory.Interface.Set
import Mathlib.Data.Set.Basic

/-!
# Set Validation

A smoke test showing that `Aim.Set` and Mathlib's `Set` share the predicate
representation.
-/

namespace AimMathlibValidation.Set

universe u

/-- Regard a project set as a Mathlib set. -/
def toMathlib {X : Type u} (S : Aim.Set X) : _root_.Set X :=
  S

/-- Regard a Mathlib set as a project set. -/
def fromMathlib {X : Type u} (S : _root_.Set X) : Aim.Set X :=
  S

theorem fromMathlib_toMathlib {X : Type u} (S : Aim.Set X) :
    fromMathlib (toMathlib S) = S := by
  rfl

theorem toMathlib_fromMathlib {X : Type u} (S : _root_.Set X) :
    toMathlib (fromMathlib S) = S := by
  rfl

end AimMathlibValidation.Set
