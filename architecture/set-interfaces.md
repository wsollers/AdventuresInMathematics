# Set Interfaces

The project's set terminology is based on Herbert B. Enderton's *Elements of Set
Theory*. Typed sets support ordinary mathematics independently of later
foundational set constructions.

The set layer has these components:

- **Set** — a typed collection of elements represented by a predicate.
- **Class** — the objects satisfying a property; in a foundational universe, a
  class may be represented by a set or may be proper.
- **Collection** — an unindexed set of typed sets.
- **Family** — an indexed assignment of typed sets.

Universe concepts are deferred until the project needs an explicit ambient-set
or foundational-universe abstraction.

## Plan of record

### The set everything uses

`Aim.Set X` is the project's set: a typed set, represented by a predicate and
shaped like a Lean set. Order theory, bounds and analysis are stated with it.
No theorem carries a parameter for the implementation of sets.

### Its contract

The contract is extensionality together with the membership lemmas in
`Aim/SetTheory/Theorems/Membership.lean`. Those proofs are the only ones that
use the fact that a set is a predicate. Every later proof cites them.

### ZFC, later

An axiomatic set theory in the style of Enderton is a separate development:
primitives, axioms, theorems. It is not a replacement for `Aim.Set`. Its
assumptions are set up in sections, so they stay local to its own files.

Following Enderton, a class is a property of sets, not an object of the
theory, and there is no set of all sets: a universe is always relative to a
containing set.

### The link between them, later

When the ZFC development exists, the contract is restated as a small
interface class holding only the primitives:

- membership;
- extensionality: two sets with the same elements are equal;
- comprehension: every property of elements determines a set.

Union, intersection, the empty set, subset, complement and the rest are
defined from these, and their membership lemmas are theorems, so that each
certificate is a few proofs.

There are two certificates:

- `Aim.Set X` satisfies the interface, by the membership lemmas already proved.
- For every ZFC set `A`, the subsets of `A` satisfy the interface, with the
  members of `A` as the elements. The universal set is `A`, complement is
  taken relative to `A`, comprehension is the Axiom of Separation, and
  extensionality is the Axiom of Extensionality.

This is a certificate, not a switch. Analysis stays on `Aim.Set`; the
certificates show that what is proved there also holds of ZFC subsets.

### Not planned

Making order theory and analysis generic over the set type, as `lra-lean`
did. That put the set-interface assumptions on every theorem.

### Until then

Nothing is built ahead of need. The interface class and both certificates are
written when the ZFC development is.
