import Aim.Set.Interface.Set
import Mathlib.Data.Set.Basic

/-!
# Set Validation

A smoke test showing that `Aim.Set.Set` and Mathlib's `Set` share the predicate
representation.
-/

namespace AimMathlibValidation.Set

universe u

/-- Regard a project set as a Mathlib set. -/
def toMathlib {X : Type u} (s : Aim.Set.Set X) : _root_.Set X :=
  s

/-- Regard a Mathlib set as a project set. -/
def fromMathlib {X : Type u} (s : _root_.Set X) : Aim.Set.Set X :=
  s

theorem fromMathlib_toMathlib {X : Type u} (s : Aim.Set.Set X) :
    fromMathlib (toMathlib s) = s := by
  rfl

theorem toMathlib_fromMathlib {X : Type u} (s : _root_.Set X) :
    toMathlib (fromMathlib s) = s := by
  rfl

end AimMathlibValidation.Set
