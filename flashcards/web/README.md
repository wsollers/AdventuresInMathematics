# Foundations web review

The public entry point at https://wsollers.dev/AdventuresInMath/flashcards/ sends visitors to the owner-private Sites app with ChatGPT sign-in. The central GitHub Pages workflow publishes only this entry point, not the app or grading endpoint.

The source JSON remains under flashcards/content/ordered-fields. The Sites Worker serves the app and deck behind the platform authorization boundary. Do not publish personal review histories in GitHub.

Features: KaTeX math rendering, keyboard controls, mobile and tablet responsive layout, manual levels, new/due/practice/browse modes, four ratings with deterministic spaced-review dates, local progress, JSON backup and restore, and ChatGPT-authorized access.

Review and unlock state are kept in localStorage under aim-foundations-review-v1. No account synchronization, analytics, or credentials. Deleting site data deletes review history unless it has been exported.

Each card includes an S Pen handwriting pad with finger rejection enabled by default, undo and clear controls, plus an editable answer field and optional browser speech recognition. Uncheck S Pen only to draw with a finger. Ink scales with the tablet layout and remains visible when revealing the answer; ink and text clear when changing cards or filters and are never saved or exported.

Submit answer uses the optional same-origin POST /api/grade endpoint. The private Sites Worker in ../server reads handwriting and text using the OpenAI Responses API, returns advisory feedback and a transcription, and suggests a rating. A review is saved only when the user accepts a rating. Unreadable input earns no passing grade. Requests use store:false; submission sends the answer to OpenAI. A purely static GitHub Pages deployment cannot run the grader and displays a connection message while preserving the response.

The worker requires OPENAI_API_KEY as a Sites runtime secret; GRADING_MODEL defaults to gpt-4.1. Build with `node flashcards/server/build-site.mjs <Sites checkout>` from the repository root. The checkout must already have its hosting manifest and the shared site CSS/JS assets. This worker relies on the owner-private Sites access boundary and must not be made public without adding authorization and usage controls. Never put the API key in browser assets or Git.

Voice starts only after tapping Speak answer. It stops on reveal, navigation, hiding the tab, or Stop microphone. Speech recognition depends on browser support, permission and service availability; it may send audio to the browser vendor and require internet. Unsupported browsers can use keyboard dictation in the answer field. Real Samsung S Pen hardware and microphone service behavior need device verification.

Browse mode does not grade cards and does not bypass the manual-unlock policy for scheduled review. Card-specific prerequisites must have been reviewed to enter the new-card queue.

Run checks from repository root:

  node --test flashcards/web/tests/*.test.mjs
  python3 flashcards/content/ordered-fields/validate.py

Math notation uses pinned KaTeX 0.16.22 loaded from jsDelivr. If unavailable, card text remains readable as raw LaTeX. Offline app caching is retired so requests go through authorization. The retirement service worker deletes only Foundations caches and preserves browser progress.

