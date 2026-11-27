# haghpanah2013: Non-isothermal, non-isobaric adsorption column model; CO2/N2 breakthrough and four-step VSA/PVSA cycle on zeolite 13X

Status: verified


## 1. Source
The citation and DOI are authoritative: every reference in this spec resolves against the version of record they identify.

- Citation: R. Haghpanah, A. Majumder, R. Nilam, A. Rajendran, S. Farooq, I. A. Karimi and M. Amanullah, "Multiobjective Optimization of a Four-Step Adsorption Process for Postcombustion CO2 Capture Via Finite Volume Simulation", Ind. Eng. Chem. Res. 2013, 52, 4249–4265.
- DOI: 10.1021/ie302658y
- Supporting information: Supporting Information to 10.1021/ie302658y. Two pages: SI Table 1, dimensionless coefficients in the governing equations; SI Table 2, discretised boundary conditions for the pressurisation, adsorption (breakthrough), forward blowdown and reverse evacuation steps. The paper's "Associated Content" (p. 4263) lists exactly these two items.
- Local copies (not in git; `docs/papers/` is ignored): `docs/papers/Haghpanah et al. - 2013 - Multiobjective Optimization of a Four-Step Adsorption Process (Paper).pdf` (17 PDF pages) and `docs/papers/Haghpanah et al. - 2013 - Multiobjective Optimization of a Four-Step Adsorption Process (SI).pdf` (2 pages).

Page references below are journal page numbers (4249–4265), which are the same in any copy of the version of record. In the local copy, p. 4249 is PDF page 1. "SI p. n" is page n of the supporting information.

## 2. Scope
What is needed to reproduce the validation targets in Section 11, from the paper and its supporting information:
- the column model: Sec. 2, Eqs. (1)–(18), and its dimensional form with boundary conditions, Appendix A, Eqs. (A.1)–(A.21);
- the separation system: dual-site Langmuir isotherm, Table 2, LDF coefficient and axial dispersion (Sec. 4, Eqs. 37–42);
- all parameters of Table 3;
- the dynamic column breakthrough (DCB) case study: Sec. 5;
- the four-step VSA cycle: Sec. 6, Eqs. (57)–(64), Table 4, and all four rows of SI Table 2;
- the energy, productivity and energy penalty: Sec. 7.2, Eqs. (66)–(72);
- the minimum-energy operating points of Table 6 (Sec. 7.2), simulated as single runs;
- for information, the finite volume method of Sec. 3 with the WENO scheme (Eqs. 19–24, 30–36).

Implementation order is separate from this scope. The breakthrough case (Sec. 5) is implemented first.

Not covered: the literature review of Sec. 1 and Table 1; the comparison of discretisation schemes and the convergence studies (Secs. 5–6), apart from the UDS curves of Figure 4b, c (V9), for which the UDS scheme itself, Eq. (25) (p. 4252), is cited but not transcribed; the optimisation studies (Sec. 7), apart from the Table 6 operating points; computational times.

## 3. Nomenclature
Symbols as in the paper's Nomenclature (p. 4264) and text. Each meaning is sourced by the first of these that applies: (1) the paper's Nomenclature section: its wording, verbatim, with no citation; (2) an equation, table or figure number where the symbol is defined or printed, e.g. (Eq. 42), (Table 3), (Figure 1), (SI Table 1); (3) a page number, (p. n) or (SI p. n), only when no equation, table or figure applies. Wording taken from outside the Nomenclature is quoted exactly. Wording from two places is never merged into one uncited meaning, and explanatory words added by this spec are labelled "spec wording:". "SI unit" is the unit the code uses. Where the paper's unit differs, both are noted.

| Symbol | Meaning | SI unit | Code name | Verified |
|---|---|---|---|---|
| $A$ | cross-sectional area of the column | m² | `A` | DM 24/11/26 |
| $b_0$ | parameter in Langmuir isotherm; written $b_{0,i}$ in Eq. (38); spec wording: site-1 parameter, since $b_i$ pairs with $q_{sb,i}$ in Eq. (37) and "qsb,i and qsd,i are the solid phase saturation loadings of sites 1 and 2, respectively" (Eq. 37) | m³ mol⁻¹ | `b_0` | DM 24/11/26 |
| $b_i$ | "The parameters bi and di follow the Arrhenius type temperature dependence" (Eqs. 38, 39); spec wording: site-1 affinity of component $i$, since $b_i$ pairs with $q_{sb,i}$ in Eq. (37) | m³ mol⁻¹ | `b` | DM 24/11/26 |
| $c$ | fluid phase concentration; "c is the total concentration" (Eq. A.1) | mol m⁻³ | `c` | DM 24/11/26 |
| $c_i$ | "ci and qi are the fluid and solid phase concentrations of component i, respectively" (Eq. A.1) | mol m⁻³ | `c_i` | DM 24/11/26 |
| $C_{p,a}$ | specific heat capacity of the adsorbed phase | J mol⁻¹ K⁻¹ | `C_pa` | DM 24/11/26 |
| $C_{p,g}$ | specific heat capacity of the gas phase | J mol⁻¹ K⁻¹ | `C_pg` | DM 24/11/26 |
| $C_{p,s}$ | specific heat capacity of the adsorbent | J kg⁻¹ K⁻¹ | `C_ps` | DM 24/11/26 |
| $C_{p,w}$ | specific heat capacity of the column wall | J kg⁻¹ K⁻¹ | `C_pw` | DM 24/11/26 |
| $d_0$ | parameter in Langmuir isotherm; written $d_{0,i}$ in Eq. (39); spec wording: site-2 parameter, since $d_i$ pairs with $q_{sd,i}$ in Eq. (37) and "qsb,i and qsd,i are the solid phase saturation loadings of sites 1 and 2, respectively" (Eq. 37) | m³ mol⁻¹ | `d_0` | DM 24/11/26 |
| $d_i$ | "The parameters bi and di follow the Arrhenius type temperature dependence" (Eqs. 38, 39); spec wording: site-2 affinity of component $i$, since $d_i$ pairs with $q_{sd,i}$ in Eq. (37) | m³ mol⁻¹ | `d` | DM 24/11/26 |
| $d_p$ | "dp is the diameter of the adsorbent particle" (Eq. 42) | m | `d_p` | DM 24/11/26 |
| $D_L$ | axial dispersion | m² s⁻¹ | `D_L` | DM 24/11/26 |
| $D_m$ | molecular diffusivity | m² s⁻¹ | `D_m` | DM 24/11/26 |
| $D_p$ | macropore diffusivity | m² s⁻¹ | `D_p` | DM 24/11/26 |
| $f$, $f_j$ | state variable; cell average of state variable $f$ | — | `f` | DM 24/11/26 |
| $h_{in}$ | inside heat transfer coefficient | W m⁻² K⁻¹ (printed J m⁻² K⁻¹ s⁻¹) | `h_in` | DM 24/11/26 |
| $h_{out}$ | outside heat transfer coefficient | W m⁻² K⁻¹ (printed J m⁻² K⁻¹ s⁻¹) | `h_out` | DM 24/11/26 |
| $\Delta H_i$ | "ΔHi is heat of adsorption of component i" (Eq. A.8); spec wording: the Nomenclature lists only "H = enthalpy" | J mol⁻¹ | `ΔH` | DM 27/11/26|
| $k$ | mass transfer coefficient; used per component as $k_i$ in Eqs. (A.4), (40) | s⁻¹ | `k` | DM 27/11/26|
| $K_w$ | thermal conductivity of column wall | W m⁻¹ K⁻¹ (printed J m⁻¹ K⁻¹ s⁻¹) | `K_w` | DM 24/11/26 |
| $K_z$ | effective gas thermal conductivity | W m⁻¹ K⁻¹ (printed J m⁻¹ K⁻¹ s⁻¹) | `K_z` | DM 24/11/26 |
| $L$ | column length | m | `L` | DM 24/11/26 |
| mole | number of moles | mol | `mole` | DM 24/11/26 |
| $n_{comp}$ | number of components | — | `n_comp` | DM 24/11/26 |
| $N$ | number of discretization volumes | — | `N` | DM 27/11/26|
| $P$ | pressure | Pa | `P` | DM 24/11/26 |
| $\bar P$ | dimensionless pressure; $\bar P = P/P_0$ (SI Table 1) | — | `Pbar` | DM 27/11/26|
| $Pe$ | Peclet number | — | `Pe` | DM 24/11/26 |
| $Pe_h$ | heat Peclet number | — | `Pe_h` | DM 24/11/26 |
| $q$ | concentration in the solid phase | printed mmol g⁻¹; see E1 | `q` | DM 24/11/26 |
| $q_i$ | "ci and qi are the fluid and solid phase concentrations of component i, respectively" (Eq. A.1) | as $q$ | `q[i]` | DM 24/11/26 |
| $q_i^*$ | "qi* is the solid phase equilibrium concentration" (Eq. A.4) | as $q$ | `q_star` | DM 24/11/26 |
| $q_{sb,i}$ | saturation concentration in the solid phase for site 1; used per component as $q_{sb,i}$ in Eq. (37) and Table 2 | printed mmol g⁻¹ (SI: mol kg⁻¹); see E1 | `q_sb` | DM 24/11/26 |
| $q_{sd,i}$ | saturation concentration in the solid phase for site 2; used per component as $q_{sd,i}$ in Eq. (37) and Table 2 | printed mmol g⁻¹ (SI: mol kg⁻¹); see E1 | `q_sd` | DM 24/11/26 |
| $q_{s,0}$ | listed in Table 3 under "constants for dimensionless parameters" with value $q_{sb,N_2}$; $x_i = q_i/q_{s,0}$ (SI Table 1); subscript "0 = reference value for nondimensionalizing parameters"; spec wording: reference solid concentration | as $q$ | `q_s0` | DM 24/11/26 |
| $r_{in}$ | column inner radius | m | `r_in` | DM 24/11/26 |
| $r_{out}$ | column outer radius | m | `r_out` | DM 24/11/26 |
| $r_p$ | particle radius | m | `r_p` | DM 24/11/26 |
| $R$ | universal gas constant | Pa m³ mol⁻¹ K⁻¹ | `R` | DM 24/11/26 |
| $t$ | time | s | `t` | DM 24/11/26 |
| $T$ | temperature | K | `T` | DM 24/11/26 |
| $\bar T$ | dimensionless temperature; $\bar T = T/T_0$ (SI Table 1) | — | `Tbar` | DM 24/11/26 |
| $T_a$, $\bar T_a$ | $T_a$: ambient temperature; $\bar T_a = T_a/T_0$ (SI Table 1) | K; — | `T_a`, `Tbar_a` | DM 24/11/26 |
| $T_w$, $\bar T_w$ | $T_w$: column wall temperature; $\bar T_w = T_w/T_0$ (SI Table 1) | K; — | `T_w`, `Tbar_w` | DM 24/11/26 |
| $T_{feed}$ | "feed temperature" (Table 3) | K | `T_feed` | DM 24/11/26 |
| $\Delta U_{b,i}$, $\Delta U_{d,i}$ | $U$: internal energy; $\Delta U_{b,i}$, $\Delta U_{d,i}$ appear in Eqs. (38), (39) and Table 2 with no further definition; spec wording: change in internal energy (by the $\Delta$ notation), in $b_i$ (site 1) and $d_i$ (site 2) respectively; the paper does not say of what process, nor how it relates to $\Delta H_i$ (M1) | J mol⁻¹ | `ΔU_b`, `ΔU_d` | DM 24/11/26 |
| $v$ | interstitial velocity | m s⁻¹ | `v` | DM 24/11/26 |
| $\bar v$ | dimensionless interstitial velocity; $\bar v = v/v_0$ (SI Table 1) | — | `vbar` | DM 24/11/26 |
| $v_{feed}$ | "interstitial feed velocity" (Table 3) | m s⁻¹ | `v_feed` | DM 24/11/26 |
| $V$, $\Delta V$ | $V$: cell volume; "the column is divided into N cells, each with a volume of ΔV" (Eq. 19) | m³ | `ΔV` | DM 24/11/26 |
| $x_i$ | dimensionless solid phase concentration; $x_i = q_i/q_{s,0}$ (SI Table 1) | — | `x` | DM 24/11/26 |
| $x^*$ | dimensionless equilibrium concentration in solid phase | — | `x_star` | DM 24/11/26 |
| $y_i$ | composition in the gas phase; "yi is the mole fraction in the fluid phase" (Eq. A.1) | — | `y` | DM 24/11/26 |
| $y_{i,feed}$ | appears in Figure 1 and Eq. (8) without verbal definition; spec wording: mole fraction of component $i$ in the feed; Table 4 writes $y_{feed,CO_2}$, and this spec also writes $y_{CO_2,feed}$ for the same quantity | — | `y_feed` | DM 24/11/26 |
| $\bar T_{feed}$ | appears in Eq. (10) without definition; spec wording: dimensionless feed temperature, $T_{feed}/T_0$, by analogy with $\bar T = T/T_0$ (SI Table 1); equals 1 here since $T_0 = T_{feed}$ (Table 3; A2) | — | `Tbar_feed` | DM 25/11/26 |
| $\Delta Z$ | marked between faces $j-0.5$ and $j+0.5$ in Figure 1 and used in Eqs. (20), (21), (23), (24), (33)–(36) and SI Table 2 without verbal definition; spec wording: dimensionless cell width | — | `ΔZ` | DM 25/11/26 |
| $M_{CO_2}$ | not in the paper; spec wording: molar mass of CO2, introduced for "mass of CO2 in the extract stream(s) per cycle" (Eq. 70); no value in the paper (M4) | kg mol⁻¹ | `M_CO2` | DM 25/11/26 |
| $z$ | bed coordinate | m | `z` | DM 25/11/26 |
| $Z$ | dimensionless axial coordinate; $Z = z/L$ (SI Table 1) | — | `Z` | DM 25/11/26 |
| $\alpha_i$ | "αi in eq 3 is given by" $\alpha_i = k_i L / v_0$ (Eq. 40; also SI Table 1); spec wording: dimensionless LDF coefficient | — | `α` | DM 25/11/26 |
| $\delta$ | "The constant δ is a very small number, typically 10^−10" (Eq. 27); also used in Eq. (31) | — | `δ` | DM 25/11/26 |
| $\varepsilon$ | bed voidage | — | `ε` | DM 25/11/26 |
| $\varepsilon_p$ | particle voidage | — | `ε_p` | DM 25/11/26 |
| $\mu$ | fluid viscosity | Pa s (printed kg m⁻¹ s⁻¹) | `μ` | DM 25/11/26 |
| $\rho_g$ | density of fluid phase | mol m⁻³ | `ρ_g` | DM 25/11/26 |
| $\rho_s$ | density of adsorbent; "ρs and ρg are the densities of the particles and gas phase, respectively" (Eq. A.8) | kg m⁻³ | `ρ_s` | DM 25/11/26 |
| $\rho_w$ | wall density | kg m⁻³ | `ρ_w` | DM 25/11/26 |
| $\Pi_1,\Pi_2,\Pi_3$ | dimensionless group in column wall energy balance; $\Pi_1$, $\Pi_2$, $\Pi_3$ are defined in SI Table 1 and appear in Eqs. (5), (24) | — | `Π_1`, `Π_2`, `Π_3` | DM 25/11/26 |
| $\tau$ | dimensionless time; $\tau = t v_0 / L$ (SI Table 1) | — | `τ` | DM 25/11/26 |
| $\tau'$ | tortuosity | — | `τ_tort` | DM 25/11/26 |
| $`\Omega_1..\Omega_4`$ | dimensionless group in column energy balance; $`\Omega_1`$–$`\Omega_4`$ are defined in SI Table 1 and appear in Eqs. (4), (23) | — | `Ω_1`..`Ω_4` | DM 25/11/26 |
| $\psi$ | dimensionless group in component and total mass balance equations | — | `ψ` | DM 25/11/26 |
| $\sigma_i$ | dimensionless group in column energy balance; $\sigma_i$ is defined in SI Table 1 and appears in Eqs. (4), (23) | — | `σ` | DM 25/11/26 |
| $P_0$, $T_0$, $v_0$ | subscript 0: reference value for nondimensionalizing parameters; listed under "constants for dimensionless parameters" (Table 3) as $P_0 = P_H$, $T_0 = T_{feed}$, $v_0 = v_{feed}$ | Pa, K, m s⁻¹ | `P_0`, `T_0`, `v_0` | DM 25/11/26 |
| $P_H$ | "high pressure" (Table 3) | Pa | `P_H` | DM 25/11/26 |
| $P_I$ | "intermediate pressure" (Table 3); "the column pressure is reduced to an intermediate pressure, PI < 1 bar" (p. 4255) | Pa | `P_I` | DM 25/11/26 |
| $P_L$ | "low pressure" (Table 3); "by decreasing the column pressure to PL (PL < PI < 1 bar)" (p. 4256) | Pa | `P_L` | DM 25/11/26 |
| $P_f$ | "flue gas pressure" (Table 3); "we use Pf to denote flue gas pressure" (p. 4260) | Pa | `P_f` | DM 25/11/26 |
| $P_{atm}$ | "where Patm= 1 bar" (Eqs. 68, 69); spec wording: atmospheric pressure | Pa | `P_atm` | DM 25/11/26 |
| $\lambda$ | rate of pressure change | s⁻¹ | `λ` | DM 25/11/26 |
| $t_{press}$, $t_{ads}$, $t_{bd}$, $t_{evac}$ | $t$: time; subscripts press: pressurization step, ads: adsorption step, bd: blowdown step, evac: evacuation step; "the durations of the four steps (tpress, tads, tbd, tevac)" (p. 4259) | s | `t_press`, `t_ads`, `t_bd`, `t_evac` | DM 25/11/26 |
| $\tau_{step}$, $\tau_{evac}$ | upper limits of the integrals in Eqs. (62), (63) ($\tau_{step}$) and (64) ($\tau_{evac}$), not defined in words by the paper; spec wording: dimensionless step durations | — | `τ_step`, `τ_evac` | DM 25/11/26 |
| $E$ | energy consumption of vacuum pump or compressor | J | `E_press`, `E_ads`, `E_bd`, `E_evac` | DM 25/11/26 |
| $E_T$ | $E$: energy consumption of vacuum pump or compressor; subscript T: total; "total energy consumption in terms of kilowatt hours per metric ton of CO2 captured is calculated by the following equation" (Eq. 70) | printed kWh t⁻¹; SI J kg⁻¹ | `E_T` | DM 25/11/26 |
| $\eta$ | compression/evacuation efficiency (Table 3) | — | `η` | DM 25/11/26 |
| $\gamma$ | adiabatic constant | — | `γ` | DM 25/11/26 |
| $n_{cycle}$ | number of VSA cycle | — | `n_cycle` | DM 25/11/26 |
| purity, recovery | Eqs. (60), (61) | % | `purity`, `recovery` | DM 25/11/26 |
| productivity | Eq. (71) | mol m⁻³ s⁻¹ | `productivity` | DM 25/11/26 |

