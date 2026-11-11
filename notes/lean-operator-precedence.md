# The Axiomatic Laws of Arithmetic and Operator Mechanics in Lean 4

Study guide for proving arithmetic from individual axiom mixins
(`Aim/Analysis/Numbers.lean`) without automation.

**How this was checked**

- **Books.** Every statement about a book was read on the cited page through
  the Librarian. Pages are printed pages, with the PDF page in parentheses.
  Items I could not confirm are marked **verify**.
  - Lang, *Basic Mathematics* (cited as **Lang BM**).
  - Lang, *Undergraduate Algebra*, 3rd ed. (**Lang UA**). The graduate
    *Algebra* is not in the library, so nothing here is cited from it.
  - Landau, *Foundations of Analysis* (**Landau**).
  - Zorich, *Mathematical Analysis I* (**Zorich**).
- **Lean.** Precedences were read from `Init/Notation.lean`, `Init/Core.lean`
  and `Lean/Parser/Term.lean` in toolchain `leanprover/lean4:v4.32.1`.
  Groupings were confirmed with `set_option pp.parens true`.
- **Proof chains.** Every step-by-step chain in §1 was run as a Lean `calc`
  block, one `rw` per line, over a structure with no commutativity axiom
  (commutativity passed in as an explicit hypothesis only where a chain says
  it is used).

---

## 1. The hidden distinctions of elementary arithmetic

### 1.0 What each book actually assumes

The books do not agree on which side the axioms live on, and none of them
matches `Numbers.lean` exactly. This table is the reference for everything
that follows.

| Source | Identity | Inverse | Associativity as written | Commutativity | Distributivity |
|---|---|---|---|---|---|
| Zorich p. 36–37 (PDF 57–58) | two-sided axiom: `x + 0 = 0 + x = x` | two-sided axiom: `x + (−x) = (−x) + x = 0` | `x + (y + z) = (x + y) + z` | axiom 4₊ | axiom is the **right** law `(x + y)z = xz + yz` |
| Lang BM p. 6–15 (PDF 22–31) | N1 (formula lost in the scan, **verify**); N6 `1a = a` | N2 gives both `a + (−a) = 0` and `−a + a = 0` | `(a + b) + c = a + (b + c)` | assumed | both sides stated |
| Lang UA p. 16–17 (PDF 28–29) | GR 2, two-sided | GR 3, two-sided: `xy = yx = e` | `(xy)z = x(yz)` | **not** assumed; `+` is used only for commutative groups | n/a |
| Landau ch. I (PDF 18–30) | none (naturals start at 1) | none | Theorem 5 (proved) | Theorem 6 (**proved**) | Theorem 30, the **left** law `x(y + z) = xy + xz` (proved) |
| `Numbers.lean` | `zero_add` only (left) | `add_neg` only (right) | `a + b + c = a + (b + c)` | mixin `IsAddComm` | `mul_add` only (left) |

Three consequences worth knowing before you start:

1. **Your associativity points the opposite way from Zorich's.** His 3₊ reads
   right-to-left compared with `IsAddAssoc.add_assoc`. His proofs that say
   "by associativity" correspond to `rw [← add_assoc]` as often as
   `rw [add_assoc]`.
2. **Your distributive axiom is the mirror of Zorich's.** His axiom is
   `add_mul`; yours is `mul_add`.
3. **Left identity plus right inverse is not a group.** With only
   `zero_add`, `add_neg` and `add_assoc`, the law `a + 0 = a` is
   *unprovable*. Counter-model (checked in Lean with `decide`): on `Bool`
   take `a + b := b`, `0 := false`, `−a := false`. Associativity holds,
   `0 + a = a` holds, `a + −a = 0` holds, but `true + 0 = false`. So in
   `Numbers.lean` the use of `add_comm` inside `add_zero` and `neg_add` is
   forced by the choice of mixins, not a weakness of the proof.

### 1.1 Left versus right operations

**They are different functions.** "Add `c` on the left" is the function
`(c + ·)`; "add `c` on the right" is `(· + c)`. In Lean you choose one
explicitly:

```lean
congrArg (c + ·) h   -- from h : a = b, gives c + a = c + b
congrArg (· + c) h   -- from h : a = b, gives a + c = b + c
```

Without commutativity neither result can be turned into the other. Each
left/right pair below is therefore two laws, and one of them is always bought
with a commutativity step.

| Left-handed | Right-handed | Bridge |
|---|---|---|
| `zero_add : 0 + a = a` | `add_zero : a + 0 = a` | one `add_comm` |
| `neg_add : −a + a = 0` | `add_neg : a + −a = 0` | one `add_comm` |
| `mul_add : a * (b + c) = a * b + a * c` | `add_mul : (a + b) * c = a * c + b * c` | three `mul_comm` |
| `add_left_cancel : c + a = c + b → a = b` | `add_right_cancel : a + c = b + c → a = b` | none needed if both identity and inverse are two-sided |

**How the books get from one side to the other.**

- **Landau builds addition right-handed and proves the left-handed facts.**
  Theorem 4 (p. 4, PDF 18) defines `x + y` by recursion on the *right*
  argument: `x + 1 = x′` and `x + y′ = (x + y)′`. The left-handed equations
  `1 + y = y′` and `x′ + y = (x + y)′` are not part of the definition; they
  come out of the construction in part B of the proof (p. 5, PDF 19).
  Theorem 6, commutativity (p. 6, PDF 20), is an induction whose two steps
  cite exactly those two left-handed equations. In Landau, commutativity is
  the theorem that says the right-handed definition also works on the left.
- **Landau does the same for multiplication.** Theorem 28 (p. 14, PDF 28):
  `x · 1 = x`, `x · y′ = xy + x`. Theorem 30 (p. 16, PDF 30) proves the left
  law `x(y + z) = xy + xz`. His Preliminary Remark says the right law
  `(y + z)x = yx + zx`, "which results from Theorem 30 and Theorem 29", need
  not even be set down. That remark is the silent blending in one sentence.
