# Structure audit prompt

Paste everything below the line into a fresh session opened at the repository
root.

---

I want an independent audit of how this Lean 4 repository is structured. I am
not asking you to write mathematics or fill in proofs. I am asking whether the
structure will hold up as the project grows, and I need an answer I can rely
on, so please check claims by running things, and tell me which of your
findings you verified and which you inferred.

## What the project is

`AdventuresInMathematics` formalizes undergraduate pure mathematics from first
principles in Lean 4, without Mathlib. I am the learner: I write the
definitions and proofs myself. Most proofs are `sorry` on purpose. A `sorry`
is never a finding. A statement that is false, unprovable as written, or
unusable by its consumers is.

Read these first: `AGENTS.md`, `README.md`, `ARCHITECTURE.md`, everything in
`architecture/`, and `Aim/Logic/logic-todo.md`. Then read the Lean sources
under `Aim/` and `validation/mathlib/`. Empty stub files are expected.

## The requirement to audit against

I want four independent places to start work, and each must work without me
first finishing the others:

1. **Logic**: propositional, first-order, second-order, modal, temporal.
2. **Sets**: building out set theory.
3. **Number systems**: constructing ℕ, ℤ, ℚ, ℝ.
4. **Analysis**: sequences, limits, metric spaces, point-set topology.

The mechanism is supposed to be interfaces. Analysis consumes a set
interface, a natural-number interface and a complete-ordered-field interface.
It must not care how any of them is constructed. Constructions are developed
separately and proved to satisfy the interface. Swapping a construction must
not break a consumer.

## Decisions already made

Evaluate these on their merits. If one causes a concrete failure, show the
failure. Do not reopen them on taste alone.

- All mathematics is declared in the flat `Aim` namespace. A sub-namespace
  exists only when it is the name of a type and holds that type's operations.
  Folders do not determine namespaces.
- A file that only re-exports its folder is named `<Folder>Aggregator.lean`.
- Typed sets are predicates (`Aim.Set X := X → Prop`). Foundational set theory
  is a separate, later object of study.
- `Aim.PeanoSystem` has an unnamed base element. `Aim.NaturalNumbers` extends
  it and names the base `0`. A one-based system is a possible later marker.
- Definition by recursion will be proved as a theorem from `Prop`-valued
  induction (Feferman's route), not added as an interface field.
- The scope of the natural-number layer is in
  `architecture/natural-numbers.md`. Multiplication, exponentiation, strong
  induction and categoricity are deliberately deferred.
- `Field` is flat, with no group or ring layers yet. There is no
  `PartialOrder` yet.
- Mathlib appears only in the separate `validation/mathlib` package.

## Questions

For each of the four entry points:

- Can I start there today? What is the first thing I would write, and what
  would stop me?
- What does it import, directly and transitively? Does that match the
  intended independence? Produce the actual import graph from the files, not
  from the README.
- If I change the internals of a layer beneath it, what breaks above?

About the interfaces:

- Is each interface a real abstraction boundary, or can consumers see through
  it? Look for definitional unfolding that consumers would come to rely on,
  reducible definitions, and instances that leak.
- Does each interface contain enough for its consumers, and nothing a
  construction would struggle to supply? Name the specific missing or excess
  item and who needs it.
- Is every interface satisfiable, and is the stated construction able to
  satisfy it? Check the statements, not the proofs.
- Are there typeclass problems waiting: diamonds, overlapping or global
  instances, instances that will collide with Lean core, universe issues,
  `OfNat` or notation clashes, anything that forces `noncomputable` where it
  will hurt?

About the whole:

- Is the dependency order between top-level folders one-directional? List
  any cycle or any import that points the wrong way.
- Is anything defined twice, or defined in a place its consumers cannot
  import without pulling in something unrelated?
- Does the layout have a home for what is planned: second-order, modal and
  temporal logic; relations and functions; ℤ, ℚ and ℝ with more than one
  construction of ℝ; metric spaces over an abstract ordered field?
- Which choices will be expensive to change after a few thousand lines are
  written on top of them? Those matter most.
- Is anything stale or misleading: documentation that no longer matches the
  code, files that claim to be something they are not?

## How to work

- Do not modify the repository. The working tree has uncommitted changes that
  are intentional.
- Build before judging: run `lake build` at the root. The validation package
  builds with `lake build` inside `validation/mathlib` and needs the Mathlib
  cache.
- To test a claim, write a throwaway `.lean` file outside the repository and
  check it with `lake env lean <file>` from the root. For example, to test
  whether analysis can be written against the interfaces, try stating a
  sequence limit over `[NaturalNumbers N]` and `[CompleteOrderedField R]` and
  see what is missing.
- Read the code, not only the documents. Where they disagree, the code is the
  truth and the disagreement is a finding.

## What I want back

1. A one-paragraph verdict: is the structure sound for the stated
   requirement, yes or no, and the main reason.
2. A table with one row per entry point: ready, ready with gaps, or blocked,
   and the reason in a sentence.
3. Findings, most serious first. For each one:
   - what is wrong, in a sentence;
   - the file and line;
   - a concrete scenario where it bites;
   - whether you verified it, and how;
   - the smallest change that would fix it.
4. A separate short list of choices that are fine now but costly to reverse
   later.
5. Anything you looked for and found to be sound, in a line each, so I know
   what was covered.

Keep it to what matters. I would rather have five findings I can trust than
thirty I have to check.
