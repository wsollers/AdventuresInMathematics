# Ordered-field Foundations flashcards

This is a fresh, source-linked mathematics curriculum. No cards were copied from previous flashcard repositories.

- **375 version-controlled cards** in stages 00 through 08.
- **79 named derived results** have a dependency card and a proof-reconstruction card; four definitional identities do not require an independent theorem proof.
- **Manual study levels** are described in unlock-levels.json. The default review level is additive axioms; every card is assigned to exactly one level.
- **Web app:** https://wsollers.dev/AdventuresInMath/flashcards/
- **Schema and manifest:** schema.json and manifest.json.
- **Coverage audit:** coverage.json includes every row from the TeX reference, mapped Lean declarations, pedagogical proof coverage, and proof-placeholder status.

## Mathematical authority

The source scope is output/pdf/ordered_field_reference.tex, with comparisons to Aim/Analysis/Numbers.lean. Subtraction and division are defined operations; the Archimedean property is a separate Lean mixin even though it follows mathematically from ordered-field completeness.

A declaration containing sorry is NOT formally verified. The coverage report distinguishes its statement from completed proof status. No flashcard should be taken as proof of Lean compilation or of full formal correctness.

## Validation

From the repository root:

    python -m pip install jsonschema
    python flashcards/content/ordered-fields/validate.py
    node --test flashcards/web/tests/scheduler.test.mjs

GitHub Actions also runs static UI, DOM interaction, and pinned KaTeX compatibility tests.

Personal review state is kept in the browser. Do not commit learning history or import the old lra-flashcards decks.
