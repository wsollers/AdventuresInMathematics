# AIM notes: conventions

Every conversation working on AIM notes reads this file first. It is owned by
the **hub** conversation (Enderton). A topic conversation that wants a
convention changed proposes it to the hub; it does not edit this file.

## 1. What the notes are for

The goal is one rigorous, formalized book of undergraduate mathematics:
every object constructed before it is used, every proof written by William,
every statement checked by Lean where possible. Developing mathematical
maturity — how to learn a definition, theorem, example or exercise — is an
explicit goal, not a side effect.

Two levels of document:

* **Source notes** (`notes/<source>/`): notes on one book's section, in that
  book's conventions, citing its pages.
* **Assembled sections** (the book): William's own development, built only
  from source notes. **The book never claims more than the notes cover.** A
  node in the outline with no source note behind it is a *gap*; the remedy is
  to find a source and take notes, not to write the node from nowhere.

## 2. Working with William

* **Proofs are his.** Give structural hints and confirmations only, never a
  complete proof, unless he explicitly asks for one.
* He writes handwritten notes and proofs first. The handwritten pages are kept
  as originals (photographed, dated, under `notes/<source>/handwritten/`) and
  are **not** revised; the typeset version is the study copy.
* When checking, return a list keyed by line or item. Do not rewrite his
  notes; he fixes them.
* Check against the **actual source page**, never from memory. Cite the
  printed page, and the PDF page when they differ. If unsure of a reading or a
  wording, mark it **verify** rather than asserting it.

## 3. Workflow per section

1. **Capture**: handwritten notes on the section.
2. **Check**: Claude checks them against the source. Each item is classified:
   * *wrong*: contradicts the source;
   * *imprecise*: true in spirit, false as stated;
   * *merged convention*: another book's convention silently mixed in;
   * *status error*: a theorem labelled a definition or the reverse;
   * *missing quantified form*: required by §5 and absent or mismatched;
   * *verify*: Claude is not certain; settle against the page.
3. **Log**: corrections go to `notes/<source>/corrections.md` (flashcard
   material).
4. **Attempt**: handwritten proofs; structural hints only if stuck.
5. **Write**: Claude typesets William's proof with the agreed fixes.
6. **Formalize**: Lean statement, checked against the typeset statement, then
   the proof. `sorry` allowed while in progress.
7. **Admit**: a node is done when every required field is filled.

## 4. Node format (LaTeX)

All notes use `notes/aim-notes.sty` (`\usepackage{../aim-notes}`). Each
definition or result carries:

| Field | Macro / environment | Required |
|---|---|---|
| Label | `\label{def:…}` / `thm:` / `lem:` / `prop:` / `ex:` | yes |
| Source | `\source{Book §x.y, p. N.}` | yes |
| Uses | `\uses{label, …}` (feeds the dependency graph) | yes |
| Motivation | `\motivation{…}` | definitions and major results |
| Statement | the environment body, in the source's convention | yes |
| Quantified form | `quantified` environment | per §5 |
| Proof | `proof` environment, William's proof | results |
| Proof structure | `remark[Proof structure]` sketch | encouraged |
| Idea | `remark[Idea]`, one line | encouraged |
| Examples | example, non-example, near miss | definitions |
| Lean | `\lean{decl}`, `\leanok` only with no `sorry` | when formalized |
| Open slot | `\pending{…}` (orange box) | for items still to write |

Keep the quantified forms: they are part of the thinking. Do not add a second
"learning" proof.

## 5. When a quantified form is required

Run the tests in order; the first that fires decides.

| # | The statement… | Then write |
|---|---|---|
| 1 | quantifies over sets, properties or functions | required; name each domain |
| 2 | defines a least set closed under operations | required, intersection form |
| 3 | claims uniqueness ("the", "exactly one") | required, ∃! expanded |
| 4 | alternates quantifiers (∀∃, ∃∀) | required, plus the negation |
| 5 | uses a variable the English leaves unbound | required; make the ∀ explicit |
| 6 | introduces a predicate or property | required, as a predicate reading |
| 7 | introduces a structure or tuple | a signature instead |
| 8 | names a constant, notation or abbreviation | not needed |

Also write the negation wherever a proof argues by contradiction or a
counterexample is needed. Quantified forms in Chapter 1 material are
**metalanguage** statements; the sentential language itself has none.

