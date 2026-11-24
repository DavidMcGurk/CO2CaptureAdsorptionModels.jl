using Pkg
using TOML

@testset "Manifest.toml was resolved from the current Project.toml files" begin
    # Pkg.test in a workspace only warns about a stale manifest and runs anyway.
    @test Pkg.is_manifest_current(ROOT) === true
end

@testset "test/Project.toml has a [compat] entry for every dependency" begin
    project = TOML.parsefile(joinpath(ROOT, "test", "Project.toml"))
    # The package under test is a workspace member, resolved from its own project.
    names = setdiff(keys(project["deps"]), [string(nameof(CO2CaptureAdsorptionModels))])
    compat = get(project, "compat", Dict{String, Any}())
    @testset "$name" for name in sort!(collect(names))
        @test haskey(compat, name)
    end
end
