/-!
# Metalanguage Sets

A thin wrapper over host predicates, distinct from the mathematical `Aim.Set`
representation. The shared interface certificate is imported separately.
-/

namespace Aim

universe u

/-- Subsets used as primitive tools when studying formal languages. -/
structure MetaSet (X : Type u) where
  contains : X → Prop

namespace MetaSet

instance {X : Type u} : Membership X (MetaSet X) :=
  ⟨fun S x => S.contains x⟩

/-- Construct a metalanguage set from a predicate. -/
def ofPredicate {X : Type u} (p : X → Prop) : MetaSet X :=
  ⟨p⟩

end MetaSet
end Aim
