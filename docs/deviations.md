# Deviations from cited methods

Every intentional difference between this code and the method it cites, so that results can be described accurately when written up. Append only: to change an entry, add a new one that supersedes it.

| ID | Date | Code location | Cited method | What differs | Why | Expected effect on results | Evidence |
|---|---|---|---|---|---|---|---|
| D001 | 2026-11-27 | not yet implemented (cycle CSS check) | [haghpanah2013, p. 4258] | Haghpanah et al. stop the optimisation runs at "a mass balance error of less than 0.5% for five consecutive cycles" without defining the error. This project defines it as [estupinanperez2019, Eq. (1)] applied to CO2 over one cycle, keeping the 0.5 % / five-cycle threshold; Estupiñan Perez et al. apply Eq. (1) to each species at 1 % (p. 555). | Definition missing in the cited source; CO2 at 0.5 % / five cycles follows [pai2020, p. 4]. See [haghpanah2013, U7]. | Affects only when V7, V8 runs are taken as at CSS, not the model. Expected small if the criterion is tight enough; quantify by continuing a converged run for further cycles and comparing purity, recovery and energy. | none yet |
| D002 | 2026-11-27 | not yet implemented (column energy balance, $\sigma_i$) | [haghpanah2013, Eq. (4), (A.8), SI Table 1] | Haghpanah et al. use the heat of adsorption $\Delta H_i$ but give no value or relation to their $\Delta U_{b,i}$, $\Delta U_{d,i}$. This project uses $\Delta H_i = \Delta U_{b,i} - RT$ at the local $T$, with $\Delta U_{b,i}$ from [haghpanah2013, Table 2], as in [ward2022, SI Eq. (8)]. | Value missing in the cited source; [ward2022] uses this form for the same model, conditions and cycle (p. 13653) and compares its productivity with [haghpanah2013, Table 6] at five operating points (SI pp. 8–9, Figure S1); its energy comparison is a weaker check, since it uses a pressure-dependent vacuum-pump efficiency (Eq. 11). See [haghpanah2013, M1]. | Sets the heat released by adsorption, so it affects temperatures and, through them, every validation target except V1. Site-1-only is exact for N2; for CO2, $\Delta U_b$ and $\Delta U_d$ differ by about 2.6 %. Quantify by repeating V5, V7 with $\Delta U_{d,i}$ in place of $\Delta U_{b,i}$. | none yet |

<!--
Format example (not a real entry):
| D001 | YYYY-MM-DD | src/<file>.jl, `function_name` | [bibkey, Sec. n] | What the source does, and what this code does instead | The reason for the change | Size and direction of the expected difference, and how it is quantified | Test or run ID that measures it |
-->
