import Aim.SetTheory.Interface.Set

/-!
# Membership Lemmas

One lemma per set operation, saying what it means to be an element of the
result. Together they are the contract for `Set`: a proof that cites these
lemmas never needs to know that a set is represented as a predicate.

Each statement below is given in English and in quantified form. The Lean
statement and proof are to be written beneath it.

Throughout, `X` is a type, `S` and `T` are sets of elements of `X`, and `x`
and `a` are elements of `X`.
-/

namespace Aim

namespace Set

universe u v

variable {X : Type u} {I : Type v}

-- ## Set-builder and subset

/-
`mem_setOf_iff`

Let `p` be a property of elements of `X`. An element `x` belongs to the set
of all elements satisfying `p` if and only if `x` satisfies `p`.

  ∀ p : X → Prop, ∀ x : X,  x ∈ { y | p y } ↔ p x
-/
theorem mem_setOf_iff {X : Type u} {p : X->Prop}
  (x : X) : -- Everything before the : is implicitly for all
  x ∈ { y | p y } ↔ p x := by

  constructor
  . --
    intro h
    --show p x
    exact h

  . --
    intro hpx
    show p x
    exact hpx

/-
`subset_def`

`S` is a subset of `T` if and only if every element of `S` is an element
of `T`.

  ∀ S T : Set X,  S ⊆ T ↔ ∀ x : X, x ∈ S → x ∈ T
-/

-- ## The empty set and the universal set

/-
`not_mem_empty`

No element belongs to the empty set.

  ∀ x : X,  x ∉ ∅
-/

/-
`mem_univ`

Every element belongs to the universal set.

  ∀ x : X,  x ∈ univ
-/

-- ## Singleton and insertion

/-
`mem_singleton_iff`

An element `x` belongs to the singleton `{a}` if and only if `x` equals `a`.

  ∀ a x : X,  x ∈ {a} ↔ x = a
-/

/-
`mem_insert_iff`

An element `x` belongs to the set obtained by inserting `a` into `S` if and
only if `x` equals `a` or `x` belongs to `S`.

  ∀ a x : X, ∀ S : Set X,  x ∈ insert a S ↔ x = a ∨ x ∈ S
-/

-- ## Binary operations

/-
`mem_union_iff`

An element belongs to the union of `S` and `T` if and only if it belongs to
`S` or it belongs to `T`.

  ∀ S T : Set X, ∀ x : X,  x ∈ S ∪ T ↔ x ∈ S ∨ x ∈ T
-/

/-
`mem_inter_iff`

An element belongs to the intersection of `S` and `T` if and only if it
belongs to `S` and it belongs to `T`.

  ∀ S T : Set X, ∀ x : X,  x ∈ S ∩ T ↔ x ∈ S ∧ x ∈ T
-/

/-
`mem_diff_iff`

An element belongs to the difference `S \ T` if and only if it belongs to
`S` and does not belong to `T`.

  ∀ S T : Set X, ∀ x : X,  x ∈ S \ T ↔ x ∈ S ∧ x ∉ T
-/

/-
`mem_compl_iff`

An element belongs to the complement of `S` if and only if it does not
belong to `S`.

  ∀ S : Set X, ∀ x : X,  x ∈ Sᶜ ↔ x ∉ S

There is no `ᶜ` notation yet; the complement is written `Set.compl S`.
-/

-- ## Indexed and unindexed families

/-
`mem_iUnion_iff`

Let `(S i)` be a family of sets of elements of `X`, indexed by `i : I`. An
element belongs to the union of the family if and only if it belongs to
`S i` for at least one index `i`.

  ∀ S : I → Set X, ∀ x : X,  x ∈ ⋃ i, S i ↔ ∃ i : I, x ∈ S i

There is no `⋃` notation yet; the union is written `Set.iUnion S`.
-/

/-
`mem_iInter_iff`

Let `(S i)` be a family of sets of elements of `X`, indexed by `i : I`. An
element belongs to the intersection of the family if and only if it belongs
to `S i` for every index `i`.

  ∀ S : I → Set X, ∀ x : X,  x ∈ ⋂ i, S i ↔ ∀ i : I, x ∈ S i

There is no `⋂` notation yet; the intersection is written `Set.iInter S`.
-/

/-
`mem_sUnion_iff`

Let `C` be a set of sets of elements of `X`. An element belongs to the union
of `C` if and only if it belongs to at least one member of `C`.

  ∀ C : Set (Set X), ∀ x : X,  x ∈ ⋃₀ C ↔ ∃ S : Set X, S ∈ C ∧ x ∈ S

There is no `⋃₀` notation yet; the union is written `Set.sUnion C`.
-/

end Set

end Aim
