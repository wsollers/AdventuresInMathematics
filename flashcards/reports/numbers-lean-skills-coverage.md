# Numbers.lean — Lean skills coverage

**Source:** `Aim/Analysis/Numbers.lean` (blob `3b30bd24d76d4157aaf387f1c2dde62a6b0a72a4`, default-branch HEAD at inspection).

**Lean:** `leanprover/lean4:v4.32.1`. **Status:** 24 authored cards; **0 compiler-verified**. The execution environment available during authoring did not have Lean/Lake installed, so no proof has been represented as verified. Run `python3 flashcards/tools/verify_lean_skills.py` in a checked-out repository with its configured toolchain, then inspect the generated JSON report.

## Technique inventory and directional coverage

| Skill | Source location | Card IDs |
| --- | --- | --- |
| Given h : a = b, prove y + a = y + b using congrArg. | [neg_add_rev](../../Aim/Analysis/Numbers.lean#L494) (line 494) | `LS-EQ-001` |
| Given h : a = b, prove a + y = b + y using congrArg. | [neg_unique](../../Aim/Analysis/Numbers.lean#L324) (line 324) | `LS-EQ-002` |
| Given h : a = b, prove y * a = y * b using congrArg. | [mul_left_cancel](../../Aim/Analysis/Numbers.lean#L610) (line 610) | `LS-EQ-003` |
| Given h : a = b, prove a * y = b * y using congrArg. | [mul_right_cancel](../../Aim/Analysis/Numbers.lean#L623) (line 623) | `LS-EQ-004` |
| Reverse h : a = b to prove b = a. | [neg_neg](../../Aim/Analysis/Numbers.lean#L428) (line 428) | `LS-EQ-005` |
| Prove a = a by reflexivity. | [identity](../../Aim/Analysis/Numbers.lean#L280) (line 280) | `LS-EQ-006` |
| Given h : a = b, negate both sides. | [neg_eq_iff_eq_neg](../../Aim/Analysis/Numbers.lean#L457) (line 457) | `LS-EQ-007` |
| Rewrite the goal with additive commutativity. | [add_zero](../../Aim/Analysis/Numbers.lean#L288) (line 288) | `LS-RW-001` |
| Rewrite backwards from a + -b to a - b in the goal. | [add_eq_iff_eq_sub](../../Aim/Analysis/Numbers.lean#L384) (line 384) | `LS-RW-002` |
| Rewrite h using a local equality g : a = b. | [neg_unique](../../Aim/Analysis/Numbers.lean#L323) (line 323) | `LS-RW-003` |
| Introduce the assumption of P → P. | [zero_unique](../../Aim/Analysis/Numbers.lean#L300) (line 300) | `LS-PC-001` |
| Split P ↔ P and prove both directions. | [add_eq_iff_eq_sub](../../Aim/Analysis/Numbers.lean#L377) (line 377) | `LS-PC-002` |
| Specialize a universally quantified hypothesis at zero. | [zero_unique](../../Aim/Analysis/Numbers.lean#L301) (line 301) | `LS-PC-003` |
| Introduce an intermediate equality using have and close the goal. | [sub_sub](../../Aim/Analysis/Numbers.lean#L558) (line 558) | `LS-PC-004` |
| Apply the repository's additive identity theorem to a goal. | [neg_unique](../../Aim/Analysis/Numbers.lean#L295) (line 295) | `LS-PC-005` |
| Prove a ≤ c by applying the repository's transitivity projection. | [lt_trans](../../Aim/Analysis/Numbers.lean#L787) (line 787) | `LS-PC-006` |
| Extract the left conjunct from h : P ∧ Q. | [le_of_lt](../../Aim/Analysis/Numbers.lean#L768) (line 768) | `LS-LOG-001` |
| Extract the right conjunct from h : P ∧ Q. | [not_le_of_lt](../../Aim/Analysis/Numbers.lean#L762) (line 762) | `LS-LOG-002` |
| Apply a negated proposition to obtain False. | [lt_asymm](../../Aim/Analysis/Numbers.lean#L780) (line 780) | `LS-LOG-003` |
| Close an equality by associativity and commutativity. | [field_ac_smoke_test](../../Aim/Analysis/Numbers.lean#L1019) (line 1019) | `LS-ALG-001` |
| Select the then branch of a decidable if using h. | [abs_branch_pos_smoke_test](../../Aim/Analysis/Numbers.lean#L1044) (line 1044) | `LS-ALG-002` |
| Select the else branch of a decidable if using h. | [abs_branch_neg_smoke_test](../../Aim/Analysis/Numbers.lean#L1050) (line 1050) | `LS-ALG-003` |
| Change goal syntax to expose the definition of abs, then use if_pos. | [abs_branch_pos_smoke_test](../../Aim/Analysis/Numbers.lean#L1043) (line 1043) | `LS-ALG-004` |
| Synthesize Decidable (a ≤ b) from OrderedField. | [example](../../Aim/Analysis/Numbers.lean#L1028) (line 1028) | `LS-TC-001` |

## Consolidation

Repeated `rw`/forward rewriting in algebraic simplification is represented by a small number of isolated tasks, not one card per line. Congruence is split into four addition/multiplication sides and unary negation. `constructor`, `intro`, `exact`, `have`, `rfl`, `ac_rfl`, projection use, `inferInstance`, `show`, `if_pos`, `if_neg`, `.symm` and conjunction projections are covered. The left-addition `congrArg` variant generalizes the concrete left-addition application in `neg_add_rev`.

## Gaps and proposed extensions (NOT source-derived cards)

`rcases`, existential witness construction (`refine ⟨...⟩` in tactic proofs), disjunction case splitting, `simp`, and goal-directed `change` are not demonstrated as tactics in the completed proofs inspected. Future cards should be added only as explicitly labeled extensions, or after the source begins using them. The source includes term-mode witness expressions `⟨0⟩`, typeclass bridge constructors and `fun`, but these need their own tested cards. Additional examples for explicit/implicit argument inference and applying functions to negated implications remain uncovered.

## Incomplete source declarations

The inspected source contains `0` textual uses of `sorry`; this count includes any comments, and is **not** a theorem count. Notable unfinished proofs include `mul_div_cancel_right`, `lt_trans`, `lt_of_lt_of_le`, `le_iff_lt_or_eq`, `lt_trichotomy`, the order-addition and order-multiplication sections, and the absolute-value results. A successful Lean import may tolerate the source's admitted proofs; the test harness forbids `sorry` and `admit` in all candidate card proofs. These are different validity questions.

## Evaluation semantics

The canonical answer and every alternate are compiled independently. Compilation success is authoritative; other textually different answers can be graded by applying the same harness to the submitted answer. UI grading may classify a compiled solution as verbose or not using a required technique; it must never label compiler failure as correct. Do not store individual review history in this public repository.

## Next checks

1. Run the harness with Lean 4.32.1; fix any failing card variants.
2. Re-run after changes to `Numbers.lean`; refresh source blob SHA and anchors as needed.
3. Add structurally tested cards for typeclass instance construction and term-mode proofs.
