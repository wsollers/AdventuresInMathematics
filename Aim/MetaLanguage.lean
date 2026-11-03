/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# The Metalanguage

The mathematics we reason *with*, as opposed to the mathematics we construct.

In the notes, the **object language** is the formal language under study
(symbols, expressions, wffs), and the **metalanguage** is the language used to
describe it. Enderton fixes his metalanguage in Chapter 0, "Useful Facts about
Sets". This module is the Lean counterpart of Chapter 0: everything here is
*assumed* machinery, not a construction under study.

## Trusted host

Lean's kernel and core logic are the trusted host, used without apology:
`Prop`, `=`, `∧`, `∨`, `¬`, `→`, `↔`, `∀`, `∃`, `True`, `False`, and the
inductive-type mechanism itself.

Core *types* allowed in metalanguage code (extend this list deliberately, and
note why):

* `Bool`, `Option`, `Prod`, `Sum`, `Unit`, `Empty`
* `DecidableEq` and `Decidable`, for computable comparison of symbols

Core types **not** used, because the project constructs their mathematics
itself: `Nat`, `Int`, `List`, `Array`, `String` (as mathematics), `Fin`.

## Planned contents

Each item is something §1.1 already used informally.

* `MetaLanguage/Nat.lean`: `MetaNat`, with addition, `<` and `≤`, and
  **strong induction** proved as a theorem.
* `MetaLanguage/Seq.lean`: finite sequences, with `append`, `length`, indexed
  access and the last entry; the monoid laws; `count` and `count_append`
  (counts add under concatenation).
* `MetaLanguage/Pred.lean`: sets as predicates `α → Prop`; membership, `⊆`,
  set equality, and closure under one- and two-place operations.

## Rule of use

`MetaLanguage` is for metatheoretic use only. In particular `Aim.Number`
constructs ℕ as mathematics under study and must not use `MetaNat` in its
place. The two meet in exactly one bridge theorem, `MetaNat ≅ ℕ`, which
lives in the `Number` layer.

Imports run one way: `MetaLanguage` imports `Common`; `Common` imports no
mathematics.
-/

namespace aim.meta

end aim.meta
