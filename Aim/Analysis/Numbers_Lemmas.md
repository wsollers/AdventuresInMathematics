# Numbers — derived lemmas up to `OrderedField`

Statement-only worklist for `aim.analysis`. Each row is a theorem to be proved from the
axiom mixins in `Numbers.lean`; nothing here needs `IsOrderComplete` or `ArchimedeanProperty`.

Conventions
- Variables `x y z w a b c : F`, `n m : Nat`. Sections 1–3 assume `[Field F]`; sections 4–8 assume `[OrderedField F]`.
- Names follow Mathlib where a Mathlib lemma exists, so the later isomorphism switch is a rename-free `open`.
- **Related** lists the left/right mirror, the `≤`/`<` twin, or the iff/implication twin — the lemma you
  usually want immediately after this one. `(ax)` marks an axiom mixin.
- **Source**: Z = Zorich, *Mathematical Analysis I*, §2.1.2 (groups a–f, item numbers as printed);
  LS = Laczkovich–Sós, *Real Analysis I*, Ch. 3. LS theorem numbers are left for you to fill in
  (the Librarian wasn't reachable when this was written). `—` = standard, both books or neither.
- `0⁻¹` is unconstrained by the axioms, so every inverse lemma carries an `≠ 0` hypothesis.

## 1. Additive group

| Name | Statement | Related | Source |
|---|---|---|---|
| `add_zero` | `x + 0 = x` | `zero_add` (ax) | Z a |
| `zero_unique` | `(∀ x, x + z = x) → z = 0` | `(∀ x, z + x = x) → z = 0` | Z a.1° |
| `neg_add` | `-x + x = 0` | `add_neg` (ax) | — |
| `neg_unique` | `x + y = 0 → y = -x` | `y + x = 0 → y = -x` | Z a.2° |
| `add_left_cancel` | `x + y = x + z → y = z` | `add_right_cancel` | Z a.3° |
| `add_eq_iff_eq_sub` | `x + a = b ↔ x = b - a` | `a + x = b ↔ x = b - a` | Z a.3° |
| `neg_neg` | `-(-x) = x` | — | — |
| `neg_zero` | `-0 = 0` | — | — |
| `neg_eq_iff_eq_neg` | `-x = y ↔ x = -y` | `neg_inj : -x = -y ↔ x = y` | — |
| `neg_add_rev` | `-(x + y) = -y + -x` | `neg_add' : -(x + y) = -x + -y` | — |
| `sub_self` | `x - x = 0` | — | — |
| `sub_eq_zero_iff` | `x - y = 0 ↔ x = y` | `sub_ne_zero_iff` | — |
| `neg_sub` | `-(x - y) = y - x` | — | — |
| `add_sub_cancel_right` | `x + y - y = x` | `sub_add_cancel : x - y + y = x` | — |
| `sub_sub` | `x - y - z = x - (y + z)` | `sub_add : x - y + z = x - (y - z)` | — |

## 2. Multiplicative group on `F \ {0}`

| Name | Statement | Related | Source |
|---|---|---|---|
| `mul_one` | `x * 1 = x` | `one_mul` (ax) | Z b |
| `one_unique` | `(∀ x, x * e = x) → e = 1` | left version | Z b.1° |
| `inv_mul_cancel` | `x ≠ 0 → x⁻¹ * x = 1` | `mul_inv_cancel` (ax) | — |
| `inv_unique` | `x ≠ 0 → x * y = 1 → y = x⁻¹` | `y * x = 1 → y = x⁻¹` | Z b.2° |
| `mul_left_cancel` | `x ≠ 0 → x * y = x * z → y = z` | `mul_right_cancel` | Z b.3° |
| `mul_eq_iff_eq_div` | `a ≠ 0 → (a * x = b ↔ x = b / a)` | `x * a = b ↔ x = b / a` | Z b.3° |
| `inv_ne_zero` | `x ≠ 0 → x⁻¹ ≠ 0` | — | — |
| `inv_inv` | `x ≠ 0 → x⁻¹⁻¹ = x` | — | — |
| `one_inv` | `1⁻¹ = 1` | `one_div : 1 / x = x⁻¹` | — |
| `mul_inv` | `x ≠ 0 → y ≠ 0 → (x * y)⁻¹ = x⁻¹ * y⁻¹` | `mul_inv_rev` (order swapped) | — |
| `div_self` | `x ≠ 0 → x / x = 1` | `div_one : x / 1 = x` | — |
| `div_div_eq_mul_div` | `y ≠ 0 → z ≠ 0 → x / (y / z) = x * z / y` | `div_mul_eq_div_div` | — |
| `mul_div_assoc` | `x * y / z = x * (y / z)` | — | — |

## 3. Ring interaction (addition × multiplication)

| Name | Statement | Related | Source |
|---|---|---|---|
| `mul_zero` | `x * 0 = 0` | `zero_mul` | Z c.1° |
| `mul_eq_zero_iff` | `x * y = 0 ↔ x = 0 ∨ y = 0` | `mul_ne_zero` | Z c.2° |
| `neg_one_mul` | `-1 * x = -x` | `mul_neg_one` | Z c.3° |
| `neg_mul` | `-x * y = -(x * y)` | `mul_neg` | — |
| `neg_mul_neg` | `-x * -y = x * y` | `neg_mul_eq_neg_mul`, `(-1)*(-1) = 1` | Z c.4°, c.5° |
| `add_mul` | `(x + y) * z = x * z + y * z` | `mul_add` (ax) | — |
| `mul_sub` | `x * (y - z) = x * y - x * z` | `sub_mul` | — |
| `neg_inv` | `x ≠ 0 → (-x)⁻¹ = -x⁻¹` | `neg_div`, `div_neg` | — |
| `add_div` | `(x + y) / z = x / z + y / z` | `div_add_div` (common denominator) | — |
| `mul_self_eq_mul_self_iff` | `x * x = y * y ↔ x = y ∨ x = -y` | `sq_sub_sq : x*x - y*y = (x - y)*(x + y)` | — |

## 4. Order alone (`≤`, `<`)

| Name | Statement | Related | Source |
|---|---|---|---|
| `lt_irrefl` | `¬ x < x` | `ne_of_lt : x < y → x ≠ y` | — |
| `le_of_lt` | `x < y → x ≤ y` | `lt_iff_le_and_ne` | — |
| `lt_asymm` | `x < y → ¬ y < x` | — | — |
| `lt_trans` | `x < y → y < z → x < z` | `lt_of_le_of_lt`, `lt_of_lt_of_le` | Z d.2° |
| `not_lt_iff_le` | `¬ x < y ↔ y ≤ x` | `not_le_iff_lt` | — |
| `lt_or_ge` | `x < y ∨ y ≤ x` | `le_or_lt` | — |
| `lt_trichotomy` | `x < y ∨ x = y ∨ y < x` | `lt_trichotomy_exclusive` (at most one) | Z d.1° |
| `le_iff_lt_or_eq` | `x ≤ y ↔ x < y ∨ x = y` | `lt_of_le_of_ne` | — |
| `eq_of_le_of_le` | `x ≤ y → y ≤ x → x = y` | `le_antisymm` (ax) restated | — |

## 5. Order and addition

| Name | Statement | Related | Source |
|---|---|---|---|
| `add_le_add_left` | `x ≤ y → z + x ≤ z + y` | `add_le_add_right` (ax) | — |
| `add_lt_add_right` | `x < y → x + z < y + z` | `add_lt_add_left` | Z e.1° |
| `le_of_add_le_add_right` | `x + z ≤ y + z → x ≤ y` | `lt_of_add_lt_add_right` | — |
| `add_le_add` | `x ≤ y → z ≤ w → x + z ≤ y + w` | `add_lt_add`, `add_lt_add_of_le_of_lt` | Z e.3°, e.4° |
| `neg_neg_of_pos` | `0 < x → -x < 0` | `neg_pos_of_neg : x < 0 → 0 < -x` | Z e.2° |
| `neg_nonpos_of_nonneg` | `0 ≤ x → -x ≤ 0` | `neg_nonneg_of_nonpos` | — |
| `neg_le_neg_iff` | `-x ≤ -y ↔ y ≤ x` | `neg_lt_neg_iff` | — |
| `sub_nonneg_iff` | `0 ≤ y - x ↔ x ≤ y` | `sub_pos_iff : 0 < y - x ↔ x < y` | — |
| `sub_le_iff_le_add` | `x - z ≤ y ↔ x ≤ y + z` | `le_sub_iff_add_le` | — |
| `lt_add_of_pos_right` | `0 < y → x < x + y` | `lt_add_of_pos_left`, `le_add_of_nonneg_right` | — |

## 6. Order and multiplication

| Name | Statement | Related | Source |
|---|---|---|---|
| `mul_nonneg` | `0 ≤ x → 0 ≤ y → 0 ≤ x * y` | `mul_pos` (ax) | — |
| `mul_pos_of_neg_of_neg` | `x < 0 → y < 0 → 0 < x * y` | — | Z f.2° |
| `mul_neg_of_neg_of_pos` | `x < 0 → 0 < y → x * y < 0` | `mul_neg_of_pos_of_neg` | Z f.3° |
| `mul_lt_mul_of_pos_right` | `x < y → 0 < z → x * z < y * z` | `mul_lt_mul_of_pos_left`; `mul_le_mul_of_nonneg_right` | Z f.4° |
| `mul_lt_mul_of_neg_right` | `x < y → z < 0 → y * z < x * z` | `mul_lt_mul_of_neg_left` | Z f.5° |
| `lt_of_mul_lt_mul_right` | `x * z < y * z → 0 ≤ z → x < y` | `le_of_mul_le_mul_right` | — |
| `mul_self_nonneg` | `0 ≤ x * x` | `mul_self_pos : x ≠ 0 → 0 < x * x` | — |
| `zero_lt_one` | `0 < 1` | `zero_le_one`, `neg_one_lt_zero` | Z f.6° |
| `two_pos` | `0 < 1 + 1` | `two_ne_zero` (char ≠ 2) | — |
| `inv_pos` | `0 < x → 0 < x⁻¹` | `inv_neg_of_neg`; `inv_pos_iff` | Z f.7° |
| `inv_lt_inv_of_lt` | `0 < x → x < y → y⁻¹ < x⁻¹` | `inv_le_inv_of_le` | Z f.8° |
| `div_pos` | `0 < x → 0 < y → 0 < x / y` | `div_nonneg` | — |
| `le_div_iff` | `0 < c → (a ≤ b / c ↔ a * c ≤ b)` | `div_le_iff`, `lt_div_iff`, `div_lt_iff` | — |
| `add_halves` | `x / 2 + x / 2 = x` (with `2 := 1 + 1`) | `half_pos : 0 < x → 0 < x / 2` | — |
| `midpoint_between` | `x < y → x < (x + y) / 2 ∧ (x + y) / 2 < y` | `exists_between : x < y → ∃ z, x < z ∧ z < y` | LS (no ordered field is discrete) |
| `le_of_forall_pos_lt_add` | `(∀ ε, 0 < ε → x ≤ y + ε) → x ≤ y` | `eq_of_forall_dist_le` (after `abs`) | LS (the ε-lemma) |

## 7. `natCast` and `pow` (define `pow` by recursion on `Nat`)

| Name | Statement | Related | Source |
|---|---|---|---|
| `natCast_zero` | `natCast 0 = 0` | `natCast_succ` (defn unfolds) | — |
| `natCast_add` | `natCast (m + n) = natCast m + natCast n` | `natCast_mul` | — |
| `natCast_nonneg` | `0 ≤ natCast n` | `natCast_pos : 0 < natCast (n + 1)` | — |
| `natCast_lt` | `m < n → natCast m < natCast n` | `natCast_le`, `natCast_injective` (char 0) | — |
| `pow_zero` | `x ^ 0 = 1` | `pow_succ : x ^ (n+1) = x ^ n * x` | — |
| `pow_add` | `x ^ (m + n) = x ^ m * x ^ n` | `pow_mul`, `mul_pow` | — |
| `pow_nonneg` | `0 ≤ x → 0 ≤ x ^ n` | `pow_pos` | — |
| `pow_le_pow_left` | `0 ≤ x → x ≤ y → x ^ n ≤ y ^ n` | strict version for `n ≥ 1` | — |
| `one_lt_pow` | `1 < x → 1 ≤ n → 1 < x ^ n` | `pow_lt_pow_right : 1 < x → m < n → x^m < x^n` | — |
| `one_add_mul_le_pow` (Bernoulli) | `-1 ≤ x → 1 + natCast n * x ≤ (1 + x) ^ n` | strict for `x ≠ 0`, `n ≥ 2` | LS; Z §2.2 exercises |
| `four_mul_le_sq_add` (2-term AM–GM, no roots) | `4 * (x * y) ≤ (x + y) ^ 2` | `two_mul_le_add_sq : 2*x*y ≤ x^2 + y^2` | LS |

## 8. `max`, `min`, `abs` (definitions: `max x y := if x ≤ y then y else x`, `min` dually, `abs x := max x (-x)`)

| Name | Statement | Related | Source |
|---|---|---|---|
| `le_max_left` | `x ≤ max x y` | `le_max_right`; `min_le_left`, `min_le_right` | — |
| `max_le` | `x ≤ z → y ≤ z → max x y ≤ z` | `le_min` | — |
| `max_comm` | `max x y = max y x` | `min_comm`; `max_self` | — |
| `max_eq_left` | `y ≤ x → max x y = x` | `max_eq_right`; `min_eq_left` | — |
| `abs_nonneg` | `0 ≤ \|x\|` | `abs_pos : x ≠ 0 → 0 < \|x\|` | LS |
| `abs_eq_zero_iff` | `\|x\| = 0 ↔ x = 0` | `abs_zero` | — |
| `abs_of_nonneg` | `0 ≤ x → \|x\| = x` | `abs_of_neg : x < 0 → \|x\| = -x` | LS |
| `abs_neg` | `\|-x\| = \|x\|` | `abs_sub_comm : \|x - y\| = \|y - x\|` | — |
| `le_abs_self` | `x ≤ \|x\|` | `neg_le_abs_self : -x ≤ \|x\|` | — |
| `abs_le_iff` | `\|x\| ≤ a ↔ -a ≤ x ∧ x ≤ a` | `abs_lt_iff` | LS |
| `abs_sub_lt_iff` | `\|x - y\| < ε ↔ y - ε < x ∧ x < y + ε` | `abs_sub_le_iff` | — |
| `abs_mul` | `\|x * y\| = \|x\| * \|y\|` | `abs_inv`, `abs_div` | LS |
| `abs_add` (triangle) | `\|x + y\| ≤ \|x\| + \|y\|` | `abs_sub : \|x - y\| ≤ \|x\| + \|y\|` | LS |
| `abs_sub_abs_le_abs_sub` (reverse triangle) | `\|\|x\| - \|y\|\| ≤ \|x - y\|` | `abs_abs_sub_abs_le` | LS |
| `abs_le_of_le_of_neg_le` | `x ≤ a → -x ≤ a → \|x\| ≤ a` | converse direction of `abs_le_iff` | — |
| `abs_eq_iff` | `\|x\| = a ↔ x = a ∨ x = -a` (with `0 ≤ a`) | `abs_eq_abs_iff` | — |

## Notes

- Section 4 is pure order theory; the proofs there use only `IsLERefl`, `IsLETrans`, `IsLEAntisymm`,
  `IsLETotal`, `IsLTIffLENotLE` and classical case splits. Doing it first makes sections 5–6 mechanical.
- `two_ne_zero` is the first place the order axioms feed back into pure algebra: it is false in a general
  field (char 2) and provable only because `0 < 1 + 1`.
- Full AM–GM `√(xy) ≤ (x+y)/2` and anything with `√` waits for completeness; the squared form in §7 is the
  ordered-field-only version.
- `midpoint_between` and the ε-lemma are the two LS results that carry the most weight downstream
  (limits, density). Both are ordered-field-only — no Archimedes needed.
