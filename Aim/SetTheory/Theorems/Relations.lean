import Aim.SetTheory.Interface.Relations

/-! # Elementary Set Relations: Learner Proofs -/

namespace Aim.Set

universe u

/-- The chosen element of a nonempty set belongs to that set. -/
theorem Nonempty.some_mem {X : Type u} {S : Set X}
    (hS : S.Nonempty) : hS.some ∈ S := by
  sorry

/-- Disjointness is symmetric. -/
theorem Disjoint.symm {X : Type u} {S T : Set X}
    (h : Disjoint S T) : Disjoint T S := by
  --unfold Disjoint
  --unfold Disjoint at h
  intro x
  intro hit
  intro his
  exact (h x his) hit

/-- Overlap is symmetric. -/
theorem Overlaps.symm {X : Type u} {S T : Set X}
    (h : Overlaps S T) : Overlaps T S := by
  unfold Overlaps
  unfold Overlaps at h
  obtain ⟨x, hs, ht⟩ := h
  exact ⟨x, ht, hs⟩

/-- Partial overlap is symmetric. -/
theorem PartiallyOverlaps.symm {X : Type u} {S T : Set X}
    (h : PartiallyOverlaps S T) : PartiallyOverlaps T S := by
  sorry

/-- Disjointness is the absence of overlap. -/
theorem disjoint_iff_not_overlaps {X : Type u} (S T : Set X) :
    Disjoint S T ↔ ¬ Overlaps S T := by
  sorry

end Aim.Set
