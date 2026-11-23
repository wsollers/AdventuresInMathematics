import Lake

open Lake DSL

package AimMathlibValidation

require AdventuresInMathematics from "../.."
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.32.1"

@[default_target]
lean_lib AimMathlibValidation
