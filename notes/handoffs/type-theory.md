# Handoff: type theory for the metalanguage

You are the **type theory** conversation in the AIM notes project. Your goal
is narrow: give William enough of Lean's type theory to anchor his
metalanguage, so that he understands it and it no longer feels circular.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request.
2. Attach `wsollers/AdventuresInMathematics` with push access, clone it, and
   create the branch `notes/type-theory` from `main`.
3. Read `notes/CONVENTIONS.md` in full and follow it. Write only inside
   `notes/type-theory/`.

## The anchor (what "done" looks like)

The tower is not a circle:

| Level | What | Justified by |
|---|---|---|
| Object | first-order logic, PA, ZF | studied in Lean |
| Metalanguage | Lean's type theory (Calculus of Inductive Constructions + universes, proof-irrelevant `Prop`, quotients) | finite explicit rules, checked by a small kernel |
| Base | ordinary mathematics | where every textbook stands |

Done when William can read `inductive MetaEq`, `Nat.rec` and `#print axioms`
output, explain each from the rules, and state: *the metalanguage is Lean's
type theory; its rules are explicit and finite; its consistency follows from
ZFC plus inaccessible cardinals (Carneiro); each rule has an informal
meaning.*

## Scope

In: judgments (Γ ⊢ t : A); Π types (∀ as Π); propositions as types;
inductive types and recursors; definitional vs. propositional equality;
`Prop` vs. `Type` and universes (`Sort u`); Lean's axioms `propext`,
`Quot.sound`, `Classical.choice`.

Out: normalization and consistency proofs, homotopy type theory, categorical
semantics. Martin-Löf only on request (his theory is predicative and
constructive; it does not cover Lean's impredicative `Prop`).

## Readings, in order

1. Nederpelt & Geuvers, *Type Theory and Formal Proof*, Chs. 1–7 (Ch. 2
   simply typed λ-calculus; Chs. 5–6 dependent types and the Calculus of
   Constructions; Ch. 7 encoding logic). File:
   `D:\Readings\Sources\Foundations\Type Theory\Type Theory and Formal Proof - Nederpelt.pdf`.
2. *Theorem Proving in Lean 4* (official documentation, online): inductive
   types; induction and recursion; axioms and computation.
3. Mario Carneiro, *The Type Theory of Lean* (MSc thesis, 2019, online):
   the exact rules and the set-theoretic model.
4. Companion: Angiuli & Gratzer, *Principles of Dependent Type Theory*, Ch. 4
   (intensional type theory, identity types). Same folder.

## Worked example to use throughout

`Aim/MetaLanguage/Eq.lean`: `MetaEq` as a one-constructor inductive family,
its recursor as the source of substitution. William has proved `subst`;
`symm`, `trans`, `congrArg` and the two bridges are his to finish.

## Deliverables

* `notes/type-theory/` notes per reading, through the workflow.
* A short "Metalanguage anchor" section for the hub, to become part of
  Section 1 of the book.
