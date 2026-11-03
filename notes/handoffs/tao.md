# Handoff: Tao on the natural numbers

You are the **Tao** conversation in the AIM notes project. Your topic is the
natural numbers from the Peano axioms: addition, order, strong induction.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request. If the
   computer is not reachable, say so and work from the GitHub clone and
   attachments.
2. Attach the GitHub repository `wsollers/AdventuresInMathematics` with push
   access, clone it, and create the branch `notes/tao` from `main`.
3. Read `notes/CONVENTIONS.md` in full before anything else, and follow it.
   In particular: proofs are William's (structural hints only), check against
   the actual page, and write only inside `notes/tao/`.

## Decide first, with William

Under the two-tier rule (CONVENTIONS §8), metalanguage ℕ is Lean's `Nat`, so
there are two readings of this conversation. Ask him which one, before
starting:

* **Full (recommended):** this is the **object-level** ℕ: one implementation
  from real axioms, nothing skipped, no `omega`. These notes later drive
  `Aim/Number`.
* **Light:** document only the facts about ℕ that the logic layers assume,
  each mapped to Lean's `Nat`. Short, with few proofs.

## Source

Tao, *Analysis I*, Chapter 2. File:
`D:\Readings\Sources\Analysis\Real Analysis\Analysis 1 - Tao.pdf`. Compute
the printed-to-PDF offset before citing.

| Item | Notes |
|---|---|
| §2.1 Axioms 2.1–2.5, Assumption 2.6 | the Peano axioms; Axiom 2.5 (induction) quantifies over properties (test 1) |
| Proposition 2.1.16, recursive definitions | what makes addition definable |
| §2.2 definition of addition, the two lemmas before 2.2.4 | n + 0 = n; n + (m++) = (n + m)++ |
| Propositions 2.2.4–2.2.6 | commutativity, associativity, cancellation |
| Definition of order, Propositions 2.2.12–2.2.13 | basic properties, trichotomy |
| **Proposition 2.2.14, strong induction (Exercise 2.2.5)** | the first real target; both Enderton §1.1 proofs use it |
| §2.3 multiplication | not yet |

## Points to record in the notes

* In Lean, Axioms 2.1–2.5 are not axioms but consequences of an `inductive`
  declaration (distinct, injective constructors; the recursor). Note this
  beside each axiom. If the full reading is chosen, the object-level
  development must still state them as real axioms (CONVENTIONS §8), with a
  Lean witness.
* Well-definedness of recursive addition is Proposition 2.1.16 on paper;
  structural recursion in Lean.

## Deliverables

* `notes/tao/ch2.tex`, `notes/tao/corrections.md`.
* If full: the Lean plan for `Aim/Number/Peano` (statements with `sorry`), and
  the bridge "Peano ℕ ≅ `Nat`" kept in a single bridge file.
