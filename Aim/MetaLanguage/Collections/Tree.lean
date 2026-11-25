import Aim.MetaLanguage.Collections.List

/-!
# Metalanguage Trees

Finite rooted trees with a label at every node and an ordered list of children.
A leaf is a node with no children. This is a host inductive datatype, not a
theorem about free generation or a language-specific grammar.
-/

namespace Aim

universe u

/-- A finite, ordered, arbitrarily branching syntax tree. -/
inductive MetaTree (X : Type u) : Type u where
  | node (label : X) (children : List (MetaTree X)) : MetaTree X

namespace MetaTree

/-- A leaf carries a label and has no children. -/
def leaf {X : Type u} (x : X) : MetaTree X :=
  .node x []

end MetaTree
end Aim
