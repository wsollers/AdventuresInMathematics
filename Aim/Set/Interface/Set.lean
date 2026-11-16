/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

/-! # Set Interface -/

namespace Aim.Set

universe u v

class Interface (Element : Type u) (S : Type v)
    extends Membership Element S, Union S, Inter S where
  mem_union : ∀ (x : Element) (A B : S),
    x ∈ (A ∪ B) ↔ x ∈ A ∨ x ∈ B

  mem_inter : ∀ (x : Element) (A B : S),
    x ∈ (A ∩ B) ↔ x ∈ A ∧ x ∈ B

end Aim.Set
