---
paths:
  - "experiments/**/*"
---

# Experiments

- One script per experiment in `experiments/`, run as `julia --project experiments/<name>.jl experiments/configs/<config>.toml`. The config path is the only argument.
- Everything that can change a result is in the config: model and parameter set (by spec bibkey), operating conditions, discretisation, solver tolerances, seed. No result-affecting constants in the script.
- Each run creates `<results root>/<name>_<UTC timestamp>_<short commit>/` and refuses to write into an existing directory. It stores a copy of the config, the outputs, and a provenance record: git commit, whether the tree was dirty, hash of `Manifest.toml`, Julia version, thread count, hostname, seed, start and end time.
- The results root is `results/`, unless the `RESULTS_ROOT` environment variable names another directory. Tests and smoke runs set it to a temporary directory, so `results/` holds only real runs.
- Run-directory and provenance logic exists once in `src/` and every script uses it. Do not re-implement it per script.
- All randomness comes from an `rng` created from the config seed and passed down explicitly.
- Runs from a dirty tree are fine for exploration and are recorded as such. Numbers that go into a paper or the thesis come from a clean commit.
- Figures and tables are produced by scripts that read `results/`. Never copy a number from terminal output into text, a config or a test.
- Each experiment has a smoke configuration that runs in seconds and is exercised by the fast test tier with a temporary results root, so a broken script is caught before a long run.
- Do not start a run you expect to take more than a few minutes without asking. For cluster runs, write the job script and stop.
- `results/` is write-once: scripts create new run directories, and nothing edits or deletes existing ones.
