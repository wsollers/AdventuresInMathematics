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

1. **Common** (`namespace aim.common`)
   - [`Aim/Common/Common.lean`](Aim/Common/Common.lean) — Project-wide foundations and universe conventions.
2. **Logic** (`namespace aim.logic`)
   - [`Aim/Logic/Syntax.lean`](Aim/Logic/Syntax.lean) — Propositional variables (`A, B, C`), formula syntax trees, string parsing (`"A AND B"`).
   - [`Aim/Logic/Valuation.lean`](Aim/Logic/Valuation.lean) — Truth values, truth-functional valuations (`eval`), truth tables, and tautologies ($\models \varphi$).
   - [`Aim/Logic/Sentential.lean`](Aim/Logic/Sentential.lean) — Sentential (propositional) axioms and inference rules ($\vdash \varphi$).
   - [`Aim/Logic/Predicate.lean`](Aim/Logic/Predicate.lean) — Universal ($\forall$) and existential ($\exists, \exists!$) quantifiers.
   - [`Aim/Logic/Equality.lean`](Aim/Logic/Equality.lean) — Identity and Leibniz substitution axioms ($x = y \to P(x) \to P(y)$).
   - [`Aim/Logic/Choice.lean`](Aim/Logic/Choice.lean) — Axiom of Choice and definite description.
   - [`Aim/Logic/Logic.lean`](Aim/Logic/Logic.lean) — Aggregator.
   - [`Aim/Logic/READINGS.MD`](Aim/Logic/READINGS.MD) — Reading-first study guide (source-linked Enderton, Tarski, Buss, Mileti, and other Logic sources; exercises, notes, and mastery checkpoints).
3. **Set Theory** (`namespace aim.set`)
   - [`Aim/Set/Axioms.lean`](Aim/Set/Axioms.lean) — Extensionality, Empty Set, Pairing, Comprehension, Union, Power Set, Infinity.
   - [`Aim/Set/Operations.lean`](Aim/Set/Operations.lean) — $\subseteq, \cup, \cap, \setminus$, complement, indexed families.
   - [`Aim/Set/Relation.lean`](Aim/Set/Relation.lean) — Ordered pairs, relations, equivalence relations, partitions, quotients.
   - [`Aim/Set/Function.lean`](Aim/Set/Function.lean) — Functions, injective/surjective/bijective maps, inverses, images/preimages.
   - [`Aim/Set/Set.lean`](Aim/Set/Set.lean) — Aggregator.
4. **Order & Algebraic Axioms** (`namespace aim.algebra`)
   - [`Aim/Algebra/Order.lean`](Aim/Algebra/Order.lean) — Partial orders, linear orders, bounds, Supremum/Infimum, completeness axioms.
   - [`Aim/Algebra/Structures.lean`](Aim/Algebra/Structures.lean) — Semigroups, Monoids, Groups, Rings, Integral Domains, Fields, Ordered Fields.
   - [`Aim/Algebra/Algebra.lean`](Aim/Algebra/Algebra.lean) — Aggregator.
5. **Number Systems** (`namespace aim.number`)
   - [`Aim/Number/Peano.lean`](Aim/Number/Peano.lean) — Peano Axioms, natural numbers ($\mathbb{N}$), induction, arithmetic, order.
   - [`Aim/Number/Int.lean`](Aim/Number/Int.lean) — Integers ($\mathbb{Z}$) via equivalence classes on $\mathbb{N} \times \mathbb{N}$; Ordered Integral Domain.
   - [`Aim/Number/Rat.lean`](Aim/Number/Rat.lean) — Rationals ($\mathbb{Q}$) as field of fractions of $\mathbb{Z}$; Ordered Field.
   - [`Aim/Number/Real.lean`](Aim/Number/Real.lean) — Reals ($\mathbb{R}$) and the Axiom of Completeness; Complete Ordered Field.
   - [`Aim/Number/Number.lean`](Aim/Number/Number.lean) — Aggregator.