## 6. How to study each kind of node

* **Definition**: its type (set, predicate, function, structure); quantified
  form and negation; example, non-example, near miss; drop each clause and
  see what gets in; compare with another source's definition; why it is
  needed now.
* **Theorem**: hypotheses and conclusion, quantified; a small case by hand;
  drop each hypothesis and find the counterexample; the converse; proof
  skeleton before details; afterwards the one-line idea and the `\uses` list.
* **Example**: what it instantiates; verify every clause explicitly; perturb
  it until it stops being an example.
* **Exercise**: restate in quantified form and classify; small instances;
  name the results you expect to use; hints only; afterwards the key idea and
  any error to `corrections.md`.

## 7. Object language and metalanguage

* The **object language** is the formal language under study; the
  **metalanguage** is the language used to describe it (ordinary mathematics
  plus English). Keep them apart in notation: α, β are metavariables; A₁, A₂
  are sentence symbols.
* What a proof may use: anything from the assumed metatheory (Enderton Ch. 0
  plus ordinary mathematics), and any object-language notion already defined.
  Not: object-language notions defined later.
* Metalanguage `=` is identity (Lean's `Eq`). Object-language `=` is a symbol
  of first-order logic: axiomatized as a congruence (Enderton §2.4, groups 5
  and 6), made identity only by its semantic clause. Whether to write the
  object symbol with a distinct glyph (EFT's `≡`) is **open**; the hub decides.

## 8. Lean: the two-tier rule

| | Metalanguage | Object-level build-out |
|---|---|---|
| Layers | `Logic`, `ProofTheory`, `ModelTheory` | `Set`, `Number`, `Algebra`, `Topology`, `Analysis` |
| ℕ, lists, sets, `=` | Lean's `Nat`, `List`, `α → Prop`, `Eq` | built from real axioms, one implementation, nothing skipped |
| Automation | anything (`omega`, `simp`, …) | only what the construction has earned |

* Only the logic layers import `Aim.MetaLanguage`. Object-level layers never
  import the logic tier; model-theory files may import object-level ones
  (e.g. to prove a construction is a model of PA).
* Built-in `Nat`/`List`/`Set` appear in an object-level layer only in one
  **bridge file** per subject.
* Axioms: Lean `axiom` is allowed for object-level axiom groups, with this
  discipline: axioms only about **fresh opaque constants** of the group;
  a **witness** (a model constructed in Lean) for each group; and a
  `#print axioms` audit showing logic-tier theorems use no project axioms.
* `Aim.Common` holds only conventions: the keywords `lemma`, `proposition`,
  `corollary`, `named_exercise`, `exercise`, `counterexample`.

## 9. Repository discipline

* Each topic conversation writes only inside its own `notes/<source>/`
  folder. Shared files (`CONVENTIONS.md`, `aim-notes.sty`, `Aim/Common`,
  `Aim/MetaLanguage.lean`) belong to the hub.
* Commit to a branch named `notes/<source>` and open a pull request, or ask
  William before pushing to `main`.
* Line endings are LF (`.gitattributes`). Extracted book text never goes in
  git.
* Commit messages end with the attribution lines the session provides.

## 10. Sources

* PDFs: `D:\Readings\Sources\…` on hal5000 (canonical), retrievable from
  Google Drive.
* Page-level extracted text: `D:\Readings\indexes\lra\library\markdown\`
  (`=== Page N ===` markers are PDF pages, not printed pages).
* A portable full-text index (SQLite FTS5 on Drive, plus a search skill) is
  being designed in the sources conversation. Until it exists, search with
  `pdftotext` on hal5000.

## 11. Conversations

| Conversation | Folder | Handoff |
|---|---|---|
| Hub (Enderton) | `notes/enderton/` | — |
| Tarski | `notes/tarski/` | `notes/handoffs/tarski.md` |
| Ebbinghaus–Flum–Thomas | `notes/ebbinghaus/` | `notes/handoffs/ebbinghaus.md` |
| Mendelson | `notes/mendelson/` | `notes/handoffs/mendelson.md` |
| Tao | `notes/tao/` | `notes/handoffs/tao.md` |
| Type theory | `notes/type-theory/` | `notes/handoffs/type-theory.md` |
| Sources and index | (tooling, not notes) | `notes/handoffs/sources.md` |
