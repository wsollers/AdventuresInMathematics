/-
Copyright (c) 2022 Moritz Doll. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Moritz Doll

Adapted from Mathlib/Tactic/NthRewrite.lean:
https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Tactic/NthRewrite.lean

Modifications (2026): import Lean directly instead of Mathlib.Init, use the
Aim.Common.Tactics namespace, and shorten the documentation. The macros retain
the upstream implementation. No Mathlib dependency is introduced.
The accompanying LICENSE applies to this adapted file.
-/
import Lean

/-!
# Occurrence-specific rewriting

`nth_rewrite` and `nth_rw` select one or more occurrences, numbered from 1.
Both accept rewrite direction (`←`), configuration options, and locations (`at h`).
`nth_rw` also attempts reflexivity, like core Lean's `rw`.
-/

namespace Aim.Common.Tactics

open Lean Elab Tactic Meta Parser.Tactic

/-- Rewrite only the specified occurrences, numbered from 1. -/
macro "nth_rewrite" c:optConfig ppSpace nums:(num)+ s:rwRuleSeq loc:(location)? : tactic => do
  `(tactic| rewrite $[$(getConfigItems c)]* (occs := .pos [$[$nums],*]) $s:rwRuleSeq $(loc)?)

/-- Like `nth_rewrite`, also try closing the goal by reflexivity. -/
macro "nth_rw" c:optConfig ppSpace nums:(num)+ s:rwRuleSeq loc:(location)? : tactic => do
  `(tactic| rw $[$(getConfigItems c)]* (occs := .pos [$[$nums],*]) $s:rwRuleSeq $(loc)?)

end Aim.Common.Tactics