## 4. Assumptions

| # | Assumption | Page | Verified |
|---|---|---|---|
| 1 | An axially dispersed plug flow model represents the bulk fluid flow. | 4250 | DM 25/11/26 |
| 2 | The gas phase is described by the ideal gas law. | 4250 | DM 25/11/26 |
| 3 | The solid phase mass transfer rate is described by the linear driving force (LDF) model. | 4250 | DM 25/11/26 |
| 4 | "Darcy's law" accounts for the frictional pressure drop in the axial direction (form given in Eq. 6 / A.6). | 4250 | DM 25/11/26 |
| 5 | Thermal equilibrium between the gas and solid phases is established instantaneously. | 4250 | DM 25/11/26 |
| 6 | No concentration, temperature and pressure gradients exist in the radial direction. | 4250 | DM 25/11/26 |
| 7 | Heat transfer occurs across the column wall, whose outer surface is maintained at a constant temperature. | 4250 | DM 25/11/26 |
| 8 | Adsorbent properties and bed voidage are uniform across the column. | 4250 | DM 25/11/26 |
| 9 | Fluid viscosity is independent of temperature. | 4262 | DM 25/11/26 |
| 10 | Transport into the solid phase is controlled by molecular diffusion in the macropores (basis of Eq. 40). | 4253 | DM 25/11/26 |
| 11 | Wall flanges at $z=0$ and $z=L$ have a high thermal capacity, so their temperatures equal $T_a$ (basis of Eqs. 12, A.14, A.15). | 4263 | DM 25/11/26 |
| 12 | DCB case only: the column is adiabatic, $h_{in} = h_{out} = 0$. | 4254 | DM 25/11/26 |
| 13 | DCB case only: the column is initially saturated with 100% N2 at $P_H = 1$ bar. | 4254 | DM 25/11/26 |
| 14 | Cycle only: at the start of the simulation the column is saturated with 100% N2 at $P_L$; the state at the end of a step is the initial condition for the next step. | 4256 | DM 25/11/26 |
| 15 | Steps executed in the reverse direction (flow from $z=L$ to $z=0$) use the forward-flow boundary conditions "with their ends interchanged". | 4263 | DM 25/11/26 |
| 16 | Energy: all vacuum pumps discharge at 1 bar; flue gas pressure $P_f$ = 1 bar; $\eta$ = 0.72 and $\gamma$ = 1.4 "in all energy calculations". | 4260 | DM 25/11/26 |
| 17 | Feed (cycle): 15 mol % CO2 and 85 mol % N2 at 1 bar and 25 °C, "representative of dry, postcombustion flue gas from a coal-fired power plant". | 4255 | DM 25/11/26 |

## 5. Governing equations
Dimensionless form as printed in Sec. 2. The dimensional form (Appendix A.1) follows, since the dimensionless groups are defined from it. The groups are in Section 6 below (SI Table 1).

### 5.1 Eq. (1): component mass balance
- Page: 4251
- Verified: DM 27/11/26

$$
\frac{\partial y_i}{\partial \tau} = \frac{1}{Pe}\frac{\bar T}{\bar P}\frac{\partial}{\partial Z}\left(\frac{\bar P}{\bar T}\frac{\partial y_i}{\partial Z}\right) - \frac{\bar T}{\bar P}\frac{\partial}{\partial Z}\left(\frac{y_i \bar P}{\bar T}\bar v\right) - \psi\frac{\bar T}{\bar P}\frac{\partial x_i}{\partial \tau} - \frac{y_i}{\bar P}\frac{\partial \bar P}{\partial \tau} + \frac{y_i}{\bar T}\frac{\partial \bar T}{\partial \tau}
$$

Notes: written for $n_{comp}-1$ components ("(ncomp − 1) component mass balances, total mass balance" (p. 4250)) - i.e., only solved for y_CO2.

### 5.2 Eq. (2): total mass balance
- Page: 4251
- Verified: DM 25/11/26 

$$
\frac{\partial \bar P}{\partial \tau} = -\bar T\frac{\partial}{\partial Z}\left(\frac{\bar P}{\bar T}\bar v\right) - \psi\bar T\sum_{i=1}^{n_{comp}}\frac{\partial x_i}{\partial \tau} + \frac{\bar P}{\bar T}\frac{\partial \bar T}{\partial \tau}
$$

### 5.3 Eq. (3): solid phase balance
- Page: 4251
- Verified: DM 24/11/26 

$$
\frac{\partial x_i}{\partial \tau} = \alpha_i\left(x_i^* - x_i\right)
$$

### 5.4 Eq. (4): column energy balance
- Page: 4251
- Verified: DM 24/11/26 

$$
\frac{\partial \bar T}{\partial \tau} = \Omega_1\frac{\partial^2 \bar T}{\partial Z^2} - \Omega_2\frac{\partial}{\partial Z}\left(\bar v\bar P\right) - \Omega_3\bar T\sum_{i=1}^{n_{comp}}\frac{\partial x_i}{\partial \tau} + \sum_{i=1}^{n_{comp}}\left(\sigma_i\frac{\partial x_i}{\partial \tau}\right) - \Omega_4\left(\bar T - \bar T_w\right) - \Omega_2\frac{\partial \bar P}{\partial \tau}
$$

Notes: $\Omega_1..\Omega_4$ and $\sigma_i$ contain $\sum_i x_i$ and so vary in space and time (written $\Omega_{1,j}$ etc. in Eq. 23). $\Omega_2$ multiplies both the convective term and $\partial\bar P/\partial\tau$.

### 5.5 Eq. (5): wall energy balance
- Page: 4251
- Verified:  DM 25/11/26 

$$
\frac{\partial \bar T_w}{\partial \tau} = \Pi_1\frac{\partial^2 \bar T_w}{\partial Z^2} + \Pi_2\left(\bar T - \bar T_w\right) - \Pi_3\left(\bar T_w - \bar T_a\right)
$$

### 5.6 Eq. (6): pressure drop
- Page: 4251
- Verified:  DM 25/11/26 

$$
-\frac{\partial \bar P}{\partial Z} = \frac{150}{4}\frac{1}{r_p^2}\left(\frac{1-\varepsilon}{\varepsilon}\right)^2\frac{v_0 L}{P_0}\mu\bar v
$$

### 5.7 Eq. (7): local velocity
- Page: 4251
- Verified: DM 25/11/26 

$$
\bar v = \frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2 r_p^2\frac{P_0}{\mu v_0 L}\left(-\frac{\partial \bar P}{\partial Z}\right)
$$

### 5.8 Eq. (A.1): component mass balance, dimensional
- Page: 4262
- Verified: DM 25/11/26 

$$
\frac{\partial c_i}{\partial t} = -\frac{\partial}{\partial z}\left[c D_L\frac{\partial y_i}{\partial z} + c_i v\right] - \frac{1-\varepsilon}{\varepsilon}\frac{\partial q_i}{\partial t}
$$

Notes: as printed, the dispersion term enters with a sign opposite to that in (A.2) and Eq. (1). See E2. Transcribed as printed.

### 5.9 Eq. (A.2): component mass balance in $y_i$, $P$, $T$
- Page: 4262
- Verified: DM 25/11/26 

$$
\frac{\partial y_i}{\partial t} + \frac{y_i}{P}\frac{\partial P}{\partial t} - \frac{y_i}{T}\frac{\partial T}{\partial t} = \frac{T}{P}D_L\frac{\partial}{\partial z}\left(\frac{P}{T}\frac{\partial y_i}{\partial z}\right) - \frac{T}{P}\frac{\partial}{\partial z}\left(\frac{y_i P}{T}v\right) - \frac{RT}{P}\frac{1-\varepsilon}{\varepsilon}\frac{\partial q_i}{\partial t}
$$

Notes: "The space derivative terms are not expanded for the convenience of uniformly implementing the finite volume schemes" (p. 4262). 

### 5.10 Eq. (A.3): total mass balance, dimensional
- Page: 4262
- Verified: DM 25/11/26 

$$
\frac{1}{P}\frac{\partial P}{\partial t} - \frac{1}{T}\frac{\partial T}{\partial t} = -\frac{T}{P}\frac{\partial}{\partial z}\left(\frac{P}{T}v\right) - \frac{1-\varepsilon}{\varepsilon}\frac{RT}{P}\sum_{i=1}^{n_{comp}}\frac{\partial q_i}{\partial t}
$$

Notes: obtained by "Adding the component mass balance equations, given by eq A.2 for component i, subject to the conditions $\sum y_i = 1$" (p. 4262).

### 5.11 Eq. (A.4): LDF model
- Page: 4262
- Verified: DM 25/11/26 

$$
\frac{\partial q_i}{\partial t} = k_i\left(q_i^* - q_i\right)
$$

### 5.12 Eq. (A.5): isotherm, general form
- Page: 4262
- Verified: DM 25/11/26 

$$
q_i^* = f(c_i, T)
$$

### 5.13 Eq. (A.6): pressure drop, dimensional
- Page: 4262
- Verified: DM 25/11/26 

$$
-\frac{\partial P}{\partial z} = \frac{150}{4}\frac{1}{r_p^2}\left(\frac{1-\varepsilon}{\varepsilon}\right)^2\mu v
$$

### 5.14 Eq. (A.7): local velocity, dimensional
- Page: 4262
- Verified: DM 25/11/26 

$$
v = \frac{4}{150\mu}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2 r_p^2\left(\frac{-\partial P}{\partial z}\right)
$$

### 5.15 Eq. (A.8): column energy balance, dimensional
- Page: 4262
- Verified: DM 25/11/26 

$$
\left[\frac{1-\varepsilon}{\varepsilon}\left(\rho_s C_{p,s} + C_{p,a}\sum_{i=1}^{n_{comp}} q_i\right)\right]\frac{\partial T}{\partial t} = \frac{K_z}{\varepsilon}\frac{\partial^2 T}{\partial z^2} - \frac{C_{p,g}}{R}\frac{\partial}{\partial z}(vP) - \frac{C_{p,g}}{R}\frac{\partial P}{\partial t} - \frac{1-\varepsilon}{\varepsilon}C_{p,a}T\sum_{i=1}^{n_{comp}}\frac{\partial q_i}{\partial t} + \frac{1-\varepsilon}{\varepsilon}\sum_{i=1}^{n_{comp}}\left((-\Delta H_i)\frac{\partial q_i}{\partial t}\right) - \frac{2h_{in}}{\varepsilon r_{in}}\left(T - T_w\right)
$$

Notes: $h_{in}$ is called "inside heat transfer coefficient" (p. 4255) and "overall heat transfer coefficient from column to wall" (p. 4263). $K_z$ is "effective gas thermal conductivity" (p. 4255) and "thermal conductivity of the bed in the axial direction" (p. 4263). 

### 5.16 Eq. (A.9): wall energy balance, dimensional
- Page: 4263
- Verified: DM 25/11/26 

