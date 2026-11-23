import Aim.SetTheory.Interface.Collection

/-!
# Families

Indexed families of subsets of a type.
-/

namespace Aim

universe u v

/-- An `I`-indexed family of subsets of `X`. -/
def Family (I : Type v) (X : Type u) : Type (max u v) :=
  I → Aim.Set X

namespace Family

/-- Two families are equal when they agree at every index. -/
theorem ext {I : Type v} {X : Type u} {F G : Family I X}
    (h : ∀ i, F i = G i) : F = G := by
  sorry

/-- The family containing the empty set at every index. -/
instance {I : Type v} {X : Type u} : EmptyCollection (Family I X) :=
  ⟨fun _ => ∅⟩

/-- Pointwise inclusion of indexed families. -/
protected def Subset {I : Type v} {X : Type u}
    (F G : Family I X) : Prop :=
  ∀ i, F i ⊆ G i

instance {I : Type v} {X : Type u} : HasSubset (Family I X) :=
  ⟨Family.Subset⟩

/-- Pointwise union of indexed families. -/
protected def union {I : Type v} {X : Type u}
    (F G : Family I X) : Family I X :=
  fun i => F i ∪ G i

instance {I : Type v} {X : Type u} : Union (Family I X) :=
  ⟨Family.union⟩

/-- Pointwise intersection of indexed families. -/
protected def inter {I : Type v} {X : Type u}
    (F G : Family I X) : Family I X :=
  fun i => F i ∩ G i

instance {I : Type v} {X : Type u} : Inter (Family I X) :=
  ⟨Family.inter⟩

/-- Pointwise difference of indexed families. -/
protected def diff {I : Type v} {X : Type u}
    (F G : Family I X) : Family I X :=
  fun i => F i \ G i

instance {I : Type v} {X : Type u} : SDiff (Family I X) :=
  ⟨Family.diff⟩

/-- The family containing the universal set at every index. -/
def univ {I : Type v} {X : Type u} : Family I X :=
  fun _ => Aim.Set.univ

/-- Pointwise complement of an indexed family. -/
def compl {I : Type v} {X : Type u} (F : Family I X) : Family I X :=
  fun i => Aim.Set.compl (F i)

/-- Forget the indices and retain the sets occurring in a family. -/
def range {I : Type v} {X : Type u}
    (F : Family I X) : Aim.Collection X :=
  fun S => ∃ i, F i = S

/-- The union of all sets in an indexed family. -/
def unionAll {I : Type v} {X : Type u} (F : Family I X) : Aim.Set X :=
  fun x => ∃ i, x ∈ F i

/-- The intersection of all sets in an indexed family. -/
def interAll {I : Type v} {X : Type u} (F : Family I X) : Aim.Set X :=
  fun x => ∀ i, x ∈ F i

end Family

end Aim