- **Lang BM states both sides, then shows one is redundant.** p. 15 (PDF 31):
  assuming distributivity on the left and commutativity,
  `(b + c)a = a(b + c) = ab + ac = ba + ca`.
- **Zorich assumes the right law** and remarks (p. 37, PDF 58) that by
  commutativity it holds with the factors reversed.
- **Lang UA and Zorich avoid the question for identity and inverse** by making
  both axioms two-sided.

**Lang's one-line derivation, expanded.** His last `=` hides two rewrites:

```
(b + c) * a
  = a * (b + c)        mul_comm (b + c) a
  = a * b + a * c      mul_add
  = b * a + a * c      mul_comm a b
  = b * a + c * a      mul_comm a c
```

**`add_zero` from `zero_add`.** `x + 0 = 0 + x` by `add_comm`, then `= x` by
`zero_add`. By §1.0 item 3 there is no commutativity-free route from your
mixins.

**If you want a commutativity-free group,** the identity and inverse must be
on the *same* side, or two-sided. From left identity, left inverse and
associativity alone, the right inverse follows:

```
a + −a
  = 0 + (a + −a)                    zero_add
  = (−(−a) + −a) + (a + −a)         left inverse of −a
  = −(−a) + (−a + (a + −a))         add_assoc
  = −(−a) + ((−a + a) + −a)         ← add_assoc
  = −(−a) + (0 + −a)                left inverse of a
  = −(−a) + −a                      zero_add
  = 0                               left inverse of −a
```

### 1.2 The order-reversing law of inverses

**Claim.** `−(x + y) = −y + −x`, using associativity, identity and inverse
only.

**Why the order must reverse.** To cancel `x + y` you need something whose
*first* term meets `y`. Only `−y` can do that. Writing `−x` first puts `−x`
next to `y`, and nothing cancels.

**Step 1: `−y + −x` is a right inverse of `x + y`.**

```
(x + y) + (−y + −x)
  = x + (y + (−y + −x))     add_assoc       parentheses move right
  = x + ((y + −y) + −x)     ← add_assoc     inner pair y, −y now adjacent
  = x + (0 + −x)            add_neg
  = x + −x                  zero_add
  = 0                       add_neg
```

**Step 2: a right inverse is *the* inverse** (`neg_unique : x + y = 0 → y = −x`).

```
y = 0 + y                   zero_add
  = (−x + x) + y            neg_add
  = −x + (x + y)            add_assoc
  = −x + 0                  hypothesis
  = −x                      add_zero
```

This is Zorich's uniqueness chain (a. 2°, p. 39, PDF 60) and Lang UA's
`z = ez = (yx)z = y(xz) = ye = y` (p. 17, PDF 29). Apply it to step 1.

`add_comm` is used nowhere. `add_zero` and `neg_add` are used, which in
`Numbers.lean` each cost one `add_comm` (§1.0); with two-sided axioms the
whole proof is commutativity-free.

**The school form.** `−(x + y) = −x − y` is one more step:

```
−(x + y) = −y + −x          neg_add_rev
         = −x + −y          add_comm        ← the silent step
         = −x − y           sub_eq_add_neg, read right to left
```

Lang BM does exactly this. N5 (p. 10–11, PDF 26–27) states
`−(a + b) = −a − b`, and its proof contains the line
`a + b − a − b = a − a + b − b` labelled "by commutativity". Lang UA states
uniqueness of the inverse without commutativity, but I did not locate
`(xy)⁻¹ = y⁻¹x⁻¹` stated in it (**verify**; it may be an exercise).

**The multiplicative twin.** `(x * y)⁻¹ = y⁻¹ * x⁻¹` for `x ≠ 0`, `y ≠ 0`,
by the same two steps with `*`, `1`, `⁻¹`. One extra obligation appears:
`inv_unique` needs `x * y ≠ 0`. That follows from step 1 itself, since
`(x * y) * (y⁻¹ * x⁻¹) = 1`, `0 * z = 0` and `0 ≠ 1`.

**Where forgetting the reversal breaks.** Wherever multiplication is not
commutative: matrices, quaternions, permutations, function composition
(`(f ∘ g)⁻¹ = g⁻¹ ∘ f⁻¹`: socks then shoes, undone as shoes then socks).
A 2×2 check:

```
A = [1 1]   B = [1 0]   AB = [2 1]   (AB)⁻¹ = [ 1 −1]
    [0 1]       [1 1]        [1 1]            [−1  2]

B⁻¹A⁻¹ = [ 1 −1]   = (AB)⁻¹        A⁻¹B⁻¹ = [ 2 −1]   ≠ (AB)⁻¹
         [−1  2]                            [−1  1]
```

### 1.3 Subtraction and division as derived operations

**Definitions in the sources.**

- **Lang BM** p. 9 (PDF 25): "As a matter of convention, we shall write
  `a − b` instead of `a + (−b)`." p. 43 (PDF 59): `a/b` is written instead of
  `b⁻¹a` *or* `ab⁻¹`. He can offer both orders only because multiplication is
  commutative.
- **Zorich** p. 40 (PDF 61): `b + (−a)` "can also be written as `b − a`".
- **Landau is different.** Definition 23 (p. 38, PDF 52): `X − Y` is the
  unique `U` with `Y + U = X`, and it exists only when `X > Y` (Theorem 101).
  With no negatives yet, subtraction is "the solution of an equation", not
  "add the negative". Definition 27 (p. 42, PDF 56) treats the quotient the
  same way, as the `U` of Theorem 110 (**verify** the exact statement).
- **`Numbers.lean`** follows Lang and Zorich: `a − b := a + −b` and
  `a / b := a * b⁻¹`, exposed through `IsSubEqAddNeg.sub_eq_add_neg` and
  `IsDivEqMulInv.div_eq_mul_inv`.

