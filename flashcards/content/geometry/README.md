# Geometry and computational vectors

239 cards across 15 topics, authored in `generate.py`. Regenerate from the repo
root with `python flashcards/content/geometry/generate.py`, then regenerate
navigation with `python flashcards/content/build_curriculum.py`.

The content covers Euclidean geometry, analytic geometry, and computational
vectors. It assumes standard Euclidean geometry and orthonormal Cartesian
coordinates. Vector-space theory and calculus are deliberately out of scope.
Definitions state conventions where textbooks differ (isosceles and trapezoid).
Distance and angle formulas specify nonzero directions and degeneracy conditions.
Cards are reference material, not assertions of verified Lean proofs.

The navigation taxonomy in `../curriculum.json` assigns each card once, separately
from the original card IDs and unlock dependencies. Existing records therefore
need no migration. Empty future calculus topics remain navigable with a clear
“No cards yet” state. Every new topic is initially available for scheduled review.

The app includes project-owned SVG illustrations for radius, diameter, chord,
secant, and tangent cards. All formulas are checked by the pinned KaTeX renderer.
