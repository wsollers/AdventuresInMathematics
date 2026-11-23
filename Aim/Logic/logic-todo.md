# Logic: layout and to-do

One folder per logic. Each logic owns the same three things, added only when
the reading reaches them:

| File | Contents |
|---|---|
| `Syntax.lean` | symbols, formulas, the induction principle for formulas |
| `Semantics.lean` | what a model is, and when a formula is true in it (`⊨`) |
| `Proof.lean` | one deductive calculus (`⊢`) |

Soundness and completeness go in a fourth file, `Meta.lean`, when there is
something to state. Do not create a file before it has a first definition.

## What logic may depend on

- Lean's kernel logic and inductive types (the metalanguage; see
  `Aim/MetaLanguage/MetaLanguageAggregator.lean`).
- `Aim.Set` for sets of formulas and sets of worlds.
- Nothing from `Algebra`, `NumberSystems`, `Topology` or `Analysis`.

Open decision: formula syntax needs arities, variable indices and finite
sequences. Either use Lean's `Nat` and `List` (the two-tier rule in
`MetaLanguageAggregator.lean`) or the `NaturalNumbers` interface. Pick one before writing
`FirstOrder/Syntax.lean`. `Syntax.lean` currently has its own `Arity` type,
which is a third copy of the naturals and should go either way.

## Propositional

Source: Enderton §1.1–1.7.

- [ ] Move `Syntax.lean` to `Propositional/Syntax.lean`. Keep the Enderton
      notes; delete the "STUDY HOLD" block once the new definitions replace it.
- [ ] Replace the `opaque` placeholders with: sentence symbols, connectives,
      well-formed formulas, the induction principle.
- [ ] Move `Valuation.lean` to `Propositional/Semantics.lean`: truth
      assignments, their extension to formulas, tautology, tautological
      implication.
- [ ] Move `Sentential.lean` to `Propositional/Proof.lean`.
- [ ] Later: unique readability, compactness.

## FirstOrder

Source: Enderton ch. 2.

- [ ] `Predicate.lean` becomes `FirstOrder/Syntax.lean`: languages
      (signatures), terms, formulas, free variables, substitution.
- [ ] Fold in the three other stubs that claim the same material:
      `ProofTheory/Syntax.lean`, `ModelTheory/Language.lean`,
      `ModelTheory/Structure.lean`. First-order syntax should be defined once.
- [ ] `Semantics.lean`: structures, assignments, satisfaction
      (from `ModelTheory/Satisfaction.lean`).
- [ ] `Proof.lean`: one calculus first (Enderton's Hilbert system). The other
      calculi in `ProofTheory/` stay there as alternatives.
- [ ] Object-language equality: the `=` symbol and its axioms live here.
      `Equality.lean` is superseded: identity in the metalanguage is
      `Aim.IdentityAndEquality`.
- [ ] `Choice.lean` is not first-order logic. Move it to the set layer or
      delete it until needed.

## SecondOrder

Source: Enderton ch. 4.

- [ ] Syntax: extend first-order syntax with predicate and function
      variables and quantifiers over them. Reuse `FirstOrder`, do not copy it.
- [ ] Semantics: standard (full) semantics first; Henkin (general) semantics
      second.
- [ ] State, do not yet prove: second-order Peano arithmetic is categorical.
      This is the logic-side counterpart of the categoricity theorem for the
      `NaturalNumbers` interface.

## Modal

Source: to choose (candidates: Blackburn–de Rijke–Venema ch. 1; Hughes–Cresswell).

- [ ] Syntax: propositional formulas plus `□`, with `◇` defined.
- [ ] Semantics: Kripke frames (a type of worlds and an accessibility
      relation), models, truth at a world, validity on a frame.
      Needs binary relations: see "Depends on" below.
- [ ] Proof: system K, then T, S4, S5 as extra axioms.
- [ ] Later: frame correspondence (T ↔ reflexive, 4 ↔ transitive, …).

## Temporal

Source: to choose.

- [ ] Decide which temporal logic first. Recommendation: linear temporal logic
      (LTL), because its models are sequences indexed by the naturals.
- [ ] Syntax: propositional formulas plus `next` and `until`; `eventually` and
      `always` defined.
- [ ] Semantics: truth at a position in an infinite sequence of valuations.
- [ ] Alternative reading: tense logic as a modal logic with two operators
      over a strict order. If chosen, it builds on `Modal`, not on the
      naturals.

## Depends on

- **Relations** (binary relation on a type, reflexive/symmetric/transitive):
  needed by `Modal` semantics. Not needed by Propositional or FirstOrder.
- **Natural numbers with order**: needed by `Temporal` (LTL) only.
- **Sets** (`Aim.Set`): needed everywhere for sets of formulas `Γ`.

## Cleanup when the moves are done

- [ ] `LogicAggregator.lean` imports the per-logic files instead of the flat ones.
- [ ] Delete the `.gitkeep` in each folder as it gets its first Lean file.
- [ ] Update the Logic section of `README.md`.
