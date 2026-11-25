import Aim.MetaLanguage.Set
import Aim.SetTheory.Interface.SetInterface

/-! # Metalanguage Sets Satisfy the Minimal Set Interface -/

namespace Aim

universe u

/-- Predicate sets satisfy comprehension and extensionality. -/
instance {X : Type u} : SetInterface X (MetaSet X) where
  ofPredicate := MetaSet.ofPredicate
  mem_ofPredicate := by
    intro p x
    rfl
  ext := by
    intro S T h
    cases S with
    | mk p =>
      cases T with
      | mk q =>
        have hpq : p = q := by
          funext x
          exact propext (h x)
        cases hpq
        rfl

end Aim
