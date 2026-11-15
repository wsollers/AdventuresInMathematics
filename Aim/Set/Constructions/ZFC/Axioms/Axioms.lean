/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/

/-! # ZFC Axioms -/

namespace aim.set.constructions.zfc

axiom EmptySet : ∃ A : ZFCSet, ∀ x : ZFCSet, x ∉ A

end aim.set.constructions.zfc
