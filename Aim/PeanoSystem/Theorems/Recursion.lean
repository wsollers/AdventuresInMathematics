import Aim.PeanoSystem.Interface.PeanoSystem

/-!
# Definition by Recursion

On a Peano system, a function is determined by its value at the base and a
rule for passing from each element to its successor. This file states that
theorem and turns it into a usable function, `recurse`.

After this file, `recurse` is used only through its two equations,
`recurse_base` and `recurse_succ`. Nothing should unfold its definition.

The theorem does not depend on what the base element is called, so it is
stated for any `PeanoSystem`.

Source: Feferman, *The Number Systems*, Theorem 3.4.

## Plan of the proof

1. Call a relation between `N` and `X` *closed* when it relates the base to
   `a` and, whenever it relates `n` to `x`, relates `succ n` to `f x`.
2. Let `R` be the intersection of all closed relations.
3. `R` is closed.
4. Every `n` is related by `R` to at least one `x`. (Induction.)
5. Every `n` is related by `R` to at most one `x`. (Induction; this is the
   step that uses `base_not_succ` and `succ_injective`.)
6. Steps 4 and 5 give a function; step 3 gives its two equations.
-/

namespace Aim

universe u v

variable {N : Type u} [PeanoSystem N] {X : Type v}

/-- **Recursion theorem (existence).** For every starting value `a` and step
`f` there is a function on the Peano system taking the base to `a` and
commuting with successor and `f`. -/
theorem recursion (a : X) (f : X → X) :
    ∃ g : N → X, g PeanoSystem.base = a ∧ ∀ n, g (succ n) = f (g n) := by
  sorry

/-
`recursion_unique`  (recursion theorem, uniqueness)

Let `a` be an element of `X` and `f` a function from `X` to `X`. If `g` and
`h` are functions from `N` to `X` that both take the base to `a` and both
satisfy the successor equation, then `g` and `h` are equal.

  ∀ a : X, ∀ f : X → X, ∀ g h : N → X,
    (g base = a ∧ ∀ n : N, g (succ n) = f (g n)) →
    (h base = a ∧ ∀ n : N, h (succ n) = f (h n)) →
    g = h
-/

/-- The function defined by recursion from the starting value `a` and the
step `f`. -/
noncomputable def recurse (a : X) (f : X → X) : N → X :=
  Classical.choose (recursion (N := N) a f)

/-- `recurse a f` takes the base to the starting value. -/
theorem recurse_base (a : X) (f : X → X) :
    recurse (N := N) a f PeanoSystem.base = a := by
  have h := Classical.choose_spec (recursion (N := N) a f)
  exact h.1

/-- `recurse a f` at a successor applies the step to the previous value. -/
theorem recurse_succ (a : X) (f : X → X) (n : N) :
    recurse a f (succ n) = f (recurse a f n) := by
  have h := Classical.choose_spec (recursion (N := N) a f)
  exact h.2 n

end Aim
