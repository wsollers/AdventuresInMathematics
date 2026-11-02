/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Sentential and First-Order Syntax

Variables (`A, B, C`), logical connectives, formula syntax trees, and string parsing (`"A AND B"`).
-/

namespace aim.logic

inductive TruthValue where
  | false : TruthValue
  | true : TruthValue
  deriving Repr, DecidableEq
/-
# Sentential language
Enderton - formally defines a sentential language

Sentential langauge has a set of symbols.
  There is a customary set of symbols, but we can add more.
  The symbols are called logical connectives.
  we can reduce the set -PROVIDED- it is functionally complete
  Enderton calls them sentence symbols. (These are the logical symbols)
  Enderton include ()'s as Distinguished symbols

  The logical symbols are called sentential connectives

  with ()'s they form the logical symbols

  The translation of the logical symbols is fixed
    IE and is fixed to mean and etc...

  Nonlogical symbols are the variables. Their translation is not fixed
    ie A may mean "dss" and then A may mean "ess" in another model. The translation of the nonlogical symbols is not fixed.

  The nonlogical symbols are the sentence symbols.

  There is friction between calling A a sentence or a Proposition
    Some call the current meaning of A a sentence
      And A itself as a proposition

    Enderton calls them Sentence Symbols.

  The set of Sentences may be uncountable

  There may be a universe of discourse

  The symbols are required to be distinct from each other
    ie no two symbols may be the same
    ie no symbol is a finite combination of other symbols

    finite sequences of symbols are Uniquely decomposable
      ie single reading
      If a1,..., am = b1,..., bn
        and each ai and each bj is a symbol,
      then m = n and ai = bi .

  an expression is a finite sequence of symbols
    expressions are specified by concatentating names of symbols

  Hence there is an operation of concatenation on expressions
    expression = symbol | expression

  Simplest expressions are the symbols themselves

  Some expressions are junk
    )))->A

  Logic is concerned with the well-formed Formulas (wffs)
  Defn wff:
    Every sentence symbol is a wff
    If A and B are wffs then so is:
      ( unary connective A )
      ( binary connective A B )
      ( n-nary connective A B C ...  )
    Be constructed from finitely many applications of the above rules

  Expressions build up an expresssion tree
    The leaves are the sentence symbols
    The internal nodes are the connectives

  ie a formula is built up from the sentences with the formula building
    functions defined by the connectives

    E_not_a (a) := (¬ a)
    E_and_ab (a, b) := (a ∧ b)
    ...

    the builder functions themselves are applications of
    the concatenation operation on symbols

    Expressions are closed under the concatenation operation
    Formulas are closed under the formula building functions



  The empty sequence of symbols is not a wff

  Construction sequence := <E_1, E_2, ..., E_n>
    where E_i is an sentence symbol
    or
    the result of a Formula building function
      earlier in the construction sequence

  The construction sequence is a finite sequence of expressions
    The last expression in the sequence is the formula being constructed
    The construction sequence is a linear ordering of the subexpressions of the formula being constructed

  This linear ordering of the construction sequence yields an induction principle

  Defn: Induction Principle for Formulas

    If S is a set of wffs containing all the sentence symbols
    and closed under the formula-building operations,
    then S is the set of all wffs.




    Let P be a property of formulas. If P holds for all sentence symbols, and if P holds for all formulas built from earlier formulas in the construction sequence, then P holds for all formulas.
A sentence symbols may be a formula in another language
-/

opaque SententialConnective : Type

opaque Sentence : Type

opaque LogicalSymbol : Type

opaque NonLogicalSymbol : Type


inductive Arity where
  | zero : Arity
  | succ : Arity → Arity
  deriving Repr, DecidableEq

abbrev nullary := Arity.zero
abbrev unary := Arity.succ Arity.zero
abbrev binary := Arity.succ (Arity.succ Arity.zero)
abbrev ternary := Arity.succ (Arity.succ (Arity.succ Arity.zero))



/-
STUDY HOLD — earlier exploratory syntax definitions are deliberately inactive.
Preserved verbatim for later comparison with definitions developed from
Enderton, Tarski, and accompanying exercises. No new implementation yet.
inductive TruthValue where
  | false : TruthValue
  | true : TruthValue
  deriving Repr, DecidableEq
