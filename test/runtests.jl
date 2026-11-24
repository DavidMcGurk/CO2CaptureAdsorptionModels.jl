# Test tiers, selected by ARGS (see .claude/rules/tests.md):
#   no argument    fast tier
#   "validation"   validation tier (test/validation/)
#   "all"          both
using CO2CaptureAdsorptionModels
using Test

const ROOT = pkgdir(CO2CaptureAdsorptionModels)

"""
    julia_source_files(root::AbstractString) -> Vector{String}

Every `.jl` file under `src/`, `ext/`, `test/` and `experiments/` of `root`, except
`test/reference/`, which the user maintains.
"""
function julia_source_files(root::AbstractString)
    reference = joinpath(root, "test", "reference")
    files = String[]
    for dir in ("src", "ext", "test", "experiments")
        isdir(joinpath(root, dir)) || continue
        for (path, _, names) in walkdir(joinpath(root, dir))
            (path == reference || startswith(path, joinpath(reference, ""))) && continue
            append!(files, joinpath.(path, filter(endswith(".jl"), names)))
        end
    end
    return files
end

const TIER = if isempty(ARGS)
    "fast"
elseif length(ARGS) == 1 && only(ARGS) in ("validation", "all")
    only(ARGS)
else
    error("test_args must be empty, [\"validation\"] or [\"all\"], got $(repr(ARGS))")
end

if TIER in ("fast", "all")
    @testset "Fast tier" begin
        include("quality.jl")
        include("style.jl")
        include("project.jl")
        include("mocca.jl")
    end
end

if TIER in ("validation", "all")
    @testset "Validation tier" begin
        dir = joinpath(@__DIR__, "validation")
        files = isdir(dir) ? sort!(filter(endswith(".jl"), readdir(dir; join = true))) : String[]
        isempty(files) && @warn "No validation tests: test/validation/ holds no .jl files."
        foreach(include, files)
    end
end
