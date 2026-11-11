# Operator Precedence, Associativity, and Expression Parsing in Lean 4

Reference guide for core Lean 4 (no Mathlib assumed). Every number and
grouping below was read from `Init/Notation.lean`, `Init/Core.lean` and
`Lean/Parser/Term.lean` in toolchain `leanprover/lean4:v4.32.1`, and the
example groupings were confirmed by running them with
`set_option pp.parens true`. Re-check after a toolchain bump.

Three things differ from what many tutorials say:

- `^` is at precedence **80** in this toolchain, not 75.
- `¬` is declared as `notation:max "¬" p:40`: the result is an atom, and only
  its *argument* is parsed at 40.
- `↔` is plain `infix:20`, i.e. non-associative.

---

## 1. How Lean parses expressions into ASTs

### The text you type is not what Lean stores

When you write `x + y - y`, Lean's parser turns it into a tree and the
elaborator turns that into nested function applications:

```lean
HSub.hSub (HAdd.hAdd x y) y
```

There are no parentheses and no infix symbols in that term. Parentheses in
source code only steer the parser and are then discarded.

### Why the InfoView hides parentheses

The pretty-printer does the reverse trip, from tree to text. It inserts a
parenthesis only where re-parsing the text would otherwise give a different
tree. So `(x + y) - y` is printed as `x + y - y`, because that is how the
parser groups it anyway. The parentheses are redundant, not absent.

Three ways to see the real structure:

| Tool | Effect |
|---|---|
| `set_option pp.parens true` | Prints every grouping: `((x + y) - y) = x` |
| `set_option pp.notation false` | Prints the function names: `HSub.hSub (HAdd.hAdd x y) y` |
| Hover or click in the InfoView | Highlighted regions are exactly the AST subtrees |

### Reconstructing hidden parentheses by hand

1. Find the operator with the **lowest** precedence; it is the root of the
   tree.
2. If several operators tie at that level, associativity decides: for
   `infixl` the **rightmost** one is the root, for `infixr` the **leftmost**
   one is.
3. Repeat on each side.

### AST diagrams

**`x + y - y`**: `+` and `-` are both `infixl:65`, so the rightmost one is the
root.

```
 What Lean builds: (x + y) - y        NOT: x + (y - y)

        HSub.hSub                         HAdd.hAdd
        /       \                         /       \
   HAdd.hAdd     y                       x     HSub.hSub
    /     \                                     /     \
   x       y                                   y       y
```

**`a + b + c`** means `(a + b) + c`.

```
        HAdd.hAdd
        /       \
   HAdd.hAdd     c
    /     \
   a       b
```

**`a * b + c`** means `(a * b) + c`, because `*` (70) binds tighter than `+`
(65).

```
        HAdd.hAdd
        /       \
   HMul.hMul     c
    /     \
   a       b
```

**`-x + y`** means `(-x) + y`, because prefix `-` (75) binds tighter than `+`
(65).

```
        HAdd.hAdd
        /       \
    Neg.neg      y
       |
       x
```

**`¬A ∧ B`** means `(¬A) ∧ B`, because the argument of `¬` is parsed at 40 and
`∧` is only 35.

```
          And
         /   \
       Not    B
        |
        A
```

### Why `rw` matches subtrees, not text

`rw [h]` with `h : lhs = rhs` searches the goal's **tree** for a subtree that
matches `lhs`. It never looks at the printed string.

```lean
example (x y : Nat) : x + y - y = x := by
  rw [Nat.sub_self]   -- fails
```

The actual error:

```
Tactic `rewrite` failed: Did not find an occurrence of the pattern
  ?n - ?n
in the target expression
  x + y - y = x
```

The characters `y - y` are on screen, but the tree is
`HSub.hSub (HAdd.hAdd x y) y`. The only subtraction node has left child
`x + y` and right child `y`. For `?n - ?n` to match, both children would have
to be the same term, and they are not. No node `HSub.hSub y y` exists anywhere
in the goal.

