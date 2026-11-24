# Method specs

One file per cited paper or method. A spec is this project's transcription of what its source states: equations, parameters, boundary conditions, metric definitions and reported results. Code and tests are written from the spec, and code review checks the code against it.

## Lifecycle
1. **Draft.** A draft `<bibkey>.md` is prepared from the source PDF, starting from `_TEMPLATE.md`. Drafts are produced with the Claude Code agent used in this project (`/draft-spec <bibkey>`), and nothing in a draft is relied on until it has been verified.
2. **Verify.** The maintainer checks each item against the source and records initials and date in its "Verified" cell. Only the maintainer fills these cells.
3. **Implement.** Code relies only on verified items, whether it is written by hand or with the agent (`/implement-from-spec`).
4. **Amend.** Where the source proves ambiguous or wrong, the issue is recorded under "Ambiguities and errata", together with how it was resolved and the evidence for the resolution.

## Conventions
- The file name is the citation key used in the thesis and paper bibliographies, so `Ref: [bibkey, Eq. n]` in code resolves to both the spec and the reference list.
- Equation numbers and symbols follow the source. The nomenclature table maps each symbol to its SI unit and to its name in code.
- Values are recorded as printed and in SI. Code uses the SI value.
- The "numerical method" section describes what the source did. Where this project does something different, the departure is logged in `docs/deviations.md`.
- A spec describes one source. A method that combines several papers has one spec per paper, with cross-references between them.
- Protocols count as methods: for a baseline being replicated, the spec records its inputs, tuning, disturbances and metrics.
