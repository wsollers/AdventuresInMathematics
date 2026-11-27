import Aim.SetTheory.Theorems.Subset

/-!
# Binary set algebra

Statements are exercises for the learner, ordered by dependency.
-/

namespace Aim
namespace Set

universe u v

/-- Union is commutative. -/
theorem union_comm {X : Type u} (S T : Set X) :
    S ∪ T = T ∪ S := by
  sorry

/-- Union is associative. -/
theorem union_assoc {X : Type u} (S T U : Set X) :
    (S ∪ T) ∪ U = S ∪ (T ∪ U) := by
  sorry

/-- Union is idempotent. -/
theorem union_self {X : Type u} (S : Set X) :
    S ∪ S = S := by
  sorry

/-- Inter is commutative. -/
theorem inter_comm {X : Type u} (S T : Set X) :
    S ∩ T = T ∩ S := by
  sorry

/-- Inter is associative. -/
theorem inter_assoc {X : Type u} (S T U : Set X) :
    (S ∩ T) ∩ U = S ∩ (T ∩ U) := by
  sorry

/-- Inter is idempotent. -/
theorem inter_self {X : Type u} (S : Set X) :
    S ∩ S = S := by
  sorry

/-- Empty is a right identity for union. -/
theorem union_empty {X : Type u} (S : Set X) :
    S ∪ ∅ = S := by
  sorry

/-- Empty is a left identity for union. -/
theorem empty_union {X : Type u} (S : Set X) :
    ∅ ∪ S = S := by
  sorry

/-- Universal is a right identity for intersection. -/
theorem inter_univ {X : Type u} (S : Set X) :
    S ∩ univ = S := by
  sorry

/-- Universal is a left identity for intersection. -/
theorem univ_inter {X : Type u} (S : Set X) :
    univ ∩ S = S := by
  sorry

/-- Union with universal is universal. -/
theorem union_univ {X : Type u} (S : Set X) :
    S ∪ univ = univ := by
  sorry

/-- Universal union a set is universal. -/
theorem univ_union {X : Type u} (S : Set X) :
    univ ∪ S = univ := by
  sorry

/-- Intersection with empty is empty. -/
theorem inter_empty {X : Type u} (S : Set X) :
    S ∩ ∅ = ∅ := by
  sorry

/-- Empty intersect a set is empty. -/
theorem empty_inter {X : Type u} (S : Set X) :
    ∅ ∩ S = ∅ := by
  sorry

/-- Union absorbs intersection. -/
theorem union_inter_self {X : Type u} (S T : Set X) :
    S ∪ (S ∩ T) = S := by
  sorry

/-- Intersection absorbs union. -/
theorem inter_union_self {X : Type u} (S T : Set X) :
    S ∩ (S ∪ T) = S := by
  sorry

/-- Intersection distributes over union on the left. -/
theorem inter_union_distrib_left {X : Type u} (S T U : Set X) :
    S ∩ (T ∪ U) = (S ∩ T) ∪ (S ∩ U) := by
  sorry

/-- Intersection distributes over union on the right. -/
theorem inter_union_distrib_right {X : Type u} (S T U : Set X) :
    (S ∪ T) ∩ U = (S ∩ U) ∪ (T ∩ U) := by
  sorry

/-- Union distributes over intersection on the left. -/
theorem union_inter_distrib_left {X : Type u} (S T U : Set X) :
    S ∪ (T ∩ U) = (S ∪ T) ∩ (S ∪ U) := by
  sorry

/-- Union distributes over intersection on the right. -/
theorem union_inter_distrib_right {X : Type u} (S T U : Set X) :
    (S ∩ T) ∪ U = (S ∪ U) ∩ (T ∪ U) := by
  sorry

end Set
end Aim
