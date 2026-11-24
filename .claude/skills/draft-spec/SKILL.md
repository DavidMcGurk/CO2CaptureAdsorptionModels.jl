---
name: draft-spec
description: Draft or extend a method spec in docs/specs/ from a paper PDF, for the user to verify by hand. Use when asked to create, draft or update a spec for a cited paper, model or method.
argument-hint: "[bibkey] [path to PDF]"
---

Draft a spec for: $ARGUMENTS

A spec is this project's transcription of a published method. Code is written from the spec, so a transcription error here becomes a wrong result everywhere downstream. Your job is an accurate draft that makes the user's verification fast. The user, not you, decides what is verified.

1. Read the whole paper and any supporting information, in page ranges if it is long. If no PDF path was given, look in `docs/papers/`. If it is not there, ask.
2. Copy `docs/specs/_TEMPLATE.md` to `docs/specs/<bibkey>.md` and fill every section.
3. Transcribe; do not paraphrase or tidy:
   - equations in LaTeX, with the paper's own numbers and the page they are on;
   - parameters exactly as printed (value and unit), then the SI value with the conversion shown;
   - boundary and initial conditions for every process step;
   - the definition of every reported metric.
4. Check each equation for dimensional consistency using the nomenclature units. Record any inconsistency under "Ambiguities and errata". Do not silently fix it.
5. Where the PDF is unclear (a subscript, a sign, a unit, a symbol used with two meanings), write `UNCLEAR` with the page and the candidate readings. Do not choose one.
6. Use only this paper and its supporting information. If the paper defers to another reference for an equation or value, record that reference and leave the item open. Do not fill it from memory or from another source.
7. List validation targets: each figure or table this project could reproduce, with its operating conditions and whether the values are printed or would need digitising.
8. Leave every "Verified" cell empty and the status as `draft`. Never fill them, including when asked to finish or tidy a spec.
9. End with a short list for the user: items marked UNCLEAR, dimensional inconsistencies, values taken from supporting information, and anything you could not find.

Edits under `docs/specs/` prompt the user for approval. That is intended.
