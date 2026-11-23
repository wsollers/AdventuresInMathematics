# Adventures in Mathematics — Number Systems Reading Guide

The primary sources for the Peano system, the natural numbers, and the number
systems built from them. More sources will be added.

Page and theorem numbers are the printed ones. An entry marked **verify** has
not been checked against the page and must be settled there before it is
cited in notes.

## Primary sources

| Subject | Source | Lean |
|---|---|---|
| The natural numbers | Landau — *Foundations of Analysis* | `Aim/NumberSystems/NaturalNumbers/` |
| Peano systems, recursion, and the number systems ℤ, ℚ, ℝ | Feferman — *The Number Systems: Foundations of Algebra and Analysis* | `Aim/PeanoSystem/`, `Aim/NumberSystems/` |

## What each source is used for

**Landau, *Foundations of Analysis*.** The development of the arithmetic and
order of the natural numbers from the Peano axioms: addition, order,
multiplication, each with its laws.

- Landau's natural numbers start at 1. `Aim.NaturalNumbers` starts at 0. The
  axioms are the same for both, which is why `Aim.PeanoSystem` leaves the base
  unnamed; the defining equations of addition and multiplication differ
  (`x + 1 = x'` against `x + 0 = x`). Translate each statement, do not copy it.
- Landau proves the existence of addition and of multiplication separately,
  without a general recursion theorem (Theorems 4 and 28, **verify**). This
  project proves recursion once and derives the operations from it, following
  Feferman.

**Feferman, *The Number Systems*.** The Peano system as an abstract structure,
definition by recursion, and the construction of the later number systems.

- Chapter 3, §3.2, "Recursive definitions", p. 73 onward: Theorem 3.4
  (iteration, **verify** page), Theorem 3.4′ (the step may see the index),
  Theorem 3.7, p. 74 (two-variable recursion, used for the arithmetic
  operations).
- `Aim/PeanoSystem/Theorems/Recursion.lean` follows Theorem 3.4.
- Feferman also starts the positive integers at 1.

## Reading order

1. Feferman, Chapter 3, through the recursion theorems: for `PeanoSystem` and
   `recurse`.
2. Landau, Chapter 1: for addition and order on the natural numbers.
3. Feferman, the later chapters, as each number system is constructed.
