import Aim.SetTheory.Theorems.Algebra

/-!
# Complements and set duality

Statements are exercises for the learner, ordered by dependency.
-/

namespace Aim
namespace Set

universe u v

/-- The complement of empty is universal. -/
theorem compl_empty {X : Type u}  :
    Set.compl (∅ : Set X) = univ := by
  sorry

/-- The complement of universal is empty. -/
theorem compl_univ {X : Type u}  :
    Set.compl (@univ X) = ∅ := by
  sorry

/-- Complement is an involution (classical). -/
theorem compl_compl {X : Type u} (S : Set X) :
    Set.compl (Set.compl S) = S := by
  sorry

/-- De Morgan: complement exchanges union with intersection. -/
theorem compl_union {X : Type u} (S T : Set X) :
    Set.compl (S ∪ T) = Set.compl S ∩ Set.compl T := by
  sorry

/-- De Morgan: complement exchanges intersection with union (classical). -/
theorem compl_inter {X : Type u} (S T : Set X) :
    Set.compl (S ∩ T) = Set.compl S ∪ Set.compl T := by
  sorry

/-- Complement reverses inclusion. -/
theorem compl_subset_compl {X : Type u} {S T : Set X} (hST : S ⊆ T) :
    Set.compl T ⊆ Set.compl S := by
  sorry

/-- Complement transfers inclusion to the reversed inclusion (classical). -/
theorem subset_iff_compl_subset_compl {X : Type u} {S T : Set X} :
    S ⊆ T ↔ Set.compl T ⊆ Set.compl S := by
  sorry

/-- Complement reflects equality (classical). -/
theorem compl_eq_compl_iff {X : Type u} {S T : Set X} :
    Set.compl S = Set.compl T ↔ S = T := by
  sorry

/-- A set and its complement have empty intersection. -/
theorem inter_compl_self {X : Type u} (S : Set X) :
    S ∩ Set.compl S = ∅ := by
  sorry

/-- A set and its complement cover the ambient type (classical). -/
theorem union_compl_self {X : Type u} (S : Set X) :
    S ∪ Set.compl S = univ := by
  sorry

/-- Difference is intersection with a complement. -/
theorem sdiff_eq_inter_compl {X : Type u} (S T : Set X) :
    S \ T = S ∩ Set.compl T := by
  sorry

/-- Removing a set from itself leaves empty. -/
theorem sdiff_self {X : Type u} (S : Set X) :
    S \ S = ∅ := by
  sorry

/-- Removing empty leaves a set unchanged. -/
theorem sdiff_empty {X : Type u} (S : Set X) :
    S \ ∅ = S := by
  sorry

/-- Removing a set from empty leaves empty. -/
theorem empty_sdiff {X : Type u} (S : Set X) :
    ∅ \ S = ∅ := by
  sorry

/-- Removing universal leaves empty. -/
theorem sdiff_univ {X : Type u} (S : Set X) :
    S \ univ = ∅ := by
  sorry

/-- Removing a set from universal gives its complement. -/
theorem univ_sdiff {X : Type u} (S : Set X) :
    univ \ S = Set.compl S := by
  sorry

/-- Difference lies in its first set. -/
theorem sdiff_subset {X : Type u} (S T : Set X) :
    S \ T ⊆ S := by
  sorry

/-- Difference preserves inclusion in its first argument and reverses it in the second. -/
theorem sdiff_mono {X : Type u} {S T U V : Set X} (hSU : S ⊆ U) (hVT : V ⊆ T) :
    S \ T ⊆ U \ V := by
  sorry

end Set
end Aim