/-!

The Vocabulary is a formula := propositional variables and connectives that

-/

-- Arity - number of arguments it takes
inductive Arity where
  | nullary : Arity -- connectives with no arguments IE Constants
  | unary : Arity
  | binary : Arity
  | ternary : Arity
  deriving Repr, DecidableEq

structure LogicalSymbol where
  arity : Arity
  name : String
  symbol : String
  deriving Repr, DecidableEq

def Top     : LogicalSymbol := { arity := .nullary, name := "top",     symbol := "⊤" }
def Bot     : LogicalSymbol := { arity := .nullary, name := "bot",     symbol := "⊥" }
def Not     : LogicalSymbol := { arity := .unary,  name := "not",     symbol := "¬" }
def And     : LogicalSymbol := { arity := .binary, name := "and",     symbol := "&&" }
def Or      : LogicalSymbol := { arity := .binary, name := "or",      symbol := "||" }
def Implies : LogicalSymbol := { arity := .binary, name := "implies", symbol := "->" }
def Iff     : LogicalSymbol := { arity := .binary, name := "iff",     symbol := "<->" }

inductive LogicalConnective : Arity → Type where
  | top       : LogicalConnective .nullary
  | bot       : LogicalConnective .nullary
  | not       : LogicalConnective .unary
  | and       : LogicalConnective .binary
  | or        : LogicalConnective .binary
  | implies : LogicalConnective .binary
  | iff     : LogicalConnective .binary
  | custom (s : LogicalSymbol) : LogicalConnective s.arity
  deriving Repr

def LogicalConnective.toSymbol {a : Arity} (c : LogicalConnective a) : LogicalSymbol :=
  match c with
  | .top      => Top
  | .bot      => Bot
  | .not      => Not
  | .and      => And
  | .or       => Or
  | .implies  => Implies
  | .iff      => Iff
  | .custom s => s

structure PropVar where
  name : String
  deriving Repr, DecidableEq

inductive Formula where
  | atom    (v : PropVar) : Formula
  | nullary (c : LogicalConnective .nullary) : Formula
  | unary   (c : LogicalConnective .unary)   (φ : Formula) : Formula
  | binary  (c : LogicalConnective .binary)  (φ ψ : Formula) : Formula
  | ternary (c : LogicalConnective .ternary) (φ ψ χ : Formula) : Formula
  deriving Repr

def phi : Formula := .atom { name := "φ" }
def psi : Formula := .atom { name := "ψ" }
def chi : Formula := .atom { name := "χ" }

def Formula.top : Formula := .nullary .top
def Formula.bot : Formula := .nullary .bot
def Formula.not (φ : Formula) : Formula := .unary .not φ
def Formula.and (φ ψ : Formula) : Formula := .binary .and φ ψ
def Formula.or  (φ ψ : Formula) : Formula := .binary .or φ ψ
def Formula.imp (φ ψ : Formula) : Formula := .binary .implies φ ψ
def Formula.iff (φ ψ : Formula) : Formula := .binary .iff φ ψ

scoped notation (priority := high) "⊤"    => Formula.top
scoped notation (priority := high) "⊥"    => Formula.bot
scoped prefix:40 (priority := high) "¬"   => Formula.not
scoped infixr:35 (priority := high) " ∧ " => Formula.and
scoped infixr:30 (priority := high) " ∨ " => Formula.or
scoped infixr:25 (priority := high) " ⇒ " => Formula.imp
scoped infixr:20 (priority := high) " ⇔ " => Formula.iff














def A : Formula := .atom { name := "A" }
def B : Formula := .atom { name := "B" }
-- Calling Formula.and and Formula.not:
def example3 : Formula :=
  Formula.and (Formula.not A) B

-- Or using Lean's dot-notation on Formulas:
def example4 : Formula :=
  (A.not).and B

def myFormula : Formula := ¬A ∧ B ∧ B ∧ B

#check myFormula
#print myFormula
#eval myFormula





-- Propositional Variable

-- formula
-- proposition
-- unary formula
-- binary formula
-- n-ary formula

-- only fintely many

-- Formal System

-/

end aim.logic
