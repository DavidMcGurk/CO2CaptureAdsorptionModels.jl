# CO2CaptureAdsorptionModels.jl

Simulation models of fixed-bed adsorption processes for CO2 capture, each tied to the published method it implements. The package is written in Julia and builds on [Mocca.jl](https://github.com/sintefmath/Mocca.jl) for the process physics and the numerics. The models are meant to serve as plant models in process simulation, optimisation and control studies.

This is research code. Its results go into a PhD thesis and papers, so the repository is organised around one requirement: every number must be traceable to a cited source and reproducible from a commit.

## Status

The package is at an early stage. The repository holds the package skeleton, the test and continuous-integration infrastructure, and the conventions described below. The module does not provide any models yet. The first case is the four-step vacuum swing adsorption cycle on zeolite 13X of Haghpanah et al. (2013).

## What the package does

Mocca.jl, which is built on [Jutul.jl](https://github.com/sintefmath/Jutul.jl), supplies the conservation equations, the isotherm and mass-transfer models, the cycle steps and the solvers. This package does not re-implement them. It is the layer that turns a general simulator into specific, checked cases:

- **Cases.** The parameters, cycle definition and operating conditions of each published process, taken from its spec.
- **Performance metrics.** Purity, recovery and the other reported quantities, as each source defines them.
- **Experiments.** Scripts that run a case from a single configuration file and record what is needed to repeat the run.
- **Validation.** Tests that compare simulated results with published values.

Mocca.jl is pinned to an exact commit and used only through its public interface. Code that needs a process model is meant to depend on this package rather than on Mocca.jl, so that the simulator behind a case can change without affecting its users.

## How results stay traceable

1. **Specs.** Each cited paper or method has one file in `docs/specs/`: a transcription of its equations, parameters, boundary conditions, metric definitions and reported results. Every item is checked by hand against the source before code relies on it. See [`docs/specs/README.md`](docs/specs/README.md).
2. **Code.** A function that implements a published equation cites it in its docstring as `Ref: [bibkey, Eq. n]`, and names follow the spec's nomenclature. All quantities are in SI units.
3. **Reference values.** The published results that tests compare against are kept in `test/reference/`, each with its tolerance and its place in the source. Tolerances are set before the code is run and are not tuned to it. See [`test/reference/README.md`](test/reference/README.md).
4. **Deviations.** Every intentional difference from a cited method, such as another discretisation or solver, is logged in [`docs/deviations.md`](docs/deviations.md).
5. **Environment.** `Manifest.toml` is committed, so a commit fixes the exact version of every dependency.

## Setup

Use the Julia version recorded as `julia_version` at the top of `Manifest.toml`.

```sh
git clone https://github.com/DavidMcGurk/CO2CaptureAdsorptionModels.jl.git
cd CO2CaptureAdsorptionModels.jl
julia --project -e 'using Pkg; Pkg.instantiate(; workspace=true)'
```

This installs the dependencies of the package and of its tests, including Mocca.jl from GitHub at the pinned commit.

## Tests

Tests come in two tiers:

```sh
julia --project -e 'using Pkg; Pkg.test()'                              # fast tier
julia --project -e 'using Pkg; Pkg.test(; test_args=["validation"])'   # validation tier
```

- **Fast tier.** Quick checks that run after every change: package quality (Aqua.jl), static analysis (JET.jl), formatting (Runic.jl), the project's type-annotation rules, and that the environment matches the project files and the pinned Mocca.jl commit. Unit tests of model code belong here too.
- **Validation tier.** Reproductions of published results, which can take much longer.

After installing or changing dependencies, precompile first, because that step takes a few minutes:

```sh
julia --project -e 'using Pkg; Pkg.precompile(; workspace=true)'
```

On pull requests, GitHub Actions runs both tiers.

## Repository layout

| Path | Contents |
|---|---|
| `src/` | Package code |
| `test/` | Tests: `test/reference/` holds published values, `test/validation/` the validation tier |
| `experiments/` | Run scripts, with their configuration files in `experiments/configs/` |
| `docs/specs/` | One spec per cited method |
| `docs/deviations.md` | Log of departures from cited methods |
| `docs/papers/`, `results/` | Source PDFs and run outputs, both kept out of git |
| `CLAUDE.md`, `.claude/` | Rules and configuration for the coding agent used in development |

Folders are created when they are first needed, so a clone may not contain all of them.

## Development

Development is assisted by the Claude Code agent. `CLAUDE.md` and `.claude/rules/` state the working rules, which apply equally to code written by hand:

- Tests are written from the spec before the implementation.
- A failing test is fixed in the code or reported. It is never weakened to pass.
- Reference values, source PDFs and existing results are not changed by tooling.

A session hook in `.claude/hooks/` runs the fast tier whenever code changes during an agent session.

## Sources

- R. Haghpanah, A. Majumder, R. Nilam, A. Rajendran, S. Farooq, I. A. Karimi and M. Amanullah, "Multiobjective Optimization of a Four-Step Adsorption Process for Postcombustion CO2 Capture Via Finite Volume Simulation", Ind. Eng. Chem. Res. 2013, 52, 4249–4265. https://doi.org/10.1021/ie302658y
- [Mocca.jl](https://github.com/sintefmath/Mocca.jl), SINTEF Digital.
