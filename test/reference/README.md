# Reference values

Published results that the validation tests compare against, with the tolerance and provenance of each value. Tests read the value, unit, tolerance and source from these files; no expected value is written into test code.

## Maintenance

Entries are entered by the project maintainer, from the specs in `docs/specs/` whose validation targets have been checked against the source. A draft may be prepared with tooling outside this directory, for example by reading a published figure; the maintainer checks every entry before entering it. Automated tooling has no write access to this directory, including the Claude Code agent used in this project (see `.claude/settings.json`), and a session hook reports any change made here during an agent session. When a test needs a value that is not listed, the tooling asks the maintainer for it rather than entering one itself.

## Format

One file per source, named `<bibkey>.toml`:

```toml
bibkey = "bibkey"
spec = "docs/specs/bibkey.md"

[[reference]]
id = "short-unique-id"            # tests look the value up by this
quantity = "what is measured"
conditions = "operating point, process step, or the spec's validation-target ID"
value = 0.0                       # SI value of the published result
bound = "lower"                   # optional: the source gives the value only as a minimum
unit = "SI unit, or 1 if dimensionless"
rtol = 0.0                        # relative tolerance, justified in tolerance_basis
atol = 0.0                        # absolute tolerance, if needed
source = "Table n, p. nnn"
obtained = "printed"              # printed | digitised | derived
tolerance_basis = "rounding of the printed value, digitisation accuracy, or expected discretisation error"
```

## Values and tolerances

- A value is entered only after the matching validation target in its spec has been verified against the source.
- A tolerance is set from what is known before the code is run: rounding of the printed value, digitisation accuracy, or the expected discretisation error. It is never tuned to how close the current code gets.
- An entry with `bound = "lower"` is one-sided: the source states the result only as a minimum, such as a constraint its optimiser met. The test asserts `result >= value - atol`. An entry without `bound` is two-sided.
- A digitised value is read from the figure image embedded in the source PDF, and the maintainer checks each reading on an overlay of the original figure before entering it.
- A published value that proves unreproducible keeps its entry. The investigation is recorded under the spec's "Ambiguities and errata", together with an explicit decision on whether the test stays.