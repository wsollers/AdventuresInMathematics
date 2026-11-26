import Aim.IdentityAndEquality.Interface.Identity

/-!
# Theorems of Identity

The basic laws Tarski derives from Leibniz's law. Proofs are intentionally
left for the learner.

Every theorem states its own binders: the type `X`, the candidate identity
relation `I` on it, and the assumption `[Aim.Identity I]` that `I` satisfies
Leibniz's law.
-/

namespace Aim.Identity

universe u v

/-- Two objects are identical exactly when they have every property in common. -/
theorem iff_forall_iff {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x y : X) : I x y ↔ ∀ P : X → Prop, (P x ↔ P y) := by
  constructor
  . --
    intro hi
    intro g
    have hl := hI.leibniz x y
    obtain ⟨hyx, hxy⟩ := hl.mp hi
    constructor
    . --
      intro gx
      exact hxy g gx
    . --
      intro gy
      exact hyx g gy
  . --
    intro h
    have hl := hI.leibniz x y
    apply hl.mpr
    constructor
    . --
      intro g gy
      exact (h g).mpr gy
    . --
      intro g gx
      exact (h g).mp gx

/-- Identical objects may replace one another in any property. -/
theorem replace {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : I x y) (P : X → Prop) : P x ↔ P y := by
  have hl := hI.leibniz x y
  obtain ⟨hp1, hp2⟩ := hl.mp hxy
  constructor
  . --
    have hpx := (hp2 P)
    exact hpx
  . --
    have hpy := (hp1 P)
    exact hpy

/-- Every object is identical to itself. -/
theorem refl {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x : X) : I x x := by
  have hixx := (hI.leibniz x x)

  have ⟨hii, hr⟩ := hixx
  apply hr
  constructor
  . --
    intro f fx
    exact fx
  . --
    intro g gx
    exact gx

/-- Identity is symmetric. -/
theorem symm {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : I x y) : I y x := by
  have hixy := (hI.leibniz x y)
  obntaiu

  sorry

/-- Identity is transitive. -/
theorem trans {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y z : X} (hxy : I x y) (hyz : I y z) : I x z := by
  sorry

/-- Objects identical to the same object are identical to each other. -/
theorem euclid {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y z : X} (hxz : I x z) (hyz : I y z) : I x y := by
  sorry

/-- Difference is symmetric. -/
theorem different_symm {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : Different I x y) : Different I y x := by
  sorry

/-- Any relation satisfying Leibniz's law agrees with Lean's identity. -/
theorem iff_eq {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x y : X) : I x y ↔ x = y := by
  sorry

/-- Functions preserve identity between types carrying identity relations. -/
theorem congrArg {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {Y : Sort v} {J : Y → Y → Prop} [hJ : Aim.Identity J]
  (f : X → Y) {x y : X} (hxy : I x y) : J (f x) (f y) := by
  sorry

end Aim.Identity
