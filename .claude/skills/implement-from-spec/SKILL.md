---
name: implement-from-spec
description: Implement or change model, numerical or control code from a verified spec in docs/specs/, tests first. Use when asked to implement, port or modify a published model, equation, correlation, algorithm or baseline.
argument-hint: "[what to implement] [bibkey]"
---

Implement from spec: $ARGUMENTS

1. **Scope.** Identify the spec and the exact items the task needs: equations, parameters, boundary conditions, metrics. If any is missing, marked UNCLEAR or not yet verified, stop and list them. Do not proceed on unverified items.
2. **Plan, then wait.** Present:
   - a table mapping each spec item to the function or type that will implement it;
   - the tests, each with its expected value, tolerance and source (reference file, analytical limit, invariant, convergence order);
   - reference values that are needed but absent from `test/reference/` (the user adds these; you cannot);
   - any departure from the spec you think is necessary, with the reason.

   Wait for approval before writing code.
3. **Tests first.** Write the tests and run them to confirm they fail for the expected reason.
4. **Implement**, following `.claude/rules/julia-code.md`. Read the installed source or docs of upstream packages before calling them.
5. **Run the fast tier** and iterate until it passes without changing what the tests expect. If you cannot get there, stop and report what fails and your diagnosis.
6. **Log deviations** in `docs/deviations.md` in the same change.
7. **Independent check.** Run the `spec-verifier` agent on the changed files and the spec. Fix findings that affect correctness or traceability, then re-run the tests.
8. **Report with evidence:** the spec-item-to-code table, the test command and its output, deviations logged, each verifier finding and what you did about it, and which validation-tier tests should be run next.
