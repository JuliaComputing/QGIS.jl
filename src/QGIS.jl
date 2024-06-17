module QGIS

using JSON3, GeoInterface, DataFrames

#-----------------------------------------------------------------------------# utils
check_algorithm(x) = Symbol(x) in df.algorithm ? true : error("Algorithm `$x` not found.")

#-----------------------------------------------------------------------------# __init__
qgis_process::String = ""  # Path to qgis_process
list::JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} = JSON3.read("{}")

"""
    QGIS.df

A `DataFrame` containing the metadata for all available QGIS algorithms.
"""
df::DataFrame = DataFrame()  # algorithm metadata

function __init__(x::String = "")
    if isfile(x)
        global qgis_process = x
    else
        for path in [
                "/usr/bin/qgis_process",
                "/usr/local/bin/qgis_process",
                Sys.which("qgis_process"),
                "/Applications/QGIS.app/Contents/MacOS/bin/qgis_process",
                # Windows: Search for highest version first (current is 3.36)
                joinpath("C:", "OSGeo4W64", "apps", "qgis", "bin", "qgis_process.exe"),
                [joinpath("C:", "Program Files", "QGIS 3.$i", "bin", "qgis_process.exe") for i in 50:-1:1]
            ]
            !isnothing(path) && isfile(path) && (__init__(path); break)
        end
    end
    if isempty(qgis_process)
        @warn("""
        QGIS.jl did not automatically detect `qgis_process`.

        You must successfully set `QGIS.__init__("path/to/qgis_process")` before the package will
        operate properly.
        """)
    else
        global list = process("list")
        global df = DataFrame()
        for (k, v) in list.providers
            for (k2, v2) in v.algorithms
                row = (; provider=k, algorithm=k2, v2...)
                push!(df, row; cols=:union, promote=true)
            end
        end
    end
end

#-----------------------------------------------------------------------------# process
function process(x...)
    cmd = [qgis_process, "--json", "--no-python", x...]
    io = IOBuffer()
    Base.run(pipeline(Cmd(cmd); stdout=io, stderr=stderr))
    JSON3.read(String(take!(io)))
end

#-----------------------------------------------------------------------------# help
"""
    help(alg)

Return the help (in JSON format) for the associated algorithm.
"""
help(x::AbstractString) = check_algorithm(x) && process("help", x)
Base.propertynames(::typeof(help)) = df.provider
Base.getproperty(::typeof(help), alg_id::Symbol) = () -> help(string(alg_id))

#-----------------------------------------------------------------------------# metadata
"""
    metadata(alg)

Return the associated metadata for a given algorithm.  Returns the associated `DataFrameRow` from `QGIS.df`.
"""
function metadata(x)
    check_algorithm(x)
    i = findfirst(==(Symbol(x)), df.algorithm)
    df[i, :]
end

#-----------------------------------------------------------------------------# enable/disable
enable(x) = check_algorithm(x) && process("plugins", "enable", x)
disable(x) = check_algorithm(x) && process("plugins", "disable", x)

#-----------------------------------------------------------------------------# run
function run(alg::AbstractString, args::AbstractDict)
    check_algorithm(alg)
    process("run", alg, "--", ("$k=$v" for (k,v) in args)...)
end
run(alg::AbstractString; kw...) = run(alg, Dict(kw...))
Base.propertynames(::typeof(run)) = df.algorithm
Base.getproperty(::typeof(run), alg_id::Symbol) = (x...) -> run(alg_id, x...)


#-----------------------------------------------------------------------------# Algorithm
"""
    QGIS.Algorithm(name)

Object representing a QGIS algorithm.  The struct contains the help, metadata, and default parameters
for the algorithm.  Algorithms are callable and expect a `String` input (filename) and optional
`String` output (filename).

# Example

    using QGIS, GeoJSON, Plots, GeoInterfaceRecipes

    buffer = QGIS.Algorithm("native:buffer", DISTANCE=0.1)

    input = joinpath(dirname(pathof(QGIS)), "..", "test", "nc.geojson")

    nc = GeoJSON.read(input)

    output = buffer(input)

    nc_buffered = GeoJSON.read(output)

    plot(
        plot(nc.geometry),
        plot(nc_buffered.geometry),
        layout = (2, 1)
    )
"""
struct Algorithm
    name::String
    help::JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}}
    metadata::DataFrames.DataFrameRow{DataFrames.DataFrame, DataFrames.Index}
    parameters::Dict{String, Any}
    function Algorithm(x::AbstractString; kw...)
        check_algorithm(x)
        h = help(x)
        defaults = Dict{String, Any}(string(k) => v.default_value for (k,v) in h.parameters)
        for (k, v) in kw
            defaults[string(k)] = v
        end
        new(x, h, metadata(x), defaults)
    end
end
function Base.show(io::IO, a::Algorithm)
    print(io, "QGIS.Algorithm - ", a.name)
    for (k,v) in a.parameters
        print(io, "\n  • ", k, " = ", v)
    end
end

function (alg::Algorithm)(input::AbstractString=alg.parameters["INPUT"], output::AbstractString = tempname() * splitext(input)[2])
    params = Dict(alg.parameters)
    params["INPUT"] = input
    params["OUTPUT"] = output
    res = run(alg.name, params)
    return res.results.OUTPUT
end


end  # module QGIS
