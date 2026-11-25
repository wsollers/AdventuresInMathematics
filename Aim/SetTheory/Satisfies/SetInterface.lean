import Aim.SetTheory.Interface.Set
import Aim.SetTheory.Interface.SetInterface

/-! # Typed Sets Satisfy the Minimal Set Interface -/

namespace Aim

universe u

/-- The existing project set representation supplies the common contract. -/
instance {X : Type u} : SetInterface X (Set X) where
  ofPredicate := setOf
  mem_ofPredicate := by
    intro p x
    rfl
  ext := by
    intro S T h
    exact Set.ext h

end Aim
