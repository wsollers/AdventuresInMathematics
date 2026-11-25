import Aim.MetaLanguage.Collections.List
import Init.Data.List.Perm

/-!
# Metalanguage Multisets

Lean core has list permutation but no general multiset container. Quotienting
host lists by permutation forgets order while retaining multiplicity. This
small adapter uses only Lean's quotient and permutation API, never Mathlib.
-/

namespace Aim

universe u

/-- Finite unordered collections, retaining repeated occurrences. -/
def MetaMultiset (X : Type u) : Type u :=
  Quotient (⟨List.Perm, List.Perm.eqv X⟩ : Setoid (List X))

namespace MetaMultiset

/-- Forget the order of a host list. -/
def ofList {X : Type u} (xs : MetaList X) : MetaMultiset X :=
  Quotient.mk _ xs

instance {X : Type u} : EmptyCollection (MetaMultiset X) :=
  ⟨ofList []⟩

/-- Membership is independent of the chosen ordering. -/
def mem {X : Type u} (x : X) (S : MetaMultiset X) : Prop :=
  Quotient.lift (fun xs : List X => x ∈ xs)
    (by
      intro xs ys h
      exact propext h.mem_iff) S

instance {X : Type u} : Membership X (MetaMultiset X) :=
  ⟨fun S x => mem x S⟩

/-- Add one occurrence, without choosing a canonical order. -/
def insert {X : Type u} (x : X) (S : MetaMultiset X) : MetaMultiset X :=
  Quotient.lift (fun xs : List X => ofList (x :: xs))
    (by
      intro xs ys h
      exact Quotient.sound (h.cons x)) S

/-- The number of occurrences, including repetitions. -/
def card {X : Type u} (S : MetaMultiset X) : Nat :=
  Quotient.lift List.length
    (by
      intro xs ys h
      exact h.length_eq) S

end MetaMultiset
end Aim
