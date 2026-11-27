# Conformance: haghpanah2013 against Mocca.jl

Status: draft

<!-- Status is draft, partly verified or verified, and is set by the user. "Verified" cells hold the user's initials and date; Claude leaves them empty. -->

## 1. Purpose and basis

Maps each item of the verified spec `docs/specs/haghpanah2013.md` to the Mocca.jl source that would implement it, and states whether Mocca matches it. Upstream code carries no `Ref:` tags and the `spec-verifier` agent does not check it, so this table is the check.

- Mocca.jl at commit 27b7e6d (`Manifest.toml`, `[sources]` in `Project.toml`), installed at `~/.julia/packages/Mocca/9V8b5/`. Paths below are relative to its `src/`.
- Jutul 0.5.2, as resolved in `Manifest.toml`.
- Read from source on 2026-11-27; nothing was run.

Status values:
- **match**: Mocca implements the spec item as written, possibly in an equivalent form.
- **match (configure)**: matches when this package sets the stated input; Mocca's default or library value differs.
- **differs**: Mocca does something else. The proposed deviation is logged in `docs/deviations.md` in the change that first relies on it.
- **not in Mocca**: computed in this package from Mocca's outputs.
- **not via public API**: matching would need code outside Mocca's public API or extension points; a decision for the user.

## 2. Column model

| Spec item | Mocca | Status | Notes | Verified |
|---|---|---|---|---|
| Component mass balance, Eq. (1), (A.2) (Sec. 5.1, 5.9) | `balances/gas.jl`: `face_flux!` and `update_equation_in_entity!` for `ComponentMasses`; per-cell moles $c_i V_f$, Darcy advection with upwinded $c_i/\mu$, Fickian dispersion $-\bar c\,D_L\,\Delta y_i$ with $\bar c$ the face mean of total concentration, sorption as a source | match | Same PDE in conservative form in $c_i$, against the paper's $y_i$–$\bar P$–$\bar T$ form; the difference is in the discretisation (Sec. 5). Gas volume $V_f = \varepsilon V$ (`balances/sorbent_bed.jl`, `setup_process_parameters`), as the paper: no macropore gas. | |
| Total mass balance, Eq. (2), (A.3) | Sum of the component balances; pressure from the equation of state | match | No separate total balance; equivalent for the same PDE. | |
| Solid-phase balance, Eq. (3), (A.4) | `balances/sorbent.jl`: $V_s\,\partial q_i/\partial t = V_s\,k_i(q_i^* - q_i)$ | match | | |
| Loading basis, E1 | $V_s = (1-\varepsilon)V$ (`setup_process_parameters`); isotherm capacities in mol per m³ adsorbent (`physics/isotherms/dual_site_langmuir.jl`) | match (configure) | E1 (a): this package passes $q_{sb,i}$, $q_{sd,i}$ as $\rho_s \times$ Table 2. | |
| Column energy balance, Eq. (4), (A.8) | `balances/energy.jl`: $C_{eff}\,\partial T/\partial t + (C_{pg}/R)(V_f\,\partial P/\partial t + \nabla\cdot(vP)) - \nabla\cdot(K\nabla T) - \text{sources}$; $C_{eff} = V_s(\rho_s C_{ps} + C_{pa}\sum_i q_i)$ (`balances/sorbent.jl`, `SolidHeatCapacity`, `AdsorbedPhaseHeatCapacity`); heat of sorption $V_s\sum_i (C_{pg}T + \Delta h_i + \Delta H_i)\,\partial q_i/\partial t$ (`HeatOfSorption`); wall exchange $A_{in}h_{in}(T - T_w)$ (`balances/wall.jl`) | match | Equals (A.8) multiplied by $\varepsilon V$ with $V_s = (1-\varepsilon)V$. $\Delta h_i = (c_{pa,i} - c_{pg,i})T = 0$ for $C_{pa} = C_{pg}$, so the sensible term is $C_{pa}T$ as in (A.8). $K$ per bed volume equals $K_z$. $\Delta H_i$: see Sec. 3. | |
| Wall energy balance, Eq. (5) | `balances/wall.jl`: $V_w\rho_w C_{pw}\,\partial T_w/\partial t = A_w\nabla\cdot(K_w\nabla T_w)/\Delta x + A_{in}h_{in}(T - T_w) - A_{out}h_{out}(T_w - T_a)$ | match | | |
| Pressure drop, Eq. (6), (7) (Sec. 5.6, 5.7) | Darcy through `Transmissibilities` from permeability $k = \frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2 r_p^2\,\varepsilon$ (`fixedbeds/correlations.jl`, `compute_permeability`) | match | Superficial velocity $u = \varepsilon v$, so $k$ carries the extra $\varepsilon$ of the paper's interstitial form. | |
| Ideal gas, Eq. (54) (Sec. 6.8) | `molar_concentration` of the gas thermodynamics; $R$ = 8.3144598 J mol⁻¹ K⁻¹ (`framework/types.jl`, `GAS_CONSTANT`) | differs | Paper $R$ = 8.314 (Table 3): relative difference about $5\times10^{-5}$. Proposed deviation: negligible, record only. | |
| Heat capacities $C_{p,g}$, $C_{p,a}$ (Table 3) | `IdealGasConstantCp` from heat capacities per mass | match (configure) | This package passes $30.7/M_i$ J kg⁻¹ K⁻¹ for each component, so both molar heat capacities are 30.7 J mol⁻¹ K⁻¹ for any composition. | |

