# Tests

Applies to everything under `test/`. Loaded in every session, because these rules have to hold before the first test file exists.

## Tiers
- **Fast** (default): `Pkg.test()`. Unit tests, analytical limits, invariants on small problems, smoke runs of experiments, quality checks. The whole tier stays under about two minutes. This is what the Stop hook runs.
- **Validation**: `Pkg.test(; test_args=["validation"])`. Reproduction of published results, cycles to cyclic steady state, grid and time-step refinement. Lives in `test/validation/`. Run it only when asked, or on CI or the cluster.
- `test/runtests.jl` dispatches on `ARGS`: no argument runs the fast tier, `"validation"` runs validation, `"all"` runs both.

## Where expected values come from
Strongest first. The output of the code under test is never its own expected value.
1. Published values in `test/reference/*.toml`. Value, unit, tolerance and source are all read from the file.
2. Analytical or limiting cases with a closed-form answer.
3. Conservation laws and physical invariants: mass and energy balance closure, bounds on mole fractions and loadings, symmetry.
4. Numerical verification: observed convergence order under grid or time-step refinement.
5. Regression snapshots, only for outputs already validated by 1 to 4, and labelled as regression tests.

## Rules
- `test/reference/` is maintained by the user and is read-only for you by any route, including shell commands and scripts you run. The Stop hook reports changes there. If a reference value you need is missing, list exactly what is needed (quantity, conditions, location in the source) and ask.
- Tests never write inside the repository. Whatever a test produces (run directories, figures, caches) goes under `mktempdir()`, and smoke runs of experiments get a temporary results root through `RESULTS_ROOT`.
- A tolerance is either read from the reference file or justified in one comment line: discretisation error estimate, figure digitisation error, Monte Carlo standard error. Do not adjust a tolerance until a test passes.
- A failing test is a result to report. Do not weaken an assertion, widen a tolerance, mark a test broken or skipped, or special-case an input to make it pass.
- Name each testset after what it verifies and its source, for example `@testset "Dual-site Langmuir: Henry's-law limit [bibkey, Eq. n]"`.
- Randomness in tests uses `StableRNGs.StableRNG(seed)`. Statistical assertions state their sample size and the tolerance that follows from it.
- Quality checks belong in the fast tier: Aqua.jl, a formatter check, and JET.jl where its reports are actionable.
- When you add or change a test, run it once against deliberately wrong code or a wrong expected value to confirm that it can fail, and say that you did.
