# <bibkey>: <short title>

Status: draft

<!-- Status is draft, partly verified or verified, and is set by the user. "Verified" cells hold the user's initials and date; Claude leaves them empty. -->

## 1. Source
- Citation:
- DOI:
- PDF: `docs/papers/<file>.pdf`
- Supporting information:

## 2. Scope
What this spec covers, and what in the paper it deliberately leaves out.

## 3. Nomenclature

| Symbol | Meaning | SI unit | Code name | Verified |
|---|---|---|---|---|

## 4. Assumptions

| # | Assumption | Page | Verified |
|---|---|---|---|

## 5. Governing equations
One subsection per equation, using the paper's own number.

### Eq. (n): <name>
- Page:
- Verified:

$$
$$

Notes: meaning of each term, sign conventions, anything easy to misread.

## 6. Constitutive relations and correlations
Isotherms, kinetics, transport correlations, equations of state. Same format as section 5.

## 7. Boundary and initial conditions
One table per process step.

### Step: <name>

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|

## 8. Parameters

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|

## 9. Numerical method used in the source
Discretisation, grid, time integration, tolerances, convergence or cyclic-steady-state criterion. For information only: this project's own choices, where different, are logged in `docs/deviations.md`.

## 10. Reported quantities and their definitions

| Quantity | Definition | Eq. | Page | Verified |
|---|---|---|---|---|

## 11. Validation targets
Results in the source that this project can reproduce. Once a row is verified, the user copies it into `test/reference/<bibkey>.toml` with a tolerance.

| ID | Figure or Table | Operating conditions | Quantity | Value | Printed or digitised | Page | Verified |
|---|---|---|---|---|---|---|---|

## 12. Ambiguities and errata

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|

## 13. Verification log

| Date | Who | What was checked |
|---|---|---|