## 3. Constitutive relations

| Spec item | Mocca | Status | Notes | Verified |
|---|---|---|---|---|
| Dual-site Langmuir, Eqs. (37)–(39) | `physics/isotherms/dual_site_langmuir.jl`, `compute_equilibrium` | match | Same form, concentration basis, $b_i = b_{0,i}e^{-\Delta U_{b,i}/RT}$, $d_i$ likewise. | |
| LDF coefficient, Eq. (40), U2 | `physics/mass_transfer/ldf.jl`: $k_i = (C_i/q_i^*)\,15\varepsilon_p D_p/r_p^2$, local per cell and time; $C_i/q_i^*$ set to 0 where $q_i^* = 0$ (`_capacity_ratio`) | differs | Local, as U2 (a). Where $C_i = 0$ Mocca gives $k_i = 0$; U2's divided form gives the inverse Henry constant. Differs only at exactly zero gas concentration with nonzero loading. Matching it needs a mass transfer model of this package through the extension point `compute_mass_transfer_rate`. | |
| Macropore diffusivity, Eq. (41) | $D_p = D_m/\tau'$ in `ldf.jl`; `ConstantTransport` by default, so $D_m$ is not scaled with the state | match | | |
| Axial dispersion, Eq. (42) | `0.7 D_m + 0.5 v d_p` at `dispersion_velocity` (`interface/builder.jl`) | match (configure) | With `dispersion_velocity = :adsorption`, $v = v_{feed} = v_0$. | |
| Heat of adsorption $\Delta H_i$, M1, D002 | `DualSiteLangmuir` constructor: constant per component, $\Delta H_i = [q_{sb,i}(\Delta U_{b,i} - RT_0) + q_{sd,i}(\Delta U_{d,i} - RT_0)]/(q_{sb,i} + q_{sd,i})$ with $T_0$ = 298.15 K; `compute_enthalpy` returns it | differs | D002 uses $\Delta U_{b,i} - RT$, site 1 only, at the local $T$. Mocca weights both sites by capacity and fixes $T$ at 298.15 K. For N2 the two agree at 298.15 K ($q_{sd,N_2} = 0$). Matching D002 needs an isotherm of this package through the extension point `compute_enthalpy`; a constant $\Delta U_{b,i} - RT_0$ could be passed by constructing `DualSiteLangmuir` with its fields, but not the temperature dependence. | |

## 4. Boundary and initial conditions

