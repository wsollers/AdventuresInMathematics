# Handoff: Tarski on identity and equality

You are the **Tarski** conversation in the AIM notes project. Your topic is
identity and equality as logical notions, and the difference between an
object and its name.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request. If the
   computer is not reachable, say so and work from the GitHub clone and
   attachments.
2. Attach the GitHub repository `wsollers/AdventuresInMathematics` with push
   access, clone it, and create the branch `notes/tarski` from `main`.
3. Read `notes/CONVENTIONS.md` in full before anything else, and follow it.
   In particular: proofs are William's (structural hints only), check against
   the actual page, and write only inside `notes/tarski/`.

## Source

Tarski, *Introduction to Logic and to the Methodology of Deductive
Sciences*. File: `D:\Readings\Sources\Foundations\Logic\Introduction to Logic
and the Methodology of Deductive Science - Tarski.pdf`.
Printed page + 25 = PDF page.

| Section | Printed pages | PDF pages | Focus |
|---|---|---|---|
| Ch. III §16 Logical concepts outside sentential calculus; identity | 49 | 74 | why identity belongs to logic |
| §17 Fundamental laws of the theory of identity | 50–53 | 75–78 | Leibniz's law first; reflexivity, symmetry, transitivity derived |
| **§18 Identity of objects and identity of their designations; quotation marks** | 53–56 | 78–81 | **core**: use vs. mention |
| §19 Equality in arithmetic and geometry vs. logical identity | 56–58 | 81–83 | equality "in a theory" vs. identity |
| §20 Numerical quantifiers, exercises | 58–62 | 83–87 | optional |

## Why this matters to AIM

* Tarski's derivation of the identity laws from Leibniz's law mirrors
  `Aim/MetaLanguage/Eq.lean`: `MetaEq.subst` (proved by William) gives
  symmetry, transitivity and congruence. Point this out where it applies.
* §18 is the source for the "names and notation" layer of the planned
  *Formal languages* section: a symbol vs. its designation.

## Deliverables

* `notes/tarski/ch3.tex` (using `../aim-notes`), built through the workflow.
* `notes/tarski/corrections.md`.
* Cross-references for the hub: where Tarski agrees with or differs from
  Enderton §2.4 and Mendelson §2.8.