**The first move is always to unfold.** `x − y` is an `HSub.hSub` node. No
`add_*` lemma can match it until `rw [sub_eq_add_neg]` has turned it into an
`HAdd.hAdd` node (see §2).

#### (a) `−(x − y) = y − x`

No commutativity.

```
−(x − y)
  = −(x + −y)               sub_eq_add_neg
  = −(−y) + −x              neg_add_rev      reversal puts −(−y) first
  = y + −x                  neg_neg
  = y − x                   ← sub_eq_add_neg
```

The reversal is what makes this work: it delivers `y` to the front for free.

#### (b) `x − y − z = x − (y + z)`

Commutativity **once**.

```
x − y − z
  = (x + −y) + −z           sub_eq_add_neg, twice (outer node first)
  = x + (−y + −z)           add_assoc
  = x + (−z + −y)           add_comm (−y) (−z)     ← the only commutativity
  = x + −(y + z)            ← neg_add_rev
  = x − (y + z)             ← sub_eq_add_neg
```

Without commutativity the true statement is `x − y − z = x − (z + y)`: delete
the `add_comm` line and the reversal law hands you `z + y`.

#### (c) `x − (y − z) = x − y + z`

Commutativity **once**.

```
x − (y − z)
  = x + −(y + −z)           sub_eq_add_neg, twice
  = x + (−(−z) + −y)        neg_add_rev
  = x + (z + −y)            neg_neg
  = x + (−y + z)            add_comm z (−y)        ← the only commutativity
  = (x + −y) + z            ← add_assoc
  = x − y + z               ← sub_eq_add_neg
```

Without commutativity: stop before the `add_comm` line, re-associate, and you
get `x − (y − z) = x + z − y`.

#### (d) `(a / b) / (c / d) = (a * d) / (b * c)`, for `b, c, d ≠ 0`

Commutativity **once**.

```
(a / b) / (c / d)
  = (a * b⁻¹) * (c * d⁻¹)⁻¹         div_eq_mul_inv, three times
  = (a * b⁻¹) * (d⁻¹⁻¹ * c⁻¹)       mul_inv_rev    (needs c ≠ 0, d⁻¹ ≠ 0)
  = (a * b⁻¹) * (d * c⁻¹)           inv_inv        (needs d ≠ 0)
  = a * (b⁻¹ * (d * c⁻¹))           mul_assoc
  = a * ((d * c⁻¹) * b⁻¹)           mul_comm b⁻¹ (d * c⁻¹)   ← the only one
  = a * (d * (c⁻¹ * b⁻¹))           mul_assoc
  = (a * d) * (c⁻¹ * b⁻¹)           ← mul_assoc
  = (a * d) * (b * c)⁻¹             ← mul_inv_rev  (needs b ≠ 0, c ≠ 0)
  = (a * d) / (b * c)               ← div_eq_mul_inv
```

- "Invert and multiply" is lines 2–3: the reversal law plus `inv_inv`.
- The `≠ 0` hypotheses are not decoration. `0⁻¹` is unconstrained by the
  axioms, so `mul_inv_rev`, `inv_inv` and `inv_ne_zero` each need them.
- The commutativity-free form is `(a / b) / (c / d) = a * b⁻¹ * d * c⁻¹`.

---

## 2. How Lean parses expressions into ASTs

### The text you type is not what Lean stores

When you write `x + y − y`, the parser builds a tree and the elaborator turns
it into nested function applications:

```lean
HSub.hSub (HAdd.hAdd x y) y
```

There are no parentheses and no infix symbols in that term. Parentheses in
source code only steer the parser and are then discarded.

### Why the InfoView hides parentheses

The pretty-printer goes from tree back to text and inserts a parenthesis only
where re-parsing would otherwise give a different tree. `(x + y) − y` prints
as `x + y − y` because the parser groups it that way anyway. Left-nested
parentheses on a left-associative chain are always redundant, so they are
never shown. Right-nested ones, `x + (y − y)`, are always shown.

| Tool | Effect |
|---|---|
| `set_option pp.parens true` | Prints every grouping: `((x + y) - y) = x` |
| `set_option pp.notation false` | Prints function names: `HSub.hSub (HAdd.hAdd x y) y` |
| Hover or click in the InfoView | Highlighted regions are exactly the AST subtrees |

### Reconstructing hidden parentheses by hand

1. Find the operator with the **lowest** precedence. It is the root.
2. On a tie, associativity decides: for `infixl` the **rightmost** operator is
   the root; for `infixr` the **leftmost**.
3. Repeat on each side.

### AST diagrams

**`x + y − y`**: `+` and `−` are both `infixl:65`, so the rightmost is the
root.

```
 What Lean builds: (x + y) − y        NOT: x + (y − y)

        HSub.hSub                         HAdd.hAdd
        /       \                         /       \
   HAdd.hAdd     y                       x     HSub.hSub
    /     \                                     /     \
   x       y                                   y       y
```

**`x − y − z`** means `(x − y) − z`.

```
        HSub.hSub
        /       \
   HSub.hSub     z
    /     \
   x       y
```

**`a + b + c`** means `(a + b) + c`.

```
        HAdd.hAdd
        /       \
   HAdd.hAdd     c
    /     \
   a       b
```

**`−x + y`** means `(−x) + y`: prefix `−` (75) binds tighter than `+` (65).

```
        HAdd.hAdd
        /       \
    Neg.neg      y
       |
       x
```

**`¬A ∧ B`** means `(¬A) ∧ B`: the argument of `¬` is parsed at 40 and `∧` is
only 35.

```
          And
         /   \
       Not    B
        |
        A
```

### Why `rw` matches subtrees, not text

`rw [h]` with `h : lhs = rhs` searches the goal's **tree** for a subtree
matching `lhs`. It never looks at the printed string.

```lean
example (x y : F) : x + y - y = x := by
  rw [IsAddNeg.add_neg]   -- fails
```

