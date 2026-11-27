import Aim.SetTheory.Theorems.Complement
import Aim.SetTheory.Interface.Family

/-!
# Arbitrary unions and intersections

Statements are exercises for the learner, ordered by dependency.
-/

namespace Aim
namespace Set

universe u v

/-- Membership in a collection intersection means membership in every member. -/
theorem mem_sInter_iff {X : Type u} {C : Set (Set X)} {x : X} :
    x ∈ sInter C ↔ ∀ S, S ∈ C → x ∈ S := by
  sorry

/-- Every member lies in the indexed union. -/
theorem subset_iUnion {X : Type u} {I : Type v} (F : I → Set X) (i : I) :
    F i ⊆ iUnion F := by
  sorry

/-- An indexed union lies in a set exactly when every member does. -/
theorem iUnion_subset_iff {X : Type u} {I : Type v} {F : I → Set X} {T : Set X} :
    iUnion F ⊆ T ↔ ∀ i, F i ⊆ T := by
  sorry

/-- The indexed intersection lies in each member. -/
theorem iInter_subset {X : Type u} {I : Type v} (F : I → Set X) (i : I) :
    iInter F ⊆ F i := by
  sorry

/-- A set lies in an indexed intersection exactly when it lies in each member. -/
theorem subset_iInter_iff {X : Type u} {I : Type v} {F : I → Set X} {S : Set X} :
    S ⊆ iInter F ↔ ∀ i, S ⊆ F i := by
  sorry

/-- Indexed union preserves pointwise inclusion. -/
theorem iUnion_mono {X : Type u} {I : Type v} {F G : I → Set X} (hFG : ∀ i, F i ⊆ G i) :
    iUnion F ⊆ iUnion G := by
  sorry

/-- Indexed intersection preserves pointwise inclusion. -/
theorem iInter_mono {X : Type u} {I : Type v} {F G : I → Set X} (hFG : ∀ i, F i ⊆ G i) :
    iInter F ⊆ iInter G := by
  sorry

/-- A union over an empty index type is empty. -/
theorem iUnion_eq_empty_of_isEmpty {X : Type u} {I : Type v} (F : I → Set X) (hI : ∀ i : I, False) :
    iUnion F = ∅ := by
  sorry

/-- An intersection over an empty index type is universal. -/
theorem iInter_eq_univ_of_isEmpty {X : Type u} {I : Type v} (F : I → Set X) (hI : ∀ i : I, False) :
    iInter F = univ := by
  sorry

/-- Intersection distributes over arbitrary union. -/
theorem inter_iUnion {X : Type u} {I : Type v} (S : Set X) (F : I → Set X) :
    S ∩ iUnion F = iUnion (fun i => S ∩ F i) := by
  sorry

/-- Union distributes over arbitrary intersection (classical). -/
theorem union_iInter {X : Type u} {I : Type v} (S : Set X) (F : I → Set X) :
    S ∪ iInter F = iInter (fun i => S ∪ F i) := by
  sorry

/-- Indexed De Morgan: complement of a union is the intersection of complements. -/
theorem compl_iUnion {X : Type u} {I : Type v} (F : I → Set X) :
    Set.compl (iUnion F) = iInter (fun i => Set.compl (F i)) := by
  sorry

/-- Indexed De Morgan: complement of an intersection is the union of complements (classical). -/
theorem compl_iInter {X : Type u} {I : Type v} (F : I → Set X) :
    Set.compl (iInter F) = iUnion (fun i => Set.compl (F i)) := by
  sorry

/-- Every member of a collection lies in its union. -/
theorem subset_sUnion {X : Type u} {C : Set (Set X)} {S : Set X} (hS : S ∈ C) :
    S ⊆ sUnion C := by
  sorry

/-- A collection union lies in a set exactly when every member does. -/
theorem sUnion_subset_iff {X : Type u} {C : Set (Set X)} {T : Set X} :
    sUnion C ⊆ T ↔ ∀ S, S ∈ C → S ⊆ T := by
  sorry

/-- A collection intersection lies in each member. -/
theorem sInter_subset {X : Type u} {C : Set (Set X)} {S : Set X} (hS : S ∈ C) :
    sInter C ⊆ S := by
  sorry

/-- A set lies in a collection intersection exactly when it lies in every member. -/
theorem subset_sInter_iff {X : Type u} {C : Set (Set X)} {S : Set X} :
    S ⊆ sInter C ↔ ∀ T, T ∈ C → S ⊆ T := by
  sorry

/-- Adding sets enlarges their union. -/
theorem sUnion_mono {X : Type u} {C D : Set (Set X)} (hCD : C ⊆ D) :
    sUnion C ⊆ sUnion D := by
  sorry

/-- Adding sets shrinks their intersection. -/
theorem sInter_anti {X : Type u} {C D : Set (Set X)} (hCD : C ⊆ D) :
    sInter D ⊆ sInter C := by
  sorry

/-- The union of the empty collection is empty. -/
theorem sUnion_empty {X : Type u}  :
    sUnion (∅ : Set (Set X)) = ∅ := by
  sorry

/-- The intersection of the empty collection is universal. -/
theorem sInter_empty {X : Type u}  :
    sInter (∅ : Set (Set X)) = univ := by
  sorry

/-- Forgetting the indices preserves the union. -/
theorem sUnion_range {X : Type u} {I : Type v} (F : Family I X) :
    sUnion (Family.range F) = iUnion F := by
  sorry

/-- Forgetting the indices preserves the intersection. -/
theorem sInter_range {X : Type u} {I : Type v} (F : Family I X) :
    sInter (Family.range F) = iInter F := by
  sorry

end Set
end Aim
