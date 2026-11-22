# Calculus reference flashcards

285 atomic cards in 13 independent topics: angles; trigonometric definitions,
identities and calculus; hyperbolic definitions and calculus; coordinate systems;
exponential/logarithmic definitions and calculus; general calculus rules; algebra;
limits and series; complex exponentials.

Every angle conversion has a separate reverse card. Coordinate conversions are
split by direction and by output coordinate. Spherical coordinates use theta for
azimuth and phi for the angle down from the positive z-axis. Derivatives and
trigonometric limits use radians. Antiderivatives include the integration constant.

The app loads these topics alongside Foundations, with all calculus topics
available immediately. Existing Foundations card IDs, progress storage and
manual unlocks are unchanged. These cards do not claim formal Lean verification.

Edit `generate.py`, then run `python flashcards/content/calculus/generate.py`
from the repository root. Generated JSON is checked in for review and deployment.
Run `node --test flashcards/web/tests/*.test.mjs` for content, rendering and app
checks (requires KaTeX 0.16.22 and jsdom; KATEX_PATH and JSDOM_PATH can select local
installations).
