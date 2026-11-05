# Corrections: Nederpelt & Geuvers, *Type Theory and Formal Proof*

Flashcard material from checking William's handwritten notes (CONVENTIONS §3).
Originals: `handwritten/2026-11-04-nederpelt-p1.jpg` … `p7.jpg` (not revised).

Page numbers: printed page = PDF page − 29. Items marked **verify** were
checked against the text from knowledge of the book, not against the PDF page;
settle them against the page.

## §§1.1–1.2 (handwritten pp. 1–4)

| # | Where | Kind | Note |
|---|---|---|---|
| 1 | p1, "Defn. λ-calculus" | status error | Descriptive sentence from §1.1, not a definition; nothing is defined by it. Record as a remark. |
| 2 | p3, "M[x:=N] means M in which N has been substituted for x" | imprecise | Only the **free** occurrences of x are replaced. Informal here; precise in §1.6 (Def. 1.6.1, **verify** number). |
| 3 | p3, Example (i) "(λy.5)(3) → 5[y:=3] → 5" | imprecise | Only the first arrow is a β-step. The second is evaluating the substitution: 5[y:=3] ≡ 5. Write →β for the step and ≡ for the result. Same for (ii) and (iii). Also "5[y=3]" is missing the colon. |
| 4 | p2, "λ notation struggles with complicated functions like x ↦ (x if x ≥ 0, −x if x < 0)" | verify | Check whether this is N&G's remark or your own. If yours, label it so. Such functions are expressible once a conditional is available; the difficulty is notational. |
| 5 | p4, compatibility | status | Informal in §1.2 (Example 1.2.4, **verify** number); the rules become part of Def. 1.8.1. Keep as informal with a forward pointer, as you have. |
| 6 | p4, "λ(x,y) can be done" | imprecise | λ binds exactly one variable; λ(x,y).M is not a term of Λ. At most an informal abbreviation. Multi-argument functions are handled only by currying. |
| 7 | p4, "The expression is called the curried version" | imprecise | Say which expression: λx.(λy.M) is the curried version of the two-argument function (x, y) ↦ M. |

## §1.3 (handwritten pp. 5–7)

| # | Where | Kind | Note |
|---|---|---|---|
| 8 | p5, "Understanding Inductive and Deductive Defs." | verify | "Deductive" looks like a slip for "recursive" (the companion notion to inductive). Confirm what you meant. |
| 9 | p5, inductive definition (U, B, F) | merged convention | This is Enderton §1.4's framework, not N&G's; cite Enderton. Fine to use, but mark the source. |
| 10 | p5, inductive definition | missing remark | The intersection is over a nonempty family because U itself is closed. Say so; otherwise ⋂ ∅ is undefined (or is "everything"). |
| 11 | p5, inductive definition applied to Λ | missing quantified form | Abstraction takes a *variable* and a term, so it is not an operation U^n → U on terms alone. Fit it to the framework as one unary operation abs_u for each u ∈ V. Then F is infinite (but each rule is finitary). Instantiate your quantified form for Λ. |
| 12 | p7, "Sub is a multiset of subterms" | imprecise | ∪ in Def. 1.3.5 is **multiset** union, so a subterm can occur more than once (e.g. x in Sub(xx)). "L ∈ Sub(M)" means at least one occurrence. |
| 13 | p7, Lemma 1.3.6 | missing quantified form | Both parts quantify over λ-terms (test 1). Write ∀M ∈ Λ (M ∈ Sub(M)) and ∀L,M,N ∈ Λ (L ∈ Sub(M) ∧ M ∈ Sub(N) → L ∈ Sub(N)). |
| 14 | p7, proper subterm | wrong | "L is a proper subterm of M but L ≢ M" is circular. Should be: L is a **subterm** of M and L ≢ M. |
| 15 | p7, "A proper subterm is not reflexive" | imprecise | It is the *relation* "is a proper subterm of" that is irreflexive, not a subterm. Predicate reading (test 6) is missing. |

## §1.4 (handwritten p. 7)

No errors. The three categories (free, bound, binding occurrences) match the
opening of §1.4. "categories" was written as a correction above the line.
