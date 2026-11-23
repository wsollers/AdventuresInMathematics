/-!
# Identity Interface

Identity is characterized by Leibniz's law: identical objects have every
property in common, and objects with every property in common are identical.

Reflexivity, symmetry, and transitivity are consequences of this interface,
not fields of a relation-like structure.
-/

namespace Aim

universe u

/-- `x` and `y` are different when they are not identical according to `I`. -/
def Different {X : Sort u} (I : X → X → Prop) (x y : X) : Prop :=
  ¬ I x y

/--
Leibniz's law: `x` is identical to `y` exactly when each has every property
the other has.
-/
def LeibnizLaw {X : Sort u} (I : X → X → Prop) : Prop :=
  ∀ x y, I x y ↔
    ((∀ P : X → Prop, P y → P x) ∧ (∀ P : X → Prop, P x → P y))

/-- A candidate identity relation satisfying Leibniz's law. -/
class Identity {X : Sort u} (I : X → X → Prop) : Prop where
  leibniz : LeibnizLaw I

end Aim