$$
\rho_w C_{p,w}\frac{\partial T_w}{\partial t} = K_w\frac{\partial^2 T_w}{\partial z^2} + \frac{2 r_{in} h_{in}}{r_{out}^2 - r_{in}^2}\left(T - T_w\right) - \frac{2 r_{out} h_{out}}{r_{out}^2 - r_{in}^2}\left(T_w - T_a\right)
$$

Notes: "ρw and Cp,w are the density and heat capacity of the column wall, typically made of stainless steel. r_out is the column outer radius, and h_out is the film heat transfer coefficient between the column wall and the ambient air." 

## 6. Constitutive relations and correlations

### 6.1 Eq. (37): dual-site Langmuir isotherm
- Page: 4253
- Verified: DM 25/11/26 

```math
q_i^* = \frac{q_{sb,i}\, b_i c_i}{1 + \sum_{i=1}^{n_{comp}} b_i c_i} + \frac{q_{sd,i}\, d_i c_i}{1 + \sum_{i=1}^{n_{comp}} d_i c_i}
```

Notes: the summation index reuses $i$ as printed - the sums run over all components. The relation $c_i = y_i P/(RT)$ follows from Assumption 2 but is not written as a numbered equation.

### 6.2 Eq. (38): temperature dependence of $b_i$
- Page: 4253
- Verified: DM 25/11/26 

```math
b_i = b_{0,i}\, e^{-\Delta U_{b,i}/RT}
```

### 6.3 Eq. (39): temperature dependence of $d_i$
- Page: 4253
- Verified: DM 25/11/26 

```math
d_i = d_{0,i}\, e^{-\Delta U_{d,i}/RT}
```

### 6.4 Equilibrium in dimensionless form
- Page: SI p. 1 (Table 1, $x_i = q_i/q_{s,0}$); p. 4264 ($x^*$ = dimensionless equilibrium concentration in solid phase)
- Verified: DM 25/11/26 

$$
x_i = \frac{q_i}{q_{s,0}}, \qquad x_i^* = \frac{q_i^*}{q_{s,0}}
$$

Notes: $x_i^* = q_i^*/q_{s,0}$ is not printed as an equation but is used in Eq. (A.4) and (3). It is read from the Nomenclature together with the definition of $x_i$ in SI Table 1.

### 6.5 Eq. (40): LDF coefficient
- Page: 4253
- Verified: DM 25/11/26 

$$
\alpha_i = k_i\frac{L}{v_0} = \left(\frac{c_i}{q_i^*}\frac{15\varepsilon_p D_p}{r_p^2}\right)\frac{L}{v_0}
$$

Notes: the state at which $c_i/q_i^*$ is evaluated is not stated (U2). 

### 6.6 Eq. (41): macropore diffusivity
- Page: 4253
- Verified: DM 25/11/26 

$$
D_p = \frac{D_m}{\tau'}
$$

### 6.7 Eq. (42): axial dispersion
- Page: 4254
- Verified: DM 25/11/26 

$$
D_L = 0.7 D_m + 0.5 v_0 d_p
$$

Notes: uses the reference velocity $v_0$, not the local $v$, so $D_L$ is constant.

### 6.8 Ideal-gas fluid density
- Page: 4255, Eq. (54)
- Verified: DM 25/11/26 

```math
\rho_{g,j}(\tau) = \frac{P_0}{T_0}\frac{\bar P_j(\tau)}{R\,\bar T_j(\tau)}
```

### 6.9 Dimensionless groups (SI Table 1)
- Page: SI p. 1
- Verified: DM 25/11/26 

$$
Pe = \frac{v_0 L}{D_L}
$$

$$
Pe_h = \frac{\varepsilon v_0 L}{\dfrac{K_z}{\rho_g C_{pg}}}
$$

$$
\psi = \frac{R T_0 q_{s,0}}{P_H}\frac{(1-\varepsilon)}{\varepsilon}
$$

$$
\Omega_1 = \frac{\dfrac{K_z}{v_0 \varepsilon L}}{\dfrac{(1-\varepsilon)}{\varepsilon}\left(\rho_s C_{ps} + q_{s,0} C_{pa}\sum_{i=1}^{n_{comp}} x_i\right)}
$$

$$
\Omega_2 = \frac{\dfrac{C_{pg}}{R}\dfrac{P_0}{T_0}}{\dfrac{(1-\varepsilon)}{\varepsilon}\left(\rho_s C_{ps} + q_{s,0} C_{pa}\sum_{i=1}^{n_{comp}} x_i\right)}
$$

$$
\Omega_3 = \frac{C_{pa} q_{s,0}}{\left(\rho_s C_{ps} + q_{s,0} C_{pa}\sum_{i=1}^{n_{comp}} x_i\right)}
$$

$$
\Omega_4 = \frac{\dfrac{2h_{in}}{r_{in}}\dfrac{L}{v_0}}{(1-\varepsilon)\left(\rho_s C_{ps} + q_{s,0} C_{pa}\sum_{i=1}^{n_{comp}} x_i\right)}
$$

$$
\sigma_i = \frac{\dfrac{q_{s,0}}{T_0}\left(-\Delta H_i\right)}{\left(\rho_s C_{ps} + q_{s,0} C_{pa}\sum_{i=1}^{n_{comp}} x_i\right)}
$$

$$
\Pi_1 = \frac{K_w}{\rho_w C_{pw} v_0 L};\qquad
\Pi_2 = \frac{2 r_{in} h_{in}}{r_{out}^2 - r_{in}^2}\frac{L}{\rho_w C_{pw} v_0};\qquad
\Pi_3 = \frac{2 r_{out} h_{out}}{r_{out}^2 - r_{in}^2}\frac{L}{\rho_w C_{pw} v_0}
$$

Notes:
- $\psi$ is printed with $P_H$. Deriving Eq. (1) from (A.2) gives $P_0$. In this paper $P_0 = P_H$ (Table 3), so the two agree numerically (A1).
- $\rho_g$ in $Pe_h$: the state at which it is evaluated is not stated (U1).
- SI Table 1 writes $C_{pg}$, $C_{ps}$, $C_{pa}$, $C_{pw}$ for the paper's $C_{p,g}$, $C_{p,s}$, $C_{p,a}$, $C_{p,w}$.
- $\sigma_i$ needs $\Delta H_i$, for which no value is given (M1).

## 7. Boundary and initial conditions

### 7.1 Step: dynamic column breakthrough (open–open; flow from $Z=0$ to $Z=1$)
"The boundary conditions for breakthrough simulation are listed in Table 2 in the Supporting Information" (p. 4254)

The DCB set-up, as described: "Here, both ends of the column are open and a gas stream is introduced into the bed at Z = 0 with a known flow rate. The composition and flow rate are measured at the column outlet using suitable detectors. The pressure at the column outlet is maintained by a back-pressure regulator. This situation is identical to an adsorption step with an open−open boundary condition. This is simulated by fixing the gas velocity, v_feed, at the column inlet, and the pressure at the column outlet is assigned to the desired operating pressure." (p. 4254)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $y_i$ | $Z=0$ | $`\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=0} = -\bar v_{Z=0}\,Pe\left(y_{i,feed} - y_i\vert_{Z=0}\right)`$ | (8); (A.10) | 4251; 4263 |  DM 25/11/26 |
| $y_i$ | $Z=1$ | $\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=1} = 0$ | (9); (A.11) | 4251; 4263 |  DM 25/11/26 |
| $\bar T$ | $Z=0$ | $`\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=0} = -\bar v_{Z=0}\,Pe_h\left(\bar T_{feed} - \bar T\vert_{Z=0}\right)`$ | (10); (A.12) | 4251; 4263 |  DM 25/11/26 |
| $\bar T$ | $Z=1$ | $\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=1} = 0$ | (11); (A.13) | 4251; 4263 |  DM 25/11/26 |
| $\bar T_w$ | $Z=0$, $Z=1$ | $\bar T_w\vert_{Z=0} = \bar T_w\vert_{Z=1} = \bar T_a$ | (12); (A.14), (A.15) | 4251; 4263 |  DM 25/11/26 |
| $\bar P$ | $Z=1$ | $\bar P\vert_{Z=1} = 1$ | (13); (A.16) | 4252; 4263 |  DM 25/11/26 |
| $\bar v$ | $Z=0$ | $\bar v\vert_{Z=0} = 1$; "the inlet pressure is calculated from eq 6 using a known inlet velocity" | (14); (A.17) | 4252; 4263 |  DM 25/11/26 |
| $\bar P$ | $Z=0$ | $\bar P_{0.5} = \bar P\vert_{Z=0} = \bar P_1 + \dfrac{\bar v\vert_{Z=0}\frac{\Delta Z}{2}}{\left[\frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2\right] r_p^2\frac{P_0}{\mu v_0 L}}$ | SI Table 2; cf. (36) | SI p. 2 |  DM 25/11/26 |
| $\bar P$ | $Z=1$ | $\bar P_{N+0.5} = \bar P\vert_{Z=1} = 1$ | SI Table 2 | SI p. 2 |  DM 25/11/26 |
| $y_i$ | $Z=0$ | $`y_{i,0.5} = y_i\vert_{Z=0} = \dfrac{y_{i,1} + y_{i,feed}\,\bar v\vert_{Z=0}\,Pe\frac{\Delta Z}{2}}{1 + \bar v\vert_{Z=0}\,Pe\frac{\Delta Z}{2}}`$ | SI Table 2 | SI p. 2 | DM 25/11/26 |
| $y_i$ | $Z=1$ | $y_{i,N+0.5} = y_i\vert_{Z=1} = y_{i,N}$ | SI Table 2 | SI p. 2 | DM 25/11/26 |
| $\bar T$ | $Z=0$ | $`\bar T_{0.5} = \bar T\vert_{Z=0} = \dfrac{\bar T_1 + \bar v\vert_{Z=0}\,Pe_h\frac{\Delta Z}{2}}{1 + \bar v\vert_{Z=0}\,Pe_h\frac{\Delta Z}{2}}`$ | SI Table 2 | SI p. 2 | DM 25/11/26 |
| $\bar T$ | $Z=1$ | $\bar T_{N+0.5} = \bar T\vert_{Z=1} = \bar T_N$ | SI Table 2 | SI p. 2 | DM 25/11/26 |
| $\bar T_w$ | $Z=0$, $Z=1$  | $\bar T_w\vert_{Z=0} = \bar T_a$; $\bar T_w\vert_{Z=1} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 25/11/26 |
| $y_i$ | feed | 15 mol % CO2 in N2: $y_{CO_2,feed} = 0.15$ | Sec. 5 text | 4254 | DM 25/11/26 |
| $T$ | feed | $T_{feed} = 298.15$ K | Table 3 | 4255 | DM 25/11/26 |
| $y_i$ | whole column, $t=0$ | saturated with 100% N2: $y_{N_2} = 1$, $y_{CO_2} = 0$ | Sec. 5 text | 4254 | DM 25/11/26 |
| $P$ | whole column, $t=0$ | $P_H = 1$ bar (whether uniform is not stated; U3) | Sec. 5 text | 4254 | DM 25/11/26 |
| $q_i$ | whole column, $t=0$ | "saturated" with N2; the loading is not given explicitly (U3) | Sec. 5 text | 4254 | DM 25/11/26 |
| $T$, $T_w$ | whole column, $t=0$ | not stated (U3) | — | — | DM 25/11/26 |
| $h_{in}$, $h_{out}$ | — | $h_{in} = h_{out} = 0$ (adiabatic) | Sec. 5 text | 4254 | DM 25/11/26 |

Notes:

- Why two pressure conditions: "Since velocity is a function of the pressure gradient (through Darcy's law), the total mass balance equation is in effect second order in pressure; hence two boundary conditions are required. In a typical open−open operation, the pressure at the column exit is controlled using a regulator." (p. 4263

### 7.2 Generic: open–closed (continuous form)
Figure 2 (p. 4251) defines three valve configurations: (a) open–open, (b) open–closed, (c) closed–open. Open–open is given above.

"The boundary conditions for eqs 1, 2, 4, and 5 are identical to those for the open−open case, i.e., eq 8−12." (p. 4252)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $y_i$ | $Z=0$ | $`\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=0} = -\bar v_{Z=0}\,Pe\left(y_{i,feed} - y_i\vert_{Z=0}\right)`$ | (8); (A.10) | 4251; 4263 | DM 26/11/26 |
| $y_i$ | $Z=1$ | $\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=1} = 0$ | (9); (A.11) | 4251; 4263 | DM 26/11/26 |
| $\bar T$ | $Z=0$ | $`\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=0} = -\bar v_{Z=0}\,Pe_h\left(\bar T_{feed} - \bar T\vert_{Z=0}\right)`$ | (10); (A.12) | 4251; 4263 | DM 26/11/26 |
| $\bar T$ | $Z=1$ | $\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=1} = 0$ | (11); (A.13) | 4251; 4263 | DM 26/11/26 |
| $\bar T_w$ | $Z=0$, $Z=1$ | $\bar T_w\vert_{Z=0} = \bar T_w\vert_{Z=1} = \bar T_a$ | (12); (A.14), (A.15) | 4251; 4263 | DM 26/11/26 |
| $\bar v$ | $Z=0$ | "The velocity, $\bar v\vert_{Z=0}$, is calculated from the change in pressure at the column inlet."; spec wording: discretised as Eq. (34), Sec. 3 (p. 4253) | Sec. 2 text; App. A.2 text | 4252; 4263 | DM 26/11/26 |
| $\bar v$ | $Z=1$ | "Since the end at Z = 1 is closed, $\bar v\vert_{Z=1} = 0$" | Sec. 2 text; App. A.2 text | 4252; 4263 | DM 26/11/26 |
| $\bar P$ | $Z=1$ | $\left.\dfrac{\partial \bar P}{\partial Z}\right\vert_{Z=1} = 0$ | (15); (A.18) | 4252; 4263 | DM 26/11/26|
| $\bar P$ | $Z=0$ | spec wording: not stated in Sec. 2 or App. A.2; set by the step, e.g. feed pressurization, Eq. (57) | — | — | DM 26/11/26|

