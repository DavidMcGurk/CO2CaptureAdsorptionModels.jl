# <bibkey>: <short title>

Status: draft

<!-- Status is draft, partly verified or verified, and is set by the user. "Verified" cells hold the user's initials and date; Claude leaves them empty. -->

<!-- Number subsections n.1, n.2, ... in every section that has more than one table or larger block: one per equation, process step, source table or group of related rows. Every subsection has a place for the user's sign-off: a Verified column in its table, or a "- Verified:" line under its heading. -->

## 1. Source
The citation and DOI are authoritative: every reference in this spec resolves against the version of record they identify.

- Citation:
- DOI:
- Supporting information: Supporting Information to <DOI>, with a short description of its content (pages, tables, figures).
- Local copies (not in git; `docs/papers/` is ignored): `docs/papers/<file>.pdf`

Page references use the journal's page numbers, not PDF page numbers, so they hold for any copy of the version of record.

## 2. Scope
What this spec covers, and what in the paper it deliberately leaves out.

## 3. Nomenclature
Each meaning is sourced by the first of these that applies: (1) the paper's Nomenclature section: its wording, verbatim, with no citation; (2) an equation, table or figure number where the symbol is defined or printed, e.g. (Eq. n), (Table n), (Figure n), (SI Table n); (3) a page number, (p. n) or (SI p. n), only when no equation, table or figure applies. Wording taken from outside the Nomenclature is quoted exactly. A per-component form the equations use is noted, e.g. used per component as $k_i$ in Eqs. (n), (m). Wording from two places is never merged into one uncited meaning, and explanatory words added by the spec are labelled "spec wording:". "SI unit" is the unit the code uses. Where the paper's unit differs, both are noted.

| Symbol | Meaning | SI unit | Code name | Verified |
|---|---|---|---|---|

## 4. Assumptions

| # | Assumption | Page | Verified |
|---|---|---|---|

## 5. Governing equations
One numbered subsection per equation, using the paper's own equation number.

### 5.1 Eq. (n): <name>
- Page:
- Verified:

$$
$$

Notes: meaning of each term, sign conventions, anything easy to misread. No units or dimension checks here: units are in the nomenclature, and inconsistencies in section 12.

## 6. Constitutive relations and correlations
Isotherms, kinetics, transport correlations, equations of state. Same format as section 5, numbered 6.1, 6.2, ...

## 7. Boundary and initial conditions
One numbered subsection and table per process step. Where the paper gives the same condition in dimensionless and dimensional form, write the dimensionless one and cite both, e.g. (8); (A.10).

### 7.1 Step: <name>

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|

## 8. Parameters
One numbered subsection per source table, then derived values, then values not given.

### 8.1 Table n: <title>

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|

### 8.n Derived values
Not printed in the paper; each is computed from printed values by the formula given (spec wording). The numerical values are computed in code, not copied here.

| Symbol | Description | Formula | Inputs | SI unit | Verified |
|---|---|---|---|---|---|

### 8.n Not given in the paper
Each row cites its open item in section 12.

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|

## 9. Numerical method used in the source
Discretisation, grid, time integration, tolerances, convergence or cyclic-steady-state criterion, in numbered subsections. For information only: this project's own choices, where different, are logged in `docs/deviations.md`.

### 9.1 <topic>
- Verified:

## 10. Reported quantities and their definitions
One numbered subsection and table per group of related quantities (e.g. balance errors, process performance, energy).

### 10.1 <group>

| Quantity | Definition | Eq. | Page | Verified |
|---|---|---|---|---|

## 11. Validation targets
Results in the source that this project can reproduce. Once a row is verified, the user copies it into `test/reference/<bibkey>.toml` with a tolerance. One numbered subsection and table per case (e.g. breakthrough, cycle).

### 11.1 <case>

| ID | Figure or Table | Operating conditions | Quantity | Value | Printed or digitised | Page | Verified |
|---|---|---|---|---|---|---|---|

## 12. Ambiguities and errata
IDs by type. E, erratum: a printed item that cannot be right as printed. A, ambiguity: two places in the paper disagree, so more than one reading is possible. U, unstated: a detail the model needs is not stated. M, missing: a value, definition or reference is not given. Where the spec covers more than one case, a case name at the start of an Item (e.g. "DCB:", "Cycle:") marks an item that affects only that case.

### 12.1 Errata (E)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|

### 12.2 Ambiguities (A)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|

### 12.3 Unstated (U)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|

### 12.4 Missing (M)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