| Spec item | Mocca | Status | Notes | Verified |
|---|---|---|---|---|
| Inlet composition, Eq. (8), (A.10) | Feed device stream enters the end cell with the upstream (feed) composition; no dispersion across the end (`networks/ports.jl`, `StreamCT`) | match | Conservative form of the Danckwerts condition: the total inflow of component $i$ is $F\,y_{i,feed}$. The face value $y_{i,0.5}$ of SI Table 2 is not formed. | |
| Inlet temperature, Eq. (10), (A.12), U1, A2 | The stream brings the feed enthalpy into the end cell; no conduction across the end (`networks/ports.jl`, `_stream_molar_enthalpy`) | match | Conservative form of (A.12): inflowing enthalpy $F\,C_{pg}T_{feed}$ with $F$ the molar inflow. No $Pe_h$ appears. The inflow density is that of the feed device: bed-side pressure and $T_{feed}$ (`VolumetricFlow`), against $\rho_{g,0.5}$ at $\bar T_{0.5}$ in U1. | |
| Outlet zero gradients, Eqs. (9), (11), (A.11), (A.13) | No dispersion or conduction across a bed end | match | | |
| Wall ends, Eq. (12), (A.14), (A.15) | `WallEndConduction`: half-cell conduction from the end wall cells to $T_a$ | match | | |
| Closed end, $\bar v = 0$ | Device law `Closed` | match | | |
| Face velocity and pressure at open ends, Eqs. (34)–(36), half-cell, Eq. (32) | `LinearValve` with `default_conductance` = half-cell conductance $kA/(\Delta x/2)/\mu$ (`interface/builder.jl`, `networks/ports.jl`, `port_conductance`) between the end-cell pressure and the boundary pressure | match | Places the boundary pressure at the column face, as the paper's half-cell approximation. Molar flow at the upstream concentration of the valve. Conductance at the feed viscosity; equal to the half cell for `ConstantTransport`. | |
| Pressure ramps, Eqs. (57)–(59) | `ExponentialRamp` (`devices/device.jl`): $p_1 + (p_0 - p_1)e^{-\lambda t}$ per step, from the nominal end pressure of the step before (`interface/steps.jl`, `start_pressure`, `_compile_sequence`) | match (configure) | $\lambda$ = `ramp_rate` = 0.5 s⁻¹; time from the start of each step. | |
| Adsorption step, $\bar v\vert_{Z=0} = 1$, $\bar P\vert_{Z=1} = 1$ | `Adsorb`: `VolumetricFlow` $\varepsilon A v_{feed}$ (interstitial `velocity`), molar flow at the bed-side pressure and feed temperature; product valve to $P_H$ | match (configure) | Inflow density at $T_{feed}$, against $\bar T_{0.5}$ in the paper; small, since $\bar T_{0.5} \approx \bar T_{feed}$ (A2). | |
| DCB initial state, U3; cycle initial state, U5 | `setup_unit_state`: given $P$, $T$, $y$; loading at equilibrium; wall temperature equal to $T$ by default (`balances/sorbent_bed.jl`) | match (configure) | | |
| DCB, adiabatic column ($h_{in} = h_{out} = 0$, Sec. 5) | Thermal model `Adiabatic` (`framework`) | match (configure) | Not read in detail. | |

## 5. Numerical method

| Spec item | Mocca | Status | Notes | Verified |
|---|---|---|---|---|
| Finite volume, cell averages, Eq. (19) | Jutul finite volume on a 1-D `CartesianMesh` of square cross-section with the column area (`balances/sorbent_bed.jl`, `column_mesh`) | match | | |
| Face reconstruction, WENO, Eqs. (30)–(31), U4 | Two-point flux with single-point upwinding (`Jutul.upwind` with `SPU`), i.e. UDS, Eq. (25); fixed in `framework/types.jl`, `Jutul.discretize_domain(…, ::Val{:default})`, which builds `Jutul.PotentialFlow` | differs; not via public API | First order in space. Jutul has a general WENO module (`Jutul/src/WENO/WENO.jl`), not Eqs. (30)–(31); using it would need a new `discretize_domain` method for Mocca's types, i.e. code outside the public API. U4 does not arise with Mocca's discretisation. Proposed deviation: UDS in place of WENO, with grid refinement to bound the error. | |
| Time integration, Sec. 9.4 | Jutul fully implicit backward Euler with Newton, adaptive steps (the library process uses `max_dt` = 1 s, `first_dt` = 0.05 s) | differs | Paper: MATLAB `ode23s`. Proposed deviation, with time-step refinement in the validation tier. | |
| Number of cells $N$ | `ncells` of the bed | match (configure) | V2–V6 use $N$ = 2000 (DCB) and 1000 (cycle) with WENO; with UDS, $N$ is set by refinement instead. | |

## 6. Reported quantities

This package owns the metrics (`docs/setup-todo.md`, decision of 2026-11-24) and computes them from Mocca's device streams. Mocca's own definitions are listed for comparison.

