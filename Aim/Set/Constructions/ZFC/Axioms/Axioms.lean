/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

/-! # ZFC Axioms -/

namespace Aim.Set.Constructions.ZFC

axiom EmptySet : ∃ A : ZFCSet, ∀ x : ZFCSet, x ∉ A

end Aim.Set.Constructions.ZFC
