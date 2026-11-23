import Aim.PeanoSystem.Interface.PeanoSystem

/-!
# Natural Number Interface

The natural numbers are a Peano system whose base element is called `0`.

Reading: Landau, *Foundations of Analysis*, Chapter 1. Landau's natural
numbers start at 1; see `Aim/NumberSystems/READINGS.MD`.
-/

namespace Aim

universe u

/-- A zero-based Peano system: the base element is written `0`. -/
class NaturalNumbers (N : Type u) extends PeanoSystem N

namespace NaturalNumbers

variable {N : Type u} [NaturalNumbers N]

/-- The numeral `0` is the base element. -/
instance : OfNat N 0 :=
  ⟨PeanoSystem.base⟩

/-- `0` is the base element of the underlying Peano system. -/
theorem zero_eq_base : (0 : N) = PeanoSystem.base := by
  rfl

/-- Zero is not a successor. -/
theorem zero_not_succ (n : N) : (0 : N) ≠ succ n := by
  show PeanoSystem.base ≠ succ n
  exact PeanoSystem.base_not_succ n

/-- Induction, stated with `0`. -/
theorem zero_induction (P : N → Prop)
    (zero : P 0) (step : ∀ n, P n → P (succ n)) : ∀ n, P n := by
  apply PeanoSystem.induction P
  · show P PeanoSystem.base
    exact zero
  · exact step

end NaturalNumbers

end Aim