The fix is a lemma whose left side has the shape of the tree you have, here
`Nat.add_sub_cancel : n + m - m = n`, or to re-associate first.

---

## 2. `infixl` vs. `infixr` vs. `infix`

### What the three commands mean

Each is shorthand for a `notation` with precedences on the two arguments:

| Command | Expands to | Effect |
|---|---|---|
| `infixl:65 " + "` | `notation:65 lhs:65 " + " rhs:66` | Right operand must bind strictly tighter, so chains group left |
| `infixr:35 " ∧ "` | `notation:35 lhs:36 " ∧ " rhs:35` | Left operand must bind strictly tighter, so chains group right |
| `infix:50 " = "` | `notation:50 lhs:51 " = " rhs:51` | Both sides must be tighter, so chaining is a parse error |

`lhs:65` reads "an expression of precedence at least 65 may go here".

### Why arithmetic is left-associative

```
a - b - c   =  (a - b) - c      -- not a - (b - c)
a + b + c   =  (a + b) + c
a / b / c   =  (a / b) / c
a - b + c   =  (a - b) + c
```

This matches ordinary mathematical convention, and for `-` and `/` it changes
the value: `10 - 3 - 2` is `5`, whereas `10 - (3 - 2)` is `9`. Addition is
associative as a *theorem*, but Lean still has to pick one tree, and
`a + b + c` and `a + (b + c)` are different terms until you rewrite with
associativity.

### Why connectives, arrows, cons and powers are right-associative

| Expression | Grouping | Reason |
|---|---|---|
| `A → B → C` | `A → (B → C)` | Currying: a function taking `A` and returning a function `B → C` |
| `A ∧ B ∧ C` | `A ∧ (B ∧ C)` | Matches nested pairs; `⟨a, b, c⟩` means `⟨a, ⟨b, c⟩⟩` |
| `A ∨ B ∨ C` | `A ∨ (B ∨ C)` | Same |
| `a :: b :: l` | `a :: (b :: l)` | The only version that type-checks: the tail must be a list |
| `a ^ b ^ c` | `a ^ (b ^ c)` | Convention; `(a ^ b) ^ c` is just `a ^ (b * c)` |
| `f ∘ g ∘ h` | `f ∘ (g ∘ h)` | Convention |

Consequences in proofs:

- **`intro`**: with goal `A → B → C`, the root is the first arrow. `intro hA`
  leaves `B → C`, and a second `intro hB` leaves `C`. With `(A → B) → C`, a
  single `intro h` gives `h : A → B`.
- **Projections**: for `h : A ∧ B ∧ C`, `h.1 : A`, `h.2 : B ∧ C`,
  `h.2.1 : B`, `h.2.2 : C`. There is no `h.3`.
- **`rw`**: a lemma about `(A ∧ B) ∧ C` will not match `A ∧ B ∧ C`.

### Mixed associativity at the same level

`∧` is `infixr:35` and `&&` is `infixl:35`; `∨` is `infixr:30` and `||` is
`infixl:30`. So `A ∧ B ∧ C` is `A ∧ (B ∧ C)`, but `a && b && c` is
`(a && b) && c`.

### Non-associative operators

`a = b = c`, `a < b < c` and `A ↔ B ↔ C` are all **parse errors**
("unexpected token"). Write `a < b ∧ b < c`.

### Moving parentheses with `add_assoc`

The statement (in core as `Nat.add_assoc`; generic `add_assoc` is Mathlib or
your own lemma):

```lean
Nat.add_assoc : n + m + k = n + (m + k)
--              (n + m) + k = n + (m + k)
```

| Rewrite | Direction | Effect on parentheses |
|---|---|---|
| `rw [Nat.add_assoc]` | left side to right side | `(a + b) + c` becomes `a + (b + c)`, parentheses move **right** |
| `rw [← Nat.add_assoc]` | right side to left side | `a + (b + c)` becomes `a + b + c`, parentheses move **left** |

After a forward rewrite the InfoView shows explicit parentheses,
`a + (b + c)`, because they are no longer the default. After a backward
rewrite they vanish, because left-nested is the default.

