/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
/-!
# Metric Spaces

Metric space axioms (positivity, symmetry, triangle inequality), open and closed balls,
boundedness, metric convergence, Cauchy sequences, and complete metric spaces.
-/

namespace Aim

universe u v

/-- A distance function on `X` valued in `R`, together with a proof that every
distance is non-negative.

The domain and codomain may live in different universes. The codomain will
normally be instantiated with the reals once they are constructed. -/
structure Distance (X : Type u) (R : Type v) [Zero R] [LE R] where
  dist : X → X → R
  dist_nonneg : ∀ x y : X, 0 ≤ dist x y

end Aim
