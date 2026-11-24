/-!
# Sets

Typed sets, modeled as predicates in the same way as Lean's standard mathematical
set libraries.
-/

namespace Aim

universe u v

/-- A set of elements of `X` is a predicate on `X`. -/
def Set (X : Type u) : Type u :=
  X → Prop

/-- Turn a predicate into a set. -/
def setOf {X : Type u} (predicate : X → Prop) : Set X :=
  predicate

/-- Set-builder notation: `{x | p x}` is the set of all `x` satisfying `p`.

The notation is scoped: it is available inside `namespace Aim` and after
`open Aim`, so it does not collide with other libraries' set notation. -/
scoped syntax "{" ident " | " term "}" : term

/-- Set-builder notation with the type of the variable written out:
`{x : X | p x}`. -/
scoped syntax "{" ident " : " term " | " term "}" : term

scoped macro_rules
  | `({ $x:ident | $p }) => `(setOf fun $x:ident => $p)
  | `({ $x:ident : $t | $p }) => `(setOf fun ($x:ident : $t) => $p)

/-- Display `setOf fun x => p x` as `{x | p x}` in the InfoView. -/
@[app_unexpander setOf] def setOf.unexpander : Lean.PrettyPrinter.Unexpander
  | `($_ fun $x:ident => $p) => `({ $x:ident | $p })
  | `($_ fun ($x:ident : $t) => $p) => `({ $x:ident : $t | $p })
  | _ => throw ()

namespace Set

/-- Membership in a set. -/
protected def Mem {X : Type u} (S : Set X) (x : X) : Prop :=
  S x

instance {X : Type u} : Membership X (Set X) :=
  ⟨Set.Mem⟩

/-- Two sets are equal when they have exactly the same elements. -/
theorem ext {X : Type u} {S T : Set X}
    (h : ∀ x, x ∈ S ↔ x ∈ T) : S = T := by
  funext x
  exact propext (h x)

/-- Every element of a subset belongs to its superset. -/
protected def Subset {X : Type u} (S T : Set X) : Prop :=
  ∀ ⦃x⦄, x ∈ S → x ∈ T

instance {X : Type u} : HasSubset (Set X) :=
  ⟨Set.Subset⟩

/-- The empty set contains no elements. -/
instance {X : Type u} : EmptyCollection (Set X) :=
  ⟨fun _ => False⟩

/-- The universal set contains every element of `X`. -/
def univ {X : Type u} : Set X :=
  fun _ => True

/-- Insert an element into a set. -/
protected def insert {X : Type u} (a : X) (S : Set X) : Set X :=
  fun x => x = a ∨ x ∈ S

instance {X : Type u} : Insert X (Set X) :=
  ⟨Set.insert⟩

/-- The singleton set containing `a`. -/
protected def singleton {X : Type u} (a : X) : Set X :=
  fun x => x = a

instance {X : Type u} : Singleton X (Set X) :=
  ⟨Set.singleton⟩

/-- The union contains the elements belonging to either set. -/
protected def union {X : Type u} (S T : Set X) : Set X :=
  fun x => x ∈ S ∨ x ∈ T

instance {X : Type u} : Union (Set X) :=
  ⟨Set.union⟩

/-- The intersection contains the elements belonging to both sets. -/
protected def inter {X : Type u} (S T : Set X) : Set X :=
  fun x => x ∈ S ∧ x ∈ T

instance {X : Type u} : Inter (Set X) :=
  ⟨Set.inter⟩

/-- Set difference contains the elements of `S` that do not belong to `T`. -/
protected def diff {X : Type u} (S T : Set X) : Set X :=
  fun x => x ∈ S ∧ x ∉ T

instance {X : Type u} : SDiff (Set X) :=
  ⟨Set.diff⟩

/-- The complement contains exactly the elements outside `S`. -/
protected def compl {X : Type u} (S : Set X) : Set X :=
  fun x => x ∉ S

/-- The union of an indexed family of sets. -/
def iUnion {I : Type v} {X : Type u} (S : I → Set X) : Set X :=
  fun x => ∃ i, x ∈ S i

/-- The intersection of an indexed family of sets. -/
def iInter {I : Type v} {X : Type u} (S : I → Set X) : Set X :=
  fun x => ∀ i, x ∈ S i

/-- The union of a set of sets. -/
def sUnion {X : Type u} (C : Set (Set X)) : Set X :=
  fun x => ∃ S, S ∈ C ∧ x ∈ S

end Set

end Aim
