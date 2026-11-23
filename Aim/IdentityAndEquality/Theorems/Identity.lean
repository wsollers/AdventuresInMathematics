import Aim.IdentityAndEquality.Interface.Identity

/-!
# Theorems of Identity

The basic laws Tarski derives from Leibniz's law. Proofs are intentionally
left for the learner.
-/

namespace Aim.Identity

universe u v

variable {X : Sort u} {I : X → X → Prop} [Aim.Identity I]

/-- Two objects are identical exactly when they have every property in common. -/
theorem iff_forall_iff (x y : X) :
    I x y ↔ ∀ P : X → Prop, (P x ↔ P y) := by
  sorry

/-- Identical objects may replace one another in any property. -/
theorem replace {x y : X} (hxy : I x y) (P : X → Prop) :
    P x ↔ P y := by
  sorry

/-- Every object is identical to itself. -/
theorem refl (x : X) : I x x := by
  sorry

/-- Identity is symmetric. -/
theorem symm {x y : X} (hxy : I x y) : I y x := by
  sorry

/-- Identity is transitive. -/
theorem trans {x y z : X} (hxy : I x y) (hyz : I y z) : I x z := by
  sorry

/-- Objects identical to the same object are identical to each other. -/
theorem euclid {x y z : X} (hxz : I x z) (hyz : I y z) : I x y := by
  sorry

/-- Difference is symmetric. -/
theorem different_symm {x y : X} (hxy : Different I x y) : Different I y x := by
  sorry

/-- Any relation satisfying Leibniz's law agrees with Lean's identity. -/
theorem iff_eq (x y : X) : I x y ↔ x = y := by
  sorry

/-- Functions preserve identity between types carrying identity relations. -/
theorem congrArg {Y : Sort v} {J : Y → Y → Prop} [Aim.Identity J]
    (f : X → Y) {x y : X} (hxy : I x y) : J (f x) (f y) := by
  sorry

end Aim.Identity
