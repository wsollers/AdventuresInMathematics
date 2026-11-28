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
  apply Set.ext
  intro x
  constructor
  . --
    intro hxsut
    rw [mem_union_iff]
    rw [mem_union_iff] at hxsut
    rcases hxsut with xS | xT
    . --
      right
      exact xS
    . --
      left
      exact xT
  . --
    intro hxtus
    rw [mem_union_iff]
    rw [mem_union_iff] at hxtus
    rcases hxtus with xT | xS
    . --
      right
      exact xT
    . --
      left
      exact xS

/-- Union is associative. -/
theorem union_assoc {X : Type u} (S T U : Set X) :
    (S ∪ T) ∪ U = S ∪ (T ∪ U) := by
  sorry

/-- Union is idempotent. -/
theorem union_self {X : Type u} (S : Set X) :
    S ∪ S = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hxUnion
    rw [mem_union_iff] at hxUnion
    rcases hxUnion with hl | hr
    . --
      exact hl
    . --
      exact hr
  . --
    intro hxins
    rw [mem_union_iff]
    left
    exact hxins

/-- Inter is commutative. -/
theorem inter_comm {X : Type u} (S T : Set X) :
    S ∩ T = T ∩ S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hxst
    rw [mem_inter_iff]
    rw [mem_inter_iff] at hxst
    obtain ⟨hxS, hxT⟩ := hxst
    have hans := And.intro hxT hxS
    exact hans
  . --
    intro hxst
    rw [mem_inter_iff]
    rw [mem_inter_iff] at hxst
    obtain ⟨hxT, hxS⟩ := hxst
    have hans := And.intro hxS hxT
    exact hans

/-- Inter is associative. -/
theorem inter_assoc {X : Type u} (S T U : Set X) :
    (S ∩ T) ∩ U = S ∩ (T ∩ U) := by
  apply Set.ext
  intro x
  rw [mem_inter_iff]
  rw [mem_inter_iff]
  rw [mem_inter_iff]
  rw [mem_inter_iff]
  constructor
  . --
    intro lhs
    obtain ⟨llhs, lrhs⟩ := lhs
    obtain ⟨hxS, hxT⟩ := llhs
    have hans := And.intro hxS ( And.intro hxT lrhs )
    exact hans
  . --
    intro rhs
    obtain ⟨lrhs, rrhs⟩ := rhs
    obtain ⟨hxT, hxU⟩ := rrhs
    have hans := And.intro ( And.intro lrhs hxT ) hxU
    exact hans

/-- Inter is idempotent. -/
theorem inter_self {X : Type u} (S : Set X) :
    S ∩ S = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hinter
    rw [mem_inter_iff] at hinter
    have hxs := hinter.1
    exact hxs
  . --
    intro hxins
    rw [mem_inter_iff]
    constructor
    . --
      exact hxins
    . --
      exact hxins

/-- Empty is a right identity for union. -/
theorem union_empty {X : Type u} (S : Set X) :
    S ∪ ∅ = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hU
    rw [mem_union_iff] at hU
    rcases hU with hxs | hx0
    . --
      exact hxs
    . --
      contradiction
  . --
    intro hxS
    rewrite [mem_union_iff]
    left
    exact hxS

/-- Empty is a left identity for union. -/
theorem empty_union {X : Type u} (S : Set X) :
    ∅ ∪ S = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hU
    rw [mem_union_iff] at hU
    rcases hU with hx0 | hxS
    . --
      contradiction
    . --
      exact hxS
  . --
    intro hxS
    rewrite [mem_union_iff]
    right
    exact hxS

/-- Universal is a right identity for intersection. -/
theorem inter_univ {X : Type u} (S : Set X) :
    S ∩ univ = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hinter
    obtain ⟨hxs, hxu⟩ := hinter
    exact hxs
  . --
    intro hxs
    have hxu := subset_univ S
    rw [mem_inter_iff]
    constructor
    . --
      exact hxs
    . --
      apply mem_univ

/-- Universal is a left identity for intersection. -/
theorem univ_inter {X : Type u} (S : Set X) :
    univ ∩ S = S := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hxuinters
    rw [mem_inter_iff] at hxuinters
    obtain ⟨hxu, hxs⟩ := hxuinters
    exact hxs
  . --
    intro hxs
    rw [mem_inter_iff]
    have hxu : x ∈ univ := trivial
    have hans := And.intro hxu hxs
    exact hans

/-- Union with universal is universal. -/
theorem union_univ {X : Type u} (S : Set X) :
    S ∪ univ = univ := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hxinsu
    trivial
  . --
    intro hxu
    rw [mem_union_iff]
    right
    exact hxu

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
