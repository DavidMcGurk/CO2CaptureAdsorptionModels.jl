---
name: draft-spec
description: Draft or extend a method spec in docs/specs/ from a paper PDF, for the user to verify by hand. Use when asked to create, draft or update a spec for a cited paper, model or method.
argument-hint: "[bibkey] [path to PDF]"
---

Draft a spec for: $ARGUMENTS

A spec is this project's transcription of a published method. Code is written from the spec, so a transcription error here becomes a wrong result everywhere downstream. Your job is an accurate draft that makes the user's verification fast. The user, not you, decides what is verified.

1. Read the whole paper and any supporting information, in page ranges if it is long. If no PDF path was given, look in `docs/papers/`. If it is not there, ask.
2. Copy `docs/specs/_TEMPLATE.md` to `docs/specs/<bibkey>.md` and fill every section, with numbered subsections as the template shows. Each item goes in one place only: cross-reference it rather than repeat it. Classify every entry in "Ambiguities and errata" by the template's E/A/U/M legend.
3. Transcribe; do not paraphrase or tidy:
   - equations in LaTeX, with the paper's own numbers and the page they are on;
   - parameters exactly as printed (value and unit), then the SI value with the conversion shown;
   - boundary and initial conditions for every process step;
   - the definition of every reported metric;
   - nomenclature rows: cite the source of each meaning by the first of these that applies: (1) the paper's Nomenclature section: its wording, verbatim, with no citation and no "Nomenclature" marker; (2) an equation, table or figure number where the symbol is defined or printed, e.g. (Eq. 42), (Table 3), (Figure 1), (SI Table 1); (3) a page number, (p. n) or (SI p. n), only when no equation, table or figure applies. Wording taken from outside the Nomenclature is quoted exactly. Note a per-component form the equations use, e.g. used per component as $k_i$ in Eqs. (A.4), (40). Never merge wording from two places into one uncited meaning, and label any explanatory words of your own "spec wording:". State this rule in the header of the spec's nomenclature section.
4. Check each equation for dimensional consistency using the nomenclature units. Record any inconsistency under "Ambiguities and errata", listing there every equation that is evidence for it. Do not silently fix it. Keep units and dimension checks out of equation notes: units belong in the nomenclature, and inconsistencies in "Ambiguities and errata".
5. Where the PDF is unclear (a subscript, a sign, a unit, a symbol used with two meanings), write `UNCLEAR` with the page and the candidate readings. Do not choose one.
6. Use only this paper and its supporting information. If the paper defers to another reference for an equation or value, record that reference and leave the item open. Do not fill it from memory or from another source.
7. List validation targets: each figure or table this project could reproduce, with its operating conditions and whether the values are printed or would need digitising.
8. Leave every "Verified" cell empty and the status as `draft`. Never fill them, including when asked to finish or tidy a spec.
9. End with a short list for the user: items marked UNCLEAR, dimensional inconsistencies, values taken from supporting information, and anything you could not find.

Edits under `docs/specs/` prompt the user for approval. That is intended.
