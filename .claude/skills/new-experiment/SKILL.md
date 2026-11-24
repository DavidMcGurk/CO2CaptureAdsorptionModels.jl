---
name: new-experiment
description: Scaffold a reproducible experiment (config, script, smoke test) under experiments/. Use when asked to add, set up or run a new simulation study, parameter sweep or benchmark run.
argument-hint: "[experiment name and purpose]"
---

Set up an experiment: $ARGUMENTS

1. State in two or three sentences what the experiment measures, which spec and parameter set it uses, and what output will answer the question. If it replicates a published protocol, name the spec section that defines it. If that section does not exist or is unverified, stop and ask.
2. Create `experiments/configs/<name>.toml` holding everything that can change the result, and `experiments/configs/<name>_smoke.toml`, a version small enough to run in seconds.
3. Read `.claude/rules/experiments.md` now: it loads by itself only after a file under `experiments/` has been read. Then create `experiments/<name>.jl` following it: config path as the only argument, the shared run and provenance helper from `src/`, an explicit `rng`, a write-once run directory.
4. Add a fast-tier test that runs the smoke config end to end with `RESULTS_ROOT` set to a `mktempdir()`, and checks that the outputs and the provenance record exist and are well-formed.
5. Run the smoke config with `RESULTS_ROOT` set to a temporary directory and show the command, the run directory listing and the provenance record.
6. Do not launch the full run. Give the command for it and an estimate of its cost, and say whether it belongs on the cluster.
