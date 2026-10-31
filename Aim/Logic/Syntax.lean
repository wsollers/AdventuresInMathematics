/-
Copyright (c) 2026 William Sollers. All rights reserved.
-/
import Aim.Common.Common

/-!
# Sentential and First-Order Syntax

Variables (`A, B, C`), logical connectives, formula syntax trees, and string parsing (`"A AND B"`).
-/

namespace aim.logic

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
