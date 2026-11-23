# Set Interfaces

The project's set terminology is based on Herbert B. Enderton's *Elements of Set
Theory*. Typed sets support ordinary mathematics independently of later
foundational set constructions.

The set layer has these components:

- **Set** — a typed collection of elements represented by a predicate.
- **Class** — the objects satisfying a property; in a foundational universe, a
  class may be represented by a set or may be proper.
- **Collection** — an unindexed set of typed sets.
- **Family** — an indexed assignment of typed sets.

Universe concepts are deferred until the project needs an explicit ambient-set
or foundational-universe abstraction.