### 7.3 Generic: closed–open (continuous form)
"Equations 9, 11, and 12 are not affected, while eqs 8 and 10 reduce to eqs 16 and 17, respectively" (p. 4252)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $y_i$ | $Z=0$ | $\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=0} = 0$ | (16); (A.19) | 4252; 4263 | DM 26/11/26|
| $y_i$ | $Z=1$ | $\left.\dfrac{\partial y_i}{\partial Z}\right\vert_{Z=1} = 0$ | (9); (A.11) | 4251; 4263 | DM 26/11/26|
| $\bar T$ | $Z=0$ | $\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=0} = 0$ | (17); (A.20) | 4252; 4263 | DM 26/11/26|
| $\bar T$ | $Z=1$ | $\left.\dfrac{\partial \bar T}{\partial Z}\right\vert_{Z=1} = 0$ | (11); (A.13) | 4251; 4263 | DM 26/11/26|
| $\bar T_w$ | $Z=0$, $Z=1$ | $\bar T_w\vert_{Z=0} = \bar T_w\vert_{Z=1} = \bar T_a$ | (12); (A.14), (A.15) | 4251; 4263 | DM 26/11/26|
| $\bar v$ | $Z=0$ | $\bar v\vert_{Z=0} = 0$ | Sec. 2 text; App. A.2 text | 4252; 4263 | DM 26/11/26|
| $\bar v$ | $Z=1$ | "$`\bar v\vert_{Z=1}`$ is calculated from the change in pressure at the column outlet."; spec wording: discretised as Eq. (35), Sec. 3 (p. 4253) | Sec. 2 text; App. A.2 text | 4252; 4263 | DM 26/11/26|
| $\bar P$ | $Z=0$ | $\left.\dfrac{\partial \bar P}{\partial Z}\right\vert_{Z=0} = 0$ | (18); (A.21) | 4252; 4263 | DM 26/11/26|
| $\bar P$ | $Z=1$ | spec wording: not stated in Sec. 2 or App. A.2; set by the step, e.g. blowdown, Eq. (58) | — | — | DM 26/11/26|

### 7.4 Generic: reverse-flow steps
- Verified: DM 26/11/26 

"A PVSA/VSA cycle has steps which are executed in the reverse direction; i.e., the flow is from z = L to z = 0. For such steps, the boundary conditions discussed above for forward flow will apply with their ends interchanged." (p. 4263)

### 7.5 Four-step cycle: sequence and initial condition
- Verified: DM 26/11/26 

Sec. 6.1 (pp. 4255–4256), Figure 7 (p. 4257). Labels in Figure 7: Feed Pressurization (FP), Adsorption (F), Blowdown (CoD), Evacuation (CnD); Z = 0 is the feed end, Z = 1 the light-product end. Step durations, pressures, $\lambda$, $y_{feed,CO_2}$ and $v_{feed}$ (base case): Table 4, in Section 8.

1. Feed pressurisation: "The feed containing 15 mol % CO2 and 85 mol % N2 at 1 bar and 25 °C ... is introduced into the column from the feed end (Z = 0). The other end of the column (Z = 1) is closed and the column pressure is raised to PH. Note that in a VSA process PH = 1 bar."
2. High pressure adsorption: "The feed continues to enter the column, and the light-product end (Z = 1) is opened. CO2, the heavier component, is preferentially adsorbed and N2-rich raffinate is collected from the light-product end."
3. Blowdown: "The feed end is closed and the column pressure is reduced to an intermediate pressure, PI < 1 bar, by pulling vacuum at Z = 1. The aim of this step is to remove as much N2 as possible, while retaining CO2 in the column for recovery in the next step."
4. Evacuation: "The light-product end is closed and enriched CO2 product is collected from the feed end by decreasing the column pressure to PL (PL < PI < 1 bar)."

Initial condition: "At the start of the simulation, the column is considered to be saturated with 100% N2 at PL. The state of the column at the end of a step is taken as the initial condition for the subsequent step." (p. 4256) Initial $T$, loading and $T_w$ are not stated (U5).

### 7.6 Step: feed pressurisation (open–closed; feed enters at $Z=0$)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $\bar P$ | $Z=0$ | $\bar P_{0.5} = \bar P\vert_{Z=0} = \dfrac{1}{P_0}\left(P_H - (P_H - P_L)e^{-\lambda\tau L/v_0}\right)$ | (57); SI Table 2 | 4255; SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=0$ | $`y_{i,0.5} = y_i\vert_{Z=0} = \dfrac{y_{i,1} + y_{i,feed}\,\bar v\vert_{Z=0}\,Pe\frac{\Delta Z}{2}}{1 + \bar v\vert_{Z=0}\,Pe\frac{\Delta Z}{2}}`$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=0$ | $`\bar T_{0.5} = \bar T\vert_{Z=0} = \dfrac{\bar T_1 + \bar v\vert_{Z=0}\,Pe_h\frac{\Delta Z}{2}}{1 + \bar v\vert_{Z=0}\,Pe_h\frac{\Delta Z}{2}}`$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=0$ | $\bar T_w\vert_{Z=0} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar P$ | $Z=1$ | $\bar P_{N+0.5} = \bar P\vert_{Z=1} = \bar P_N$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=1$ | $y_{i,N+0.5} = y_i\vert_{Z=1} = y_{i,N}$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=1$ | $\bar T_{N+0.5} = \bar T\vert_{Z=1} = \bar T_N$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=1$ | $\bar T_w\vert_{Z=1} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |

### 7.7 Step: high pressure adsorption (open–open)
- Verified: DM 26/11/26 

SI Table 2 gives one row, "Adsorption (breakthrough)" (SI p. 2), for this step and the DCB; its conditions, with Eqs. (8)–(14), are in the DCB table above. Spec wording: only the boundary-condition rows apply; the DCB's $h_{in} = h_{out} = 0$, feed and initial-condition rows do not.

### 7.8 Step: forward blowdown (closed–open; outflow at $Z=1$)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $\bar P$ | $Z=0$ | $\bar P_{0.5} = \bar P\vert_{Z=0} = \bar P_1$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=0$ | $y_{i,0.5} = y_i\vert_{Z=0} = y_{i,1}$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=0$ | $\bar T_{0.5} = \bar T\vert_{Z=0} = \bar T_1$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=0$ | $\bar T_w\vert_{Z=0} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar P$ | $Z=1$ | $\bar P_{N+0.5} = \bar P\vert_{Z=1} = \dfrac{1}{P_0}\left(P_I + (P_H - P_I)e^{-\lambda\tau L/v_0}\right)$ | (58); SI Table 2 | 4256; SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=1$ | $y_{i,N+0.5} = y_i\vert_{Z=1} = y_{i,N}$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=1$ | $\bar T_{N+0.5} = \bar T\vert_{Z=1} = \bar T_N$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=1$ | $\bar T_w\vert_{Z=1} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |

### 7.9 Step: reverse evacuation (light-product end $Z=1$ closed; outflow at $Z=0$)

| Variable | Location | Condition | Eq. or Table | Page | Verified |
|---|---|---|---|---|---|
| $\bar P$ | $Z=0$ | $\bar P_{0.5} = \bar P\vert_{Z=0} = \dfrac{1}{P_0}\left(P_L + (P_I - P_L)e^{-\lambda\tau L/v_0}\right)$ | (59); SI Table 2 | 4256; SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=0$ | $y_{i,0.5} = y_i\vert_{Z=0} = y_{i,1}$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=0$ | $\bar T_{0.5} = \bar T\vert_{Z=0} = \bar T_1$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=0$ | $\bar T_w\vert_{Z=0} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar P$ | $Z=1$ | $\bar P_{N+0.5} = \bar P\vert_{Z=1} = \bar P_N$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $y_i$ | $Z=1$ | $y_{i,N+0.5} = y_i\vert_{Z=1} = y_{i,N}$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T$ | $Z=1$ | $\bar T_{N+0.5} = \bar T\vert_{Z=1} = \bar T_N$ | SI Table 2 | SI p. 2 | DM 26/11/26 |
| $\bar T_w$ | $Z=1$ | $\bar T_w\vert_{Z=1} = \bar T_a$ | SI Table 2 | SI p. 2 | DM 26/11/26 |

Notes:
- The time origin of $\tau$ in Eqs. (57)–(59) is the start of each step. This is implied by the exponentials starting at the previous step's end pressure, but not stated.
- In the closed–open and reverse steps, the SI Table 2 face values at the closed end ($\bar P_{0.5} = \bar P_1$ or $\bar P_{N+0.5} = \bar P_N$) are the half-cell forms of $\partial\bar P/\partial Z = 0$. Through Eqs. (34)/(35) they give zero face velocity.

## 8. Parameters
Conversions: 1 bar = 10⁵ Pa; 1 mmol g⁻¹ = 1 mol kg⁻¹; 1 J s⁻¹ = 1 W; 1 kg m⁻¹ s⁻¹ = 1 Pa s. SI values for loadings are given per kg as printed (see E1).

### 8.1 Table 2: isotherm parameters

Table 2, "Isotherm Parameters for CO2/N2 on Zeochem Zeolite 13X" (Table 2):

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|
| $b_{0,CO_2}$ | $b_0$ for CO2 (Table 2 prints the symbol only): parameter in Langmuir isotherm; spec wording: site-1 pre-exponential | 8.65 × 10⁻⁷ | m³ mol⁻¹ | 8.65e-7 | m³ mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $b_{0,N_2}$ | $b_0$ for N2 (Table 2 prints the symbol only): parameter in Langmuir isotherm; spec wording: site-1 pre-exponential | 2.50 × 10⁻⁶ | m³ mol⁻¹ | 2.50e-6 | m³ mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $d_{0,CO_2}$ | $d_0$ for CO2 (Table 2 prints the symbol only): parameter in Langmuir isotherm; spec wording: site-2 pre-exponential | 2.63 × 10⁻⁸ | m³ mol⁻¹ | 2.63e-8 | m³ mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $d_{0,N_2}$ | $d_0$ for N2 (Table 2 prints the symbol only): parameter in Langmuir isotherm; spec wording: site-2 pre-exponential | 0.00 | m³ mol⁻¹ | 0.0 | m³ mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $\Delta U_{b,CO_2}$ | $\Delta U_{b,i}$ for CO2 (Table 2 prints the symbol only) | −36 641.21 | J mol⁻¹ | −36641.21 | J mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $\Delta U_{b,N_2}$ | $\Delta U_{b,i}$ for N2 (Table 2 prints the symbol only) | −1.58 × 10⁴ | J mol⁻¹ | −1.58e4 | J mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $\Delta U_{d,CO_2}$ | $\Delta U_{d,i}$ for CO2 (Table 2 prints the symbol only) | −35 690.66 | J mol⁻¹ | −35690.66 | J mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $\Delta U_{d,N_2}$ | $\Delta U_{d,i}$ for N2 (Table 2 prints the symbol only) | 0.00 | J mol⁻¹ | 0.0 | J mol⁻¹ | Table 2, p. 4253 | DM 26/11/26 |
| $q_{sb,CO_2}$ | $q_{sb}$ for CO2: saturation concentration in the solid phase for site 1 | 3.09 | mmol g⁻¹ | 3.09 | mol kg⁻¹ (E1) | Table 2, p. 4253 | DM 26/11/26 |
| $q_{sb,N_2}$ | $q_{sb}$ for N2: saturation concentration in the solid phase for site 1 | 5.84 | mmol g⁻¹ | 5.84 | mol kg⁻¹ (E1) | Table 2, p. 4253 | DM 26/11/26 |
| $q_{sd,CO_2}$ | $q_{sd}$ for CO2: saturation concentration in the solid phase for site 2 | 2.54 | mmol g⁻¹ | 2.54 | mol kg⁻¹ (E1) | Table 2, p. 4253 | DM 26/11/26 |
| $q_{sd,N_2}$ | $q_{sd}$ for N2: saturation concentration in the solid phase for site 2 | 0.00 | mmol g⁻¹ | 0.0 | mol kg⁻¹ (E1) | Table 2, p. 4253 | DM 26/11/26 |

### 8.2 Table 3: breakthrough and cycle parameters

Table 3, "Parameters Used in Breakthrough and PSA Simulations" (Table 3). The entries used only by the cycle and the energy calculation follow in a second table below.

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|
| $L$ | column length | 1 | m | 1.0 | m | Table 3, p. 4255 | DM 26/11/26 |
| $r_{in}$ | "inner column radius" (Table 3) | 0.1445 | m | 0.1445 | m | Table 3, p. 4255 | DM 26/11/26 |
| $r_{out}$ | "outer column radius" (Table 3) | 0.1620 | m | 0.1620 | m | Table 3, p. 4255 | DM 26/11/26 |
| $\varepsilon$ | "column void fraction" (Table 3) | 0.37 | — | 0.37 | — | Table 3, p. 4255 | DM 26/11/26 |
| $\varepsilon_p$ | particle voidage | 0.35 | — | 0.35 | — | Table 3, p. 4255 | DM 26/11/26 |
| $r_p$ | particle radius | 1.0 × 10⁻³ | m | 1.0e-3 | m | Table 3, p. 4255 | DM 26/11/26 |
| $\tau'$ | tortuosity | 3 | — | 3.0 | — | Table 3, p. 4255 | DM 26/11/26 |
| $\rho_s$ | "adsorbent density" (Table 3) | 1130 | kg m⁻³ | 1130.0 | kg m⁻³ | Table 3, p. 4255 | DM 26/11/26 |
| $\rho_w$ | "column wall density" (Table 3) | 7800 | kg m⁻³ | 7800.0 | kg m⁻³ | Table 3, p. 4255 | DM 26/11/26 |
| $C_{p,g}$ | "specific heat capacity of gas phase" (Table 3) | 30.7 | J mol⁻¹ K⁻¹ | 30.7 | J mol⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $C_{p,a}$ | "specific heat capacity of adsorbed phase" (Table 3) | 30.7 | J mol⁻¹ K⁻¹ | 30.7 | J mol⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $C_{p,s}$ | "specific heat capacity of adsorbent" (Table 3) | 1070 | J kg⁻¹ K⁻¹ | 1070.0 | J kg⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $C_{p,w}$ | "specific heat capacity of column wall" (Table 3) | 502 | J kg⁻¹ K⁻¹ | 502.0 | J kg⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $\mu$ | fluid viscosity | 1.72 × 10⁻⁵ | kg m⁻¹ s⁻¹ | 1.72e-5 | Pa s | Table 3, p. 4255 | DM 26/11/26 |
| $D_m$ | molecular diffusivity | 1.60 × 10⁻⁵ | m² s⁻¹ | 1.60e-5 | m² s⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $K_z$ | effective gas thermal conductivity | 0.09 | J m⁻¹ K⁻¹ s⁻¹ | 0.09 | W m⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $K_w$ | thermal conductivity of column wall | 16 | J m⁻¹ K⁻¹ s⁻¹ | 16.0 | W m⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $h_{in}$ | inside heat transfer coefficient | 8.6 | J m⁻² K⁻¹ s⁻¹ | 8.6 (DCB: 0, Sec. 5) | W m⁻² K⁻¹ | Table 3, p. 4255; p. 4254 | DM 26/11/26 |
| $h_{out}$ | outside heat transfer coefficient | 2.5 | J m⁻² K⁻¹ s⁻¹ | 2.5 (DCB: 0, Sec. 5) | W m⁻² K⁻¹ | Table 3, p. 4255; p. 4254 | DM 26/11/26 |
| $R$ | universal gas constant | 8.314 | m³ Pa mol⁻¹ K⁻¹ | 8.314 | Pa m³ mol⁻¹ K⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $v_{feed}$ | "interstitial feed velocity" (Table 3) | 1 | m s⁻¹ | 1.0 | m s⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $T_{feed}$ | "feed temperature" (Table 3) | 298.15 | K | 298.15 | K | Table 3, p. 4255 | DM 26/11/26 |
| $T_a$ | ambient temperature | 298.15 | K | 298.15 | K | Table 3, p. 4255 | DM 26/11/26 |
| $P_H$ | "high pressure" (Table 3) | 1 | bar | 1 × 10⁵ = 1.0e5 | Pa | Table 3, p. 4255; also Sec. 5, p. 4254 | DM 26/11/26 |
| $P_0$ | spec wording: reference pressure; Table 3 prints the symbol only, under "constants for dimensionless parameters" (Table 3) | $P_H$ | bar | 1.0e5 | Pa | Table 3, p. 4255 | DM 26/11/26 |
| $T_0$ | spec wording: reference temperature; Table 3 prints the symbol only, under "constants for dimensionless parameters" (Table 3) | $T_{feed}$ | K | 298.15 | K | Table 3, p. 4255 | DM 26/11/26 |
| $v_0$ | spec wording: reference velocity; Table 3 prints the symbol only, under "constants for dimensionless parameters" (Table 3) | $v_{feed}$ | m s⁻¹ | 1.0 | m s⁻¹ | Table 3, p. 4255 | DM 26/11/26 |
| $q_{s,0}$ | spec wording: reference solid concentration; Table 3 prints the symbol only, under "constants for dimensionless parameters" (Table 3) | $q_{sb,N_2}$ | mmol g⁻¹ | 5.84 | mol kg⁻¹ (E1) | Table 3, p. 4255 | DM 26/11/26 |

