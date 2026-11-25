/-!
# Minimal Typed Set Interface

An extensional set representation with comprehension. Set operations are derived
from comprehension rather than supplied as independent axioms. This interface
does not assume natural numbers, lists, or a universe of foundational sets.
-/

namespace Aim

universe u v w

/-- The laws required of a representation `S` of subsets of `X`. -/
class SetInterface (X : Type u) (S : Type v) [Membership X S] where
  ofPredicate : (X → Prop) → S
  mem_ofPredicate : ∀ (p : X → Prop) (x : X), x ∈ ofPredicate p ↔ p x
  ext : ∀ {S₁ S₂ : S}, (∀ x, x ∈ S₁ ↔ x ∈ S₂) → S₁ = S₂

namespace SetInterface

variable {X : Type u} {S : Type v} [Membership X S] [SetInterface X S]

/-- Inclusion uses membership only. -/
def subset (S₁ S₂ : S) : Prop :=
  ∀ x : X, x ∈ S₁ → x ∈ S₂

/-- The set of every element of the ambient type. -/
def univ : S :=
  ofPredicate (fun (_ : X) => True)

/-- Intersection indexed by an arbitrary type, without an order on indices. -/
def iInter {I : Type w} (F : I → S) : S :=
  ofPredicate (fun x : X => ∀ i, x ∈ F i)

/-- Intersection over candidates selected by a predicate on sets. -/
def interAll (C : S → Prop) : S :=
  ofPredicate (fun x : X => ∀ T, C T → x ∈ T)

end SetInterface
end Aim