```
Tactic `rewrite` failed: Did not find an occurrence of the pattern
  ?a + -?a
in the target expression
  x + y - y = x
```

Two separate things are in the way, and each needs its own rewrite:

| Goal | Tree | What is wrong |
|---|---|---|
| `x + y - y = x` | `HSub.hSub (HAdd.hAdd x y) y` | The root is `HSub`, not `HAdd`, and there is no `Neg` node at all |
| after `rw [sub_eq_add_neg]`: `x + y + -y = x` | `HAdd.hAdd (HAdd.hAdd x y) (Neg.neg y)` | Now `+` and `−y` exist, but `y` and `−y` are in different subtrees: the left child of the root is `x + y`, not `y` |
| after `rw [add_assoc]`: `x + (y + -y) = x` | `HAdd.hAdd x (HAdd.hAdd y (Neg.neg y))` | `y + −y` is now a single subtree |
| after `rw [add_neg]`: `x + 0 = x` | | |
| after `rw [add_zero]`: closed | | |

`y − y` as text was on screen from the start, but the subtree `y + −y` exists
only after the unfold and the regrouping. This four-rewrite chain is exactly
your `add_sub_cancel_right`.

---

## 3. Associativity and unary operators

### What `infixl`, `infixr`, `infix` mean

Each is shorthand for a `notation` with precedences on the two arguments:

| Command | Expands to | Effect |
|---|---|---|
| `infixl:65 " + "` | `notation:65 lhs:65 " + " rhs:66` | Right operand must bind strictly tighter, so chains group left |
| `infixr:35 " ∧ "` | `notation:35 lhs:36 " ∧ " rhs:35` | Left operand must bind strictly tighter, so chains group right |
| `infix:50 " = "` | `notation:50 lhs:51 " = " rhs:51` | Both sides must be tighter, so chaining is a parse error |

### Why arithmetic is left-associative

```
a - b - c   =  (a - b) - c      -- not a - (b - c)
a + b + c   =  (a + b) + c
a / b / c   =  (a / b) / c
a - b + c   =  (a - b) + c
```

This is the ordinary reading convention, and for `−` and `/` it changes the
value: `10 − 3 − 2 = 5` but `10 − (3 − 2) = 9`. Lang BM (p. 9, PDF 25) drops
the parentheses in `a + b + c` *because* associativity makes both readings
equal. Lean cannot do that: it must store one tree, and `(a + b) + c` and
`a + (b + c)` are different terms until you rewrite.

### Why connectives, arrows and powers are right-associative

| Expression | Grouping | Reason |
|---|---|---|
| `A → B → C` | `A → (B → C)` | Currying: takes `A`, returns a function `B → C` |
| `A ∧ B ∧ C` | `A ∧ (B ∧ C)` | Matches nested pairs: `⟨a, b, c⟩` means `⟨a, ⟨b, c⟩⟩` |
| `A ∨ B ∨ C` | `A ∨ (B ∨ C)` | Same |
| `a ^ b ^ c` | `a ^ (b ^ c)` | Convention; `(a ^ b) ^ c` is just `a ^ (b * c)` |
| `a :: b :: l` | `a :: (b :: l)` | The only version that type-checks |

Consequences in proofs:

- **`intro`**: with goal `A → B → C` the root is the first arrow. `intro hA`
  leaves `B → C`.
- **Projections**: for `h : A ∧ B ∧ C`, `h.1 : A`, `h.2.1 : B`, `h.2.2 : C`.
- **Non-associative operators**: `a = b = c`, `a < b < c` and `A ↔ B ↔ C` are
  parse errors.

### Shifting parentheses on a left-associative chain

Your axiom: `IsAddAssoc.add_assoc : a + b + c = a + (b + c)`, that is,
`(a + b) + c = a + (b + c)`.

| Rewrite | Effect | InfoView afterwards |
|---|---|---|
| `rw [add_assoc]` (forward) | `(a + b) + c ↦ a + (b + c)`: parentheses move **right** | shows `a + (b + c)`, because these parentheses are not the default |
| `rw [← add_assoc]` (backward) | `a + (b + c) ↦ (a + b) + c`: parentheses move **left** | shows `a + b + c`, because left-nested is the default |

- **Forward creates a right-hand group.** Use it to bring the last two terms
  together so they can interact (`y + −y` in §2).
- **Backward dissolves a right-hand group.** Use it to free the first term of
  a group so it can meet its left neighbour (`−y + −x` meeting `y` in §1.2).
- **Which node gets rewritten.** `rw` instantiates the pattern at the first
  match it finds, the outermost node on a chain. On `a + b + c + d`, which is
  `((a + b) + c) + d`, plain `rw [add_assoc]` gives `a + b + (c + d)`. To aim
  at a specific node, supply arguments: `rw [add_assoc a b c]`.

### Unary prefix and postfix operators

| Declaration in core | Expands to | Meaning |
|---|---|---|
| `prefix:75 "-" => Neg.neg` | `notation:75 "-" arg:75` | Operand must have precedence at least 75 |
| `postfix:max "⁻¹" => Inv.inv` | `notation:max arg:max "⁻¹"` | Operand must be an atom or application-level term |
| `notation:max "¬" p:40 => Not p` | (explicit) | Operand at least 40; the result counts as an atom |

**Rule.** The operand of a prefix operator swallows everything that binds at
least as tightly as the operand's precedence and stops at the first weaker
operator. Prefix operators nest to the right because there is nothing on
their left: `- -x` is `-(-x)` (write the space; `--` starts a comment).