### 8.3 Table 3, remaining entries, and energy constants

Table 3, remaining entries (p. 4255), and constants given in the energy section (p. 4260):

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|
| $P_f$ | "flue gas pressure" (Table 3) | 1 | bar | 1.0e5 | Pa | Table 3, p. 4255; "Pf is taken as 1 bar" (p. 4260) |  DM 26/11/26 |
| $\gamma$ | adiabatic constant | 1.4 | — | 1.4 | — | Table 3, p. 4255; p. 4260 |  DM 26/11/26 |
| $\eta$ | compression/evacuation efficiency | 0.72 | — | 0.72 | — | Table 3, p. 4255; p. 4260 |  DM 26/11/26 |
| $P_I$ | "intermediate pressure" (Table 3), in the Table 3 group "operating conditions for case studies" (Table 3) | 0.2 | bar | 2.0e4 | Pa | Table 3, p. 4255 |  DM 26/11/26 |
| $P_L$ | "low pressure" (Table 3), in the Table 3 group "operating conditions for case studies" (Table 3) | 0.1 | bar | 1.0e4 | Pa | Table 3, p. 4255 |  DM 26/11/26 |
| $P_{atm}$ | spec wording: atmospheric pressure | 1 | bar | 1.0e5 | Pa | "where Patm= 1 bar" (p. 4260) |  DM 26/11/26 |
| — | spec wording: vacuum pump discharge pressure | 1 | bar | 1.0e5 | Pa | "all vacuum pumps discharge at 1 bar" (p. 4260) |  DM 26/11/26 |

### 8.4 Derived values

Derived values: not printed in the paper; each is computed from printed values by the formula given (spec wording). The numerical values are computed in code, not copied here.

| Symbol | Description | Formula | Inputs | SI unit | Verified |
|---|---|---|---|---|---|
| $d_p$ | "the diameter of the adsorbent particle" (Eq. 42) | $d_p = 2r_p$ | $r_p$ (Table 3) | m | DM 26/11/26|
| $A$ | cross-sectional area of the column | $A = \pi r_{in}^2$; Eqs. (66)–(69) write the cross-section as $\pi r_{in}^2$ | $r_{in}$ (Table 3) | m² | DM 26/11/26|
| $y_{N_2,feed}$ | spec wording: feed N2 mole fraction | $y_{N_2,feed} = 1 - y_{CO_2,feed}$; the cycle feed is printed as "15 mol % CO2 and 85 mol % N2" (p. 4255); spec wording: the DCB feed is taken to be the same | $y_{CO_2,feed}$ (Sec. 5 text; Table 4) | — | DM 26/11/26|

### 8.5 Table 4: step parameters

Table 4, "Specific Parameters for Each Step in the Four-Step PSA Simulation" (Table 4); spec wording: base case. Table 4 prints symbols and values only, per step: "pressurization", "adsorption", "forward blowdown", "reverse evacuation" (Table 4). The descriptions below are spec wording, except rate of pressure change for $\lambda$:

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|
| $t_{press}$ | pressurisation duration | 15 | s | 15.0 | s | Table 4, p. 4257 |  DM 26/11/26 |
| $y_{feed,CO_2}$ | feed CO2 mole fraction (pressurisation and adsorption) | 0.15 | — | 0.15 | — | Table 4, p. 4257 |  DM 26/11/26 |
| $\lambda$ | rate of pressure change (pressurisation, blowdown, evacuation) | 0.5 | s⁻¹ | 0.5 | s⁻¹ | Table 4, p. 4257 |  DM 26/11/26 |
| $P_L \to P_H$ | pressurisation range | 0.1 → 1.0 | bar | 1.0e4 → 1.0e5 | Pa | Table 4, p. 4257 |  DM 26/11/26 |
| $t_{ads}$ | adsorption duration | 15 | s | 15.0 | s | Table 4, p. 4257 |  DM 26/11/26 |
| $v_{feed}$ | feed velocity, adsorption | 1 | m s⁻¹ | 1.0 | m s⁻¹ | Table 4, p. 4257 |  DM 26/11/26 |
| $P_H$ | adsorption pressure | 1.0 | bar | 1.0e5 | Pa | Table 4, p. 4257 |  DM 26/11/26 |
| $t_{bd}$ | blowdown duration | 30 | s | 30.0 | s | Table 4, p. 4257 |  DM 26/11/26 |
| $P_H \to P_I$ | blowdown range | 1.0 → 0.2 | bar | 1.0e5 → 2.0e4 | Pa | Table 4, p. 4257 |  DM 26/11/26 |
| $t_{evac}$ | evacuation duration | 40 | s | 40.0 | s | Table 4, p. 4257 |  DM 26/11/26 |
| $P_I \to P_L$ | evacuation range | 0.2 → 0.1 | bar | 2.0e4 → 1.0e4 | Pa | Table 4, p. 4257 |  DM 26/11/26 |

### 8.6 Table 6: minimum-energy operating points

Table 6, "Operating Conditions Corresponding to Minimum Energy for Four-Step PVSA Cycle at Different Evacuation Pressures" (Table 6). These are results; they are also listed as validation target V7.

| Case | $t_{ads}$ [s] | $t_{bd}$ [s] | $t_{evac}$ [s] | $P_I$ [bar] | $P_H$ [bar] | $v_{feed}$ [m s⁻¹] | total energy [kWh t⁻¹] | Verified |
|---|---|---|---|---|---|---|---|---|
| $P_L$ = 0.005 bar | 89.55 | 34.54 | 120.7 | 0.26 | 1.00 | 0.91 | 213.22 |  DM 26/11/26 |
| $P_L$ = 0.01 bar | 80.24 | 54.05 | 101.83 | 0.22 | 1.00 | 0.86 | 176.14 |  DM 26/11/26 |
| $P_L$ = 0.02 bar | 94.89 | 122.84 | 189.46 | 0.18 | 1.00 | 0.58 | 148.96 |  DM 26/11/26 |
| $P_L$ = 0.03 bar | 69.36 | 30.95 | 124.27 | 0.22 | 1.76 | 0.41 | 201.50 |  DM 26/11/26 |
| $P_L$ = 0.05 bar | 91.63 | 161.32 | 195.24 | 0.43 | 3.54 | 0.19 | 298.92 |  DM 26/11/26 |
| $P_L$ = 0.07 bar | 70.93 | 54.13 | 88.45 | 0.53 | 5.73 | 0.15 | 388.68 |  DM 26/11/26 |
| $P_L$ = 0.1 bar | 97.36 | 94.52 | 128.45 | 1.07 | 9.04 | 0.11 | 499.65 |  DM 26/11/26 |

SI conversions for Table 6: bar × 1.0e5 = Pa; 1 kWh t⁻¹ = 3.6e6 J / 1.0e3 kg = 3.6e3 J kg⁻¹ (e.g. 148.96 kWh t⁻¹ = 5.36256e5 J kg⁻¹).

### 8.7 Not given in the paper

Not given anywhere in the paper or SI (see Section 12):

| Symbol | Description | Value as printed | Unit as printed | SI value | SI unit | Source (table, page) | Verified |
|---|---|---|---|---|---|---|---|
| $\Delta H_{CO_2}$, $\Delta H_{N_2}$ | "heat of adsorption of component i" (Eq. A.8); $H$ = enthalpy | not given | — | — | J mol⁻¹ | used in Eq. (4) via $\sigma_i$, (A.8); M1 | DM 26/11/26|
| $M_{CO_2}$ | spec wording: molar mass of CO2 (not in the paper or SI) | not given | — | — | kg mol⁻¹ | needed for "mass of CO2" (p. 4261) in Eq. (70); M4 | DM 26/11/26|
| — | "total volume of the adsorbent" (Eq. 71) | not defined | — | — | m³ | used in Eq. (71); M5 | DM 26/11/26|

## 9. Numerical method used in the source
For information only. This project's own choices, where different, are logged in `docs/deviations.md`.

### 9.1 Spatial discretisation and discretised balances (Eqs. 19–24)
- Verified: DM 26/11/26 

- Spatial discretisation: finite volume, $N$ cells of volume $\Delta V$; faces $j \pm 0.5$; inlet face $0.5$, outlet face $N+0.5$ (Figure 1, p. 4251). Cell average (Eq. 19, p. 4252):

```math
f_j(t) = \frac{1}{\Delta V}\int_{V_j} f(t)\,\mathrm dV
```

- Discretised balances (p. 4252). "It should be noted that the dispersion term in eq 20 is approximated using a combination of forward difference and finite volume schemes." (p. 4252)

Eq. (20):

$$
\frac{\partial y_{i,j}}{\partial \tau} = \frac{1}{Pe}\frac{\bar T_j}{\bar P_j}\frac{1}{\Delta Z}\left(\left.\frac{\bar P}{\bar T}\right|_{j+0.5}\frac{y_{i,j+1} - y_{i,j}}{\Delta Z} - \left.\frac{\bar P}{\bar T}\right|_{j-0.5}\frac{y_{i,j} - y_{i,j-1}}{\Delta Z}\right) - \frac{\bar T_j}{\bar P_j}\frac{1}{\Delta Z}\left(\left.\frac{y_i\bar P}{\bar T}\bar v\right|_{j+0.5} - \left.\frac{y_i\bar P}{\bar T}\bar v\right|_{j-0.5}\right) - \psi\frac{\bar T_j}{\bar P_j}\frac{\partial x_{i,j}}{\partial \tau} - \frac{y_{i,j}}{\bar P_j}\frac{\partial \bar P_j}{\partial \tau} + \frac{y_{i,j}}{\bar T_j}\frac{\partial \bar T_j}{\partial \tau}
$$

Eq. (21):

$$
\frac{\partial \bar P_j}{\partial \tau} = -\frac{\bar T_j}{\Delta Z}\left(\left.\frac{\bar P}{\bar T}\bar v\right|_{j+0.5} - \left.\frac{\bar P}{\bar T}\bar v\right|_{j-0.5}\right) - \psi\bar T_j\sum_{i=1}^{n_{comp}}\frac{\partial x_{i,j}}{\partial \tau} + \frac{\bar P_j}{\bar T_j}\frac{\partial \bar T_j}{\partial \tau}
$$

Eq. (22):

$$
\frac{\partial x_{i,j}}{\partial \tau} = \alpha_i\left(x_{i,j}^* - x_{i,j}\right)
$$

Eq. (23):

$$
\frac{\partial \bar T_j}{\partial \tau} = \Omega_{1,j}\frac{1}{\Delta Z}\left(\frac{\bar T_{j+1} - \bar T_j}{\Delta Z} - \frac{\bar T_j - \bar T_{j-1}}{\Delta Z}\right) - \Omega_{2,j}\frac{1}{\Delta Z}\left(\bar v\bar P|_{j+0.5} - \bar v\bar P|_{j-0.5}\right) - \Omega_{3,j}\bar T_j\sum_{i=1}^{n_{comp}}\frac{\partial x_{i,j}}{\partial \tau} + \sum_{i=1}^{n_{comp}}\left(\sigma_{i,j}\frac{\partial x_{i,j}}{\partial \tau}\right) - \Omega_{4,j}\left(\bar T_j - \bar T_{w,j}\right) - \Omega_{2,j}\frac{\partial \bar P_j}{\partial \tau}
$$

Eq. (24):

$$
\frac{\partial \bar T_{w,j}}{\partial \tau} = \Pi_1\frac{1}{\Delta Z}\left(\frac{\bar T_{w,j+1} - \bar T_{w,j}}{\Delta Z} - \frac{\bar T_{w,j} - \bar T_{w,j-1}}{\Delta Z}\right) + \Pi_2\left(\bar T_j - \bar T_{w,j}\right) - \Pi_3\left(\bar T_{w,j} - \bar T_{a,j}\right)
$$

### 9.2 Face reconstruction: WENO (Eqs. 30–31)
- Verified: DM 26/11/26

- WENO, Eqs. (30)–(31) (pp. 4252–4253):

$$
f_{j+0.5} = \frac{\alpha_{0,j}}{\alpha_{0,j} + \alpha_{1,j}}\left[\frac{1}{2}\left(f_j + f_{j+1}\right)\right] + \frac{\alpha_{1,j}}{\alpha_{0,j} + \alpha_{1,j}}\left[\frac{3}{2}f_j - \frac{1}{2}f_{j-1}\right]
$$

$$
\alpha_{0,j} = \frac{2/3}{\left(f_{j+1} - f_j + \delta\right)^4},\qquad \alpha_{1,j} = \frac{1/3}{\left(f_j - f_{j-1} + \delta\right)^4}
$$

with $\delta$ "a very small number, typically $10^{-10}$" (p. 4252). ($\alpha_{0,j}$, $\alpha_{1,j}$ here are WENO weights, not the LDF $\alpha_i$.) Which quantities are reconstructed at faces is not stated explicitly (U4).

### 9.3 Half-cell approximation, face velocities and inlet pressure (Eqs. 32–36)
- Verified: DM 26/11/26 

- Half-cell approximation at the inlet in place of a ghost cell, Eq. (32), p. 4253: $f_1 - f_0 = 2(f_1 - f_{0.5})$, with $f_{0.5}$ and $f_{N+0.5}$ from the boundary conditions (SI Table 2).
- Face velocities from Eq. (7), Eqs. (33)–(35), p. 4253:

