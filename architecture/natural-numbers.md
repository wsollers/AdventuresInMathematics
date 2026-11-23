# Peano Systems and the Natural-Number Interface

A **Peano system** (`Aim.PeanoSystem`, in `Aim/PeanoSystem/`) is a type with a
base element and a successor map satisfying three axioms: the base is not a
successor, successor is injective, and induction. It does not say what the
base element is called. The source is Feferman, *The Number Systems*,
Chapter 3.

The **natural numbers** (`Aim.NaturalNumbers`) are a Peano system whose base
is written `0`. A one-based system, whose base is written `1`, can be added
later as a second marker class over the same Peano system.

Theorems that do not depend on the name of the base, in particular definition
by recursion, are stated against `PeanoSystem`. Arithmetic and order, whose
defining equations do depend on it, are stated against `NaturalNumbers`.

Each construction owns a `Satisfies` certificate. Lean's kernel `Nat` is the
first construction (`Aim.LeanNat`). Correspondence with Lean and Mathlib is
checked only by the separate `validation/mathlib` package.

## Scope

Required of the natural-number layer:

1. Recursion: the iteration theorem, `recurse`, and its two equations.
2. Addition: definition, defining equations, associative, commutative,
   identity, cancellation.
3. Order: `≤` and `<`, a total order, compatibility with successor and `+`.
4. The cast into a field, `natCast`, which lives with the Archimedean property.

Deferred until a consumer needs them: recursion whose step sees the index,
multiplication, exponentiation, strong induction and well-ordering,
categoricity, and the one-based marker.

## Deferred: central algebraic laws

The algebraic laws (associativity, commutativity, identity, inverse,
distributivity) currently live as mixin classes in `Aim/Algebra/Field.lean`.
They will move to a central file under `Aim/Algebra` that imports only
`Common`. Bundles such as commutative monoid and commutative semiring are
built from them, and each number system carries a `Satisfies` certificate
for the bundle it meets. The natural numbers are certified as a commutative
monoid under `+`, and later as a commutative semiring.

Trigger: the first proof of an algebraic law for the natural numbers, which
is `add_assoc` or `add_comm` once addition is defined.

Why it matters for imports: `Aim/Algebra/Archimedean.lean` imports the
natural-number interface for the cast. The import graph is acyclic today
because that interface imports nothing from `Algebra`. If natural-number
arithmetic had to import `Field.lean` to reach the laws, the two folders
would depend on each other. A central laws file sits below both and removes
the tension.
