module QGIS

using JSON3

#-----------------------------------------------------------------------------# __init__
qgis_process::String = ""  # Path to qgis_process
algorithms::Vector{String} = []  # Provider => Algorithm

function __init__()
    for path in [
            "/Applications/QGIS.app/Contents/MacOS/bin/qgis_process"
        ]
        if isfile(path)
            set_qgis_process_path(path)
            break
        end
    end
    isempty(qgis_process) && @warn("""
    QGIS.jl did not automatically detect `qgis_process`.

    You must explicitly set `QGIS.set_qgis_process_path("path/to/qgis_process")` for the package
    to work.
    """)
end

#-----------------------------------------------------------------------------# set_qgis_process_path
function set_qgis_process_path(path::String)
    isfile(path) || error("Not found: $path")
    global qgis_process = path
    foreach(values(process("list").providers)) do provider
        append!(algorithms, string.(keys(provider.algorithms)))
    end
end

#-----------------------------------------------------------------------------# process
function process(x...)
    io = IOBuffer()
    cmd = pipeline(`$qgis_process --json $x`; stdout=io, stderr=stderr)
    Base.run(cmd)
    JSON3.read(String(take!(io)))
end

#-----------------------------------------------------------------------------# help
function help(alg::AbstractString)
    @assert alg in algorithms
    process("help", alg)
end
Base.propertynames(::typeof(help)) = Symbol.(algorithms)
Base.getproperty(::typeof(help), alg_id::Symbol) = () -> help(string(alg_id))

#-----------------------------------------------------------------------------# run
function run(alg::AbstractString, args::AbstractDict)
    @assert alg in algorithms
    process("run", alg, "--", ("$k=$v" for (k,v) in args)...)
end
run(alg::AbstractString; kw...) = run(alg, Dict(kw...))
Base.propertynames(::typeof(run)) = Symbol.(algorithms)
Base.getproperty(::typeof(run), alg_id::Symbol) = (x...) -> run(alg_id, x...)

#-----------------------------------------------------------------------------# find_algorithm
find_algorithm(txt) = filter(x -> occursin(txt, x), algorithms)

end  # module QGIS