On a longer chain `a + b + c + d`, which is `((a + b) + c) + d`, plain
`rw [Nat.add_assoc]` rewrites the first match it finds, the outermost node,
giving `a + b + (c + d)`. To target a specific node, give arguments:
`rw [Nat.add_assoc a b c]`.

A lemma already shaped like the tree needs no re-association:

```lean
example (x y : Nat) : x + y - y = x := by
  rw [Nat.add_sub_cancel]          -- lemma already shaped like (n + m) - m
```

---

## 3. Unary prefix and postfix operators

### How they are defined

| Declaration in core | Expands to | Meaning |
|---|---|---|
| `prefix:75 "-" => Neg.neg` | `notation:75 "-" arg:75` | Operand must have precedence at least 75 |
| `postfix:max "⁻¹" => Inv.inv` | `notation:max arg:max "⁻¹"` | Operand must be an atom or application-level term |
| `notation:max "¬" p:40 => Not p` | (explicit) | Operand at least 40; the result counts as an atom |

### Why prefix operators nest to the right

A prefix operator has nothing on its left, so the only possible reading of
`- -x` is `-(-x)`, and of `¬¬A` is `¬(¬A)`. Write `- -x` with a space, because
`--` starts a comment.

### Prefix against binary operators

The rule: the operand of a prefix operator swallows everything that binds
**at least as tightly** as the operand's precedence and stops at the first
weaker operator.

| You write | Lean reads | Why |
|---|---|---|
| `-x + y` | `(-x) + y` | `+` (65) is below 75, so the operand stops at `x` |
| `-x * y` | `(-x) * y` | `*` (70) is below 75 |
| `-x ^ 2` | `-(x ^ 2)` | `^` (80) is at least 75, so it is pulled into the operand |
| `(-x) ^ 2` | `(-x) ^ 2` | Explicit parentheses are required for this |
| `-f x` | `-(f x)` | Application is far tighter than 75 |
| `-x⁻¹` | `-(x⁻¹)` | Postfix `⁻¹` is at `max` |
| `a * -b` | `a * (-b)` | Right operand of `*` needs at least 71, and `-b` is 75 |
| `a ^ -b` | **parse error** | Right operand of `^` needs at least 80, and `-b` is only 75; write `a ^ (-b)` |

`-x ^ 2` meaning `-(x ^ 2)` is the standard mathematical reading of −x², and
it is the most common source of surprise.

### `¬` in detail

| You write | Lean reads | Why |
|---|---|---|
| `¬A ∧ B` | `(¬A) ∧ B` | `∧` (35) is below 40 |
| `¬A ∨ B` | `(¬A) ∨ B` | `∨` (30) is below 40 |
| `¬A → B` | `(¬A) → B` | `→` (25) is below 40 |
| `¬a = b` | `¬(a = b)` | `=` (50) is at least 40, so it is pulled in |
| `¬a ≤ b ∧ C` | `(¬(a ≤ b)) ∧ C` | `≤` pulled in, `∧` left out |
| `¬¬A` | `¬(¬A)` | Prefix nesting |

So `¬` reaches over comparisons but not over connectives. To negate a
conjunction, write `¬(A ∧ B)`. Boolean `!` is declared the same way
(`notation:max "!" b:40`).

### Postfix and application

Function arguments are parsed at `max`, and `⁻¹` and `.field` are also at
`max`, so they attach to the argument before the function sees it:

```
f x⁻¹    =  f (x⁻¹)
f p.1    =  f (p.1)
g x p.1  =  g x (p.1)
f x + 1  =  (f x) + 1
```

---

## 4. Master table

Ordered from tightest to loosest. Named levels: `max = 1024`, `arg = 1023`,
`lead = 1022`, `min1 = 11`, `min = 10`. Shortcuts are the VS Code Lean 4
extension abbreviations; the common ones are given, and uncertain ones are
marked.

### Atoms, application, postfix

