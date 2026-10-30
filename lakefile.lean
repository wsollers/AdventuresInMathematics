import Lake
open Lake DSL

package AdventuresInMathematics where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

@[default_target]
lean_lib AdventuresInMathematics where
  roots := #[`AdventuresInMathematics]
