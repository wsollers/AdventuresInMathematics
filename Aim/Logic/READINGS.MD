# Adventures in Mathematics — Logic Reading Guide

**Current stage:** Formal languages and syntax. **Mode:** Read, take notes, work handwritten proofs and exercises, then create flashcards. **Lean implementation is on hold.**

## Canonical source locations

- Google Drive: [Readings](https://drive.google.com/drive/folders/1wacCUsIwhTyOP_jJl38DXFGI-9NCy-AX) → Sources → Foundations → [Logic](https://drive.google.com/drive/folders/14K9C2oB2j5_LhKpzN0TWIylEkjNV4XVn).
- GitHub: [AdventuresInMathematics](https://github.com/wsollers/AdventuresInMathematics) → [Aim/Logic](https://github.com/wsollers/AdventuresInMathematics/tree/main/Aim/Logic).
- This guide is the canonical study itinerary and source index for the Logic modules.
- **Page numbers are the printed book pages**, not PDF viewer indices. Links open source PDFs and are not asserted to jump to an exact passage.
- Keep original books in Drive; keep our original definitions, proof attempts, questions, and references in notes. Avoid reproducing substantial copyrighted passages.

## Study contract and goals

1. Formally distinguish alphabet, symbol, expression, term, WFF, sentence, theory, model, interpretation, and derivation.
2. Establish explicit **finite construction** of expressions despite an unbounded collection of possible expression lengths and arities.
3. Understand formation rules, *least closure*, construction sequences, structural induction, recursion, parsing, and unique readability.
4. Study propositional logic (PL), then first-order logic **without equality**, then FOL with explicit identity/equality as a separate extension. Second-order logic with equality is deferred.
5. Use a **shared formula representation** later for parsing, proof theory, and model-theoretic evaluation; do not implement it before studying its mathematics.
6. Distinguish object-language mathematics from the Lean metalanguage. **In the metalanguage, lean on Lean:** Lean's `Nat`, `List`, `Eq` and predicates `α → Prop` are used freely, and only inside the logic layers (`Logic`, `ProofTheory`, `ModelTheory`), through `Aim.MetaLanguage`. **In the object-level build-out** (`Set`, `Number`, `Algebra`, `Topology`, `Analysis`) nothing is skipped: ℕ, sets and equality get real axioms, stated as fields of a `structure` (never Lean `axiom`), and one implementation proved to satisfy them; built-in `Nat`, `List` and `Set` are not used there, except in a single bridge file per subject. Lean's kernel/type theory remains the explicitly documented trusted host. Classical excluded middle and choice are allowed when stated.

## Unit A — START HERE: Formal languages, symbols, and well-formed formulas

| Reading | Sections (printed pages) | What to learn |
|---|---|---|
| [Enderton — *A Mathematical Introduction to Logic*, 2nd ed.](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 1 **§1.0**, pp. **11–13** | Why formal languages require a defined alphabet and formation rules. |
| [Manin — *A Course in Mathematical Logic for Mathematicians*, 2nd ed.](https://drive.google.com/file/d/1kc9mCGvxPDVEbC9pKorxvAxamz9D0XQc/view?usp=drivesdk) | Part I, Ch. I **§1.1**, pp. **3–4**; **§§2.1–2.3**, pp. **5–7** | Alphabet as an abstract set; expressions as finite sequences; syntax and semantics described in a metalanguage; terms and formulas as least recursively generated classes. Read the formation machinery now, but defer the equality-bearing examples. |
| [Tarski — *Introduction to Logic and to the Methodology of the Deductive Sciences*, 4th ed.](https://drive.google.com/file/d/1o98AJ7PAh5KMmiSim79q_dmaxvEVYQb9/view) | Ch. I **§§1–2**, pp. **3–6** | Constants vs variables; sentential vs designatory functions; formulas vs sentences. |
| [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 1 **§1.1**, pp. **13–19** | Sentence symbols, connective symbols, the smallest class of WFFs, and construction sequences. |
| [Buss — *Introduction to Mathematical Logic*, Draft B.2.e](https://drive.google.com/file/d/1nQiKMjqVSxgo5VnvYltZ-iBtW1c8S3fc/view) | Ch. I **§I.2**, pp. **9–11** | Independent inductive definition of propositional syntax, strict parentheses, and abbreviations. |

**Produce notes:** definitions (in your own words) of alphabet, symbol, expression, WFF, sentential function, designatory function, formation rule, and construction sequence. Include an example and nonexample; cite the particular book's convention rather than silently merging different grammars.

**Exercises:** Enderton §1.1, Ex. **1** (English-to-symbol translations). Independently give a formation-rule construction for `((¬A1) → (A2 ∧ A3))` using Enderton's explicit parenthesization. Make the implicit finite construction explicit.

**Mastery checkpoint:** Explain why infinitely many sentence symbols and arbitrarily large arities do not imply infinitely long *individual* WFFs. Distinguish a mathematically meaningful English sentence from a formally admissible WFF.

## Unit B — Generated expressions, induction, and unique readability

| Reading | Sections (printed pages) | Distinct contribution |
|---|---|---|
| [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 1 **§1.3**, from p. **29**, and **§1.4**, from p. **34** | Parsing algorithms; induction and recursion based on expression construction. |
| [Manin](https://drive.google.com/file/d/1kc9mCGvxPDVEbC9pKorxvAxamz9D0XQc/view?usp=drivesdk) | Part I, Ch. II **§§1.1–1.4**, pp. **19–22** | Finite sequences, concatenation, occurrences and substitution, parentheses matching, and the Unique Reading Lemma. Stop before §§1.5–1.6 on bound variables and substitution hygiene. |
| [Mileti — *A Mathematical Introduction to Mathematical Logic*](https://drive.google.com/file/d/1lUVqhX1pdIei1BSpOodirPds49ViJvzY/view) | Ch. 1 **§§1.2–1.3**, pp. **8–14**; Ch. 2 **§§2.2–2.5**, pp. **17–35**; Ch. 3 **§3.1**, from p. **39** | **Highest-value supplement:** generating systems, step induction, **freeness**, step recursion, comparison of syntax conventions. |
| [Mundici — *Logic: A Brief Course*](https://drive.google.com/file/d/1fwzF-FxnnHPyD-AtcC0aDvIVH_Q7Zu0w/view) | Ch. **7**, **§§7.1–7.2**, pp. **35–38** | Explicit discussion of unambiguous syntax. |
| [Buss](https://drive.google.com/file/d/1nQiKMjqVSxgo5VnvYltZ-iBtW1c8S3fc/view) | Ch. I **§I.9**, from p. **33** | Proofs by induction on syntactically built objects. |

**Especially investigate:** Why is the least set closed under formation operations required? Can an expression have two different formation histories? Why does that matter for a recursively defined evaluator? Mileti's *freeness* discussion is the key additional reading.

**Exercises:** Enderton §1.1 Ex. **2** (possible WFF lengths), **3** (atomic occurrences and binary connective occurrences), **4** (deleting construction-sequence members), **5(a,b)** (length and atom-count results without negation). Prove statements, rather than just checking examples.

**Mastery checkpoint:** Write a structural-induction proof, a complete construction sequence, and a short explanation of unique readability. Explain how a parser reconstructs the formula tree from a symbol string.

## Unit C — Propositional interpretation and consequence

| Reading | Sections (printed pages) | Goal |
|---|---|---|
| [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 1 **§1.2**, pp. **20–28** | Truth assignments and the recursive value of a WFF. |
| [Buss](https://drive.google.com/file/d/1nQiKMjqVSxgo5VnvYltZ-iBtW1c8S3fc/view) | Ch. I **§§I.3–I.6**, pp. **12–24** | Truth, satisfiability, tautologies, implication, and truth tables. |
| [van Dalen — *Logic and Structure*, 4th ed.](https://drive.google.com/file/d/1XtPJCdPPMM2MjAOBal4U81A-lXEU9ud0/view) | Ch. 1 **§§1.1–1.2**, pp. **5–20** | Independent presentation of connectives and semantics. |

**Examples:** Show that `A → B, B → C, A ⊢ C`; show that `A → B, B → C` alone do *not* entail `C` by giving a countervaluation. Explain satisfaction in a valuation vs validity under all valuations, and distinguish `Γ ⊢ φ` from `Γ ⊨ φ`.

## Unit D — FOL syntax without identity (later)

| Reading | Sections (printed pages) | Goal |
|---|---|---|
| [Tarski](https://drive.google.com/file/d/1o98AJ7PAh5KMmiSim79q_dmaxvEVYQb9/view) | Ch. I **§§3–5**, pp. **7–13** | Quantifiers, bound/free variables, and construction of quantified sentences. |
| [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 2 **§§2.0–2.1**, pp. **67–79**, and **§2.3**, from p. **105** | First-order languages, terms, WFFs, parsing; **set aside equality** where the book includes it. |
| [Ebbinghaus–Flum–Thomas — *Mathematical Logic*](https://drive.google.com/file/d/1HrJK0yRmleMafYWry5rym_3D1MDVlOS1/view) | Ch. **II §§1–5**, pp. **11–26** | Particularly systematic: alphabets, term/formula formation, induction, free variables, sentences. |
| [van Dalen](https://drive.google.com/file/d/1XtPJCdPPMM2MjAOBal4U81A-lXEU9ud0/view) | Ch. 2 **§§2.1–2.5**, pp. **57–80**; prioritize **§2.3** p. **60** | Signatures (similarity types), structures, interpretation; defer §2.6 Identity. |

**Exercise:** Specify the symbols and formulas for 'Socrates is a man; every man is mortal; therefore Socrates is mortal'. Explain its proof and interpretation *without* introducing equality.

## Unit E — Formal systems, proof theory, model theory (later)

| Reading | Sections | Goal |
|---|---|---|
| [Tarski](https://drive.google.com/file/d/1o98AJ7PAh5KMmiSim79q_dmaxvEVYQb9/view) | Ch. VI **§§36–40**, pp. **109–125** | Primitive terms, definitions, axioms, theorems, interpretations, and formalization. |
| [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view) | Ch. 2 **§2.2**, p. **80** onward, and **§§2.4–2.6**, from pp. **109, 131, 147** | Models, deductive calculus, soundness/completeness, models of theories. |
| [Hodel — *An Introduction to Mathematical Logic*](https://drive.google.com/file/d/1dvvow8WnYv6OmlWJVlGxiHpq8Mg4bLpx/view) | Ch. 1 **§1.3** p. **7**, Ch. 2 **§2.1** p. **48**, Ch. 3 **§3.6** p. **117** | The notion of a formal system, propositional grammar, and Gentzen-style proof systems. |
| [van Dalen](https://drive.google.com/file/d/1XtPJCdPPMM2MjAOBal4U81A-lXEU9ud0/view) | Ch. 1 **§1.4** p. **30**, Ch. 2 **§2.8** p. **91** | Natural deduction introduction/elimination rules. |

**Mastery checkpoint:** Explain separately: is this text a WFF? is it true in a model? does it follow from assumptions in all models? does a derivation prove it? A proof *checker* and proof *searcher* are not the same operation.

## The most interesting additional sources — consult selectively, do not read all now

| Book in Drive Logic folder | Where | Why it adds something |
|---|---|---|
| [Mileti](https://drive.google.com/file/d/1lUVqhX1pdIei1BSpOodirPds49ViJvzY/view) | Ch. 2 §§2.2–2.5 | **Top supplement now:** generation, freeness and recursive definitions; directly addresses why WFF construction and evaluation work. |
| [Mundici](https://drive.google.com/file/d/1fwzF-FxnnHPyD-AtcC0aDvIVH_Q7Zu0w/view) | Ch. 7 §§7.1–7.2; later Ch. 12 | Syntax unambiguity and a later first-order syntax comparison. |
| [Manin — *A Course in Mathematical Logic for Mathematicians*, 2nd ed.](https://drive.google.com/file/d/1kc9mCGvxPDVEbC9pKorxvAxamz9D0XQc/view?usp=drivesdk) | Now: Part I, Ch. I §§1.1, 2.1–2.3 (pp. 3–7) and Ch. II §§1.1–1.4 (pp. 19–22); later §§1.5–1.6 | Advanced parallel treatment of alphabet, finite expressions, recursive formation, and **Unique Reading**; later extends this to free/bound variables and substitution hygiene. |
| [Kossak — *Mathematical Logic: On Numbers, Sets, Structures, and Symmetry*](https://drive.google.com/file/d/1MlvdUCrnzl3-UwJIH1jmvaVCzxAwFsED/view) | Ch. 1 §§1.1.1, 1.2 (pp. 6, 8) | Why choose a vocabulary, and how syntactic descriptions relate to mathematical structures. |
| [Bergmann, Moor & Nelson — *The Logic Book*, 6th ed.](https://drive.google.com/file/d/1v2GWUVm4HIf_HMrEsDbndtziTHNuxla9/view) | Ch. 2 §2.1 (p. 15); later Ch. 7 §7.2 (p. 268) | Syntax-first presentation and additional symbolization practice. |
| [Moerdijk & van Oosten — *Sets, Models and Proofs*](https://drive.google.com/file/d/14GJreSCwRcCnsrxVM76I98S08YW2HiDf/view) | Ch. 2 §2.2 (p. 44) | Compact definition of a signature with arities; note that this presentation already includes equality, unlike our first-pass FOL. |
| [Smullyan — *A Beginner's Guide to Mathematical Logic*](https://drive.google.com/file/d/1FMseH0rm7jpReydhp33Rwb5gfWlQX2OB/view) | Ch. 5; later Ch. 12 | Gentle proof-oriented motivation and formal systems, rather than a replacement for Enderton's syntax proofs. |

## Explicitly deferred: identity/equality and second-order logic

- [Tarski](https://drive.google.com/file/d/1o98AJ7PAh5KMmiSim79q_dmaxvEVYQb9/view), Ch. III §§16–19 (pp. 49–58) — the theory of identity and identity of designations.
- [van Dalen](https://drive.google.com/file/d/1XtPJCdPPMM2MjAOBal4U81A-lXEU9ud0/view), §§2.6 and 2.10 (pp. 81, 99) — identity and natural deduction.
- [Buss](https://drive.google.com/file/d/1nQiKMjqVSxgo5VnvYltZ-iBtW1c8S3fc/view), §III.7 (p. 103); [Mendelson](https://drive.google.com/file/d/1CjxCaBnOGGWd4G-i06Tpvh2k6vJQKt8c/view), §2.8 (p. 93); [Mundici](https://drive.google.com/file/d/1fwzF-FxnnHPyD-AtcC0aDvIVH_Q7Zu0w/view), Ch. 15 (p. 89) — axiom systems with equality.
- SOL: [Enderton](https://drive.google.com/file/d/1F6Qas73DDhcLVogF0uXLcYOZT8M0co0i/view), Ch. 4 §4.1 (p. 282); [van Dalen](https://drive.google.com/file/d/1XtPJCdPPMM2MjAOBal4U81A-lXEU9ud0/view), Ch. 4 (p. 143) — only after FOL with equality.

## Repeatable notes and exercise protocol

For each concept, maintain a note with: (1) source edition/section/printed page and Drive link; (2) definition in your own words; (3) rigorously quantified/formal statement; (4) prerequisites; (5) examples/nonexamples; (6) proof/exercise attempt; (7) referee feedback and first point of failure; (8) open questions; (9) flashcard candidates; (10) **Lean translation deferred until mastered**.

Use source wording and conventions accurately; label our extrapolations as commentary. Give no hints during referee-mode proof review unless requested. Make flashcards only after comprehension, with distinct cards for definitions, construction recognition, counterexamples, and theorem/proof recall.

### Later Lean notation glossary (study first, no code changes now)

Study the meaning of `inductive`, recursive definitions, `deriving Repr`, `DecidableEq`, implicit/explicit arguments and `@`, `Type` vs `Prop`, and the relation of structural induction to formation rules. Distinguish Lean's metatheoretic equality from the future object-language identity symbol.

## ChatGPT Space bootstrap: Adventures in Mathematics

Reference links to place in the Space's welcome/source-map page:

- **Formalization repository:** https://github.com/wsollers/AdventuresInMathematics
- **Logic modules:** https://github.com/wsollers/AdventuresInMathematics/tree/main/Aim/Logic
- **Canonical reading itinerary:** https://github.com/wsollers/AdventuresInMathematics/blob/main/Aim/Logic/READINGS.MD
- **Original textbook library:** https://drive.google.com/drive/folders/14K9C2oB2j5_LhKpzN0TWIylEkjNV4XVn
- **Google Drive Readings root:** https://drive.google.com/drive/folders/1wacCUsIwhTyOP_jJl38DXFGI-9NCy-AX

In the Space, create pages/subpages for Formal Languages & Syntax, Definitions, Examples & Counterexamples, Exercise Notebook, Proof Referee Reviews, Lean Concept Glossary, Flashcards, and Source Map. Refer to Drive PDFs by book/section/page, not copied full text. Keep the original source access permissions. **A GitHub link here does not grant a Space automatic synchronization or change permissions.**

## Reading progress

- [ ] A: Formal-language and WFF readings, handwritten construction
- [ ] B: Generated expressions, structural induction and unique readability
- [ ] C: PL truth assignments and consequence
- [ ] D: FOL syntax without equality
- [ ] E: Proofs, interpretations, models, and theories
- [ ] FOL with equality (later)
- [ ] SOL with equality (later)