$$
\bar v_{j+0.5} = -\frac{1}{\Delta Z}\frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2 r_p^2\frac{P_0}{\mu v_0 L}\left(\bar P_{j+1} - \bar P_j\right)
$$

$$
\bar v_{0.5} = \bar v|_{Z=0} = -\frac{2}{\Delta Z}\left[\frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2\right] r_p^2\frac{P_0}{\mu v_0 L}\left(\bar P_1 - \bar P_{0.5}\right)
$$

$$
\bar v_{N+0.5} = \bar v|_{Z=1} = -\frac{2}{\Delta Z}\left[\frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2\right] r_p^2\frac{P_0}{\mu v_0 L}\left(\bar P_{N+0.5} - \bar P_N\right)
$$

- Inlet pressure from a known inlet velocity, Eq. (36), p. 4253:

$$
\bar P_{0.5} = \bar P|_{Z=0} = \bar P_1 + \frac{\bar v_{0.5}\frac{\Delta Z}{2}}{\left[\frac{4}{150}\left(\frac{\varepsilon}{1-\varepsilon}\right)^2\right] r_p^2\frac{P_0}{\mu v_0 L}}
$$

### 9.4 Time integration
- Verified: DM 26/11/26 

- Time integration: the coupled ODE system is solved with MATLAB `ode23s` (stiff) (p. 4253). Tolerances are not stated.

### 9.5 Breakthrough runs
- Verified: DM 26/11/26 

- DCB runs: reference solution WENO with $N = 2000$ (pp. 4254, 4255). Completion criterion: "The breakthrough of CO2 is considered complete only after the heat front exits the column." (p. 4254)

### 9.6 Cycle runs
- Verified: DM 26/11/26 

- Cycle runs (Sec. 6, pp. 4255–4257; the items below are on pp. 4256–4258):
  - Cyclic steady state definition: "Strictly, a CSS condition is reached when there is no change in the column profiles of all state variables after each step for two consecutive cycles." (p. 4256)
  - Reference: WENO with $N = 1000$. "all simulations were performed up to 500 cycles to ensure the attainment of CSS" (p. 4257). Figure 8 is labelled $n_{cycle} = 500$.
  - Choice for optimisation: "we will use WENO with N = 30" (p. 4257).

### 9.7 Runs behind Table 6 (Sec. 7.2)
- Verified: DM 26/11/26 

- Conditions: "we use the compositions and conditions from section 6 and Table 4 and employ the nondominated sorting genetic algorithm II (NSGA-II)" (p. 4258). Spec wording: of Table 4, this carries over $y_{feed,CO_2}$ and $\lambda$ (8.5); the other operating values are those of each Table 6 row (8.6), and $t_{press}$ is fixed at 20 s (A4).
- $t_{press}$: "fixed at 20 s, since a shorter duration is unrealistic in industrial scale operation and a longer duration has negligible effect on process performance." (p. 4259)
- CSS criterion in the optimisation: "A mass balance error of less than 0.5% for five consecutive cycles is specified as the criterion for attainment of CSS." (p. 4258) The cycle mass balance error is not defined (U7).
- "we consider the optimization of the PVSA process only" (p. 4260). $P_L$ is fixed at seven levels. Constraints purity ≥ 90 % and recovery ≥ 90 % "are incorporated by penalizing each objective function" (p. 4261).

## 10. Reported quantities and their definitions
Open items affecting these definitions are in Section 12; each names the equations it affects.

### 10.1 Cycle performance (Eqs. 60–64)

| Quantity | Definition | Eq. | Page | Verified |
|---|---|---|---|---|
| "CO2 purity and recovery at CSS" (p. 4256); spec wording: purity | $`\text{purity}(\%) = \left[\dfrac{\text{mole}_{out,CO_2}\vert_{evac}}{\text{mole}_{out,CO_2}\vert_{evac} + \text{mole}_{out,N_2}\vert_{evac}}\right] \times 100`$ | (60) | 4256 | DM 26/11/26 |
| "CO2 purity and recovery at CSS" (p. 4256); spec wording: recovery | $`\text{recovery}(\%) = \left[\dfrac{\text{mole}_{out,CO_2}\vert_{evac}}{\text{mole}_{in,CO_2}\vert_{press} + \text{mole}_{in,CO_2}\vert_{ads}}\right] \times 100`$ | (61) | 4256 | DM 26/11/26 |
| spec wording: CO2 in, per step | $`\text{mole}_{in,CO_2} = \dfrac{P_0 v_0}{R T_0}\varepsilon A\displaystyle\int_0^{\tau_{step}}\left[\bar v_{0.5}(\tau)\frac{y_{0.5}\,\bar P_{0.5}(\tau)}{\bar T_{0.5}(\tau)}\right]\mathrm d\tau`$ | (62) | 4257 | DM 26/11/26 |
| spec wording: CO2 out, per step | $`\text{mole}_{out,CO_2} = \dfrac{P_0 v_0}{R T_0}\varepsilon A\displaystyle\int_0^{\tau_{step}}\left[\bar v_{N+0.5}(\tau)\frac{y_{N+0.5}(\tau)\,\bar P_{N+0.5}(\tau)}{\bar T_{N+0.5}(\tau)}\right]\mathrm d\tau`$ | (63) | 4257 | DM 26/11/26 |
| evac = evacuation step; spec wording: CO2 out in the evacuation (at $Z=0$) | $`\text{mole}_{out,CO_2}\vert_{evac} = \dfrac{P_0 v_0}{R T_0}\varepsilon A\displaystyle\int_0^{\tau_{evac}}\left[\bar v_{0.5}(\tau)\frac{y_{0.5}(\tau)\,\bar P_{0.5}(\tau)}{\bar T_{0.5}(\tau)}\right]\mathrm d\tau`$ | (64) | 4257 | DM 26/11/26 |

### 10.2 Energy and productivity (Eqs. 66–72)

| Quantity | Definition | Eq. | Page | Verified |
|---|---|---|---|---|
| "the energy consumption for each step" (p. 4260); press = pressurization step | $`E_{press} = \begin{cases}\dfrac{1}{\eta}\varepsilon\pi r_{in}^2 v_0 P_0\dfrac{\gamma}{\gamma-1}\displaystyle\int_{t=0}^{t=t_{press}}\left(\bar v\bar P\vert_{Z=0}\right)\left[\left(\dfrac{P_0\bar P\vert_{Z=0}}{P_f}\right)^{(\gamma-1)/\gamma} - 1\right]\mathrm dt & \text{if } P\vert_{z=0} > P_f\\ 0 & \text{if } P\vert_{z=0} \leq P_f\end{cases}`$ | (66) | 4260 | DM 26/11/26 |
| "the energy consumption for each step" (p. 4260); ads = adsorption step | $`E_{ads} = \dfrac{1}{\eta}\varepsilon\pi r_{in}^2 v_0 P_0\dfrac{\gamma}{\gamma-1}\displaystyle\int_{t=0}^{t=t_{ads}}\left(\bar v\bar P\vert_{Z=0}\right)\left[\left(\dfrac{P_0\bar P\vert_{Z=0}}{P_f}\right)^{(\gamma-1)/\gamma} - 1\right]\mathrm dt`$ | (67) | 4260 | DM 26/11/26 |
| "the energy consumption for each step" (p. 4260); bd = blowdown step | $`E_{bd} = \begin{cases}\dfrac{1}{\eta}\varepsilon\pi r_{in}^2 v_0 P_0\dfrac{\gamma}{\gamma-1}\displaystyle\int_{t=0}^{t=t_{bd}}\left(\bar v\bar P\vert_{Z=1}\right)\left[\left(\dfrac{P_{atm}}{P_0\bar P\vert_{Z=1}}\right)^{(\gamma-1)/\gamma} - 1\right]\mathrm dt & \text{if } P\vert_{z=L} < 1\text{ bar}\\ 0 & \text{if } P\vert_{z=L} \geq 1\text{ bar}\end{cases}`$ | (68) | 4260 | DM 26/11/26 |
| "the energy consumption for each step" (p. 4260); evac = evacuation step | $`E_{evac} = \dfrac{1}{\eta}\varepsilon\pi r_{in}^2 v_0 P_0\dfrac{\gamma}{\gamma-1}\displaystyle\int_{t=0}^{t=t_{evac}}\left(\bar v\bar P\vert_{Z=0}\right)\left[\left(\dfrac{P_{atm}}{P_0\bar P\vert_{Z=0}}\right)^{(\gamma-1)/\gamma} - 1\right]\mathrm dt`$ | (69) | 4260 | DM 26/11/26 |
| "total energy consumption in terms of kilowatt hours per metric ton of CO2 captured" (p. 4260) | $`E_T\left[\dfrac{\text{kWh}}{\text{t of CO}_2\text{ captured}}\right] = \dfrac{E_{press} + E_{ads} + E_{bd} + E_{evac}}{\text{mass of CO}_2\text{ in the extract stream(s) per cycle}}`$ | (70) | 4261 | DM 26/11/26 |
| "Productivity" (p. 4261) | $`\text{productivity}\left[\dfrac{\text{mol}}{\text{m}^3\text{ adsorbent}\cdot\text{s}}\right] = \dfrac{\text{mole}_{out,CO_2}\vert_{evac}}{(\text{total volume of the adsorbent})(\text{cycle time})}`$ | (71) | 4261 | DM 26/11/26 |
| "parasitic energy or energy penalty" (p. 4261) | $`\text{parasitic energy or energy penalty} = \dfrac{\text{energy required for CO}_2\text{ capture}}{\text{energy produced by power plant}}`$ | (72) | 4261 | DM 26/11/26 |

### 10.3 Notes
- Verified: DM 26/11/26 

- Text on the energy model: "During the pressurization step, the pressure increases from PL to PH. If PH > Pf, then no energy is required to take the column from PL to Pf, while compression is required to take it from Pf to PH. During the adsorption step, if PH = Pf, then energy is required only to overcome the frictional pressure drop in the column. However, if PH > Pf, then energy is required to compress the feed gas from Pf to PH. ... If PI > 1 bar, then the blowdown step does not require any energy. However, if PI < 1 bar, then energy is required only to evacuate from 1 bar to PI. ... If PI > 1 bar, then energy is required only to evacuate from 1 bar to PL. If PI < 1 bar, then energy is required to evacuate from PI and PL." (p. 4260)
- Eqs. (66)–(69) integrate over dimensional $t$ (not $\tau$).
- Eq. (70): spec wording: "extract stream(s)" (p. 4261) for this cycle is the evacuation product; Figure 7 shows "CO2 rich (Extract)" leaving at Z = 0 in the evacuation (p. 4257).

## 11. Validation targets
Results in the source that this project can reproduce. Once a row is verified, the user copies it into `test/reference/haghpanah2013.toml` with a tolerance.

### 11.1 Breakthrough targets (V1–V4, V9)

Common conditions for V2–V4 and V9: the breakthrough set-up of 7.1, with the Table 3 parameters (8.2) and derived values (8.4).

| ID | Figure or Table | Operating conditions | Quantity | Value | Printed or digitised | Page | Verified |
|---|---|---|---|---|---|---|---|
| V1 | Figure 3 | 25 °C, single component, P from 0 to 0.15 bar | $q^*$ of CO2 and N2 vs P (mmol g⁻¹) from Eq. (37), Table 2 | curve; to digitise | digitised | 4253 |  DM 26/11/26 |
| V2 | Figure 4a–c | common; WENO, $N$ = 2000 | (a) $y_{CO_2}$, $T/T_0$, $v/v_0$ (axis labels) "at the exit of the adsorption column" (p. 4256) vs time ("Time [-]" (p. 4256), 0–8000); (b), (c) close-ups of $y_{CO_2}$ "at the two transitions" (p. 4256), time 490–550 and 3000–4400: only the curve with the legend label "WENO N=2000" (p. 4256), the reference of the text (p. 4254) | curves; to digitise | digitised | 4256 |  |
| V3 | Sec. 5 text | common; WENO, $N$ = 2000 | time of "the sharp transition ... representing the breakthrough of the CO2 front" (p. 4254), in the Figure 4a profiles "at the column exit" (p. 4254) | "t ∼ 520 s" (p. 4254) | printed (approximate) | 4254 |  DM 26/11/26 |
| V4 | Sec. 5 text | common; WENO, $N$ = 2000 | time of the second transition, "corresponding to the elution of the heat front" (p. 4254), in the Figure 4a profiles "at the column exit" (p. 4254) | "around 3600 s" (p. 4254) | printed (approximate) | 4254 |  DM 26/11/26 |
| V9 | Figure 4b, c | common; UDS (Eq. 25, p. 4252), $N$ = 200 (caption, p. 4256) | $y_{CO_2}$ at the exit of the column vs time "at the two transitions" (p. 4256), time 490–550 and 3000–4400: the curve with the legend label "UDS" (p. 4256) | curves; to digitise | digitised | 4256 |  |

### 11.2 Cycle targets (V5–V8)

Common conditions for V5, V6: the four-step cycle of 7.5–7.9, with the Table 3 parameters (8.2) and the Table 4 base case (8.5).

| ID | Figure or Table | Operating conditions | Quantity | Value | Printed or digitised | Page | Verified |
|---|---|---|---|---|---|---|---|
| V5 | Sec. 6.1 text | common; WENO, $N$ = 1000; at CSS (500 cycles) | CO2 purity; CO2 recovery | 88.74 %; 35.83 % | printed | 4257 |  DM 26/11/26 |
| V6 | Figure 8 | common; WENO, $N$ = 1000; $n_{cycle}$ = 500 | profiles of $T/T_0$, $q_{CO_2}/q_{s,0}$, $y_{CO_2}$ vs $Z$ at the end of each step | curves; to digitise | digitised | 4258 |  DM 26/11/26 |
| V7 | Table 6 | PVSA; $t_{press}$ = 20 s (A4); each row's $t_{ads}$, $t_{bd}$, $t_{evac}$, $P_I$, $P_H$, $v_{feed}$, $P_L$ | "total energy [kWh t−1]" (p. 4261) at the given operating point; purity ≥ 90 % and recovery ≥ 90 % (the optimisation constraints) | 213.22; 176.14; 148.96; 201.50; 298.92; 388.68; 499.65 (rows $P_L$ = 0.005 … 0.1 bar) | printed | 4261 |  DM 26/11/26 |
| V8 | Sec. 8 Conclusions, item 2 | VSA mode, $P_L$ = 0.02 bar (Table 6 row) | minimum energy; productivity; energy penalty | "149 kWh/t of CO2 captured" (p. 4262); "0.49 mol of CO2/m3 of adsorbent/s" (p. 4262); "11%" (p. 4262) | printed | 4262 |  DM 26/11/26 |

V7 and V8 are single simulations at the Table 6 operating points. V7 needs Eqs. (66)–(70) and so M4. V8 also needs M5 and M6.

