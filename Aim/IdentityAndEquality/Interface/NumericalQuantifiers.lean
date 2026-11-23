import Aim.IdentityAndEquality.Interface.Identity

/-!
# Numerical Quantifiers

Tarski's finite numerical quantifiers that can be stated before developing a
general theory of relations.
-/

namespace Aim

universe u

variable {X : Sort u}

/-- At least one object satisfies `P`. -/
def AtLeastOne (P : X → Prop) : Prop :=
  ∃ x, P x

/-- At most one object satisfies `P`, measured using identity `I`. -/
def AtMostOne (I : X → X → Prop) (P : X → Prop) : Prop :=
  ∀ x y, P x → P y → I x y

/-- Exactly one object satisfies `P`. -/
def ExactlyOne (I : X → X → Prop) (P : X → Prop) : Prop :=
  AtLeastOne P ∧ AtMostOne I P

/-- At least two different objects satisfy `P`. -/
def AtLeastTwo (I : X → X → Prop) (P : X → Prop) : Prop :=
  ∃ x y, P x ∧ P y ∧ Different I x y

end Aim
