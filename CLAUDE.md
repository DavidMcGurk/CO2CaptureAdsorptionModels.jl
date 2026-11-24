# CO2CaptureAdsorptionModels.jl

Models of fixed-bed adsorption CO2 capture processes and the experiments run on them. The first case is the four-step VSA cycle on zeolite 13X from Haghpanah et al. 2013, built on Mocca.jl where it fits. Results go into a PhD thesis and papers, so every number has to be traceable to a cited source and reproducible from a commit.

## Layout
- `src/` package code, `test/` tests, `experiments/` run scripts with `experiments/configs/`
- `docs/specs/<bibkey>.md` one spec per cited method: the only source for equations, parameters and metric definitions
- `docs/deviations.md` log of every departure from a cited method
- `docs/papers/` PDFs and `results/` run outputs: not in git
- `test/reference/` published values and tolerances, maintained by me

## Commands
- Fast tests: `julia --project -e 'using Pkg; Pkg.test()'`
- Validation tests (slow, ask first): `julia --project -e 'using Pkg; Pkg.test(; test_args=["validation"])'`
- Set up after cloning: `julia --project -e 'using Pkg; Pkg.instantiate(; workspace=true)'`
- After adding or updating a dependency, before you stop: `julia --project -e 'using Pkg; Pkg.precompile(; workspace=true)'`
- Test-only dependencies live in the `test/` workspace project (`test/Project.toml`), pinned by the single root `Manifest.toml`. Without `workspace=true`, `instantiate` and `precompile` skip them.

A Stop hook runs the fast tests whenever code changed during a turn and sends failures back to you. It allows them 8 minutes. It also reports files in `test/reference/`, `docs/papers/` and `results/` that changed during the turn.

## Sources of truth
- Implement published methods from the spec, not from your memory of the paper or of similar models.
- Rely only on spec items I have marked verified. If an equation, parameter, boundary condition, correlation or metric definition is missing, unclear or unverified, stop and ask. Never fill the gap with a typical value or a formulation from another source.
- Log every intentional departure from a cited method (discretisation, solver, simplification, changed value) in `docs/deviations.md` in the same change.
- Before calling Mocca.jl, Jutul, InfiniteOpt or any other package you are not certain about, read its installed source or docs for the version in `Manifest.toml`. Do not guess signatures.

## Code
- SI units throughout, no exceptions; convert only at the input/output boundary.
- Names follow the spec's nomenclature table so code can be read against the equations.
- A function implementing a published equation cites it in its docstring: `Ref: [bibkey, Eq. n]`.
- Comment sparsely: only where it clearly helps understanding of a complex function or where a numerical choice is not obvious from the code.

## Tests
- Write tests from the spec before the implementation, and show me the list with expected values, tolerances and their sources before writing code.
- If a test fails, fix the code or report the failure with your diagnosis. Do not weaken an assertion, widen a tolerance, skip a test or special-case an input to get it to pass.
- You must not change `test/reference/`, `docs/papers/` or existing files under `results/` by any route, including shell commands and scripts you run. If a reference value is missing, tell me exactly which one and where in the source it is.

## Experiments
- A run is one script plus one config file; the config path is the script's only argument and holds everything that can change the result, including the seed.
- Each run writes once to its own directory under `results/`, with its config, git commit, `Manifest.toml` hash and seed. Tests and smoke runs write to a temporary directory instead.
- Numbers in text, tests or configs are never copied by hand from program output.

## Working agreements
- For anything larger than a small fix, plan first and wait for my approval.
- After changing code that carries a `Ref:` tag, run the `spec-verifier` agent on it before reporting that you are done.
- Report with evidence: the command you ran and its output, not a statement that it works.
- When compacting, keep the list of modified files, the spec items in use and any failing tests.