| You write | Lean reads | Why |
|---|---|---|
| `-x + y` | `(-x) + y` | `+` (65) is below 75 |
| `-x * y` | `(-x) * y` | `*` (70) is below 75 |
| `-x ^ 2` | `-(x ^ 2)` | `^` (80) is at least 75, so it is pulled in |
| `-x⁻¹` | `-(x⁻¹)` | Postfix `⁻¹` is at `max` |
| `x + -y` | `x + (-y)` | Right operand of `+` needs at least 66; `-y` is 75 |
| `-y + -x` | `(-y) + (-x)` | Both of the above |
| `a * b⁻¹` | `a * (b⁻¹)` | `⁻¹` attaches before `*` sees its operand |
| `(a * b)⁻¹` | needs the parentheses | Otherwise `⁻¹` attaches to `b` only |
| `d⁻¹⁻¹` | `(d⁻¹)⁻¹` | Postfix nests to the left |
| `a ^ -b` | **parse error** | Right operand of `^` needs at least 80; write `a ^ (-b)` |
| `¬A ∧ B` | `(¬A) ∧ B` | `∧` (35) is below 40 |
| `¬a = b` | `¬(a = b)` | `=` (50) is at least 40, so it is pulled in |
| `¬b ≤ a` | `¬(b ≤ a)` | Same; this is the shape in `lt_iff_le_not_le` |

---

## 4. Axiom-to-theorem dependency map

**How to read "Comm?".** It answers: is commutativity needed when identity
and inverse are *two-sided* (Zorich 1₊–3₊, Lang UA GR 1–3)? That is the
honest measure of whether a law is about order of operands.

In `Numbers.lean` the picture is coarser. `add_zero` and `neg_add` each cost
one `add_comm` (§1.0), so any lemma citing them carries `[IsAddComm R]` in
its instance list even when no commutativity step appears in its own proof.
If you want Lean to certify the "No" rows, the mixins would need right-hand
companions (`IsAddZero`, `IsNegAdd`).

The "key step" column is a hint, not a proof.

### 4.1 Additive group

| Law | Axioms | Comm? | Key step |
|---|---|---|---|
| `add_zero : x + 0 = x` | id | axiom if two-sided; **yes** from `zero_add` alone | Swap, then `zero_add` |
| `zero_unique : (∀ x, z + x = x) → z = 0` | id | No | Evaluate at `0`: `0 = z + 0 = z`. Zorich a. 1°, p. 39 |
| `neg_add : −x + x = 0` | inv | axiom if two-sided; **yes** from `add_neg` alone | Swap, then `add_neg` |
| `neg_unique : x + y = 0 → y = −x` | assoc, id, inv | No | Insert `0 = −x + x` on the **left** of `y`, re-associate. Zorich a. 2°; Lang BM N3, p. 9 |
| `add_left_cancel : x + y = x + z → y = z` | assoc, id, inv | No | Add `−x` on the **left**, where the `x` is. Adding on the right forces two commutes |
| `add_right_cancel : y + x = z + x → y = z` | assoc, id, inv | No | Add `−x` on the right |
| `add_eq_iff_eq_sub : x + a = b ↔ x = b − a` | assoc, id, inv | No | Add `−a` on the right; back direction uses `neg_add` |
| `a + x = b ↔ x = b − a` | + comm | **Yes** | Without it the answer is `x = −a + b`. Zorich a. 3° (p. 40) commutes in his first step |
| `neg_neg : −(−x) = x` | `neg_unique` | No | `−x + x = 0` says `x` is the inverse of `−x`. Lang BM N4, p. 10 |
| `neg_zero : −0 = 0` | id, inv | No | `0 + −0 = 0`, then `zero_add` |
| `neg_eq_iff_eq_neg : −x = y ↔ x = −y` | `neg_neg` | No | Negate both sides |
| `neg_add_rev : −(x + y) = −y + −x` | assoc, id, inv | **No** | §1.2: inner pair cancels first |
| `neg_add' : −(x + y) = −x + −y` | + comm | **Yes**, once | `neg_add_rev` then swap. Lang BM N5 |
| `sub_self : x − x = 0` | def, inv | No | Unfold |
| `sub_eq_zero_iff : x − y = 0 ↔ x = y` | assoc, id, inv | No | Add `y` on the right; `−y + y` cancels |
| `neg_sub : −(x − y) = y − x` | `neg_add_rev`, `neg_neg` | **No** | §1.3 (a) |
| `add_sub_cancel_right : x + y − y = x` | assoc, id, inv | No | Unfold, `add_assoc`, cancel (§2) |
| `sub_add_cancel : x − y + y = x` | assoc, id, inv | No | Same, with `neg_add` |
| `add_sub_cancel_left : x + y − x = y` | + comm | **Yes** | `x` and `−x` are separated by `y` |
| `sub_sub : x − y − z = x − (y + z)` | + comm | **Yes**, once | §1.3 (b); comm-free form has `z + y` |
| `x − (y − z) = x − y + z` | + comm | **Yes**, once | §1.3 (c); comm-free form is `x + z − y` |

### 4.2 Multiplicative group on the nonzero elements

Mirror of 4.1 with `*`, `1`, `⁻¹`, plus `≠ 0` hypotheses. Zorich b. 1°–3°
(p. 40, PDF 61) omits the proofs for exactly that reason.

