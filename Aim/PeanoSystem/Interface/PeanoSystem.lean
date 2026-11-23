/-!
# Peano System Interface

A Peano system is a type with a distinguished base element and a successor
map satisfying the three Peano axioms. The interface does not say what the
base element is called: a zero-based system names it `0`, a one-based system
names it `1`. That choice belongs to the number system built on top.

Source: Feferman, *The Number Systems*, Chapter 3.
-/

namespace Aim

universe u

/-- A type with a base element and a successor map satisfying the Peano axioms. -/
class PeanoSystem (N : Type u) where
  base : N
  succ : N → N

  base_not_succ : ∀ n : N,
    base ≠ succ n

  succ_injective : ∀ {m n : N},
    succ m = succ n → m = n

  induction : ∀ (P : N → Prop),
    P base →
    (∀ n, P n → P (succ n)) →
    ∀ n, P n

export PeanoSystem (succ)

end Aim
