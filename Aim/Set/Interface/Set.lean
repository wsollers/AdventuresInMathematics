/-!
# Sets

Typed sets, modeled as predicates in the same way as Lean's standard mathematical
set libraries.
-/

namespace Aim.Set

universe u v

/-- A set of elements of `X` is a predicate on `X`. -/
def Set (X : Type u) : Type u :=
  X → Prop

/-- Turn a predicate into a set. -/
def setOf {X : Type u} (predicate : X → Prop) : Set X :=
  predicate

namespace Set

/-- Membership in a set. -/
protected def Mem {X : Type u} (s : Set X) (x : X) : Prop :=
  s x

instance {X : Type u} : Membership X (Set X) :=
  ⟨Set.Mem⟩

/-- Two sets are equal when they have exactly the same elements. -/
theorem ext {X : Type u} {s t : Set X}
    (h : ∀ x, x ∈ s ↔ x ∈ t) : s = t := by
  sorry

/-- Every element of a subset belongs to its superset. -/
protected def Subset {X : Type u} (s t : Set X) : Prop :=
  ∀ ⦃x⦄, x ∈ s → x ∈ t

instance {X : Type u} : HasSubset (Set X) :=
  ⟨Set.Subset⟩

/-- The empty set contains no elements. -/
instance {X : Type u} : EmptyCollection (Set X) :=
  ⟨fun _ => False⟩

/-- The universal set contains every element of `X`. -/
def univ {X : Type u} : Set X :=
  fun _ => True

/-- Insert an element into a set. -/
protected def insert {X : Type u} (a : X) (s : Set X) : Set X :=
  fun x => x = a ∨ x ∈ s

instance {X : Type u} : Insert X (Set X) :=
  ⟨Set.insert⟩

/-- The singleton set containing `a`. -/
protected def singleton {X : Type u} (a : X) : Set X :=
  fun x => x = a

instance {X : Type u} : Singleton X (Set X) :=
  ⟨Set.singleton⟩

/-- The union contains the elements belonging to either set. -/
protected def union {X : Type u} (s t : Set X) : Set X :=
  fun x => x ∈ s ∨ x ∈ t

instance {X : Type u} : Union (Set X) :=
  ⟨Set.union⟩

/-- The intersection contains the elements belonging to both sets. -/
protected def inter {X : Type u} (s t : Set X) : Set X :=
  fun x => x ∈ s ∧ x ∈ t

instance {X : Type u} : Inter (Set X) :=
  ⟨Set.inter⟩

/-- Set difference contains the elements of `s` that do not belong to `t`. -/
protected def diff {X : Type u} (s t : Set X) : Set X :=
  fun x => x ∈ s ∧ x ∉ t

instance {X : Type u} : SDiff (Set X) :=
  ⟨Set.diff⟩

/-- The complement contains exactly the elements outside `s`. -/
protected def compl {X : Type u} (s : Set X) : Set X :=
  fun x => x ∉ s

/-- The union of an indexed family of sets. -/
def iUnion {I : Type v} {X : Type u} (s : I → Set X) : Set X :=
  fun x => ∃ i, x ∈ s i

/-- The intersection of an indexed family of sets. -/
def iInter {I : Type v} {X : Type u} (s : I → Set X) : Set X :=
  fun x => ∀ i, x ∈ s i

/-- The union of a set of sets. -/
def sUnion {X : Type u} (collection : Set (Set X)) : Set X :=
  fun x => ∃ s, s ∈ collection ∧ x ∈ s

end Set

end Aim.Set
