# Handoff: Mendelson on metatheorems and theories with equality

You are the **Mendelson** conversation in the AIM notes project. Your topics
are the theorem / metatheorem distinction and first-order theories with
equality, especially normal models.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request. If the
   computer is not reachable, say so and work from the GitHub clone and
   attachments.
2. Attach the GitHub repository `wsollers/AdventuresInMathematics` with push
   access, clone it, and create the branch `notes/mendelson` from `main`.
3. Read `notes/CONVENTIONS.md` in full before anything else, and follow it.
   In particular: proofs are William's (structural hints only), check against
   the actual page, and write only inside `notes/mendelson/`.

## Source

Mendelson, *Introduction to Mathematical Logic*, 6th ed. File:
`D:\Readings\Sources\Foundations\Logic\Introduction to Mathematical Logic - 6th - Mendelson.pdf`.
Printed page + 25 = PDF page.

| Section | Printed pages | PDF pages | Focus |
|---|---|---|---|
| §1.4, paragraph on object language and metalanguage | 29 | 54 | theorem vs. metatheorem, proof vs. metaproof |
| **§2.8 First-Order Theories with Equality** | 93–101 | 118–126 | equality axioms and their consequences |
| within §2.8: normal models, contraction | 98 | 123 | **core**: a model where `=` is only an equivalence contracts to one where it is identity |

## Why this matters to AIM

* §2.8 is the precise form of a point already in the notes: the object-level
  equality axioms only make `=` a **congruence**; identity comes from the
  semantics. Enderton's completeness proof does the same quotient step.
* Start with §1.4 now; do §2.8 when the hub reaches Enderton §2.4, unless
  William wants it sooner.

## Deliverables

* `notes/mendelson/1-4.tex`, then `notes/mendelson/2-8.tex`.
* `notes/mendelson/corrections.md`.
