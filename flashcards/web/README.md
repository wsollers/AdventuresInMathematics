# Foundations web review

Static flashcard application published under /AdventuresInMath/flashcards/.

The source JSON remains under flashcards/content/ordered-fields. The central GitHub Pages workflow copies both the app and deck to the same public directory. Do not publish personal review histories in GitHub.

Features: KaTeX math rendering, keyboard controls, mobile and tablet responsive layout, manual levels, new/due/practice/browse modes, four ratings with deterministic spaced-review dates, local progress, JSON backup and restore, and optional same-origin offline caching after visiting online.

Review and unlock state are kept in localStorage under aim-foundations-review-v1. No account synchronization, analytics, or credentials. Deleting site data deletes review history unless it has been exported.

Browse mode does not grade cards and does not bypass the manual-unlock policy for scheduled review. Card-specific prerequisites must have been reviewed to enter the new-card queue.

Run checks from repository root:

  node --test flashcards/web/tests/*.test.mjs
  python3 flashcards/content/ordered-fields/validate.py

Math notation uses pinned KaTeX 0.16.22 loaded from jsDelivr; offline use requires that external library to have been cached by the browser. If unavailable, card text remains readable as raw LaTeX.

