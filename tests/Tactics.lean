import Aim.Common.Common

-- Importing Common should make both tactics available without opening a namespace.
example (a b : Nat) (h : a = b) : a + a = b + a := by
  nth_rewrite 1 [h]
  rfl

example (a b : Nat) (h : a = b) : a + a + a = a + b + b := by
  nth_rw 2 3 [h]

-- Rewrite only the first occurrence in a hypothesis, preserving its RHS.
example (a b c : Nat) (hab : a = b) (h : c + b = b) : c + a = b := by
  nth_rewrite 1 [← hab] at h
  exact h

-- Each successive rule counts occurrences in the updated expression.
example (a b c : Nat) (hab : a = b) (hbc : b = c) : a + a = c + a := by
  nth_rw 1 [hab, hbc]
