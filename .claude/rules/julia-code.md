# Julia model and library code

Applies to `src/` and `ext/`. Loaded in every session, because these rules have to hold before the first source file exists.

## Traceability
- A function that implements a published equation, correlation or algorithm cites it in its docstring: `Ref: [bibkey, Eq. n]` (or Table, Section, Algorithm). Keep one function per equation or closely related group, so the mapping to the spec is one-to-one.
- Variable and field names follow the spec's nomenclature table. Where the spec's symbol is not a readable identifier, use the code name the table gives.
- Docstrings state the SI unit of every argument and return value, and any assumption the equation relies on (ideal gas, isothermal, negligible radial gradients, and so on).

## Parameters and units
- No numeric physical constants in function bodies. Parameters live in immutable structs built from a spec's parameter table or a config file, with the unit in each field's doc.
- SI units only inside the package: Pa, K, mol, kg, m, s, J. Convert at the input/output boundary, in one place.
- Do not add clamps, floors, smoothing, regularisation or default values to physical quantities on your own. If the numerics need one, that is a deviation: ask first, then log it in `docs/deviations.md`.

## Style
- Small functions without hidden state: no mutable globals; pass `rng`, parameters and solver options explicitly.
- Keep numerical code generic in its number type (no `::Float64` on arguments or on struct fields that carry state or parameters), so automatic differentiation and optimisation layers can use it.
- Type-stable on hot paths, with concretely typed or parametric struct fields.
- Annotate every function argument, positional and keyword, with the most abstract type the function supports (`Real`, `AbstractVector{<:Real}`, `AbstractString`, a parameter struct). Write `::Any` when a function genuinely accepts anything. Anonymous functions and `do` blocks are exempt. This also applies to helper functions in `test/` and `experiments/`.
- Do not annotate return types in the signature (`f(x)::T`): Julia converts the result to `T`, which hides type instability and breaks dual numbers. State the return type in the docstring's signature line instead, `f(x::Real) -> Real`, and test type stability with `@inferred`.
- The fast-tier test `test/style.jl` enforces the two rules above.
- Validate inputs at the public boundary, with errors that name the offending value and its unit.
- Comments are sparse: explain a numerical choice that is not obvious, not what the line does.

## Dependencies
- Use Mocca.jl, Jutul and other upstream packages through their public API. Do not copy, patch or shadow upstream code. If the public API cannot do what is needed, stop and ask.
- Adding or updating a dependency changes `Project.toml` and `Manifest.toml`. Say so explicitly in your summary.