| Law | Axioms | Comm? | Key step |
|---|---|---|---|
| `mul_one : x * 1 = x` | id | axiom if two-sided; **yes** from `one_mul` alone | Swap |
| `inv_mul_cancel : x ≠ 0 → x⁻¹ * x = 1` | inv | axiom if two-sided; **yes** from `mul_inv_cancel` alone | Swap |
| `inv_unique : x ≠ 0 → x * y = 1 → y = x⁻¹` | assoc, id, inv | No | Multiply by `x⁻¹` on the **left**. Lang BM p. 42 |
| `mul_left_cancel : x ≠ 0 → x * y = x * z → y = z` | assoc, id, inv | No | Multiply by `x⁻¹` on the left |
| `inv_ne_zero : x ≠ 0 → x⁻¹ ≠ 0` | + `mul_zero`, `0 ≠ 1` | No | If `x⁻¹ = 0` then `1 = x * 0 = 0`. Not a pure group fact: it needs §4.3 |
| `inv_inv : x ≠ 0 → x⁻¹⁻¹ = x` | `inv_unique`, `inv_ne_zero` | No | `x⁻¹ * x = 1` |
| `mul_inv_rev : (x * y)⁻¹ = y⁻¹ * x⁻¹` | assoc, id, inv | **No** | §1.2; also show `x * y ≠ 0` |
| `mul_inv : (x * y)⁻¹ = x⁻¹ * y⁻¹` | + comm | **Yes**, once | `mul_inv_rev` then swap |
| `div_self : x ≠ 0 → x / x = 1` | def, inv | No | Unfold |
| `mul_div_assoc : x * y / z = x * (y / z)` | def, assoc | No | Unfold both sides, one `mul_assoc` |
| `div_div_eq_mul_div : x / (y / z) = x * z / y` | `mul_inv_rev`, `inv_inv` | **No** | Reversal delivers `z` first, as in `neg_sub` |
| `(a / b) / (c / d) = (a * d) / (b * c)` | + comm | **Yes**, once | §1.3 (d) |
| cross-multiplication: `a / b = c / d → a * d = b * c` | + comm | **Yes** | Multiply both sides by `d * b`. Lang BM p. 43 |

### 4.3 Ring interaction

"L" is the left law `mul_add` (your axiom); "R" is the right law `add_mul`.

| Law | Axioms | Mul comm? | Key step |
|---|---|---|---|
| `add_mul : (x + y) * z = x * z + y * z` | L | **Yes**, three times | §1.1. In Zorich this is the axiom and `mul_add` is the derived one |
| `mul_zero : x * 0 = 0` | L, additive group | No | `x * 0 = x * (0 + 0) = x * 0 + x * 0`, then cancel. Zorich c. 1°, p. 40 |
| `zero_mul : 0 * x = 0` | R, additive group | No with R; **yes** with only L | Same with `(0 + 0) * x`. Lang BM p. 15 uses R |
| `mul_eq_zero_iff : x * y = 0 ↔ x = 0 ∨ y = 0` | inv, `mul_zero` | No | If `x ≠ 0`, multiply by `x⁻¹` on the left. Lang BM p. 42; Zorich c. 2° |
| `neg_one_mul : −1 * x = −x` | R, `zero_mul`, `neg_unique` | No with R | `x + (−1) * x = (1 + −1) * x`. Zorich c. 3°, p. 41; Lang BM N7, p. 16 |
| `mul_neg_one : x * −1 = −x` | L, `mul_zero` | No | Mirror; this is the one L gives directly |
| `neg_mul : −x * y = −(x * y)` | R, `zero_mul` | No with R | Show `x * y + (−x) * y = 0`. Lang BM N8, p. 16 |
| `mul_neg : x * −y = −(x * y)` | L, `mul_zero` | No | Mirror. Lang BM N9 |
| `neg_mul_neg : −x * −y = x * y` | `neg_mul`, `mul_neg`, `neg_neg` | No | Two sign moves, then `neg_neg`. Zorich c. 4°, 5° (p. 41) are the special cases `(−1)(−x) = x` and `(−x)(−x) = x · x` |
| `mul_sub : x * (y − z) = x * y − x * z` | L, `mul_neg` | No | Unfold, distribute, fold |
| `add_div : (x + y) / z = x / z + y / z` | R | No with R | It is `add_mul` with `z⁻¹` |
| `add_comm` itself | L, R, `one_mul`, additive cancellation | n/a | Expand `(1 + 1) * (a + b)` both ways and cancel: with both distributive laws, commutativity of `+` is a theorem |

### 4.4 Order laws

Your order axioms: `le_refl`, `le_trans`, `le_antisymm`, `le_total`,
`lt_iff_le_not_le`, `add_le_add_right`, `mul_pos`.

Two differences from Zorich (p. 37–38, PDF 58–59, and p. 41, PDF 62):

- His `<` is *defined* as `x ≤ y` and `x ≠ y`. Yours is `a ≤ b ∧ ¬b ≤ a`.
- His (II, III) is non-strict: `0 ≤ x ∧ 0 ≤ y ⇒ 0 ≤ xy`. Your `IsMulPos` is
  strict.

| Law | Axioms | Comm? | Key step |
|---|---|---|---|
| `lt_irrefl : ¬ x < x` | `lt` def | No | Unfold: `x ≤ x ∧ ¬ x ≤ x` |
| `lt_trichotomy` | total, antisymm, `lt` def | No | Case on `le_total`. Zorich d. 1°, p. 41 |
| `lt_of_lt_of_le`, `lt_of_le_of_lt`, `lt_trans` | trans, `lt` def | No | `≤` by transitivity; the `¬ ≤` half by transitivity again. Zorich d. 2°, p. 41–42 |
| `add_le_add_left : x ≤ y → z + x ≤ z + y` | `add_le_add_right` | **Yes** (add) | The axiom adds on the right only. Left/right again |
| `add_lt_add_right : x < y → x + z < y + z` | axiom, cancellation | No | `≤` from the axiom; if `y + z ≤ x + z`, add `−z` on the right. Zorich e. 1°, p. 42 |
| `neg_le_neg : x ≤ y → −y ≤ −x` | axiom | **Yes** (add) | Add `−x` on the right, then `−y` must go on the **left** |
| `0 < x → −x < 0` | `add_lt_add_right` | No | Add `−x` on the right of `0 < x`. Zorich e. 1° |
| `add_le_add : x ≤ y → z ≤ w → x + z ≤ y + w` | axiom, trans | **Yes** (add) | One right addition, one left addition, chain |
| `sub_nonneg_iff : 0 ≤ y − x ↔ x ≤ y` | axiom | No | Add `−x`, respectively `x`, on the right |
| `mul_pos_of_neg_of_neg : x < 0 → y < 0 → 0 < x * y` | `mul_pos`, `neg_mul_neg` | No | Apply `mul_pos` to `−x`, `−y`. Zorich e. 2°, p. 42–43 |
| `mul_lt_mul_of_pos_right : x < y → 0 < z → x * z < y * z` | `mul_pos`, R | No with R | `0 < (y − x) * z`, distribute on the right |
| `mul_lt_mul_of_pos_left` | `mul_pos`, L | No | Mirror with `mul_sub` |
| `mul_self_nonneg : 0 ≤ x * x` | trichotomy, sign rules | No | Case on the sign of `x` |
| `zero_lt_one : 0 < 1` | trichotomy, `0 ≠ 1` | No | If `1 < 0` then `0 < 1 * 1`. Zorich e. 3°, p. 43 |
| `inv_pos : 0 < x → 0 < x⁻¹` | sign rules, `zero_lt_one` | No | If `x⁻¹ < 0` then `x * x⁻¹ < 0`. Zorich e. 4°, p. 43 |

