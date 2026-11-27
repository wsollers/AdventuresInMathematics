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

/-- Transport a proof of a property from the first object to the second. -/
theorem subst {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : I x y) {P : X → Prop} (hx : P x) : P y := by
  exact (replace hxy P).mp hx

/-- Transport a proof of a property from the second object to the first. -/
theorem subst_rev {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : I x y) {P : X → Prop} (hy : P y) : P x := by
  exact (replace hxy P).mpr hy

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
  obtain ⟨hi, hp⟩ := hixy
  have r := hi hxy
  obtain ⟨h1, h2⟩ := r
  have hiyx := h1 (I y)
  have hyy := hI.refl y
  exact hiyx hyy

/-- Identity is transitive. -/
theorem trans {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y z : X} (hxy : I x y) (hyz : I y z) : I x z := by
  have hyx := symm hxy
  --let ha := (fun a => I a z)
  have hreplace := replace hyx (fun a => I a z) -- can use the ha above but info view is not as clean
  have hh := hreplace.mp hyz
  exact hh

/-- Objects identical to the same object are identical to each other. -/
theorem euclid {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y z : X} (hxz : I x z) (hyz : I y z) : I x y := by
  have hzx := symm hxz
  have hzy := symm hyz
  have hreplace := replace hzy (fun a => I x a) -- can use the ha above but info view is not as clean
  have hh := hreplace.mp hxz
  exact hh

/-- Difference is symmetric. -/
theorem different_symm {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : Different I x y) : Different I y x := by
  unfold Different
  unfold Different at hxy
  intro hiyx
  have hixy := symm hiyx
  exact hxy hixy

/-- No object is different from itself. -/
theorem not_different_self {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x : X) : ¬ Different I x x := by
  intro h
  exact h (refl (I := I) x)

/-- Difference can be read in either direction. -/
theorem different_comm {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x y : X) : Different I x y ↔ Different I y x := by
  constructor
  · exact different_symm
  · exact different_symm

/-- Project identity yields Lean's kernel equality. -/
theorem eq_of_identity {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : I x y) : x = y := by
  exact subst hxy (P := fun a => x = a) (Eq.refl x)

/-- Lean's kernel equality yields any identity satisfying Leibniz's law. -/
theorem identity_of_eq {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (hxy : x = y) : I x y := by
  cases hxy
  exact refl (I := I) x

/-- One-way preservation of every property is sufficient for identity. -/
theorem of_forall_imp {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  {x y : X} (h : ∀ P : X → Prop, P x → P y) : I x y := by
  exact h (fun a => I x a) (refl (I := I) x)

/-- Project difference agrees with Lean's inequality, constructively. -/
theorem different_iff_ne {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x y : X) : Different I x y ↔ x ≠ y := by
  constructor
  · intro hd he
    exact hd (identity_of_eq he)
  · intro hn hi
    exact hn (eq_of_identity hi)

/-- Any relation satisfying Leibniz's law agrees with Lean's identity. -/
theorem iff_eq {X : Sort u} {I : X → X → Prop} [hI : Aim.Identity I]
  (x y : X) : I x y ↔ x = y := by
  constructor
  . --
    intro hxy
    have hreplace := replace hxy (fun a => x = a)
    have hxx : x = x := by rfl
    exact hreplace.mp hxx
  . --
    intro hxy
    --have hreplace := replace hxy (fun a => a = x)
    have hi := (hI.identity_of_eq hxy)
    exact hi

/-- Functions preserve identity between types carrying identity relations. -/
theorem congrArg {X : Sort u} {I : X → X → Prop} [hIx : Aim.Identity I]
  {Y : Sort v} {J : Y → Y → Prop} [hIy : Aim.Identity J]
  (f : X → Y) {x y : X} (hxy : I x y) : J (f x) (f y) := by
  have hXleibxy := (hIx.leibniz x y)
  have hYleibxy := (hIy.leibniz (f x) (f y))
  have hr := replace hxy (fun a => J (f x) (f a))
  have hself := refl (I := J) (f x)
  have hji := hr.mp
  exact hji hself

end Aim.Identity
