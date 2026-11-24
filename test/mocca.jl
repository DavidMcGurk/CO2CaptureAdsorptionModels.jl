using Mocca
using Pkg
using TOML

@testset "Mocca.jl loads at the commit pinned in Project.toml [sources]" begin
    source = TOML.parsefile(joinpath(ROOT, "Project.toml"))["sources"]["Mocca"]
    info = Pkg.dependencies()[Base.PkgId(Mocca).uuid]
    @test info.git_source == source["url"]
    @test info.git_revision == source["rev"]
    @test pkgdir(Mocca) == info.source
end
