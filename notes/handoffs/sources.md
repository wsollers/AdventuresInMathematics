# Handoff: sources, extracted text and a portable full-text index

You are the **sources** conversation in the AIM project. This is tooling, not
mathematics. Keep it small: it must not grow into another infrastructure
project that displaces the notes.

## Setup (do this first)

1. This session should be linked to William's computer **hal5000**. Request
   access to `F:\repos` and `D:\Readings` in a single request.
2. Attach `wsollers/AdventuresInMathematics` with push access if the tool
   ends up in AIM; read `notes/CONVENTIONS.md`.

## What exists

* PDFs: `D:\Readings\Sources\…` (canonical; also retrievable from Google
  Drive).
* Page-level extracted text for about 600 sources:
  `D:\Readings\indexes\lra\library\markdown\LIB-<sha>.md`, with YAML front
  matter (title, sha256, local path) and `=== Page N ===` markers (**PDF**
  pages). All core AIM sources are present: Enderton (both), Tarski,
  Mendelson 6th, Ebbinghaus, Manin, Mileti, Tao I, Simpson, Stillwell.
* `F:\repos\lra-source-profiles`: the existing, heavy ingestion and profile
  pipeline (manifest keyed by SHA-256).
* No full-text index exists; grepping 600 files from the shell times out.

## What William wants

* The extracted markdown and the indexes stored in **Google Drive** and
  mirrored locally (hal5000, zarathustra), so search is portable.
* A **skill** for searching the books, so any conversation can find and cite
  a page.
* He has also considered a new library project that syncs and dedupes across
  hal5000, zarathustra and Drive, and duplicating the source-profile work.
  Discuss with him before building anything that large.

## Recommended shape (agree it with William first)

1. **One SQLite file** built from the existing markdown: a pages table
   (source id, title, PDF page, printed page, text), an FTS5 table, and a
   sources table with printed-page offsets. Store a schema version and build
   date. Build on one machine; publish a read-only copy to Drive.
2. **Printed pages**: detect from running headers and footers per page, with
   a manual override per source; offsets can drift within a book.
3. **A query script** returning source, printed page, PDF page and a snippet.
4. **A skill** (proposed through the skill review card) that finds the index
   (local mirror, or downloads it from Drive into a cloud session) and runs
   the script. Rule: always cite the printed page and read the page itself
   before asserting anything.
5. **Sync**: Google Drive for desktop or rclone, not custom code. Dedupe as a
   one-off pass keyed on SHA-256.

## Constraints

* Extracted text is copyrighted book text: private Drive only, never in git,
  never shared.
* Decide with William where the tool lives: in `lra-source-profiles` (reuse)
  or in AIM (independence).
* Time-box it. Done means: index on Drive, mirrored on both machines, skill
  saved, and a query for "construction sequence" returning Enderton §1.1,
  printed p. 17–18.
