using QGIS, JSON3, DataFrames
using Test

@testset "QGIS.jl" begin
    @testset "Algorithm metadata" begin
        @test !isempty(QGIS.df)
        @test QGIS.help("native:buffer") isa JSON3.Object
        @test QGIS.metadata("native:buffer") isa DataFrameRow
    end
    @testset "Usage" begin
        buffer = QGIS.Algorithm("native:buffer", DISTANCE=0.1)

        input = joinpath(@__DIR__, "nc.geojson")

        output = buffer(input)

        @test isfile(output)

        obj = JSON3.read(read(output))
        @test obj.features[1].geometry[:type] == "MultiPolygon"
    end
end
