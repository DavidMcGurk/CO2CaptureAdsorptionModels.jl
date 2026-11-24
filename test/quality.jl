using Aqua
using JET
using Runic

@testset "Aqua.jl package quality checks" begin
    # Mocca is a declared dependency that src/ does not load yet, which Aqua reports as
    # stale. Remove this ignore as soon as src/ does `using Mocca`.
    Aqua.test_all(CO2CaptureAdsorptionModels; stale_deps = (ignore = [:Mocca],))
end

@testset "JET.jl static analysis of CO2CaptureAdsorptionModels" begin
    # Fails rather than skips when JET does not support the running Julia version.
    @test JET.JET_AVAILABLE
    JET.test_package(CO2CaptureAdsorptionModels; target_modules = (CO2CaptureAdsorptionModels,))
end

@testset "Runic.jl formatting of src/ and test/" begin
    files = julia_source_files(ROOT)
    @test !isempty(files)
    # --check never writes; --diff prints the required changes to stderr.
    @test Runic.main(["--check", "--diff", files...]) == 0
end
