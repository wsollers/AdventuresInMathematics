# Set Theory Reading Guide

## Readings

- Herbert B. Enderton — *Elements of Set Theory*.
- Paul R. Halmos — *Naive Set Theory*.

These are the chosen readings for this development. Record editions and exact
chapter, page, and theorem references as the material is studied.

The library currently uses typed sets (`Set X`), not a construction of an
untyped universe satisfying the axioms of set theory. Translate each reading
into that setting explicitly; do not assume every foundational construction
in the books is already represented here.

## Proof sequence

1. Finish the remaining overlap and disjointness lemmas in `Theorems/Relations.lean`.
2. `Theorems/Subset.lean`: inclusion and extensional equality.
3. `Theorems/Algebra.lean`: binary operations, identities, absorption, distribution.
4. `Theorems/Complement.lean`: complements, differences, and set duality through
   double complement, De Morgan laws, and reversal of inclusion.
5. `Theorems/Indexed.lean`: arbitrary unions and intersections, their inclusion
   rules, empty index cases, distribution, and indexed De Morgan laws.

New statements are learner proof stubs. Some complement results need classical
reasoning. No general theorem about syntactic dualization is claimed yet.

## Following this foundation

Develop general relations and functions in sibling `Aim/Relations` and
`Aim/Functions` folders when their first interfaces are introduced. Include
composition and identity laws, then function images and preimages and their
set laws. Keep general order duality in OrderTheory. This supports the later
algebraic hierarchy and number-system constructions without requiring a lattice
interface today.
