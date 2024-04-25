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
    isempty(qgis_process) && @warn("qgis_process not detected.  You must explicitly set `QGIS.set_qgis_process_path(\"path/to/qgis_process\")`.")
end

function set_qgis_process_path(path::String)
    isfile(path) || error("Not found: $path")
    global qgis_process = path
    foreach(values(process("list").providers)) do provider
        append!(algorithms, string.(keys(provider.algorithms)))
    end
end

function process(x...)
    io = IOBuffer()
    cmd = pipeline(`$qgis_process --json $x`; stdout=io, stderr=devnull)
    Base.run(cmd)
    JSON3.read(String(take!(io)))
end

#-----------------------------------------------------------------------------# run
run(algorithm_id::String, args...) = process("run", algorithm_id, args...)
Base.propertynames(::typeof(run)) = Symbol.(algorithms)
Base.getproperty(::typeof(run), alg_id::Symbol) = (x...) -> run(alg_id, x...)


end  # module QGIS
