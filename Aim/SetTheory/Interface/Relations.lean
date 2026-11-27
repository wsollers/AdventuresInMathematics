import Aim.SetTheory.Interface.Set

/-!
# Relations Between Sets

Nonemptiness, disjointness, and overlap depend only on membership, not on an
order on the elements. Partial overlap means overlap with neither set contained
in the other; ordinary overlap also allows containment and equality.
-/

namespace Aim.Set

universe u

/-- A set is nonempty when it has an element. -/
def Nonempty {X : Type u} (S : Set X) : Prop :=
  ∃ x, x ∈ S

/-- Choose an element of a nonempty set using classical choice. -/
noncomputable def Nonempty.some {X : Type u} {S : Set X}
    (hS : S.Nonempty) : X :=
  Classical.choose hS

/-- Disjoint sets have no common element. -/
def Disjoint {X : Type u} (S T : Set X) : Prop :=
  ∀ x, x ∈ S → x ∈ T → False

/-- Overlapping sets have a common element. -/
def Overlaps {X : Type u} (S T : Set X) : Prop :=
  ∃ x, x ∈ S ∧ x ∈ T

/-- The sets overlap, and each contains an element outside the other. -/
def PartiallyOverlaps {X : Type u} (S T : Set X) : Prop :=
  Overlaps S T ∧ (∃ x, x ∈ S ∧ x ∉ T) ∧ (∃ y, y ∈ T ∧ y ∉ S)

end Aim.Set
