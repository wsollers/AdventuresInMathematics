import Aim.SetTheory.Interface.Set

/-!
# Collections

Unindexed collections of subsets of a type.
-/

namespace Aim

universe u

/-- A C on `X` is a set of subsets of `X`. -/
def Collection (X : Type u) : Type u :=
  Aim.Set (Aim.Set X)

namespace Collection

/-- Membership of a set in a C. -/
protected def Mem {X : Type u}
    (C : Collection X) (S : Aim.Set X) : Prop :=
  C S

instance {X : Type u} : Membership (Aim.Set X) (Collection X) :=
  ⟨Collection.Mem⟩

/-- Two collections are equal when they contain exactly the same sets. -/
theorem ext {X : Type u} {C D : Collection X}
    (h : ∀ S, S ∈ C ↔ S ∈ D) : C = D := by
  funext x
  exact propext (h x)

protected def Subset {X : Type u} (C D : Collection X) : Prop :=
  ∀ ⦃S⦄, S ∈ C → S ∈ D

instance {X : Type u} : HasSubset (Collection X) :=
  ⟨Collection.Subset⟩

instance {X : Type u} : EmptyCollection (Collection X) :=
  ⟨fun _ => False⟩

/-- The universal C contains every subset of `X`. -/
def univ {X : Type u} : Collection X :=
  fun _ => True

protected def insert {X : Type u}
    (S : Aim.Set X) (C : Collection X) : Collection X :=
  fun T => T = S ∨ T ∈ C

instance {X : Type u} : Insert (Aim.Set X) (Collection X) :=
  ⟨Collection.insert⟩

protected def singleton {X : Type u} (S : Aim.Set X) : Collection X :=
  fun T => T = S

instance {X : Type u} : Singleton (Aim.Set X) (Collection X) :=
  ⟨Collection.singleton⟩

protected def union {X : Type u} (C D : Collection X) : Collection X :=
  fun S => S ∈ C ∨ S ∈ D

instance {X : Type u} : Union (Collection X) :=
  ⟨Collection.union⟩

protected def inter {X : Type u} (C D : Collection X) : Collection X :=
  fun S => S ∈ C ∧ S ∈ D

instance {X : Type u} : Inter (Collection X) :=
  ⟨Collection.inter⟩

protected def diff {X : Type u} (C D : Collection X) : Collection X :=
  fun S => S ∈ C ∧ S ∉ D

instance {X : Type u} : SDiff (Collection X) :=
  ⟨Collection.diff⟩

protected def compl {X : Type u} (C : Collection X) : Collection X :=
  fun S => S ∉ C

/-- The union of all sets in a C. -/
def unionAll {X : Type u} (C : Collection X) : Aim.Set X :=
  Aim.Set.sUnion C

/-- The intersection of all sets in a C. -/
def interAll {X : Type u} (C : Collection X) : Aim.Set X :=
  Aim.Set.sInter C

end Collection

end Aim
