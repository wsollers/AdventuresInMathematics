import Aim.SetTheory.Theorems.Membership

/-!
# Set inclusion

Statements are exercises for the learner, ordered by dependency.
-/

namespace Aim
namespace Set

universe u v

/-- Every set is a subset of itself. -/
theorem subset_refl {X : Type u} (S : Set X) :
    S ⊆ S := by
  change ∀ x : X, x ∈ S → x ∈ S
  intro x hx
  exact hx

/-- Inclusion is transitive. -/
theorem subset_trans {X : Type u} {S T U : Set X} (hST : S ⊆ T) (hTU : T ⊆ U) :
    S ⊆ U := by
  change ∀ x : X, x ∈ S → x ∈ U
  intro x hx
  have hxt := hST hx
  have hxu := hTU hxt
  exact hxu

/-- Mutual inclusion gives equality. -/
theorem subset_antisymm {X : Type u} {S T : Set X} (hST : S ⊆ T) (hTS : T ⊆ S) :
    S = T := by
  apply Set.ext
  intro x
  constructor
  . --
    intro hxs
    exact hST hxs
  . --
    intro hxt
    exact hTS hxt

/-- Equality is equivalent to mutual inclusion. -/
theorem eq_iff_subset_and_subset {X : Type u} {S T : Set X} :
    S = T ↔ S ⊆ T ∧ T ⊆ S := by
  constructor
  . --
    intro hset
    constructor
    . --
      rw [subset_def]
      intro x hxinS
      rw [← hset]
      exact hxinS
    . --
      rw [subset_def]
      intro x hxinT
      rw [← hset.symm]
      exact hxinT
  . --
    --rw [subset_def]
    intro he
    obtain ⟨hxx, hx⟩ := he
    have heq := subset_antisymm hxx hx
    exact heq

/-- The empty set is a subset of every set. -/
theorem empty_subset {X : Type u} (S : Set X) :
    (∅ : Set X) ⊆ S := by
  rw [subset_def]
  intro x hxin0
  change False at hxin0
  contradiction

/-- Every set is a subset of the universal set. -/
theorem subset_univ {X : Type u} (S : Set X) :
    S ⊆ univ := by
  rw [subset_def]
  intro x hinS
  apply mem_univ

/-- The first set lies in the union. -/
theorem subset_union_left {X : Type u} (S T : Set X) :
    S ⊆ S ∪ T := by
  rw [subset_def]
  intro x hxinS
  rw [mem_union_iff]
  left
  exact hxinS


/-- The second set lies in the union. -/
theorem subset_union_right {X : Type u} (S T : Set X) :
    T ⊆ S ∪ T := by
  rw [subset_def]
  intro x hxinT
  rw [mem_union_iff]
  right
  exact hxinT

/-- A union lies in a set exactly when both members do. -/
theorem union_subset_iff {X : Type u} {S T U : Set X} :
    S ∪ T ⊆ U ↔ S ⊆ U ∧ T ⊆ U := by
  rw [subset_def]
  constructor
  . --
    intro hxinunion
    constructor
    . --
      rw [subset_def]
      intro x hx
      have hans := hxinunion x
      apply hans
      rw [mem_union_iff]
      left
      exact hx
    . --
      rw [subset_def]
      intro x hx
      have hans := hxinunion x
      apply hans
      rw [mem_union_iff]
      right
      exact hx
  . --
    rw [subset_def]
    rw [subset_def]
    intro hinU
    intro x
    intro hinS
    obtain ⟨hh, hx⟩ := hinU
    have gg := hh x
    have ht := hx x
    rw [mem_union_iff] at hinS
    rcases hinS with hxS | hxT
    ·
      have dd := gg hxS
      exact dd
    · -- Here you have hxT : x ∈ T.
      -- Goal: x ∈ U. Which implication accepts hxT?
      have dd := ht hxT
      exact dd

/-- An intersection lies in its first set. -/
theorem inter_subset_left {X : Type u} (S T : Set X) :
    S ∩ T ⊆ S := by
  sorry

/-- An intersection lies in its second set. -/
theorem inter_subset_right {X : Type u} (S T : Set X) :
    S ∩ T ⊆ T := by
  sorry

/-- A set lies in an intersection exactly when it lies in both sets. -/
theorem subset_inter_iff {X : Type u} {S T U : Set X} :
    S ⊆ T ∩ U ↔ S ⊆ T ∧ S ⊆ U := by
  sorry

/-- Union preserves inclusion in both arguments. -/
theorem union_mono {X : Type u} {S T U V : Set X} (hSU : S ⊆ U) (hTV : T ⊆ V) :
    S ∪ T ⊆ U ∪ V := by
  rw [subset_def]
  intro x hxinST
  rw [mem_union_iff] at hxinST
  rw [subset_def] at hSU
  rw [subset_def] at hTV
  have hxSU := hSU x
  have hxTU := hTV x
  rcases hxinST with xs | xt
  . --
    have xU := hxSU xs
    rw [mem_union_iff]
    left
    exact xU
  . --
    have xU := hxTU xt
    rw [mem_union_iff]
    right
    exact xU

/-- Intersection preserves inclusion in both arguments. -/
theorem inter_mono {X : Type u} {S T U V : Set X} (hSU : S ⊆ U) (hTV : T ⊆ V) :
    S ∩ T ⊆ U ∩ V := by
  sorry

end Set
end Aim
