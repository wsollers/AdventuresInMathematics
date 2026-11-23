import Aim.SetTheory.Interface.Set

/-!
# Collections

Unindexed collections of subsets of a type.
-/

namespace Aim

universe u

/-- A collection on `X` is a set of subsets of `X`. -/
def Collection (X : Type u) : Type u :=
  Aim.Set (Aim.Set X)

namespace Collection

/-- Membership of a set in a collection. -/
protected def Mem {X : Type u}
    (C : Collection X) (s : Aim.Set X) : Prop :=
  C s

instance {X : Type u} : Membership (Aim.Set X) (Collection X) :=
  ⟨Collection.Mem⟩

/-- Two collections are equal when they contain exactly the same sets. -/
theorem ext {X : Type u} {C D : Collection X}
    (h : ∀ s, s ∈ C ↔ s ∈ D) : C = D := by
  sorry

protected def Subset {X : Type u} (C D : Collection X) : Prop :=
  ∀ ⦃s⦄, s ∈ C → s ∈ D

instance {X : Type u} : HasSubset (Collection X) :=
  ⟨Collection.Subset⟩

instance {X : Type u} : EmptyCollection (Collection X) :=
  ⟨fun _ => False⟩

/-- The universal collection contains every subset of `X`. -/
def univ {X : Type u} : Collection X :=
  fun _ => True

protected def insert {X : Type u}
    (s : Aim.Set X) (C : Collection X) : Collection X :=
  fun t => t = s ∨ t ∈ C

instance {X : Type u} : Insert (Aim.Set X) (Collection X) :=
  ⟨Collection.insert⟩

protected def singleton {X : Type u} (s : Aim.Set X) : Collection X :=
  fun t => t = s

instance {X : Type u} : Singleton (Aim.Set X) (Collection X) :=
  ⟨Collection.singleton⟩

protected def union {X : Type u} (C D : Collection X) : Collection X :=
  fun s => s ∈ C ∨ s ∈ D

instance {X : Type u} : Union (Collection X) :=
  ⟨Collection.union⟩

protected def inter {X : Type u} (C D : Collection X) : Collection X :=
  fun s => s ∈ C ∧ s ∈ D

instance {X : Type u} : Inter (Collection X) :=
  ⟨Collection.inter⟩

protected def diff {X : Type u} (C D : Collection X) : Collection X :=
  fun s => s ∈ C ∧ s ∉ D

instance {X : Type u} : SDiff (Collection X) :=
  ⟨Collection.diff⟩

protected def compl {X : Type u} (C : Collection X) : Collection X :=
  fun s => s ∉ C

/-- The union of all sets in a collection. -/
def unionAll {X : Type u} (C : Collection X) : Aim.Set X :=
  fun x => ∃ s, s ∈ C ∧ x ∈ s

/-- The intersection of all sets in a collection. -/
def interAll {X : Type u} (C : Collection X) : Aim.Set X :=
  fun x => ∀ s, s ∈ C → x ∈ s

end Collection

end Aim
