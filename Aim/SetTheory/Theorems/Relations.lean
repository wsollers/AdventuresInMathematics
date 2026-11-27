import Aim.SetTheory.Interface.Relations

/-! # Elementary Set Relations: Learner Proofs -/

namespace Aim.Set

universe u

/-- Disjointness is symmetric. -/
theorem Disjoint.symm {X : Type u} {S T : Set X}
    (h : Disjoint S T) : Disjoint T S := by
  sorry

/-- Overlap is symmetric. -/
theorem Overlaps.symm {X : Type u} {S T : Set X}
    (h : Overlaps S T) : Overlaps T S := by
  sorry

/-- Partial overlap is symmetric. -/
theorem PartiallyOverlaps.symm {X : Type u} {S T : Set X}
    (h : PartiallyOverlaps S T) : PartiallyOverlaps T S := by
  sorry

/-- Disjointness is the absence of overlap. -/
theorem disjoint_iff_not_overlaps {X : Type u} (S T : Set X) :
    Disjoint S T ↔ ¬ Overlaps S T := by
  sorry

end Aim.Set
