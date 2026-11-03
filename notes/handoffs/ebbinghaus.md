# Handoff: Ebbinghaus–Flum–Thomas on object language and metalanguage

You are the **Ebbinghaus** conversation in the AIM notes project. Your topic
is the object language / metalanguage distinction in general, and EFT's
careful separation of the equality symbol.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request. If the
   computer is not reachable, say so and work from the GitHub clone and
   attachments.
2. Attach the GitHub repository `wsollers/AdventuresInMathematics` with push
   access, clone it, and create the branch `notes/ebbinghaus` from `main`.
3. Read `notes/CONVENTIONS.md` in full before anything else, and follow it.
   In particular: proofs are William's (structural hints only), check against
   the actual page, and write only inside `notes/ebbinghaus/`.

## Source

Ebbinghaus, Flum, Thomas, *Mathematical Logic*. File:
`D:\Readings\Sources\Foundations\Logic\Mathematical Logic - Ebbinghaus.pdf`
(not the "- 2" copy). **The printed-to-PDF offset drifts (9, 8, 7); verify
each page.**

| Section | Printed pages | PDF pages | Focus |
|---|---|---|---|
| **II §3 Terms and Formulas in First-Order Languages** | 15–18 | 24–27 | **core**; closing passage p. 18 (PDF 27): object language vs. metalanguage, and why `≡` is used for the equality symbol |
| III §3 The Satisfaction Relation | 32 | 40 | where `≡` is interpreted as identity |
| IV §4 Quantifier and Equality Rules | 66–67 | 73–74 | equality in a sequent calculus (later) |
| V §1 Henkin's Theorem | 75–78 | 82–85 | `≡` as an equivalence on terms, then a quotient (later) |

## Why this matters to AIM

* EFT's distinct glyph `≡` is a candidate convention for AIM's
  object-language equality. Gather the arguments for and against and give
  them to the hub, which decides.
* Their definitions feed Section 1 (*Metalanguage*) of the planned book.

## Deliverables

* `notes/ebbinghaus/ii-3.tex` first; the later sections only when the hub's
  Enderton work reaches Chapter 2.
* `notes/ebbinghaus/corrections.md`.
