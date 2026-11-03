/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Lean.Parser.Command

/-!
# Common Project Settings and Conventions

Project-wide conventions for `aim`. This module holds *how we write*, not
*what we know*: it contains no mathematics.

## Textbook-facing declaration keywords

Lean elaborates each of these as an ordinary `theorem` or `example`; the
keywords only make a declaration read like the statement in the notes. The
`TexExport` tool (from `lra-notes`) chooses the LaTeX environment from the
keyword a declaration was written with, so keep these names stable.

| Keyword          | Elaborates as | Use for                                        |
|------------------|---------------|------------------------------------------------|
| `lemma`          | `theorem`     | auxiliary results (core Lean has no `lemma`)   |
| `proposition`    | `theorem`     | results of middling importance                 |
| `corollary`      | `theorem`     | immediate consequences                         |
| `named_exercise` | `theorem`     | exercises that later declarations cite         |
| `exercise`       | `example`     | exercises checked once and never cited         |
| `counterexample` | `example`     | counterexamples and non-examples               |

Mathematical content does not belong here: the metalanguage kit lives in
`Aim.MetaLanguage`.
-/

open Lean

/-- `lemma` is a textbook-facing synonym for `theorem`. Core Lean, unlike
Mathlib, does not provide it. -/
syntax (name := lemmaCommand) declModifiers
  group("lemma " declId ppIndent(declSig) declVal) : command

@[macro lemmaCommand] def expandLemma : Macro := fun stx =>
  let stx := stx.modifyArg 1 fun stx =>
    let stx := stx.modifyArg 0 (mkAtomFrom · "theorem" (canonical := true))
    stx.setKind ``Parser.Command.theorem
  pure <| stx.setKind ``Parser.Command.declaration

/-- `proposition` is a textbook-facing synonym for `theorem`. -/
syntax (name := propositionCommand) declModifiers
  group("proposition " declId ppIndent(declSig) declVal) : command

@[macro propositionCommand] def expandProposition : Macro := fun stx =>
  let stx := stx.modifyArg 1 fun stx =>
    let stx := stx.modifyArg 0 (mkAtomFrom · "theorem" (canonical := true))
    stx.setKind ``Parser.Command.theorem
  pure <| stx.setKind ``Parser.Command.declaration

/-- `corollary` is a textbook-facing synonym for `theorem`. -/
syntax (name := corollaryCommand) declModifiers
  group("corollary " declId ppIndent(declSig) declVal) : command

@[macro corollaryCommand] def expandCorollary : Macro := fun stx =>
  let stx := stx.modifyArg 1 fun stx =>
    let stx := stx.modifyArg 0 (mkAtomFrom · "theorem" (canonical := true))
    stx.setKind ``Parser.Command.theorem
  pure <| stx.setKind ``Parser.Command.declaration

/-- `named_exercise` is a textbook-facing synonym for a named `theorem`: an
exercise whose result later declarations cite. -/
syntax (name := namedExerciseCommand) declModifiers
  group("named_exercise " declId ppIndent(declSig) declVal) : command

@[macro namedExerciseCommand] def expandNamedExercise : Macro := fun stx =>
  let stx := stx.modifyArg 1 fun stx =>
    let stx := stx.modifyArg 0 (mkAtomFrom · "theorem" (canonical := true))
    stx.setKind ``Parser.Command.theorem
  pure <| stx.setKind ``Parser.Command.declaration

/-- `exercise` is a textbook-facing synonym for an anonymous `example`: an
exercise checked once and never cited. Use `named_exercise` for one that is. -/
syntax (name := exerciseCommand) declModifiers
  group("exercise " ppIndent(optDeclSig) declVal) : command

@[macro exerciseCommand] def expandExercise : Macro := fun stx =>
  let stx := stx.modifyArg 1 fun stx =>
    let stx := stx.modifyArg 0 (mkAtomFrom · "example" (canonical := true))
    stx.setKind ``Parser.Command.example
  pure <| stx.setKind ``Parser.Command.declaration

/-- `counterexample` is a textbook-facing synonym for an anonymous `example`. -/
syntax (name := counterexampleCommand) "counterexample " ":" term " := " term : command

macro_rules
  | `(counterexample : $ty:term := $val:term) =>
      `(example : $ty := $val)

namespace aim.common

end aim.common
