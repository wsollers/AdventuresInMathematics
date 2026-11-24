# AdventuresInMathematics (`aim`)

A self-contained Lean 4 library for undergraduate mathematics, built from the ground up without `mathlib4`.

## Foundations flashcards

The ordered-fields Foundations deck has 375 public cards across nine stages, with theorem statements, prerequisite and hypothesis questions, and proof reconstruction.

- [Study the interactive web deck](https://wsollers.dev/AdventuresInMath/flashcards/) (mobile/tablet and desktop)
- [Review the version-controlled cards](flashcards/content/ordered-fields/)
- [Web app implementation and local-progress details](flashcards/web/README.md)

Review progress and unlocked levels are stored only in the browser, never in this public repository. The mathematical statements in the deck are not claims of formal Lean verification; see the coverage report for outstanding `sorry` placeholders.


## Architecture & Dependency Spine

Every module builds from the ground up along a linear axiomatic progression:

1. **Common** (`namespace Aim.Common`)
   - [`Aim/Common/Common.lean`](Aim/Common/Common.lean) — Project-wide foundations and universe conventions.
   - [`Aim/Common/Tactics.lean`](Aim/Common/Tactics.lean) — Local `nth_rewrite` and `nth_rw` macros, adapted from Mathlib with attribution and the [Apache-2.0 license](Aim/Common/LICENSE). Imported by `Common`; requires only Lean, not Mathlib.
2. **Logic** (`namespace Aim.Logic`)
   - [`Aim/Logic/Syntax.lean`](Aim/Logic/Syntax.lean) — Propositional variables (`A, B, C`), formula syntax trees, string parsing (`"A AND B"`).
   - [`Aim/Logic/Valuation.lean`](Aim/Logic/Valuation.lean) — Truth values, truth-functional valuations (`eval`), truth tables, and tautologies ($\models \varphi$).
   - [`Aim/Logic/Sentential.lean`](Aim/Logic/Sentential.lean) — Sentential (propositional) axioms and inference rules ($\vdash \varphi$).
   - [`Aim/Logic/Predicate.lean`](Aim/Logic/Predicate.lean) — Universal ($\forall$) and existential ($\exists, \exists!$) quantifiers.
   - [`Aim/Logic/Equality.lean`](Aim/Logic/Equality.lean) — Identity and Leibniz substitution axioms ($x = y \to P(x) \to P(y)$).
   - [`Aim/Logic/Choice.lean`](Aim/Logic/Choice.lean) — Axiom of Choice and definite description.
   - [`Aim/Logic/LogicAggregator.lean`](Aim/Logic/LogicAggregator.lean) — Aggregator.
   - [`Aim/Logic/READINGS.MD`](Aim/Logic/READINGS.MD) — Reading-first study guide (source-linked Enderton, Tarski, Buss, Mileti, and other Logic sources; exercises, notes, and mastery checkpoints).
3. **Set Theory** (types `Aim.Set`, `Aim.Class`, `Aim.Collection`, `Aim.Family`)
   - [`Aim/SetTheory/Interface/Set.lean`](Aim/SetTheory/Interface/Set.lean) — Typed sets as predicates; $\in, \subseteq, \cup, \cap, \setminus$, complement, indexed unions and intersections.
   - [`Aim/SetTheory/Interface/Class.lean`](Aim/SetTheory/Interface/Class.lean) — Classes; represented and proper classes.
   - [`Aim/SetTheory/Interface/Collection.lean`](Aim/SetTheory/Interface/Collection.lean) — Unindexed collections of sets.
   - [`Aim/SetTheory/Interface/Family.lean`](Aim/SetTheory/Interface/Family.lean) — Indexed families of sets.
   - [`Aim/SetTheory/Interface/Universe.lean`](Aim/SetTheory/Interface/Universe.lean) — Placeholder for a foundational universe.
   - [`Aim/SetTheory/SetTheoryAggregator.lean`](Aim/SetTheory/SetTheoryAggregator.lean) — Aggregator.
   - Design: [`architecture/set-interfaces.md`](architecture/set-interfaces.md).
4. **Order Theory** (declarations directly in `namespace Aim`)
   - [`Aim/OrderTheory/TotalOrder.lean`](Aim/OrderTheory/TotalOrder.lean) — Order axioms, `TotalOrder`, strict and non-strict comparison, maximum and minimum.
   - [`Aim/OrderTheory/Bounds.lean`](Aim/OrderTheory/Bounds.lean) — Upper and lower bounds, boundedness, greatest and least elements, least upper and greatest lower bounds.
   - [`Aim/OrderTheory/Completeness.lean`](Aim/OrderTheory/Completeness.lean) — The least-upper-bound property and its consequences; dense orders.
   - [`Aim/OrderTheory/OrderTheoryAggregator.lean`](Aim/OrderTheory/OrderTheoryAggregator.lean) — Aggregator.
5. **Algebra** (declarations directly in `namespace Aim`)
   - [`Aim/Algebra/Field.lean`](Aim/Algebra/Field.lean) — Field axioms as mixins, `Field`, and the derived arithmetic lemmas.
   - [`Aim/Algebra/OrderedField.lean`](Aim/Algebra/OrderedField.lean) — `OrderedField`, order with arithmetic, absolute value.
   - [`Aim/Algebra/CompleteOrderedField.lean`](Aim/Algebra/CompleteOrderedField.lean) — The axiomatic interface for the real numbers.
   - [`Aim/Algebra/Archimedean.lean`](Aim/Algebra/Archimedean.lean) — The cast from the natural numbers and the Archimedean property.
   - [`Aim/Algebra/OrderedField_Lemmas.md`](Aim/Algebra/OrderedField_Lemmas.md) — Statement-only worklist of derived lemmas.
   - [`Aim/Algebra/AlgebraAggregator.lean`](Aim/Algebra/AlgebraAggregator.lean) — Aggregator.
6. **Peano Systems** (class `Aim.PeanoSystem`)
   - [`Aim/PeanoSystem/Interface/PeanoSystem.lean`](Aim/PeanoSystem/Interface/PeanoSystem.lean) — Base element, successor, and the three Peano axioms; the base is not named.
   - [`Aim/PeanoSystem/Theorems/Recursion.lean`](Aim/PeanoSystem/Theorems/Recursion.lean) — The recursion theorem and `recurse`.
   - [`Aim/PeanoSystem/PeanoSystemAggregator.lean`](Aim/PeanoSystem/PeanoSystemAggregator.lean) — Aggregator.
7. **Number Systems** (class `Aim.NaturalNumbers`, construction `Aim.LeanNat`)
   - [`Aim/NumberSystems/NaturalNumbers/Interface/NaturalNumbers.lean`](Aim/NumberSystems/NaturalNumbers/Interface/NaturalNumbers.lean) — A Peano system whose base element is written `0`.
   - [`Aim/NumberSystems/NaturalNumbers/Constructions/LeanNat/`](Aim/NumberSystems/NaturalNumbers/Constructions/LeanNat/) — Lean's `Nat` as the first construction, with its `Satisfies` certificate.
   - [`Aim/NumberSystems/NumberSystemsAggregator.lean`](Aim/NumberSystems/NumberSystemsAggregator.lean) — Aggregator.
   - [`Aim/NumberSystems/READINGS.MD`](Aim/NumberSystems/READINGS.MD) — Reading guide: Landau for the natural numbers, Feferman for the number systems.
   - Design: [`architecture/natural-numbers.md`](architecture/natural-numbers.md). $\mathbb{Z}$, $\mathbb{Q}$ and $\mathbb{R}$ are not started.
8. **Proof Theory** (`namespace Aim.ProofTheory`)
   - [`Aim/ProofTheory/Syntax.lean`](Aim/ProofTheory/Syntax.lean) — First-order terms, formulas, and capture-avoiding substitution.
   - [`Aim/ProofTheory/Hilbert.lean`](Aim/ProofTheory/Hilbert.lean) — Hilbert-style axiomatic calculus and the Deduction Theorem.
   - [`Aim/ProofTheory/NaturalDeduction.lean`](Aim/ProofTheory/NaturalDeduction.lean) — Gentzen's Natural Deduction ($\mathsf{NJ} / \mathsf{NK}$).
   - [`Aim/ProofTheory/SequentCalculus.lean`](Aim/ProofTheory/SequentCalculus.lean) — Gentzen's Sequent Calculus ($\mathsf{LJ} / \mathsf{LK}$) and Cut-Elimination.
   - [`Aim/ProofTheory/ProofTheoryAggregator.lean`](Aim/ProofTheory/ProofTheoryAggregator.lean) — Aggregator.
9. **Model Theory** (`namespace Aim.ModelTheory`)
   - [`Aim/ModelTheory/Language.lean`](Aim/ModelTheory/Language.lean) — First-order signatures and languages $\mathcal{L}$.
   - [`Aim/ModelTheory/Structure.lean`](Aim/ModelTheory/Structure.lean) — $\mathcal{L}$-structures $\mathfrak{M}$, embeddings, and isomorphisms.
   - [`Aim/ModelTheory/Satisfaction.lean`](Aim/ModelTheory/Satisfaction.lean) — Tarski's truth definition ($\mathfrak{M} \models \varphi$) and Soundness.
   - [`Aim/ModelTheory/Completeness.lean`](Aim/ModelTheory/Completeness.lean) — Henkin construction, Gödel's Completeness Theorem, and Compactness.
   - [`Aim/ModelTheory/ModelTheoryAggregator.lean`](Aim/ModelTheory/ModelTheoryAggregator.lean) — Aggregator.
10. **Topology & Metric Spaces** (`namespace Aim.Topology`)
   - [`Aim/Topology/MetricSpace.lean`](Aim/Topology/MetricSpace.lean) — Metric axioms, open balls, Cauchy sequences, complete metric spaces.
   - [`Aim/Topology/TopologicalSpace.lean`](Aim/Topology/TopologicalSpace.lean) — Open/closed sets, bases, interior, closure, Hausdorff spaces.
   - [`Aim/Topology/Continuity.lean`](Aim/Topology/Continuity.lean) — Continuous maps, homeomorphisms, subspaces, products.
   - [`Aim/Topology/Compactness.lean`](Aim/Topology/Compactness.lean) — Open covers, sequential compactness, Heine-Borel Theorem.
   - [`Aim/Topology/Connectedness.lean`](Aim/Topology/Connectedness.lean) — Connected and path-connected spaces.
   - [`Aim/Topology/TopologyAggregator.lean`](Aim/Topology/TopologyAggregator.lean) — Aggregator.
11. **Real Analysis** (stubs)
   - [`Aim/Analysis/Sequences.lean`](Aim/Analysis/Sequences.lean) — Real sequences, Monotone Convergence, Bolzano-Weierstrass.
   - [`Aim/Analysis/Series.lean`](Aim/Analysis/Series.lean) — Infinite series, Root/Ratio/Comparison tests.
   - [`Aim/Analysis/Limits.lean`](Aim/Analysis/Limits.lean) — $\varepsilon$-$\delta$ functional limits, continuity, IVT, EVT.
   - [`Aim/Analysis/Derivative.lean`](Aim/Analysis/Derivative.lean) — Differentiation, Rolle's Theorem, Mean Value Theorem, Taylor's Theorem.
   - [`Aim/Analysis/Integral.lean`](Aim/Analysis/Integral.lean) — Darboux/Riemann integration and the Fundamental Theorem of Calculus.
   - [`Aim/Analysis/AnalysisAggregator.lean`](Aim/Analysis/AnalysisAggregator.lean) — Aggregator.

## Notation and conventions

[`Aim/Common/conventions.json`](Aim/Common/conventions.json) is the single source for how letters are used, where the Lean departs from standard notation, and the project's conventions. [`Aim/Common/Notation.tex`](Aim/Common/Notation.tex) is generated from it.

```bash
python scripts/build_notation.py      # regenerate the notation page
python scripts/check_conventions.py   # check the Lean sources against the conventions
```

## Building

```bash
lake build
```
