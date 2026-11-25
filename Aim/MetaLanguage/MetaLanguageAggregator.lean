/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.MetaLanguage.Eq
import Aim.MetaLanguage.Set
import Aim.MetaLanguage.Satisfies.SetInterface
import Aim.MetaLanguage.Collections.CollectionsAggregator
import Aim.MetaLanguage.Algorithms.AlgorithmsAggregator

/-!
# The Metalanguage

The mathematics we reason *with*, as opposed to the mathematics we construct.

In the notes, the **object language** is the formal language under study
(symbols, expressions, wffs), and the **metalanguage** is the language used to
describe it. Enderton fixes his metalanguage in Chapter 0, "Useful Facts about
Sets". This module is the Lean counterpart of Chapter 0: everything here is
*assumed* machinery, not a construction under study.

## The two-tier rule

| | Metalanguage (this module) | Object-level build-out |
|---|---|---|
| Where | `Logic`, `ProofTheory`, `ModelTheory` only | `Set`, `Number`, `Algebra`, `Topology`, `Analysis` |
| ℕ | Lean's `Nat` | Peano axioms + one construction, nothing skipped |
| Sequences | Lean's `List` | whatever the object theory builds |
| Sets | predicates `α → Prop` | set theory: axioms + one development |
| `=` | Lean's `Eq` | the `=` symbol of first-order logic, with its axioms |
| Automation | anything, e.g. `omega`, `simp`, `decide` | only what the construction has earned |

In the metalanguage we **lean on Lean**: built-in types and their library
lemmas are tools, as Enderton's Chapter 0 is a toolkit. Rebuilding them here
would teach nothing that the object-level build-out does not teach properly.

In the object-level build-out, axioms are the **fields of a `structure`**
(e.g. a `PeanoSystem`), never Lean `axiom` declarations, so Lean's trusted base
never grows; one implementation is then proved to satisfy them.

## Import rule

* `Aim.Logic`, `Aim.ProofTheory`, `Aim.ModelTheory`, `Aim.TypeTheory`, and
  `Aim.LambdaCalculus` (and the root aggregator `Aim`) may import these tools.
* General `Aim.Induction` proofs depend on the shared set interface, not on
  this module or its certificates.
* The object-level layers must not import it, and must not use `Nat`, `List`
  or a library `Set`, except in one **bridge file** per subject, which proves
  the construction agrees with the built-in (e.g. Peano ℕ ≅ `Nat`).

This keeps the object-level build-out buildable from its own axioms alone.

## Trusted host

Lean's kernel and core logic: `Prop`, `=`, `∧`, `∨`, `¬`, `→`, `↔`, `∀`, `∃`,
`True`, `False`, and the inductive-type mechanism. Classical excluded middle
and choice are allowed when stated.

## Planned contents

Lazily: an item is added when a proof first needs it.

* `IdentityAndEquality/` contains the equality and identity interfaces,
  constructions, and satisfaction certificates. `MetaLanguage/Eq.lean`
  preserves the former names as compatibility aliases.

* `Set.lean` supplies `MetaSet`, a thin predicate wrapper; its separate
  `Satisfies/SetInterface.lean` certificate supplies the common set contract.
* `Collections/` supplies `MetaList`, `MetaTree`, and `MetaMultiset`. Lists
  reuse Lean directly; trees use a host inductive type; multisets use host
  lists modulo permutation because Lean core has no multiset container.
* `Algorithms/` reserves generic symbol-sequence operations. Binding-aware
  substitution stays with the syntax whose binding rules it implements.
-/
