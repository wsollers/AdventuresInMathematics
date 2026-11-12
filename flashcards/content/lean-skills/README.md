# Lean skills: compiler-graded recall

Cards are grouped by skill. Each card supplies `context` (the binders of an isolated `example`), `expected_goal`, canonical tactic code, independently checked alternatives, and a stable ID.

## Verify

From the repository root, with Lean and Lake from `lean-toolchain` installed:

```sh
python3 flashcards/tools/verify_lean_skills.py --skip-compile
python3 flashcards/tools/verify_lean_skills.py
```

The second command compiles the actual module and one isolated example per candidate using `lake env lean`. A nonzero exit means at least one candidate failed. JSON results are written to `flashcards/reports/numbers-lean-skills-verification.json` (machine-generated, not a record of learner study). The committed card statuses remain `unverified` until successful execution and review; never infer success from syntactic plausibility.

For interactive grading, substitute the student's code for the canonical answer, run it with identical context and toolchain, and report the first useful compiler diagnostic. For technique-constrained prompts, check the requested construct separately *after* compiler success. Stable card IDs allow review metadata to live privately, outside Git.
