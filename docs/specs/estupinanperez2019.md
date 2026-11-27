# estupinanperez2019: Cycle mass balance error and CSS criterion for VSA simulations

Status: verified

## 1. Source
The citation and DOI are authoritative: every reference in this spec resolves against the version of record they identify.

- Citation: L. Estupiñan Perez, P. Sarkar and A. Rajendran, "Experimental validation of multi-objective optimization techniques for design of vacuum swing adsorption processes", Sep. Purif. Technol. 224 (2019) 553–563.
- DOI: 10.1016/j.seppur.2019.05.039
- Supporting information: Supporting Information to 10.1016/j.seppur.2019.05.039. Five pages (S1–S5): Figure S1, CO2 isotherms from volumetric and gravimetric measurements; Table S1, equations for modelling adsorption column dynamics, Eqs. (S1)–(S6) and following; Figure S2, decision variables for the basic 4-step and LPP cycle optimisation. None of it is in scope.
- Local copies (not in git; `docs/papers/` is ignored): `docs/papers/Estupiñan Perez et al. - 2019 - Experimental validation of multi-objective optimization techniques for design of VSA (Paper).pdf` (11 PDF pages) and `docs/papers/Estupiñan Perez et al. - 2019 - Experimental validation of multi-objective optimization techniques for design of VSA  (SI).pdf` (5 pages).

Page references use the journal's page numbers (553–563). In the local copy, p. 553 is PDF page 1.

## 2. Scope
Only what [haghpanah2013] needs and does not define: the cycle mass balance error, Eq. (1), and the CSS criterion stated with it (Sec. 3, p. 555). It supplies the definition for the CSS criterion of the Table 6 runs in [haghpanah2013, p. 4258]; see [haghpanah2013, U7].

Not covered: everything else in the paper and SI, including the isotherm measurements, the DCB experiments, the column model (SI Table S1), the parameters of Table 1, the cycles and their optimisation, and the experiments A–F.

## 3. Nomenclature
Each meaning is sourced by the first of these that applies: (1) the paper's Nomenclature section: its wording, verbatim, with no citation; (2) an equation, table or figure number where the symbol is defined or printed, e.g. (Eq. n), (Table n), (Figure n), (SI Table n); (3) a page number, (p. n) or (SI p. n), only when no equation, table or figure applies. Wording taken from outside the Nomenclature is quoted exactly. A per-component form the equations use is noted, e.g. used per component as $k_i$ in Eqs. (n), (m). Wording from two places is never merged into one uncited meaning, and explanatory words added by the spec are labelled "spec wording:". "SI unit" is the unit the code uses. Where the paper's unit differs, both are noted.

None of the symbols below is in the paper's Nomenclature.

| Symbol | Meaning | SI unit | Code name | Verified |
|---|---|---|---|---|
| mass balance error | defined by Eq. (1); "the mass balance error for each species" (p. 555) | % | `mass_balance_error` |  DM 27/11/26|
| $\text{mass}_{in}$ | "the total amount of mass entering ... the process within one cycle" (Eq. 1) | mol per species; see A1 | `mass_in` |  DM 27/11/26|
| $\text{mass}_{out}$ | "the total amount of mass ... leaving the process within one cycle" (Eq. 1) | mol per species; see A1 | `mass_out` |  DM 27/11/26|

## 4. Assumptions
None in scope. The model assumptions (p. 555) concern the column model, which is not covered.

## 5. Governing equations
None in scope.

## 6. Constitutive relations and correlations
None in scope.

## 7. Boundary and initial conditions
None in scope.

## 8. Parameters
None in scope. The CSS thresholds are in Section 9.1.

## 9. Numerical method used in the source

### 9.1 Cyclic steady state criterion
- Page: 555
- Verified: DM 27/11/26

- "The simulations were run for a minimum of 80 cycles after which the CSS mass balance criterion was checked." (p. 555)
- "The cycle was deemed to have reached cyclic steady state (CSS) if the mass balance error for each species was below 1% for 5 consecutive cycles." (p. 555)
- "For the system described in this work, the number of cycles required to reach CSS varied between 80 and 150 cycles." (p. 555)

## 10. Reported quantities and their definitions

### 10.1 Balance errors

| Quantity | Definition | Eq. | Page | Verified |
|---|---|---|---|---|
| "mass balance error" (p. 555) | $\text{mass balance error} = \dfrac{\lvert \text{mass}_{in} - \text{mass}_{out} \rvert}{\text{mass}_{in}} * 100$, "where mass in and massout are the total amount of mass entering and leaving the process within one cycle" | (1) | 555 |  DM 27/11/26|

Notes: printed with "$*\,100$" for the multiplication. Basis of $\text{mass}_{in}$, $\text{mass}_{out}$: see A1.

## 11. Validation targets
None in scope.

## 12. Ambiguities and errata
IDs by type. E, erratum: a printed item that cannot be right as printed. A, ambiguity: two places in the paper disagree, so more than one reading is possible. U, unstated: a detail the model needs is not stated. M, missing: a value, definition or reference is not given.

### 12.1 Errata (E)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|

### 12.2 Ambiguities (A)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| A1 | Basis and unit of $\text{mass}_{in}$, $\text{mass}_{out}$ in Eq. (1), p. 555 | Eq. (1) defines them as "the total amount of mass entering and leaving the process within one cycle" (p. 555), while the criterion that follows applies the error "for each species" (p. 555), and for the experiments the error is "described as the difference between the total inlet and outlet moles of a certain component within a cycle" (p. 560). So "total" may mean summed over the cycle (per species) or summed over species, and the amount may be in mass or in moles. For one species the ratio in Eq. (1) is the same in kg and in mol, since the molar mass cancels; mass and moles differ only for a total over species. | (a) per species, total over all streams in one cycle, in moles (equivalently mass); (b) total over species, in mass | (a): $\text{mass}_{in}$ and $\text{mass}_{out}$ are the amounts of one species, summed over all streams entering or leaving in one cycle, in mol. "For each species" (p. 555) and "total inlet and outlet moles of a certain component within a cycle" (p. 560) both use "total" for the sum over the cycle of one component; for one species the ratio is the same in kg and in mol. |  DM 27/11/26|

### 12.3 Unstated (U)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| U1 | Streams counted in $\text{mass}_{in}$, $\text{mass}_{out}$ (p. 555) | "entering and leaving the process within one cycle" (p. 555) does not list the streams. For a single-column cycle with no internal transfer (e.g. the basic 4-step cycle) every feed and product stream crosses the process boundary. For the LPP cycle, simulated with "a one-bed approach" and "a data buffer" (p. 555), it is not stated whether the light product used for pressurisation is counted. | single-column cycle: all feed in, all products out; LPP cycle: open | Single-column cycle: $\text{mass}_{in}$ is all feed entering the column and $\text{mass}_{out}$ all product leaving it in one cycle, since every stream crosses the process boundary. The LPP cycle is not in scope, so whether its internal light-product stream counts is left open. |  DM 27/11/26|

### 12.4 Missing (M)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