6. **Proof Theory** (`namespace aim.prooftheory`)
   - [`Aim/ProofTheory/Syntax.lean`](Aim/ProofTheory/Syntax.lean) — First-order terms, formulas, and capture-avoiding substitution.
   - [`Aim/ProofTheory/Hilbert.lean`](Aim/ProofTheory/Hilbert.lean) — Hilbert-style axiomatic calculus and the Deduction Theorem.
   - [`Aim/ProofTheory/NaturalDeduction.lean`](Aim/ProofTheory/NaturalDeduction.lean) — Gentzen's Natural Deduction ($\mathsf{NJ} / \mathsf{NK}$).
   - [`Aim/ProofTheory/SequentCalculus.lean`](Aim/ProofTheory/SequentCalculus.lean) — Gentzen's Sequent Calculus ($\mathsf{LJ} / \mathsf{LK}$) and Cut-Elimination.
   - [`Aim/ProofTheory/ProofTheory.lean`](Aim/ProofTheory/ProofTheory.lean) — Aggregator.
7. **Model Theory** (`namespace aim.modeltheory`)
   - [`Aim/ModelTheory/Language.lean`](Aim/ModelTheory/Language.lean) — First-order signatures and languages $\mathcal{L}$.
   - [`Aim/ModelTheory/Structure.lean`](Aim/ModelTheory/Structure.lean) — $\mathcal{L}$-structures $\mathfrak{M}$, embeddings, and isomorphisms.
   - [`Aim/ModelTheory/Satisfaction.lean`](Aim/ModelTheory/Satisfaction.lean) — Tarski's truth definition ($\mathfrak{M} \models \varphi$) and Soundness.
   - [`Aim/ModelTheory/Completeness.lean`](Aim/ModelTheory/Completeness.lean) — Henkin construction, Gödel's Completeness Theorem, and Compactness.
   - [`Aim/ModelTheory/ModelTheory.lean`](Aim/ModelTheory/ModelTheory.lean) — Aggregator.
8. **Topology & Metric Spaces** (`namespace aim.topology`)
   - [`Aim/Topology/MetricSpace.lean`](Aim/Topology/MetricSpace.lean) — Metric axioms, open balls, Cauchy sequences, complete metric spaces.
   - [`Aim/Topology/TopologicalSpace.lean`](Aim/Topology/TopologicalSpace.lean) — Open/closed sets, bases, interior, closure, Hausdorff spaces.
   - [`Aim/Topology/Continuity.lean`](Aim/Topology/Continuity.lean) — Continuous maps, homeomorphisms, subspaces, products.
   - [`Aim/Topology/Compactness.lean`](Aim/Topology/Compactness.lean) — Open covers, sequential compactness, Heine-Borel Theorem.
   - [`Aim/Topology/Connectedness.lean`](Aim/Topology/Connectedness.lean) — Connected and path-connected spaces.
   - [`Aim/Topology/Topology.lean`](Aim/Topology/Topology.lean) — Aggregator.
9. **Real Analysis** (`namespace aim.analysis`)
   - [`Aim/Analysis/Sequences.lean`](Aim/Analysis/Sequences.lean) — Real sequences, Monotone Convergence, Bolzano-Weierstrass.
   - [`Aim/Analysis/Series.lean`](Aim/Analysis/Series.lean) — Infinite series, Root/Ratio/Comparison tests.
   - [`Aim/Analysis/Limits.lean`](Aim/Analysis/Limits.lean) — $\varepsilon$-$\delta$ functional limits, continuity, IVT, EVT.
   - [`Aim/Analysis/Derivative.lean`](Aim/Analysis/Derivative.lean) — Differentiation, Rolle's Theorem, Mean Value Theorem, Taylor's Theorem.
   - [`Aim/Analysis/Integral.lean`](Aim/Analysis/Integral.lean) — Darboux/Riemann integration and the Fundamental Theorem of Calculus.
   - [`Aim/Analysis/Analysis.lean`](Aim/Analysis/Analysis.lean) — Aggregator.

## Building

```bash
lake build
```