| Spec item | Mocca | Status | Notes | Verified |
|---|---|---|---|---|
| Moles in and out, Eqs. (62)–(64), E3, E4, M3 | `operation/metrics.jl`, `stream_totals`: $\sum_k F_k y_k \Delta t_k$ at a device, backward flow negative, composition of the upstream port | match | Amounts in mol (E3); net flow (E4 (b)); N2 as for CO2 (M3). | |
| Purity, recovery, Eqs. (60), (61) | `purity`, `recovery` from the extract and feed device totals | match | | |
| Step energies, Eqs. (66)–(69), E5, U8 | `vacuum_pump_energy`, `compressor_energy`: $F R T_{in}\frac{\gamma}{\gamma-1}[(P_2/P_1)^{(\gamma-1)/\gamma} - 1]/\eta$, counted per time step only for forward flow and a pressure below (pump) or above (compressor) ambient | not in Mocca | Pointwise zero branches as E5 (a), U8 (a). Eq. (67) prints no zero branch for adsorption; Mocca's compressor counts only above ambient. This package computes Eqs. (66)–(69) as resolved. | |
| Specific energy, Eq. (70), M4 | `specific_energy_kwh_per_tonne` with the gas molar mass (library: 0.04401 kg mol⁻¹) | not in Mocca | This package uses $M_{CO_2}$ of M4. | |
| Productivity, Eq. (71), M5, U9 | `productivity` per adsorbent volume $\sum V_s = (1-\varepsilon)V$ | not in Mocca | M5 (a) is per bed volume $\pi r_{in}^2 L$: Mocca's value is larger by $1/(1-\varepsilon)$. This package computes M5 (a). | |
| Energy penalty, Eq. (72), M6 | none | not in Mocca | | |
| CSS for V7, V8, U7, D001 | `operation/css.jl`, `simulate_until_mass_balance`: relative CO2 balance error between inflow and outflow devices below `tol` for `consecutive` cycles after `min_cycles` (defaults 0.005, 5, 50) | match (configure) | Matches D001 with `component` = CO2. `min_cycles` has no counterpart in the paper. Mocca's default `cyclic_steady_state` instead uses Newton's method on the cycle map, a stricter test. | |
| CSS for V5, V6 (500 cycles), U7 | not checked | — | Whether Mocca runs a fixed number of cycles through its public API is not yet checked. | |

## 7. Mocca's library process `haghpanah_2013_four_stage_vsa`

`models/library/processes/haghpanah_2013_four_stage_vsa.json`, read through `read_process`. Values that differ from the spec; this package builds the process from the spec instead.

| Item | Library | Spec | Notes | Verified |
|---|---|---|---|---|
| $K_z$ | 0.0903 W m⁻¹ K⁻¹ | 0.09 (Table 3) | | |
| $q_{sb,CO_2}$, $q_{sd,CO_2}$, $q_{sb,N_2}$ | 3489.44, 2872.35, 6613.551 mol m⁻³ | $1130 \times$ (3.09, 2.54, 5.84) mol kg⁻¹ (Table 2, Table 3, E1) | Ratios to 1130 × Table 2: 0.99935, 1.00075, 1.00218; not a single density. | |
| $M_{CO_2}$ | 0.04401 kg mol⁻¹ | 0.0440095 (M4) | | |
| $N$ | 30 | 1000 for V5, V6 (Sec. 9.6) | 30 is the paper's optimisation grid. | |

## 8. Open points

1. **Base-case gap.** Mocca's documentation (`docs/src/processes.md`) reports 79.5 % purity and 36.7 % recovery for this cycle against 88.74 % and 35.83 % (V5), and states that the difference "does not change with the grid, the time step or the heat model. Its cause has not been found yet." The table above finds no structural difference large enough to explain a 9-point purity gap on its own. Candidates to test in the acceptance test, not established: the loading basis the paper's code used (E1); where the paper evaluated $c_i/q_i^*$ (U2); the heat of adsorption (M1, D002); the library parameter differences of Sec. 7.
2. **Decisions for the user:** (a) U4: accept UDS with grid refinement, or ask upstream about another face discretisation; (b) $\Delta H_i$: an isotherm of this package through `compute_enthalpy` to follow D002, or Mocca's weighting logged as a deviation; (c) the LDF ratio at $C_i = 0$: a mass transfer model through `compute_mass_transfer_rate`, or Mocca's guard logged as a deviation; (d) V5, V6: 500 fixed cycles or a CSS criterion.
3. **Not read:** Mocca's `Adiabatic` thermal model in detail, the fixed-cycle simulation API, and Jutul's time-step controller.
