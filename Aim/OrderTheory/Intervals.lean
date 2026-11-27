import Aim.OrderTheory.SetOrder

/-!
# Intervals as Sets

Intervals are project-owned sets of elements of an ordered carrier, not new
order instances on the carrier. Definitions use only the comparisons they need;
derived results state their order laws explicitly. No field, completeness,
lattice, or decidability assumption is required here.

Use SetBelow, SetStrictlyBelow, EgliMilner, Set.Disjoint, and Set.Overlaps on
these sets. No single global order on intervals is chosen. Closed interval
endpoint characterizations require nonempty intervals. The letters in Icc,
Ico, Ioc, Ioo, Ici, Ioi, Iic, and Iio mean closed, open, and infinite.
-/

namespace Aim.Set

universe u

/-- The closed interval from `a` to `b`. -/
def Icc {X : Type u} [LE X] (a b : X) : Set X :=
  {x | a ≤ x ∧ x ≤ b}

/-- Readable name for `Icc`. -/
abbrev closedInterval {X : Type u} [LE X] (a b : X) : Set X :=
  Icc a b

/-- Membership in `Icc` is exactly its endpoint comparison condition. -/
theorem mem_Icc_iff {X : Type u} [LE X] {a b x : X} :
    x ∈ Icc a b ↔ a ≤ x ∧ x ≤ b := by
  sorry

/-- The interval including `a` and excluding `b`. -/
def Ico {X : Type u} [LE X] [LT X] (a b : X) : Set X :=
  {x | a ≤ x ∧ x < b}

/-- Readable name for `Ico`. -/
abbrev closedOpenInterval {X : Type u} [LE X] [LT X] (a b : X) : Set X :=
  Ico a b

/-- Membership in `Ico` is exactly its endpoint comparison condition. -/
theorem mem_Ico_iff {X : Type u} [LE X] [LT X] {a b x : X} :
    x ∈ Ico a b ↔ a ≤ x ∧ x < b := by
  sorry

/-- The interval excluding `a` and including `b`. -/
def Ioc {X : Type u} [LE X] [LT X] (a b : X) : Set X :=
  {x | a < x ∧ x ≤ b}

/-- Readable name for `Ioc`. -/
abbrev openClosedInterval {X : Type u} [LE X] [LT X] (a b : X) : Set X :=
  Ioc a b

/-- Membership in `Ioc` is exactly its endpoint comparison condition. -/
theorem mem_Ioc_iff {X : Type u} [LE X] [LT X] {a b x : X} :
    x ∈ Ioc a b ↔ a < x ∧ x ≤ b := by
  sorry

/-- The open interval from `a` to `b`. -/
def Ioo {X : Type u} [LT X] (a b : X) : Set X :=
  {x | a < x ∧ x < b}

/-- Readable name for `Ioo`. -/
abbrev openInterval {X : Type u} [LT X] (a b : X) : Set X :=
  Ioo a b

/-- Membership in `Ioo` is exactly its endpoint comparison condition. -/
theorem mem_Ioo_iff {X : Type u} [LT X] {a b x : X} :
    x ∈ Ioo a b ↔ a < x ∧ x < b := by
  sorry

/-- The upper ray including `a`. -/
def Ici {X : Type u} [LE X] (a : X) : Set X :=
  {x | a ≤ x}

/-- Readable name for `Ici`. -/
abbrev closedUpperRay {X : Type u} [LE X] (a : X) : Set X :=
  Ici a

/-- Membership in `Ici` is exactly its endpoint comparison condition. -/
theorem mem_Ici_iff {X : Type u} [LE X] {a x : X} :
    x ∈ Ici a ↔ a ≤ x := by
  constructor
  . --
    intro hmem
    exact hmem
  . --
    intro hle
    exact hle

/-- The upper ray excluding `a`. -/
def Ioi {X : Type u} [LT X] (a : X) : Set X :=
  {x | a < x}

/-- Readable name for `Ioi`. -/
abbrev openUpperRay {X : Type u} [LT X] (a : X) : Set X :=
  Ioi a

/-- Membership in `Ioi` is exactly its endpoint comparison condition. -/
theorem mem_Ioi_iff {X : Type u} [LT X] {a x : X} :
    x ∈ Ioi a ↔ a < x := by
  sorry

/-- The lower ray including `b`. -/
def Iic {X : Type u} [LE X] (b : X) : Set X :=
  {x | x ≤ b}

/-- Readable name for `Iic`. -/
abbrev closedLowerRay {X : Type u} [LE X] (b : X) : Set X :=
  Iic b

/-- Membership in `Iic` is exactly its endpoint comparison condition. -/
theorem mem_Iic_iff {X : Type u} [LE X] {b x : X} :
    x ∈ Iic b ↔ x ≤ b := by
  sorry

/-- The lower ray excluding `b`. -/
def Iio {X : Type u} [LT X] (b : X) : Set X :=
  {x | x < b}

/-- Readable name for `Iio`. -/
abbrev openLowerRay {X : Type u} [LT X] (b : X) : Set X :=
  Iio b

/-- Membership in `Iio` is exactly its endpoint comparison condition. -/
theorem mem_Iio_iff {X : Type u} [LT X] {b x : X} :
    x ∈ Iio b ↔ x < b := by
  sorry

/-- A closed interval is nonempty exactly when its endpoints are ordered. -/
theorem nonempty_Icc_iff {X : Type u} [Preorder X] (a b : X) :
    Nonempty (Icc a b) ↔ a ≤ b := by
  sorry

/-- Containment of a nonempty closed interval is determined by its endpoints. -/
theorem Icc_subset_Icc_iff {X : Type u} [Preorder X] {a b c d : X}
    (hab : a ≤ b) : Icc a b ⊆ Icc c d ↔ c ≤ a ∧ b ≤ d := by
  sorry

/-- Nonempty closed intervals are separated exactly when the inner endpoints are ordered. -/
theorem setBelow_Icc_iff {X : Type u} [Preorder X] {a b c d : X}
    (hab : a ≤ b) (hcd : c ≤ d) :
    SetBelow (Icc a b) (Icc c d) ↔ b ≤ c := by
  sorry

/-- Strict separation of nonempty closed intervals compares the inner endpoints strictly. -/
theorem setStrictlyBelow_Icc_iff {X : Type u} [Preorder X] {a b c d : X}
    (hab : a ≤ b) (hcd : c ≤ d) :
    SetStrictlyBelow (Icc a b) (Icc c d) ↔ b < c := by
  sorry

/-- Egli–Milner comparison of nonempty closed intervals compares corresponding endpoints. -/
theorem egliMilner_Icc_iff {X : Type u} [Preorder X] {a b c d : X}
    (hab : a ≤ b) (hcd : c ≤ d) :
    EgliMilner (Icc a b) (Icc c d) ↔ a ≤ c ∧ b ≤ d := by
  sorry

end Aim.Set