| Prec. | Symbol | Shortcut | Name / typeclass | Kind & associativity | Parenthesization example |
|---|---|---|---|---|---|
| 1024 | `(e)`, `x`, `42`, `⟨a, b⟩` | `\<` `\>` | atoms, anonymous constructor | atom | n/a |
| 1024 | `x.foo`, `x.1` | ASCII | structure projection | postfix (trailing), left | `x.a.b` = `(x.a).b`; `f x.a` = `f (x.a)` |
| 1024 | `x⁻¹` | `\inv`, `\-1` | `Inv.inv` | `postfix:max` | `-x⁻¹` = `-(x⁻¹)`; `f x⁻¹` = `f (x⁻¹)` |
| 1022 | `f x` | ASCII | function application | left; arguments at `max` | `f a b` = `(f a) b`; `f a + b` = `(f a) + b` |

### Arithmetic and data

| Prec. | Symbol | Shortcut | Name / typeclass | Kind & associativity | Parenthesization example |
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
| 67 | `::` | ASCII | `List.cons` | `infixr` | `a :: b :: l` = `a :: (b :: l)`; `a :: l ++ m` = `(a :: l) ++ m` |
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

| Prec. | Symbol | Shortcut | Name / typeclass | Kind & associativity | Parenthesization example |
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

| Prec. | Symbol | Shortcut | Name / typeclass | Kind & associativity | Parenthesization example |
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

| Prec. | Symbol | Shortcut | Name / typeclass | Kind & associativity | Parenthesization example |
|---|---|---|---|---|---|
| 10 (`min`) | `<\|` | ASCII | low-precedence application | right | `f <\| g <\| x` = `f (g x)`; `f <\| a + b` = `f (a + b)` |
| 10 (`min`) | `$` | ASCII | same as `<\|` (discouraged alternative) | right | `f $ g a $ b + c` = `f (g a (b + c))` |
| 10 (`min`) | `\|>` | ASCII | reverse application | left | `x \|> f \|> g` = `g (f x)`; `a + b \|> f` = `f (a + b)` |
| body at 0 | `fun x => e`, `fun x ↦ e`, `λ` | `\fun`, `\lam`, `\mapsto` | lambda | prefix binder; body extends as far right as possible | `fun n => n + 1` = `fun n => (n + 1)` |
| body at 0 | `∀ x, p` | `\forall`, `\all` | dependent function type | prefix binder | `∀ n, n = n ∧ A` = `∀ n, ((n = n) ∧ A)` |
| body at 0 | `∃ x, p` | `\exists`, `\ex` | `Exists` | prefix binder | `∃ x, P x ∧ Q` = `∃ x, (P x ∧ Q)` |
| 0 | `:=`, `:`, `←`, `,` | `\l` for `←` | definition, ascription, bind, separators | not term operators | They delimit whole terms, e.g. `(e : T)`, `x := a + b` |

### Notes on the table

- **Binders are greedy.** The body of `∀`, `∃`, and `fun` runs to the end of
  the enclosing parentheses or line. `∀ x, P x → Q` is `∀ x, (P x → Q)`. To
  end a binder early, parenthesize it: `(∀ x, P x) → Q`.
- **A binder as an operand needs parentheses** in most positions, for example
  `A ∧ (∀ x, P x)` on the left of another operator.
- **`::` vs. `+` and `++`.** `::` (67) is tighter than both, so `a + b :: l`
  parses as `a + (b :: l)` and fails to type-check, and `a :: l ++ m` is
  `(a :: l) ++ m`.
- **`∣` is not `|`.** Divisibility is the Unicode character typed with `\mid`;
  the ASCII bar is used for pattern matching.
- **Mathlib adds more** (`∑`, `∘ₗ`, `≃`, set-builder notation and so on) and
  reuses these same levels, but nothing above depends on it.

### The whole ladder in one line

```
atoms . ⁻¹  >  f x  >  ∘  >  ^  >  -x  >  * / %  >  ::  >  + - ++  >  = ≠ < ≤ ∈
            >  ¬  >  ∧ &&  >  ∨ ||  >  →  >  ↔  >  <| |> $  >  ∀ ∃ fun bodies
```