Qualitative results printed in the text:
- V5, V6: "The high purity can be rationalized by considering the high feed velocity during the adsorption step and the high capacity of zeolite 13X for CO2 (cf. Figure 8b). ... It can be seen that the CO2 front reaches the light-product end of the column at the end of the adsorption step. Due to this, CO2 is lost along with nitrogen during the blowdown step, resulting in a low recovery." (p. 4257)

### 11.3 Notes
- Verified: DM 26/11/26 

Notes:
- All targets except V1 depend on the open heat of adsorption (M1), through the energy balance.

## 12. Ambiguities and errata
IDs by type. E, erratum: a printed item that cannot be right as printed. A, ambiguity: two places in the paper disagree, so more than one reading is possible. U, unstated: a detail the model needs is not stated. M, missing: a value, definition or reference is not given. "DCB:" or "Cycle:" at the start of an Item marks an item that affects only the breakthrough or only the cycle and optimisation; unmarked items affect both.

### 12.1 Errata (E)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| E1 | Unit of $q$, $`q^*`$, $`q_{sb}`$, $`q_{sd}`$, $`q_{s,0}`$ (pp. 4264, 4253, 4255) | Printed in mmol g⁻¹ for $q$, $`q_{sb}`$, $`q_{sd}`$ (p. 4264), $`q_{sb,i}`$, $`q_{sd,i}`$ (Table 2) and $`q_{s,0}`$ (Table 3); for $`q^*`$ only on the Figure 3 axis, "q* [mmol/g]" (p. 4253). Dimensional consistency of (A.2), (A.3), (A.8), Eq. (40), $\psi$, $`\Omega_1..\Omega_4`$, $`\sigma_i`$ (SI Table 1) requires $q$ per unit volume (mol m⁻³). No conversion factor is stated. | (a) multiply mass-based loadings by $`\rho_s`$ = 1130 kg m⁻³, "densities of the particles" (p. 4263), to get mol m⁻³ of particle; (b) another density or basis not stated in the paper | (a): $`q\,[\text{mol m}^{-3}] = \rho_s\,q\,[\text{mol kg}^{-1}]`$, per unit particle volume. In (A.8), $`C_{p,a}\sum_i q_i`$ is added to $`\rho_s C_{p,s}`$ [J m⁻³ K⁻¹] inside the same $\frac{1-\varepsilon}{\varepsilon}$ bracket, so $q$ is on the same per-particle-volume basis as $`\rho_s`$. The factor $(1-\varepsilon)$ already present in (A.2), (A.3), (A.8) converts per-particle-volume to per-bed-volume, so $q$ must be per particle volume and the conversion density is the particle density; no further $(1-\varepsilon)$ is applied. $`\rho_s`$ is defined as "densities of the particles" (p. 4263). Applies to $q$, $`q^*`$, $`q_{sb,i}`$, $`q_{sd,i}`$ and $`q_{s,0}`$ alike. |  DM 27/11/26 |
| E2 | Eq. (A.1), p. 4262 | Printed $-\partial_z[c D_L \partial_z y_i + c_i v]$ gives the dispersion term the opposite sign to (A.2) and Eq. (1), i.e. anti-diffusive. | (a) printing error in (A.1), with (A.2) and Eq. (1) correct; (b) (A.1) correct and (A.2), (1) wrong | (a): the dispersive flux inside the bracket should read $`-c D_L\,\partial_z y_i`$, giving $`\partial_t c_i = +\partial_z(c D_L\,\partial_z y_i) - \partial_z(c_i v) - \frac{1-\varepsilon}{\varepsilon}\partial_t q_i`$. The leading minus is correct for the convective term. As printed, with constant $c$, $D_L$ and no flow, (A.1) reduces to $`\partial_t y_i = -D_L\,\partial_z^2 y_i`$, the backward heat equation: ill-posed, with modes of wavenumber $k$ growing as $e^{D_L k^2 t}$. (A.2), derived from (A.1) on the same page, Eq. (1) and Eq. (20) all carry the diffusive sign. The model is implemented from Eq. (1) and (20), not from (A.1). | DM 27/11/26|
| E3 | Eqs. (62)–(64), p. 4257 | Dimensionally inconsistent as printed: the $\int\mathrm d\tau$ terms (62)–(64) lack a factor $`L/v_0`$ (s). Purity and recovery (Eqs. 60, 61) are ratios of these terms, so the missing factor cancels there. It does not cancel in productivity (Eq. 71), or in $`E_T`$ (Eq. 70), where energies integrated over dimensional $\mathrm dt$ (Eqs. 66–69) are divided by a CO2 amount from Eq. (64). In Sec. 6, $L$ = 1 m and $`v_0 = v_{feed}`$ = 1 m s⁻¹, so the numerical values are unchanged in SI units. At the Table 6 operating points $`v_0 = v_{feed}`$ (Table 3) is 0.11–0.91 m s⁻¹, so $`L/v_0 \neq`$ 1 s and the reading matters for V7 and V8. | (a) missing factor $`L/v_0`$, omitted because it equals 1 s in Sec. 6 | (a): each of (62)–(64) is multiplied by $`L/v_0`$, so that with $`\mathrm dt = (L/v_0)\,\mathrm d\tau`$ it is $`\int_0^{t_{step}}\dot n\,\mathrm dt`$, the amount in mol per step. As printed, the prefactor $`\frac{P_0 v_0}{R T_0}\varepsilon A`$ is in mol s⁻¹ and the integral is dimensionless, giving the amount per step divided by $`L/v_0`$. That is not a physical rate: $`L/v_0`$ is a reference time, not the step duration, and the printed value scales with step length like an amount. The paper uses these quantities as amounts: they are named $`\text{mole}_{in}`$, $`\text{mole}_{out}`$; Eq. (71) divides $`\text{mole}_{out,CO_2}\vert_{evac}`$ by cycle time to get mol m⁻³ s⁻¹; Eq. (70) divides energy by "mass of CO2 in the extract stream(s) per cycle". | DM 27/11/26|
| E4 | Cycle: Sign of $\bar v_{0.5}$ in Eq. (64) and of $\bar v$ in $(\bar v\bar P\vert_{Z=0})$ in Eq. (69) | In the reverse evacuation the flow is towards $Z=0$, so $\bar v_{0.5} < 0$. As printed, Eq. (64) gives a negative amount. Eq. (69) gives a negative energy while $P\vert_{z=0} < P_{atm}$; above $P_{atm}$ the bracket also changes sign (see E5). | (a) magnitude $\vert\bar v_{0.5}\vert$ intended; (b) velocity defined positive in the step's own flow direction, "ends interchanged" (p. 4263) | (b): in the reverse evacuation, Eqs. (64) and (69) use $-\bar v_{0.5}$, the velocity positive in the step's flow direction (towards $Z=0$), consistent with "the boundary conditions discussed above for forward flow will apply with their ends interchanged" (p. 4263). Eq. (64) then gives the net CO2 outflow over the step, with any backflow subtracted, which is the correct mass balance. (a) and (b) agree while $\bar v_{0.5} \le 0$ throughout the step: the step starts with the boundary at $P_I$ (Eq. 59) and the column at or above $P_I$ after the blowdown (Eq. 58, $Z=0$ closed), and the boundary pressure then falls monotonically to $P_L$. The sign of the bracket in Eq. (69) above $P_{atm}$ is E5. | DM 27/11/26|
| E5 | Cycle: Eq. (69), p. 4260 | No zero branch for $P\vert_{z=0} \geq 1$ bar, while the text says "If PI > 1 bar, then energy is required only to evacuate from 1 bar to PL" (p. 4260). As printed, $(P_{atm}/P_0\bar P\vert_{Z=0})^{(\gamma-1)/\gamma} - 1 < 0$ when $P > P_{atm}$. Relevant to PVSA rows with $P_I$ > 1 bar (Table 6, $P_L$ = 0.1 bar: $P_I$ = 1.07). | (a) add the branch (spec wording: 0 if $P\vert_{z=0} \geq 1$ bar), by analogy with Eq. (68), which prints 0 "if $P\vert_{z=L} \geq 1$ bar" (p. 4260); (b) as printed | (a): the integrand of Eq. (69) is 0 while $P\vert_{z=0} \geq P_{atm}$ (1 bar), and as printed otherwise. The text states "If PI > 1 bar, then energy is required only to evacuate from 1 bar to PL" (p. 4260). Eq. (68) (blowdown) and Eq. (66) (pressurization) both print the zero branch, and the paper models no energy recovery, so the negative bracket above $P_{atm}$ would be an unmodelled expander credit. $P\vert_{z=0}$ is the boundary pressure of Eq. (59), so the branch depends only on $P_I$, $P_L$, $\lambda$; with $P_I$ < 1 bar (base case, all Table 6 rows except $P_L$ = 0.1 bar) (a) and (b) coincide. | DM 27/11/26|

### 12.2 Ambiguities (A)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| A1 | $\psi$, SI Table 1 | Printed with $P_H$; derivation from (A.2) gives $P_0$. Equal here ($P_0 = P_H$, Table 3). | $P_0$ or $P_H$ | $P_0$: $\psi = \dfrac{R T_0 q_{s,0}}{P_0}\dfrac{1-\varepsilon}{\varepsilon}$, the form obtained by nondimensionalising (A.2) with $\bar P = P/P_0$, $\tau = t v_0/L$, $x_i = q_i/q_{s,0}$ (SI Table 1). Identical to the printed $P_H$ form, since $P_0 = P_H$ (Table 3; in the PVSA runs, U6). | DM 27/11/26|
| A2 | $\bar T_{0.5}$, SI Table 2, row "Adsorption (breakthrough)" (SI p. 2); the row "Pressurization" (SI p. 2) prints the same expression | Numerator $\bar T_1 + \bar v\vert_{Z=0} Pe_h\Delta Z/2$ omits $\bar T_{feed}$, which Eq. (10) contains. Equal here ($\bar T_{feed} = 1$ since $T_0 = T_{feed}$). Spec wording: discretising Eq. (8) with the half-cell approximation, Eq. (32), i.e. $\partial y_i/\partial Z\vert_{Z=0} \approx (y_{i,1} - y_{i,0.5})/(\Delta Z/2)$, gives the SI row for $y_{i,0.5}$ exactly, including $y_{i,feed}$; the same step applied to Eq. (10) gives $`\bar T_{0.5} = (\bar T_1 + \bar T_{feed}\,\bar v\vert_{Z=0} Pe_h\Delta Z/2)/(1 + \bar v\vert_{Z=0} Pe_h\Delta Z/2)`$. | include $\bar T_{feed}$ in general; or SI row specific to $T_0 = T_{feed}$ | include $\bar T_{feed}$ in general: in both SI Table 2 rows ("Adsorption (breakthrough)", "Pressurization"), $`\bar T_{0.5} = (\bar T_1 + \bar T_{feed}\,\bar v\vert_{Z=0} Pe_h\Delta Z/2)/(1 + \bar v\vert_{Z=0} Pe_h\Delta Z/2)`$. This is Eq. (10) discretised with the half-cell approximation, Eq. (32), the same step that reproduces the SI row for $y_{i,0.5}$ from Eq. (8) with $y_{i,feed}$ retained. Identical to the printed rows, since $T_0 = T_{feed}$ (Table 3) gives $\bar T_{feed} = 1$. | DM 27/11/26|
| A3 | DCB: Figure 4 time axis, p. 4256 | Labelled "Time [-]" (p. 4256), i.e. dimensionless $\tau$; text quotes seconds. Coincide since $L/v_0$ = 1 s. | $\tau$ or $t$ in s | $\tau$, as labelled; numerically equal to $t$ in s since $L/v_0$ = 1 s ($L$ = 1 m, $v_0 = v_{feed}$ = 1 m s⁻¹, Table 3), so the text values in seconds (p. 4254) and the figure axis agree. No effect on V2–V4. | DM 27/11/26|
| A4 | Cycle: $t_{press}$ | 15 s in Table 4 (p. 4257; spec wording: base case); "fixed at 20 s" (p. 4259) in the optimisation. Table 6 lists no $t_{press}$. | 15 s for V5, V6; 20 s for V7, V8 | 15 s for V5, V6; 20 s for V7, V8. V5 and V6 are the Sec. 6.1 base case, whose step parameters are Table 4 (15 s). V7 and V8 are Table 6 operating points from the optimisation, in which $t_{press}$ is "fixed at 20 s" (p. 4259); its absence from Table 6 is consistent with it being fixed rather than optimised. | DM 27/11/26|