---

## 5. Lean 4 operator precedence master table

Ordered from tightest to loosest. Named levels: `max = 1024`, `arg = 1023`,
`lead = 1022`, `min1 = 11`, `min = 10`. Shortcuts are the VS Code Lean 4
extension abbreviations.

### Atoms, application, postfix

| Prec. | Symbol | Shortcut | Name / typeclass | Associativity | Parenthesized example |
|---|---|---|---|---|---|
| 1024 | `(e)`, `x`, `42`, `⟨a, b⟩` | `\<` `\>` | atoms, anonymous constructor | atom | n/a |
| 1024 | `x.foo`, `x.1` | ASCII | structure projection | postfix, left | `x.a.b` = `(x.a).b`; `f x.a` = `f (x.a)` |
| 1024 | `x⁻¹` | `\inv`, `\-1` | `Inv.inv` | `postfix:max` | `-x⁻¹` = `-(x⁻¹)`; `a * b⁻¹` = `a * (b⁻¹)` |
| 1022 | `f x` | ASCII | function application | left; arguments at `max` | `f a b` = `(f a) b`; `f a + b` = `(f a) + b` |

### Arithmetic and data

| Prec. | Symbol | Shortcut | Name / typeclass | Associativity | Parenthesized example |
|---|---|---|---|---|---|
| 100 | `<$>` | ASCII | `Functor.map` | `infixr` | `f <$> g <$> x` = `f <$> (g <$> x)` |
| 100 | `~~~` | ASCII | `Complement.complement` | `prefix` | `~~~a + b` = `(~~~a) + b` |
| 90 | `∘` | `\comp`, `\circ` | `Function.comp` | `infixr` | `f ∘ g ∘ h` = `f ∘ (g ∘ h)` |
| 80 | `^` | ASCII | `HPow.hPow` | `infixr` | `a ^ b ^ c` = `a ^ (b ^ c)` |
| 75 | `-x` | ASCII | `Neg.neg` | `prefix` | `-x ^ 2` = `-(x ^ 2)`; `-x * y` = `(-x) * y` |
| 75 | `<<<`, `>>>` | ASCII | `HShiftLeft.hShiftLeft`, `HShiftRight.hShiftRight` | `infixl` | `a <<< b <<< c` = `(a <<< b) <<< c` |
| 75 | `▸` | `\t` | `Eq.subst`-style rewriting | right | `h₁ ▸ h₂ ▸ e` = `h₁ ▸ (h₂ ▸ e)` |
| 73 | `•` | `\smul`, `\bu` | `HSMul.hSMul` | `infixr` | `a • b • c` = `a • (b • c)` |
| 70 | `*` | ASCII | `HMul.hMul` | `infixl` | `a * b * c` = `(a * b) * c` |
| 70 | `/` | ASCII | `HDiv.hDiv` | `infixl` | `a / b / c` = `(a / b) / c` |
| 70 | `%` | ASCII | `HMod.hMod` | `infixl` | `a + b % c` = `a + (b % c)` |
| 70 | `∩` | `\cap` | `Inter.inter` | `infixl` | `a ∩ b ∩ c` = `(a ∩ b) ∩ c` |
| 70 | `\` | ASCII | `SDiff.sdiff` | `infix` | `a \ b \ c` is an error |
| 67 | `::` | ASCII | `List.cons` | `infixr` | `a :: b :: l` = `a :: (b :: l)` |
| 65 | `+` | ASCII | `HAdd.hAdd` | `infixl` | `a + b + c` = `(a + b) + c` |
| 65 | `-` (binary) | ASCII | `HSub.hSub` | `infixl` | `a - b - c` = `(a - b) - c`; `x + y - y` = `(x + y) - y` |
| 65 | `++` | ASCII | `HAppend.hAppend` | `infixl` | `l ++ m ++ n` = `(l ++ m) ++ n` |
| 65 | `∪` | `\cup` | `Union.union` | `infixl` | `a ∪ b ∩ c` = `a ∪ (b ∩ c)` |
| 60 | `&&&` | ASCII | `HAnd.hAnd` | `infixl` | `a &&& b &&& c` = `(a &&& b) &&& c` |
| 60 | `<*>`, `<*`, `*>` | ASCII | `Seq.seq`, `SeqLeft.seqLeft`, `SeqRight.seqRight` | left | `f <*> x <*> y` = `(f <*> x) <*> y` |
| 60 | `>>` | ASCII | `HAndThen.hAndThen` | right | `a >> b >> c` = `a >> (b >> c)` |
| 58 | `^^^` | ASCII | `HXor.hXor` | `infixl` | `a ^^^ b ^^^ c` = `(a ^^^ b) ^^^ c` |
| 55 | `\|\|\|` | ASCII | `HOr.hOr` | `infixl` | `a \|\|\| b \|\|\| c` = `(a \|\|\| b) \|\|\| c` |
| 55 | `>>=` | ASCII | `Bind.bind` | `infixl` | `x >>= f >>= g` = `(x >>= f) >>= g` |

### Relations

| Prec. | Symbol | Shortcut | Name / typeclass | Associativity | Parenthesized example |
|---|---|---|---|---|---|
| 50 | `=` | ASCII | `Eq` | `infix` | `a + b = c` = `(a + b) = c`; `a = b = c` is an error |
| 50 | `≠` | `\ne` | `Ne` | `infix` | `a ≠ b + c` = `a ≠ (b + c)` |
| 50 | `<`, `>` | ASCII | `LT.lt`, `GT.gt` | `infix` | `a < b ∧ b < c` = `(a < b) ∧ (b < c)` |
| 50 | `≤`, `≥` | `\le`, `\ge` | `LE.le`, `GE.ge` | `infix` | `a ≤ b + c` = `a ≤ (b + c)` |
| 50 | `==`, `!=` | ASCII | `BEq.beq`, `bne` | `infix` | `a == b && c` = `(a == b) && c` |
| 50 | `≍` | paste (shortcut varies) | `HEq` | `infix` | `a ≍ b` |
| 50 | `∣` | `\mid`, `\|` | `Dvd.dvd` | `infix` | `a ∣ b * c` = `a ∣ (b * c)` |
| 50 | `∈`, `∉` | `\in`, `\notin` | `Membership.mem` | `notation`, non-assoc | `a ∈ s ∪ t` = `a ∈ (s ∪ t)` |
| 50 | `≈` | `\approx` | `HasEquiv.Equiv` | `infix` | `a ≈ b` |
| 50 | `⊆`, `⊂`, `⊇`, `⊃` | `\sub`, `\ssub`, `\sup`, `\ssup` | `Subset`, `SSubset`, `Superset`, `SSuperset` | `infix` | `s ∩ t ⊆ s` = `(s ∩ t) ⊆ s` |

### Logic

| Prec. | Symbol | Shortcut | Name / typeclass | Associativity | Parenthesized example |
|---|---|---|---|---|---|
| 40 (operand); result `max` | `¬` | `\not`, `\neg` | `Not` | prefix (`notation:max "¬" p:40`) | `¬A ∧ B` = `(¬A) ∧ B`; `¬a = b` = `¬(a = b)` |
| 40 (operand); result `max` | `!` | ASCII | `not` (Bool) | prefix | `!a && b` = `(!a) && b` |
| 35 | `∧` | `\and` | `And` | `infixr` | `A ∧ B ∧ C` = `A ∧ (B ∧ C)` |
| 35 | `&&` | ASCII | `and` (Bool) | `infixl` | `a && b && c` = `(a && b) && c` |
| 35 | `×` | `\times`, `\x` | `Prod` | `infixr` | `α × β × γ` = `α × (β × γ)` |
| 30 | `∨` | `\or` | `Or` | `infixr` | `A ∧ B ∨ C` = `(A ∧ B) ∨ C`; `A ∨ B ∨ C` = `A ∨ (B ∨ C)` |
| 30 | `\|\|` | ASCII | `or` (Bool) | `infixl` | `!a && b \|\| c` = `((!a) && b) \|\| c` |
| 30 | `⊕` | `\oplus` | `Sum` | `infixr` | `α ⊕ β ⊕ γ` = `α ⊕ (β ⊕ γ)` |
| 25 | `→` | `\to`, `\r` | function type / implication | `infixr` | `A → B → C` = `A → (B → C)`; `A ∧ B → C` = `(A ∧ B) → C` |
| 20 | `↔` | `\iff`, `\lr` | `Iff` | `infix` | `A ∧ B → C ↔ D` = `((A ∧ B) → C) ↔ D`; `A ↔ B ↔ C` is an error |
| 20 | `<\|>` | ASCII | `HOrElse.hOrElse` | right | `a <\|> b <\|> c` = `a <\|> (b <\|> c)` |

### Pipes, binders, and things that are not operators

| Prec. | Symbol | Shortcut | Name / typeclass | Associativity | Parenthesized example |
|---|---|---|---|---|---|
| 10 (`min`) | `<\|` | ASCII | low-precedence application | right | `f <\| g <\| x` = `f (g x)`; `f <\| a + b` = `f (a + b)` |
| 10 (`min`) | `$` | ASCII | same as `<\|` | right | `f $ g a $ b + c` = `f (g a (b + c))` |
| 10 (`min`) | `\|>` | ASCII | reverse application | left | `x \|> f \|> g` = `g (f x)` |
| body at 0 | `fun x => e`, `fun x ↦ e`, `λ` | `\fun`, `\lam`, `\mapsto` | lambda | prefix binder; body runs as far right as possible | `fun n => n + 1` = `fun n => (n + 1)` |
| body at 0 | `∀ x, p` | `\forall`, `\all` | dependent function type | prefix binder | `∀ n, n = n ∧ A` = `∀ n, ((n = n) ∧ A)` |
| body at 0 | `∃ x, p` | `\exists`, `\ex` | `Exists` | prefix binder | `∃ x, P x ∧ Q` = `∃ x, (P x ∧ Q)` |
| 0 | `:=`, `:`, `←`, `,` | `\l` for `←` | definition, ascription, bind, separators | not term operators | They delimit whole terms: `(e : T)`, `x := a + b` |

### Notes on the table

- **`^` is at 80 in this toolchain**, not the 75 many tutorials give.
- **Binders are greedy.** `∀ x, P x → Q` is `∀ x, (P x → Q)`. To end a binder
  early, parenthesize it: `(∀ x, P x) → Q`.
- **`::` is tighter than `+` and `++`.** `a :: l ++ m` is `(a :: l) ++ m`.
- **`∣` is not `|`.** Divisibility is the Unicode character typed with `\mid`.

### The whole ladder in one line

```
atoms . ⁻¹  >  f x  >  ∘  >  ^  >  -x  >  * / %  >  ::  >  + - ++  >  = ≠ < ≤ ∈
            >  ¬  >  ∧ &&  >  ∨ ||  >  →  >  ↔  >  <| |> $  >  ∀ ∃ fun bodies
```
