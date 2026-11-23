import Aim.SetTheory.Interface.Set

/-!
# Classes

Classes of objects from an ambient type. In a one-sorted foundational set
theory, the ambient type will be the type of all foundational sets.
-/

namespace Aim

universe u v

/-- A class of objects from `X` is a predicate on `X`. -/
def Class (X : Type u) : Type u :=
  X → Prop

namespace Class

/-- Membership in a class. -/
protected def Mem {X : Type u} (C : Class X) (x : X) : Prop :=
  C x

instance {X : Type u} : Membership X (Class X) :=
  ⟨Class.Mem⟩

/-- Two classes are equal when they have exactly the same members. -/
theorem ext {X : Type u} {C D : Class X}
    (h : ∀ x, x ∈ C ↔ x ∈ D) : C = D := by
  sorry

/-- Every member of a subclass belongs to its superclass. -/
protected def Subset {X : Type u} (C D : Class X) : Prop :=
  ∀ ⦃x⦄, x ∈ C → x ∈ D

instance {X : Type u} : HasSubset (Class X) :=
  ⟨Class.Subset⟩

instance {X : Type u} : EmptyCollection (Class X) :=
  ⟨fun _ => False⟩

/-- The universal class contains every object of `X`. -/
def univ {X : Type u} : Class X :=
  fun _ => True

protected def insert {X : Type u} (a : X) (C : Class X) : Class X :=
  fun x => x = a ∨ x ∈ C

instance {X : Type u} : Insert X (Class X) :=
  ⟨Class.insert⟩

protected def singleton {X : Type u} (a : X) : Class X :=
  fun x => x = a

instance {X : Type u} : Singleton X (Class X) :=
  ⟨Class.singleton⟩

protected def union {X : Type u} (C D : Class X) : Class X :=
  fun x => x ∈ C ∨ x ∈ D

instance {X : Type u} : Union (Class X) :=
  ⟨Class.union⟩

protected def inter {X : Type u} (C D : Class X) : Class X :=
  fun x => x ∈ C ∧ x ∈ D

instance {X : Type u} : Inter (Class X) :=
  ⟨Class.inter⟩

protected def diff {X : Type u} (C D : Class X) : Class X :=
  fun x => x ∈ C ∧ x ∉ D

instance {X : Type u} : SDiff (Class X) :=
  ⟨Class.diff⟩

protected def compl {X : Type u} (C : Class X) : Class X :=
  fun x => x ∉ C

def iUnion {I : Type v} {X : Type u} (C : I → Class X) : Class X :=
  fun x => ∃ i, x ∈ C i

def iInter {I : Type v} {X : Type u} (C : I → Class X) : Class X :=
  fun x => ∀ i, x ∈ C i

/-- Regard a typed set as a class with the same members. -/
def ofSet {X : Type u} (s : Aim.Set X) : Class X :=
  s

/-- The class of members of a foundational object. -/
def extension {V : Type u} [Membership V V] (a : V) : Class V :=
  fun x => x ∈ a

/-- A class is represented when it is the extension of some foundational object. -/
def IsRepresented {V : Type u} [Membership V V] (C : Class V) : Prop :=
  ∃ a : V, extension a = C

/-- A proper class is not represented by any foundational object. -/
def IsProper {V : Type u} [Membership V V] (C : Class V) : Prop :=
  ¬IsRepresented C

end Class

end Aim
