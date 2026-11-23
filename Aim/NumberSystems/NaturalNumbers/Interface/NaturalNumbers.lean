/-!
# Natural Number Interface

The Peano interface shared by natural-number constructions.
-/

namespace Aim.NumberSystems

universe u

/-- A type of natural numbers satisfying the Peano axioms. -/
class NaturalNumbers (N : Type u) extends OfNat N 0 where
  succ : N → N

  zero_not_succ : ∀ n : N,
    0 ≠ succ n

  succ_injective : ∀ {m n : N},
    succ m = succ n → m = n

  induction : ∀ (P : N → Prop),
    P 0 →
    (∀ n, P n → P (succ n)) →
    ∀ n, P n

end Aim.NumberSystems