### 12.3 Unstated (U)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| U1 | $\rho_g$ in $Pe_h$, SI Table 1 | State at which $\rho_g$ is evaluated is not stated; $\rho_g$ varies with $P$ and $T$ (Eq. 54). | (a) $P_0/(RT_0)$, constant; (b) local value, so $Pe_h$ varies | (b), at the inlet face: $\rho_g = \rho_{g,0.5}(\tau)$ from Eq. (54), so $`Pe_h(\tau) = \dfrac{\varepsilon v_0 L}{K_z}\dfrac{P_0}{RT_0}C_{pg}\,\dfrac{\bar P_{0.5}(\tau)}{\bar T_{0.5}(\tau)}`$. $Pe_h$ is used only in the $Z=0$ temperature condition, Eq. (10). Its dimensional form, (A.12), $`K_z\,\partial_z T\vert_{z=0} = -\varepsilon v\vert_{z=0}\rho_g C_{p,g}(T_{feed} - T\vert_{z=0})`$ (p. 4263), is an energy-flux balance at the inlet face with local $v$; nondimensionalising it gives Eq. (10) with $\rho_g$ unchanged. The paper's own inlet enthalpy flux, "heat in", Eq. (48) (p. 4254), uses $\rho_{g,0.5}(\tau)$. | DM 27/11/26|
| U2 | $`c_i/q_i^*`$ in Eq. (40), p. 4253 | State at which the ratio is evaluated is not stated. | (a) local, time-varying; (b) at feed conditions, constant; (c) other reference state | (a): $`c_i/q_i^*`$ at the local state of each cell and time, evaluated as $`\dfrac{c_i}{q_i^*} = \left[\dfrac{q_{sb,i}\,b_i}{1+\sum_j b_j c_j} + \dfrac{q_{sd,i}\,d_i}{1+\sum_j d_j c_j}\right]^{-1}`$, which is Eq. (37) divided by $`c_i`$: an exact identity, finite as $`c_i \to 0`$ (inverse Henry constant), where the printed ratio is $0/0$ (e.g. CO2 in the initial 100 % N2 bed, U5). Eq. (40) writes the field variables $`c_i`$ (A.1) and $`q_i^*`$ (A.4) without the subscripts the paper uses for reference or feed values ($`v_0`$, $`P_0`$, $`q_{s,0}`$, $`y_{i,feed}`$), and where it fixes a coefficient at a reference state it says so ($`D_L`$ with $`v_0`$, Eq. 42). The factor converts the pore-gas driving force to a loading driving force through the isotherm, which is non-linear over the cycle's range of $P$ and $T$. | DM 27/11/26|
| U3 | DCB: initial condition, p. 4254 | "initially saturated with 100% N2 at PH = 1 bar" (p. 4254). Not stated for the DCB: initial $T$ and $T_w$; whether $P$ is uniform; the initial loading. The general statements on p. 4251 ("saturated with a known composition of gas at a particular temperature and pressure") and p. 4263 ("a bed equilibrated with the lighter component ... at the feed temperature at a specified pressure", written for the first step of a cyclic process) point to an equilibrated bed at $T_{feed}$, but neither is stated for the DCB. Nothing is said about $T_w$. | $T = T_w = T_{feed} = T_a$ = 298.15 K; uniform $\bar P = 1$; $x_i$ in equilibrium with pure N2 at $P_H$, $T_{feed}$ | As candidate: at $\tau = 0$, uniformly in $Z$, $y_{N_2} = 1$, $y_{CO_2} = 0$; $\bar P = 1$ ($P = P_H = P_0$ = 1 bar); $\bar T = \bar T_w = 1$ ($T = T_w = T_{feed} = T_a$ = 298.15 K, Table 3); $x_i = x_i^*$ from Eq. (37) at $c_{N_2} = P_H/(RT_{feed})$, $c_{CO_2} = 0$, so $x_{CO_2} = 0$. "Saturated with 100% N2 at PH = 1 bar" (p. 4254) gives composition and pressure; the general statements (pp. 4251, 4263) give an equilibrated bed at $T_{feed}$; $T_w$ is taken equal to $T$ and $T_a$ (both 298.15 K), so the column starts with no heat flux to the wall or ambient. | DM 27/11/26|
| U4 | Face reconstruction, Sec. 3, p. 4252 | Which quantities ($y_i$, $`\bar P/\bar T\,\bar v`$ products, $\bar T$, $\bar P$) are reconstructed with WENO is not stated explicitly. | — | Open, deferred to the implementation plan. Mocca (rev 27b7e6d, `Manifest.toml`) computes face values by Jutul single-point upwinding (`src/balances/gas.jl`, `src/balances/energy.jl`), i.e. UDS, Eq. (25), on a $c_i$-conservative form, so with Mocca as is there is no WENO to configure and UDS in place of WENO would be a discretisation deviation (`docs/deviations.md`). Jutul has a general WENO module (`src/WENO/WENO.jl`), which is not Eqs. (30)–(31); whether Mocca's public API accepts another face discretisation is not yet checked. The choice (Mocca UDS with deviation; Jutul WENO; Eqs. 30–31) decides whether U4 arises, and affects V1–V6, which use WENO with $N$ = 2000 (DCB) and 1000 (cycle). Also unstated: face $\bar P/\bar T$ in the dispersion term, and the stencil mirroring for $\bar v < 0$. | DM 27/11/26|
| U5 | Cycle: initial condition, p. 4256 | "saturated with 100% N2 at PL" (p. 4256). For cyclic processes, Appendix A.2 gives "a bed equilibrated with the lighter component ... at the feed temperature at a specified pressure" (p. 4263), which supplies $T$ and the loading. It is not tied explicitly to Sec. 6. Initial $T_w$ is not stated anywhere. | $T = T_{feed}$ and loading in equilibrium with N2 at $P_L$ (A.2); $T_w = T_a$ or $T_{feed}$ (both 298.15 K) | At the start of the first cycle, uniformly in $Z$: $y_{N_2} = 1$, $y_{CO_2} = 0$; $\bar P = P_L/P_0$; $T = T_w = T_{feed} = T_a$ = 298.15 K (Table 3), so $\bar T = \bar T_w = 1$; $x_i = x_i^*$ from Eq. (37) at $c_{N_2} = P_L/(RT_{feed})$, $c_{CO_2} = 0$, so $x_{CO_2} = 0$. Composition and pressure from "saturated with 100% N2 at PL" (p. 4256), consistent with Eq. (57) starting at $P_L$; temperature and equilibrium loading from App. A.2 (p. 4263); $T_w$ candidates coincide since $T_a = T_{feed}$. Results at CSS (V5–V8) do not depend on the initial state, provided the CSS is unique; the initial state affects only the number of cycles to reach it. | DM 27/11/26|
| U6 | Cycle: $P_0$ in the PVSA optimisation | Table 3 sets $P_0 = P_H$. In the PVSA runs $P_H$ is a decision variable (1–10 bar), so $P_0$, and with it $\psi$, $\Omega_2$ and the boundary values, change with each design. Not stated whether $P_0$ follows $P_H$ there. | (a) $P_0 = P_H$ of each design; (b) $P_0$ = 1 bar | (a): $P_0 = P_H$ of each design. Table 3 gives the reference values as rules tied to operating variables ($P_0 = P_H$, $v_0 = v_{feed}$, $T_0 = T_{feed}$), not as fixed numbers, and the paper states no other value for the optimisation. With $\psi$ written with $P_0$ (A1), $P_0$ only rescales $\bar P$: it cancels from every dimensional quantity (pressures, flows, Eqs. 60–71), so the choice does not change results. | DM 27/11/26|
| U7 | Cycle: Cyclic steady state | Three statements: (i) "no change in the column profiles of all state variables after each step for two consecutive cycles" (p. 4256); (ii) "all simulations were performed up to 500 cycles to ensure the attainment of CSS" (p. 4257); (iii) optimisation: "A mass balance error of less than 0.5% for five consecutive cycles" (p. 4258). The cyclic mass balance error in (iii) is not defined; no tolerance is given for (i). | (a) 500 cycles for V5, V6 and criterion (iii) for V7, V8; (b) other | (a): V5, V6 are run for 500 cycles, as stated for the Sec. 6 simulations (ii) and labelled on Figure 8 ($`n_{cycle}`$ = 500). V7, V8 are run to criterion (iii), "a mass balance error of less than 0.5% for five consecutive cycles" (p. 4258), the criterion stated for the optimisation that produced Table 6. The cyclic mass balance error in (iii), which the paper does not define, is taken from [estupinanperez2019, Eq. (1)] and applied to CO2: $`\lvert \text{mole}_{in,CO_2} - \text{mole}_{out,CO_2} \rvert / \text{mole}_{in,CO_2} \times 100`$ over one cycle, with $`\text{mole}_{in,CO_2}`$ the feed in pressurization and adsorption (Eq. 62) and $`\text{mole}_{out,CO_2}`$ all outflow in adsorption, blowdown (Eq. 63) and evacuation (Eq. 64), with E3 and E4 applied; threshold 0.5 % for five consecutive cycles as stated in (iii). Applying it to CO2 at this threshold follows [pai2020, p. 4]: "the mass balance error on CO2 is below 0.5% for 5 consecutive cycles". Logged in `docs/deviations.md` (D001). | DM 27/11/26|
| U8 | Cycle: Eq. (66), (68) conditions | Conditions are written in dimensional $P\vert_{z=0}$, $P\vert_{z=L}$ with lower-case $z$, while the integrands use $\bar P\vert_{Z=0}$, $\bar P\vert_{Z=1}$. Whether the condition is evaluated pointwise in time (switching within the step) or once per step is not stated. | (a) pointwise in time; (b) per step on the end-of-step pressure | (a): the condition is applied to the integrand at each instant, with $P\vert_{z=0} = P_0\bar P\vert_{Z=0}$ and $P\vert_{z=L} = P_0\bar P\vert_{Z=1}$ ($z = ZL$), so the integrand is 0 while the condition for 0 holds and as printed otherwise. The text describes switching within a step: "If PH > Pf, then no energy is required to take the column from PL to Pf, while compression is required to take it from Pf to PH" and "if PI < 1 bar, then energy is required only to evacuate from 1 bar to PI" (p. 4260). Consistent with E5 (a), which is also pointwise. | DM 27/11/26|
| U9 | Cycle: cycle time in Eq. (71), p. 4261 | Eq. (71) divides by the "cycle time" (p. 4261), which is not defined in the text. Figure 7 draws the "Cycle Time" (p. 4257) axis as the sequence $t_{press}$, $t_{ads}$, $t_{bd}$, $t_{evac}$. | $t_{press} + t_{ads} + t_{bd} + t_{evac}$ (Figure 7) | As candidate: cycle time $= t_{press} + t_{ads} + t_{bd} + t_{evac}$, the four steps Figure 7 places along the "Cycle Time" axis (p. 4257), with no idle or hold time, none being described. For V8, $t_{press}$ = 20 s (A4) and the other step times are those of the Table 6 row. | DM 27/11/26|

### 12.4 Missing (M)

| # | Item | Issue | Candidate readings | Resolution and evidence | Resolved by |
|---|---|---|---|---|---|
| M1 | $\Delta H_i$, "heat of adsorption of component i" (p. 4263) | Used in Eq. (4) through $\sigma_i$ and in (A.8). No value in the paper or SI. Table 2 gives $\Delta U_{b,i}$, $\Delta U_{d,i}$ only, and the paper states no relation between them and $\Delta H_i$. | open: needs a value and its source from the user | $\Delta H_i = \Delta U_{b,i} - RT$, at the local temperature $T = T_0\bar T$, with $\Delta U_{b,i}$ from Table 2. Taken from [ward2022, SI Eq. (8)], whose $\sigma_i$ has $-\Delta U_{b,i} + RT_0\bar T$ where $\sigma_i$ of this paper (SI Table 1) has $-\Delta H_i$; [ward2022] states that it uses "the same conditions and process cycle as presented by Haghpanah et al." (p. 13653) and compares its productivity with Table 6 at five operating points (SI pp. 8–9, Figure S1); productivity depends on $\Delta H_i$ through the bed temperatures. The energy usage compared in the same figure is a weaker check, since [ward2022] use a pressure-dependent vacuum-pump efficiency $\eta(p)$ (Eq. 11, p. 13655) where this paper uses a constant $\eta$. $\Delta U - RT$ is the isosteric enthalpy of a Langmuir constant written per unit concentration, as $b_i$ here (Eq. 38, $b_i$ in m³ mol⁻¹). Only site 1 enters: exact for N2 ($q_{sd,N_2} = 0$); for CO2, $\Delta U_{b}$ and $\Delta U_{d}$ differ by about 2.6 % (Table 2). Logged in `docs/deviations.md` (D002). | DM 27/11/26|
| M2 | Isotherm data, ref. 38 | Isotherm data "gravimetrically measured in our laboratory" (p. 4253), where citation 38 is placed, "and fitted to a dual-site Langmuir model" (p. 4253); ref. 38 (Krishnamurthy, Haghpanah, Rajendran, Farooq, APCChE 2012, Singapore, conference presentation). Only the fitted parameters are printed (Table 2). | Table 2 is the paper's own statement of the parameters; ref. 38 is not needed for them | As candidate: the isotherm is Eq. (37)–(39) with the Table 2 parameters as printed; ref. 38 and the raw isotherm data are not needed, since the model uses only the fitted parameters. | DM 27/11/26|
| M3 | Cycle: $`\text{mole}_{out,N_2}\vert_{evac}`$ in Eq. (60), p. 4256 | Not written out. | Eq. (64) with $`y_{N_2}`$ in place of $`y_{CO_2}`$ | As candidate: Eq. (64) with $`y_{N_2}`$ in place of $`y_{CO_2}`$, with E3 and E4 applied as for Eq. (64); the same component-flow form as Eqs. (62)–(64). | DM 27/11/26|
| M4 | Cycle: $M_{CO_2}$ in Eq. (70) | "mass of CO2 in the extract stream(s) per cycle" (p. 4261) needs the molar mass of CO2, which the paper does not give. | open: needs a value and source from the user | $M_{CO_2}$ = 44.0095 g mol⁻¹ = 0.0440095 kg mol⁻¹. Source: NIST Chemistry WebBook, NIST Standard Reference Database 69, entry "Carbon dioxide" (CAS 124-38-9), "Molecular weight" 44.0095, printed without unit as a relative molecular mass, so numerically the molar mass in g mol⁻¹; https://webbook.nist.gov/cgi/cbook.cgi?ID=C124389, accessed 2026-11-27. A physical constant the paper relies on without printing it, not a departure from the method, so no deviation entry. | DM 27/11/26|
| M5 | Cycle: "total volume of the adsorbent" (p. 4261), Eq. (71) | Not defined. Figure 12 has a top axis "Adsorbent Volume [m3]" (p. 4261) for the 500 MW plant with ticks 7890, 1820, 1029, 717, 550 aligned with productivity 0.3, 1.3, 2.3, 3.3, 4.3 mol CO2/m3 adsorbent/s; this relates plant adsorbent volume to productivity but does not define the column's adsorbent volume. | (a) bed volume $`\pi r_{in}^2 L`$; (b) solid volume $`(1-\varepsilon)\pi r_{in}^2 L`$; (c) other | (a): total volume of the adsorbent = bed volume $`\pi r_{in}^2 L`$. [ward2022] define productivity as $`n^{evac}_{CO_2,out}/(V_{bed}\,t_{cycle})`$ with $`V_{bed} = \pi r_{in}^2 L`$, "the volume of the adsorption bed" (Eq. 9, p. 13655; SI Eq. 39, SI p. 9), "per unit bed volume" (p. 13655), and compare their productivity with this paper's at five Table 6 points (SI Figure S1, SI p. 9). Reading (b) would differ by $1/(1-\varepsilon)$ ≈ 1.59, which V8 would show. | DM 27/11/26|
| M6 | Cycle: Energy penalty, Eq. (72), p. 4261 | "energy produced by power plant" (p. 4261) is given only through "a 500 MW coal based power plant emitting 10 000 t of CO2/day" (p. 4261). The capture basis (all emitted CO2, or 90 % of it) and the conversion are not stated in text. The only quantitative statement is graphical: "energy consumption and productivity are also expressed as energy penalty and adsorbent volume for a 500 MW coal based power plant ... and shown on the secondary axes in Figure 12" (p. 4261). Figure 12's right axis "Energy Penalty [%]" (p. 4261) reads 7.5, 15.0, 22.5, 30.0 at energy 100, 200, 300, 400 kWh/tonne CO2 cap (and 37.5, 45.0 above). Figure 13's right axis reads 0, 15, 30, 45 at 0, 200, 400, 600. | — | Energy penalty $`= E_T \cdot 0.9\,\dot m_{CO_2,emitted}/P_{plant}`$, with $\dot m_{CO_2,emitted}$ = 10 000 t/day and $P_{plant}$ = 500 MW (taken as electrical output), all in SI. The 90 % capture basis is implied by the right axes of Figure 12 (7.5 % at 100 kWh/t) and Figure 13 (15 % at 200 kWh/t), which match 90 % and not 100 % capture; by the top axis of Figure 12, where adsorbent volume × productivity ≈ 0.9 of the emitted molar flow (with $M_{CO_2}$, M4); and by the recovery ≥ 90 % constraint (p. 4261). Consistent with V8 (149 kWh/t ↔ 11 %), which therefore tests the conversion only, not the model. | DM 27/11/26|
