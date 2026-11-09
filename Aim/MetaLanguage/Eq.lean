/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Metalanguage equality

An exercise, not infrastructure: everywhere else the metalanguage uses Lean's
own `=`. This file shows what that `=` is.

* `MetaEq` is equality as an inductive type with one constructor,
  reflexivity. It is a copy of Lean's `Eq`.
* `MetaEq.subst` is the one real theorem: substitution for **every**
  property `P : α → Prop`. Symmetry, transitivity, congruence and the bridge
  to `=` all follow from it by choosing `P`.
* `LeibEq` is Leibniz equality, indiscernibility by every property, proved
  equivalent to `=`.

Contrast with object-level `=` (Enderton §2.4): axiom group 6 allows
substitution into *atomic formulas only*, so the axioms make `=` a
congruence; it is identity only because the semantics interprets it with
this metalanguage `=`.
-/

namespace aim.meta

universe u

/-- Equality as an inductive type: one constructor, reflexivity. -/
inductive MetaEq {α : Sort u} : α → α → Prop
  | refl (a : α) : MetaEq a a

namespace MetaEq
variable {α β : Sort u} {a b c : α}

/-- Substitution, for *every* property `P`. Comes from the eliminator. -/
theorem subst {P : α → Prop} (h : MetaEq a b) (ha : P a) : P b := by
  cases h
  exact ha

theorem symm (h : MetaEq a b) : MetaEq b a :=
  match h with
    | .refl _ => .refl a

theorem trans (h₁ : MetaEq a b) (h₂ : MetaEq b c) : MetaEq a c :=
  match h₁, h₂ with
    | .refl _, .refl _ => .refl a

theorem congrArg (f : α → β) (h : MetaEq a b) : MetaEq (f a) (f b) :=
  match h with
    | .refl _ => .refl (f a)

end MetaEq

/-- The bridge: our equality is Lean's equality. -/
theorem metaEq_iff_eq {α : Sort u} {a b : α} : MetaEq a b ↔ a = b := by
  constructor
  · intro h
    cases h
    rfl
  · intro h
    rw [h]
    exact MetaEq.refl b

/-- Leibniz equality: indiscernible by every property. -/
def LeibEq {α : Sort u} (a b : α) : Prop := ∀ P : α → Prop, P a → P b

theorem leibEq_iff_eq {α : Sort u} {a b : α} : LeibEq a b ↔ a = b := by
  constructor
  · -- LeibEq a b → a = b
    intro hab
    unfold LeibEq at hab
    have heq : a = b := hab (fun x => a = x) rfl
    exact heq
  · -- a = b → LeibEq a b
    intro hab
    unfold LeibEq
    intro P ha
    have hpb : P b := congrArg P hab ▸ ha
    exact hpb


end aim.meta
